Steamscreens
Download all your steam screenshots with a bash script!

How it works:

Go to your screenshots page on steam in a web browser.

From here you can select a specific game or you can use this page to get all
public/unlisted screenshots.

Now you just scroll/hold Page Down until you are at the bottom of your screenshots.

Then save the page in the same directory as the script.

Then just run:

./getSteampics.sh "/home/<username>/pathtosteampics/Steam Community SteamName Screenshots.html"

Then it should just start downloading.

This script depends on curl and bc

License MIT