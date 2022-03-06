# pac export packages
Utility to export list of packages explicitly installed from an Archlinux installation

To be used when it's needed a re-installation of the system to generate a list of packages that can be consumed by pacman when performing a fresh installation, after installing the base system

Edit variables at the begining of the scripts in order to edit groups: they will be used to ignore from the final list groups' members. The groups will be indeed added in the list of pacman packages

Also local packages are not included. This is meant to avoid AUR/manual installation packages are included, but only official arch packages.

The scripts generates 2 files
	
	pacman_packages_${DATE_TIME}.txt: it includes the pacman packages. to be installed with pacman -S < file.txt
	pacman_packages_${DATE_TIME}.aur.txt: it included local packages. To be used with your favourite AUR helper
