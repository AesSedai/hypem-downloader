# DISCLAIMER: This script is for educational/theoretical purposes. Don't use if in violation of [hype machine terms of service](http://hypem.com/terms).

# CREDIT: https://github.com/fzakaria/HypeMachine-Extension/blob/6ea946024fd3f856306aba0874029964051dd369/extension.js

require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'

def download_tracks(options = {})
  page_url = options[:from_url] || "http://hypem.com/popular"
  downloads_dir = options[:to_dir] || "#{Dir.home}/Desktop/hypem_downloads"

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

    sleep 3.seconds
  end
end

download_tracks(:from_url => "http://hypem.com/artist/Sia/1/?sortby=favorite")

#
# MOCK OBJECTS ...
#

def sample_serve_source
  ###response = <<-JSON
  ###  {"itemid":"1zht4","type":"SC","url":"http:\/\/api.soundcloud.com\/tracks\/113324557\/stream?consumer_key=nH8p0jYOkoVEZgJukRlG6w"}
  ###JSON
  ###JSON.parse(response) #> {"itemid"=>"1zht4", "type"=>"SC", "url"=>"http://api.soundcloud.com/tracks/113324557/stream?consumer_key=nH8p0jYOkoVEZgJukRlG6w"}
  {"itemid"=>"1zht4", "type"=>"SC", "url"=>"http://api.soundcloud.com/tracks/113324557/stream?consumer_key=nH8p0jYOkoVEZgJukRlG6w"}
end

def sample_track
  {"type"=>"normal", "id"=>"1zht4", "time"=>260, "ts"=>1387207295, "postid"=>2378176, "posturl"=>"http://www.indieshuffle.com/best-artist-collaborations-2013/", "fav"=>0, "key"=>"5373d0eae8c78b030cccfcb0f95baa80", "artist"=>"Sia", "song"=>"Elastic Heart feat. The Weeknd & Diplo", "is_sc"=>true, "is_bc"=>false}
end

def sample_track_list
  {
    "page_cur"=>"/artist/Sia/1/?sortby=favorite",
    "page_num"=>"1",
    "tracks"=>[
      {
        "type"=>"normal",
        "id"=>"1zht4",
        "time"=>260,
        "ts"=>1387207295,
        "postid"=>2378176,
        "posturl"=>"http://www.indieshuffle.com/best-artist-collaborations-2013/",
        "fav"=>0,
        "key"=>"5373d0eae8c78b030cccfcb0f95baa80",
        "artist"=>"Sia",
        "song"=>"Elastic Heart feat. The Weeknd & Diplo",
        "is_sc"=>true,
        "is_bc"=>false
      },
      {
        "type"=>"normal",
        "id"=>"235dm",
        "time"=>216,
        "ts"=>1422756847,
        "postid"=>2613089,
        "posturl"=>"http://www.cougarmicrobes.com/2015/01/cm-top-albums-2014-sia-1000-forms-fear/",
        "fav"=>0,
        "key"=>"be476e99c1a3dddf5f2db1bf1c20443c",
        "artist"=>"Sia",
        "song"=>"Chandelier",
        "is_sc"=>true,
        "is_bc"=>false
      }
    ],
    "page_name"=>"search",
    "page_mode"=>"artist",
    "page_arg"=>"Sia",
    "page_sort"=>"favorite",
    "title"=>"Sia / mp3s and music from the best music blogs",
    "page_next"=>"/artist/Sia/2?sortby=favorite"
  }
end
