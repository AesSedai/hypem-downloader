#!/usr/bin/env ruby
require 'httparty'
require 'nokogiri'
require 'json'
require 'fileutils'
require 'csv'
require 'thread'
require 'optparse'

module Hypem
  class Tracks

    def initialize(user, cookie, threads, max_page = nil)
      @user = user
      @cookie = cookie
      @threads = threads
      @max_page = if max_page.nil?
                    if cookie.empty?
                      1
                    else
                      get_max_page
                    end
                  else
                    max_page
                  end
    end

    def page_link(page = nil)
      return "https://hypem.com/#{@user}" if page.nil?
      return "https://hypem.com/#{@user}/#{page}"
    end

    def get_max_page
      page_source = HTTParty.get(page_link(1), headers: { "Cookie": @cookie }).parsed_response
      document = Nokogiri::HTML(page_source)
      track_list_data_element = document.at_css("#displayList-data")
      track_list = JSON.parse(track_list_data_element)

      # extract pagination links with the username present and just a number for the text content
      pagination_links = document.css("a[rel='nofollow']").select { |link| link["href"].include?(@user) && link.text.to_i.to_s == link.text }

      # largest one is the last page
      return pagination_links.map(&:text).map(&:to_i).max
    end

    def extract_sc_link(link)
      retries = 3
      begin
        resp = HTTParty.get(link)
        document = Nokogiri::HTML(resp.body)
        hydration = document.css("script").map(&:text).find { |sc| sc.include?("window.__sc_hydration") }
        return "" if hydration.nil?
        sound = JSON.parse(hydration.sub("window.__sc_hydration = ", "").gsub(/;/, "")).find { |sc| sc["hydratable"] == "sound" }
        return "" if sound.nil?
        link = sound["data"]["permalink_url"]
        return link
      rescue => exception
        retries -= 1
        if retries > 0
          retry
        else
          puts "Failed to fetch SC info for: #{link}"
          return ""
        end
      end
    end

    def extract_bc_link(link)
      retries = 3
      begin
        resp = HTTParty.get(link)
        document = Nokogiri::HTML(resp.body)
        meta = document.at_css("meta[property='og:url']")
        return "" if meta.nil?
        return meta["content"]
      rescue => exception
        retries -= 1
        if retries > 0
          retry
        else
          puts "Failed to fetch SC info for: #{link}"
          return ""
        end
      end
    end

    def download
      puts "Beginning download of #{page_link}, up to page #{@max_page}"

      headers = %w[title artist is_soundcloud soundcloud_link is_bandcamp bandcamp_link is_apple_music apple_music_link is_ca ca_link is_spotify spotify_link is_audius audius_link]

      CSV.open("/out/track_list.csv", "wb", write_headers: true, headers: headers, force_quotes: true) do |csv|
        (1..@max_page).to_a.each do |page|
          puts "Page: #{page}"

          # Get track list.
          page_source = HTTParty.get(page_link(page), headers: { "Cookie": @cookie }).parsed_response
          document = Nokogiri::HTML(page_source)
          track_list_data_element = document.at_css("#displayList-data")
          track_list = JSON.parse(track_list_data_element)
          # puts track_list

          tracks = track_list["tracks"]
          mutex = Mutex.new

          @threads.times.map do |_|
            Thread.new(tracks) do |ttracks|
              while (track = mutex.synchronize { ttracks.pop })
                file_name = "#{track["song"]} by #{track["artist"]}"

                mutex.synchronize do
                  puts "Looking for #{file_name}"
                end

                sc_link = ""
                bc_link = ""
                au_link = ""
                am_link = ""
                ca_link = ""

                if track["is_sc"]
                  # soundcloud
                  sc_link = self.extract_sc_link("https://hypem.com/go/sc/#{track["id"]}")
                end

                if track["is_bc"]
                  # bandcamp
                  bc_link = self.extract_bc_link("https://hypem.com/go/bc/#{track["id"]}")
                end

                if track["is_am"]
                  # apple music
                  # puts "AM track: #{page_link(page)}, #{track}"
                end

                if track["is_ca"]
                  # ca?
                  # puts "CA track: #{page_link(page)}, #{track}"
                end

                if track["is_au"]
                  # audius
                  # puts "AU track: #{page_link(page)}, #{track}"
                end

                mutex.synchronize do
                  csv << [track["song"],
                          track["artist"],
                          track["is_sc"],
                          sc_link,
                          track["is_bc"],
                          bc_link,
                          track["is_am"],
                          am_link,
                          track["is_ca"],
                          ca_link,
                          track["spotify_uri"].is_a?(String) ? true : false,
                          track["spotify_uri"].is_a?(String) ? track["spotify_uri"] : "",
                          track["is_au"],
                          au_link]
                end
              end
            end
          end.each(&:join)

        end
      end

    end
  end
end

options = {
  threads: 10,
  user: "popular",
  max_page: nil,
  cookie: ""
}

OptionParser.new do |opts|
  opts.banner = "Usage: tracks.rb"

  opts.on("-t", "--threads <number>", "Number of concurrent requests to run") do |arg|
    options[:threads] = arg.to_i
  end

  opts.on("-u", "--user <string>", "User URL to scrape (eg: 'popular')") do |arg|
    options[:user] = arg
  end

  opts.on("-p", "--pages <number>", "Max page number to scrape") do |arg|
    options[:max_page] = arg.to_i
  end

  opts.on("-c" "--cookie <string>", "User auth cookie (eg: 'AUTH=ABCDEFGHIJKLMNOPQRSTUVWXYZ-US'") do |arg|
    options[:cookie] = arg
  end
end.parse!

downloader = Hypem::Tracks.new(options[:user], options[:cookie], options[:threads], options[:max_page])
downloader.download
