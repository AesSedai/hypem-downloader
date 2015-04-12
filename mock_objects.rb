module Hypem
  class MockObjects
    def serve_source
      ###response = <<-JSON
      ###  {"itemid":"1zht4","type":"SC","url":"http:\/\/api.soundcloud.com\/tracks\/113324557\/stream?consumer_key=nH8p0jYOkoVEZgJukRlG6w"}
      ###JSON
      ###JSON.parse(response) #> {"itemid"=>"1zht4", "type"=>"SC", "url"=>"http://api.soundcloud.com/tracks/113324557/stream?consumer_key=nH8p0jYOkoVEZgJukRlG6w"}
      {"itemid"=>"1zht4", "type"=>"SC", "url"=>"http://api.soundcloud.com/tracks/113324557/stream?consumer_key=nH8p0jYOkoVEZgJukRlG6w"}
    end

    def track
      {"type"=>"normal", "id"=>"1zht4", "time"=>260, "ts"=>1387207295, "postid"=>2378176, "posturl"=>"http://www.indieshuffle.com/best-artist-collaborations-2013/", "fav"=>0, "key"=>"5373d0eae8c78b030cccfcb0f95baa80", "artist"=>"Sia", "song"=>"Elastic Heart feat. The Weeknd & Diplo", "is_sc"=>true, "is_bc"=>false}
    end

    def track_list
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
  end
end
