#!/bin/bash

# process parameters
if [[ $1 -eq 1 ]] && [[ "$1" == "all" ]]; then
	./buildpackage "dlvhex2" "2.4.0"
	./buildpackage "dlvhex2-aggregateplugin" "2.0.0"
	./buildpackage "dlvhex2-dlliteplugin" "2.0.0"
	./buildpackage "dlvhex2-dlplugin" "2.0.0"
	./buildpackage "dlvhex2-mcsieplugin" "2.0.0"
	./buildpackage "dlvhex2-nestedhexplugin" "2.0.0"
	./buildpackage "dlvhex2-stringplugin" "2.0.0"
	./buildpackage "dlvhex2-scriptplugin" "2.0.0"
	exit 0
fi
if [[ $# -ne 2 ]]; then
	echo "This script expects the package name and the package version as parameters"
	echo "Supported packages and versions:"
	echo "   dlvhex2                         (versions: 2.4.0)"
	echo "   dlvhex2-aggregateplugin         (versions: 2.0.0)"
	echo "   dlvhex2-dlliteplugin            (versions: 2.0.0)"
	echo "   dlvhex2-dlplugin                (versions: 2.0.0)"
	echo "   dlvhex2-mcsieplugin             (versions: 2.0.0)"
	echo "   dlvhex2-nestedhexplugin         (versions: 2.0.0)"
	echo "   dlvhex2-stringplugin            (versions: 2.0.0)"
	echo "   dlvhex2-scriptplugin            (versions: 2.0.0)"
	echo ""
	echo "The call"
	echo "   ./buildpackage all"
	echo "builds the most recent version of all supported packages"
	exit 1
fi
package=$1
version=$2

# check if the sourcecode is available
if [ ! -f ${package}_$version.orig.tar.gz ]; then
	# no: download it
	echo "Sourcecode in \"${package}_$version.orig.tar.gz\" does not exist, trying to download it"
	if [[ "$package" == "dlvhex2" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex/$version/${package}-$version.tar.gz -O ${package}_$version.orig.tar.gz
	elif [[ "$package" == "dlvhex2-aggregateplugin" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex-aggregateplugin/$version/${package}-$version.tar.gz -O ${package}_$version.orig.tar.gz
	elif [[ "$package" == "dlvhex2-dlliteplugin" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex-dlliteplugin/$version/${package}-$version.tar.gz -O ${package}_$version.orig.tar.gz
	elif [[ "$package" == "dlvhex2-dlplugin" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex-dlplugin/$version/${package}-$version.tar.gz -O ${package}_$version.orig.tar.gz
	elif [[ "$package" == "dlvhex2-mcsieplugin" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex-mcsieplugin/$version/${package}-$version.tar.gz -O ${package}_$version.orig.tar.gz
	elif [[ "$package" == "dlvhex2-nestedhexplugin" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex-mcsieplugin/$version/${package}-$version.tar.gz -O ${package}_$version.orig.tar.gz
	elif [[ "$package" == "dlvhex2-scriptplugin" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex-scriptplugin/$version/${package}-$version.tar.gz -O ${package}_$version.orig.tar.gz
	elif [[ "$package" == "dlvhex2-stringplugin" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex-stringplugin/$version/${package}-$version.tar.gz -O ${package}_$version.orig.tar.gz
	else
		echo "Unknown package: \"$package\""
		exit 1
	fi

	if [ ! -f ${package}_$version.orig.tar.gz ]; then
		echo "Error: Could not find sourcecode \"${package}_$version.orig.tar.gz\""
		exit 1
	fi
fi

# check if the sourcecode is ready for building
if [ ! -f $package-$version/configure ]; then
	echo "Sourcecode is not extracted, will do this now"
	temp=$(mktemp -d)
	tar -xvzf ${package}_$version.orig.tar.gz -C $temp
	mv $temp/*/* $package-$version/
	rm -rf $temp
	if [ ! -f $package-$version/configure ]; then
		echo "Error: Cound not extract sourcecode for building"
		exit 1
	fi
fi

# build the package
echo "Building package $package (version $version)"
cd $package-$version
# 32 bit package
#dpkg-buildpackage -ai386 -us -uc -d
# 64 bit package
dpkg-buildpackage -us -uc -d

