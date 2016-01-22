# gentoo-overlay
PropertyGuru Gentoo Overlay

Add the following to your `/etc/portage/repos.conf/propertyguru.conf`:
```
# If you want to resync only this then use `emaint sync -r propertyguru`
# https://wiki.gentoo.org/wiki/Project:Portage/Sync#Portage_configuration
[propertyguru]
location = /usr/local/portage
sync-type = git
sync-uri = https://github.com/propertyguru/gentoo-overlay.git
auto-sync = yes
```
And run `emaint sync -r propertyguru`
