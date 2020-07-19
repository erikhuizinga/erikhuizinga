#!/usr/bin/env bash

simpleIcons=simple-icons
repo=$simpleIcons/$simpleIcons
latestVersion=$(curl https://api.github.com/repos/$repo/releases/latest --no-progress-meter | grep tag_name | cut -d '"' -f 4)
simpleIconsDir=icons/$simpleIcons
versionFile=$simpleIconsDir/.current-simple-icons-version
currentVersion=$(cat $versionFile)

if test $currentVersion != $latestVersion
then
	rawRepoUrl="https://raw.githubusercontent.com/$repo/$latestVersion"
	iconsUrl="$rawRepoUrl/icons"

	# Add fill color to SVG, so that it works on white(ish) and black(ish) backgrounds
	color="rgb(255,108,55)" # Source: Nedap Spark Orange (https://nedap.design/pages/color)
	icons="flutter rust vim kotlin java android androidstudio visualstudiocode gnubash jetbrains apple windows linux python mathworks"
	for icon in $icons
	do
		svgFile="$icon.svg"
		svgUrl="$iconsUrl/$svgFile"
		svg=$(curl $svgUrl --no-progress-meter)
		svg="${svg//fill=\"*\"}"
		svg="${svg//<path /<path fill=\"$color\" }"
		echo $svg > $simpleIconsDir/$svgFile
	done
	echo $latestVersion > $versionFile
	git add -A
	git commit -m "Update $simpleIcons to $latestVersion"
	git push
fi

