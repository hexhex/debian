if [[ $# -ne 1 ]]; then
	echo "This script expects the package name as single parameter"
	echo "Supported values:"
	echo "   dlvhex2-2.4.0"
	echo "   dlvhex2-mcsieplugin-2.0.0"
	exit 1
fi
package=$1

# check if the sourcecode is available
if [ ! -f $package.tar.gz ]; then
	# no: download it
	echo "Sourcecode does not exist, trying to download package $package"
	if [[ "$package" == "dlvhex2-2.4.0" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex/2.4.0/dlvhex-2.4.0.tar.gz -O dlvhex2-2.4.0.tar.gz
		cp dlvhex2-2.4.0.tar.gz dlvhex2_2.4.0.orig.tar.gz
	elif [[ "$package" == "dlvhex2-mcsieplugin-2.0.0" ]]; then
		wget http://sourceforge.net/projects/dlvhex/files/dlvhex-mcsieplugin/2.0.0/dlvhex-mcsieplugin-2.0.0.tar.gz -O dlvhex2-mcsieplugin-2.0.0.tar.gz
		cp dlvhex2-mcsieplugin-2.0.0.tar.gz dlvhex2-mcsieplugin_2.0.0.orig.tar.gz
	else
		echo "Unknown package: $package"
		exit 1
	fi

	if [ ! -f $package.tar.gz ]; then
		echo "Error: Could not find sourcecode"
		exit 1
	fi
fi

# check if the sourcecode is ready for building
if [ ! -f $package/configure ]; then
	echo "Sourcecode is not extracted"
	temp=$(mktemp -d)
	tar -xvzf $package.tar.gz -C $temp
	mv $temp/*/* $package/
	rm -rf $temp
	if [ ! -f $package/configure ]; then
		echo "Error: Cound not prepare sourcecode for building"
		exit 1
	fi
fi

# build the package
cd $package
dpkg-buildpackage -us -uc -d
