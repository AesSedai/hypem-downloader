require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'

class TracksController
  def download(options = {})
    begin
      page_url = options[:from_url] || "http://hypem.com/popular"
      downloads_dir = options[:to_dir] || "#{Dir.getwd}/tracks" # "#{Dir.home}/Desktop/hypem_downloads"

      # Create downloads directory.

      FileUtils.mkdir_p(downloads_dir)

      # Get track list.

      page_source = HTTParty.get(page_url).parsed_response
      document = Nokogiri::HTML(page_source)
      track_list_data_element = document.at_css("#displayList-data")
      track_list = JSON.parse(track_list_data_element)
      tracks = track_list["tracks"]
      tracks.each do |track|

        # Get track source url.

        serve_source_url = "http://hypem.com/serve/source/#{track["id"]}/#{track["key"]}"
        serve_source = HTTParty.get(serve_source_url).parsed_response
        track_source_url = serve_source["url"]

        # Download file from track source.

        file_name = "#{track["song"]} by #{track["artist"]}.mp3"
        destination_file = "#{downloads_dir}/#{destination_file}"
        File.write(destination_file, track_source_url)

      rescue => e
        puts "#{e.class} -- #{e.message}"
        sleep 1.second
        next
      end
    end
  end
end
