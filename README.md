# hypem-downloader-ruby

## Usage

```` sh
git clone https://gist.github.com/s2t2/2a24d01976b7aab74b27
cd 2a24d01976b7aab74b27
bundle install
````

```` rb
Hypem::TracksController.download(:from_url => "http://hypem.com/artist/Sia/1/?sortby=favorite")
````

## Disclaimer

This script is for educational/theoretical purposes. Don't use if in violation of [hype machine terms of service](http://hypem.com/terms).

## Reference

 + https://github.com/fzakaria/HypeMachine-Extension/blob/6ea946024fd3f856306aba0874029964051dd369/extension.js
 + https://github.com/kenanM/HypeMachine-Downloader/blob/master/hypem.py
 + https://github.com/Saimuel/HypeDownloader/blob/master/hypecloud.py
 + http://hypem.com/
 + http://hypem.com/playlist/latest/all/json/1/data.js
 + https://developers.soundcloud.com/docs/api/guide
