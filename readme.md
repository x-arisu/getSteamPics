Steamscreens
Download all your steam screenshots with a bash script!

How it works:

Go to your screenshots page on steam in a web browser.

From here you can select a specific game or you can use this page to get all
public/unlisted screenshots.

Now you just scroll/hold Page Down until you are at the bottom of your screenshots.

Then save the page in the same directory as the script.

Then just run:

./getSteampics.sh "/home/username/pathtosteampics/Steam Community SteamName Screenshots.html"

Then it should just start downloading.


Private & Friends only screenshots

To download screenshots hidden behind your account you will need to get the
steamLoginSecure token. To get this just login to the steam community website.
Press f12 / inspect element and go to the Storage/Cookies section.

There you will find stored cookies for steamcommunity.com
Just copy the steamLoginSecure token and paste it into the steamLoginSecure text file.
You will have to remove any extra stuff that might be there after pasting it

```
After pasting:
steamLoginSecure:"<your token here>"
```
```
After clean up:
<your token here>
```

This script depends on curl and bc

License MIT