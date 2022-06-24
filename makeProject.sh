#!/bin/bash

clear


displayCompilerInfo() {
	printf "\n"
	echo -n "### Current Compiler"
	printf "\n"
	eval xcrun swift -version
	eval xcode-select --print-path
}

#./iOSGenericCompile.sh "SmartApp.xcodeproj" "SmartApp Production" "Release" "[V1.0.0]"  "~/Desktop/" "Configuration/exportPlist.appStore.plist"

################################################################################

echo "### Brew"
echo " [1] : Install"
echo " [2] : Update"
echo " [3] : Skip"
echo -n "Option? "
read option
case $option in
    [1] ) /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ;;
    [2] ) eval brew update ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"

echo "### CocoaPods"
echo " [1] : Install"
echo " [2] : Skip"
echo -n "Option? "
read option
case $option in
    [1] ) sudo gem install cocoapods ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"

echo "### Swiftlint"
echo " [1] : Install"
echo " [2] : Skip"
echo -n "Option? "
read option
case $option in
    [1] ) brew install swiftlint ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"

echo "### Periphery"
echo " [1] : Install"
echo " [2] : Skip"
echo -n "Option? "
read option
case $option in
    [1] ) brew tap peripheryapp/periphery && brew install periphery ;;
    [2] ) eval brew update ;;
   *) echo "Ignored...."
;;
esac

################################################################################

printf "\n"

echo "### Xcodegen"
echo " [1] : Install"
echo " [2] : Upgrade"
echo " [3] : No/Skip"
echo -n "Option? "
read option
case $option in
    [1] ) brew install xcodegen ;;
    [2] ) brew upgrade xcodegen ;;
   *) echo "Ignored...."
;;
esac

################################################################################

displayCompilerInfo

printf "\n"

################################################################################

echo "### Kill Xcode?"
echo " [1] : No/Skip"
echo " [2] : Yes"
echo -n "Option? "
read option
case $option in
    [1] ) echo "Ignored...." ;;
   *) killall Xcode
;;
esac

################################################################################

printf "\n"

echo "### Clean DerivedData?"
echo " [1] : Yes"
echo " [2] : No/Skip"
echo -n "Option? "
read option
case $option in
    [1] ) rm -rf ~/Library/Developer/Xcode/DerivedData/* ;;
   *) echo "Ignored...."
;;
esac


################################################################################

printf "\n"

echo "Generating project...."
xcodegen -s ./XcodeGen/SmartApp.yml -p ./

################################################################################

echo "Generating graphviz...."
xcodegen dump --spec ./XcodeGen/SmartApp.yml --type graphviz --file ./_Documents/Graph.viz
xcodegen dump --spec ./XcodeGen/SmartApp.yml --type json --file ./_Documents/Graph.json

################################################################################

printf "\n"

echo "### periphery scan?"
echo " [1] : Yes"
echo " [2] : No/Skip"
echo -n "Option? "
read option
case $option in
    [1] ) periphery scan --project "SmartApp.xcodeproj" --schemes "SmartApp Production" --targets "SmartApp" --format xcode ;;
   *) echo "Ignored...."
;;
esac

################################################################################

open SmartApp.xcodeproj
