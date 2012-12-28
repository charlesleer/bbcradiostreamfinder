#!bin/sh
#there are most likely 10000's of other ways to do this, but this one is working for me :)
clear
echo "BBC stream url finder"
echo ""
read -p "[*] Enter PID: " pid
echo "[*] Grabbing playlist for $pid"
wget -O $pid.xml http://www.bbc.co.uk/iplayer/playlist/$pid >/dev/null 2>&1
xmlraw=$(cat $pid.xml | awk '/mediator identifier/')
showid=$(echo $xmlraw | cut -c23-30)
echo "[*] Scrapping for stream link"
wget -O $showid.raw http://bbc.co.uk/mediaselector/4/asx/$showid/iplayer_intl_stream_wma_lo_concrete >/dev/null 2>&1
urlraw=$(sed -n '8p' $showid.raw)
echo $urlraw | cut -c 12- | awk 'sub("...$", "")' >$showid.asx
urlfinal=$(cat $showid.asx)
echo "[*] Stream URL = $urlfinal"
echo "[*] Playlist file saved as $showid.xml"
echo "[*] Show URL saved in file $showid.asx"
rm $showid.raw
