## set up server

```shell
docker build -t my-nginx-rtmp:v1 .

docker rm -f nginx-rtmp && docker run -d --name nginx-rtmp \
-p 1935:1935 -p 80:80 -p 9001:9001 \
-v $(pwd)/nginx.conf:/etc/nginx/nginx.conf \
-v $(pwd)/tmp/hls:/tmp/hls \
-v $(pwd)/var/log:/var/log/nginx \
my-nginx-rtmp:v1
```

## run ffmpeg input from camera & audio , output to rtmp
```shell
ffmpeg -re -f avfoundation -framerate 30 -video_size 640x480 -i "0" -f avfoundation -i ":0" \
-c:v libx264 -vf format=uyvy422 -b:v 4000k -bufsize 8000k -maxrate 4000k -g 30 \
-c:a aac -b:a 192k -ar 48000 -af "equalizer=f=1000:t=q:w=1:g=5,loudnorm" \
-f flv 'rtmp://localhost:1935/live/mychannel3'
```

```shell
apt-get install websockify lsof
websockify -D localhost:9001 127.0.0.1:1935
lsof -i -P -n | grep LISTEN
```

# republish to oss rtmp
```shell
ffmpeg -i http://localhost/hls/mychannel/index.m3u8 -c:v copy -c:a copy -f flv "rtmp://bucket-name.oss-ap-southeast-5.aliyuncs.com/live/live-demo2?Expires=&OSSAccessKeyId=&Signature=&playlistName=playlist.m3u8"
```

## playback HLS urls

[http://localhost/hls/mychannel.m3u8](http://localhost/hls/mychannel.m3u8)




## doc

- https://github.com/arut/nginx-rtmp-module
- https://github.com/arut/nginx-rtmp-module/wiki/Directives#hls_sync
- https://github.com/tiangolo/nginx-rtmp-docker/blob/master/Dockerfile

