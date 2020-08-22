# GenCool
Cool ebuilds collection for gentoo

These ebuilds are provided as it. They work for me at the time I commited them.
I make my possible to follow the gentoo policies and to keep the ebuilds up to date.
All ebuilds are tested with repoman.
If you find a non working ebuild, please contribute and open a bug report.

The x11-wm/fvwm3 ebuild does not follow the gentoo policy about installation paths.
It install most of the files into /usr/local.
That way, you can have both fvwm 2 and 3 installed into the same system.

Enjoy!

## Ebuilds list
dev-libs/slicot: dependency of media-sound/guitarix[dkbuilder]

media-sound/guitarix: guitarix live ebuild with dkbuilder support

sci-electronics/lepton-eda: gEDA fork

sci-electronics/spice-audio-tools: using wav files with ngspice

sci-electronics/xoscope: xoscope live ebuild

x11-libs/gtkdatabox: runtime dependency for sci-electronics/xoscope

x11-wm/fvwm3: live ebuild for fvwm3

## Usage
I suppose you want to install the overlay in /var/lib/layman, and get it managed by layman

1) `cd /var/lib/layman`
2) `git clone https://github.com/domichel/GenCool.git`
3) `/var/lib/layman/installed.xml` must have one repo section for each layman managed overlay. As example for GenCool:
```
<?xml version='1.0' encoding='UTF-8'?>
<repositories encoding="UTF-8" version="1.0">
  <repo priority="50" quality="experimental" status="unofficial">
    <name>GenCool</name>
    <description>Domichel's overlay with cool ebuilds</description>
    <homepage>https://github.com/fomichel/GenCool</homepage>
    <owner>
      <email>dominique_libre@users.sf.net</email>
    </owner>
    <source type="git">git://github.com/domichel/GenCool.git</source>
  </repo>'
```
4)  `/var/lib/layman/make.conf` should look like:
```
PORTDIR_OVERLAY="
$PORTDIR_OVERLAY
/var/lib/layman/GenCool
/var/lib/layman/test"
```
5) `/etc/portage/repos.conf/GenCool.conf` should be:
```
[DEFAULT]
main-repo = layman

[GenCool]
location = /var/lib/layman/GenCool
sync-type = git
sync-uri = https://github.com/domichel/GenCool.git
```
6) `/etc/portage/repos.conf/layman.conf` should have a section for GenCool:
```
[GenCool]
priority = 90
location = /var/lib/layman/GenCool
layman-type = git
auto-sync = No
```
Now, you can run `layman -s ALL` and get all your overlays including GenCool to be updated.
You will see something like:
```
 * Syncing selected overlay(s)...
 * Running Git... # ( cd /var/lib/layman/GenCool  && /usr/bin/git pull )
Already up to date.
...snip...
* Successfully synchronized overlay "GenCool".
...snip...
* Overlay "GenCool" could not be found in the remote lists.
``` 
You can ignore that warning, it's normal because GenCool is not in layman's remote list of overlays. 
