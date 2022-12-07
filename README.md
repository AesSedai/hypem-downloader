# hypem-downloader-ruby

## Usage

Download songs from the popular page.

Ruby:
```` sh
ruby tracks.rb
````

Docker:
``` sh
docker run -v /host/path/to/out:/out -it aessedai/hypem:0.0.1 -u popular -c "AUTH=ABCDEFGHIJKLMNOPQRSTUVWXYZ" -p 1
```

## Disclaimer

This script is for educational/theoretical purposes. Don't use if in violation of [hype machine terms of service](http://hypem.com/terms).

## Reference

 + https://github.com/fzakaria/HypeMachine-Extension/blob/6ea946024fd3f856306aba0874029964051dd369/extension.js
 + https://github.com/kenanM/HypeMachine-Downloader/blob/master/hypem.py
 + https://github.com/Saimuel/HypeDownloader/blob/master/hypecloud.py
 + http://hypem.com/
 + http://hypem.com/playlist/latest/all/json/1/data.js
 + https://developers.soundcloud.com/docs/api/guide
