#!/bin/bash

# Export only expliticly installed packages
mygroups="gnome gnome-extra base-devel"
additional_exclusions="base grub linux efibootmgr intel-ucode dhcpcd"
pacman_local_packages=$(pacman -Qm | awk '{printf "%s ",$1}')
echo "excluding local packages (AUR): $pacman_local_packages"
echo "excluding packages (as normally part of arch installation): $additional_exclusions"
echo "excluding members groups $mygroups"

#get complete packages list
pacman_all_packages=$(pacman -Qe | awk '{printf "%s ",$1}')
#echo "###########"
#echo "ALL PACKAGES INSTALLED EXPLICITLY"
#echo $pacman_all_packages
#echo "###########"
ignore_packages=""
ignore_groups_packages=""
echo "#########"
echo "##adding ignore package for groups $mygroups"
groups_packages=$(pacman -Qg $mygroups | awk '{printf "%s ",$2}')
#echo $groups_packages
echo "#########"

ignore_packages="$groups_packages $pacman_local_packages $additional_exclusions"
echo "Full list of ignored packages: $ignore_packages"
pacman_packages=""

# Loop over all package and exclude explicit exclusions + AUR packages
ignore_packages_array=( $ignore_packages )
#echo "ARRAY IGNORE: ${ignore_packages_array[@]}"
all_packages_array=( $pacman_all_packages )
for package in "${all_packages_array[@]}"
do
	#echo "iterating for package $package"
	match=0
	for package_to_be_ignored in "${ignore_packages_array[@]}"
	do
		#echo "Comparing $package_to_be_ignored and $package"
    		if [ "$package_to_be_ignored" = "$package" ]
		then
			#echo "Match found $package_to_be_ignored $package"
	        	match=1
	        	break
    		fi
	done
	if [ $match -eq 0 ] 
		then
			#echo "No match found for package $package"
			pacman_packages="$pacman_packages $package"
	fi
done
echo "###############################"

#Add groups to list of packages to be installed
pacman_packages="$pacman_packages $mygroups"
echo "Final list of packages: $pacman_packages"
out_file=pacman_packages_$(date +'%Y-%m-%d_%H-%M').txt
out_file_aur=pacman_packages_$(date +'%Y-%m-%d_%H-%M').aur.txt
echo $pacman_packages > $out_file
echo $local_packages > $out_file_aur
