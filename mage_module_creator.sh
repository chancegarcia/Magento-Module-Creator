#!/bin/bash

# Magento Module Creator
# Copyright (c) 2010 Erik Mitchell
# Creates Magento module based on simple user input provided at runtime
# Based on the Module Creator plugin by Netz98
# 	Daniel Nitz <d.nitz@netz98.de>
#	Copyright (c) 2008-2009 netz98 new media GmbH (http://www.netz98.de)
#	Credits for blank files go to alistek, Barbanet (contributer), Somesid (contributer) from the community:
#	http://www.magentocommerce.com/wiki/custom_module_with_custom_database_table
# License: http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)

NAMESPACE=""
MODULE=""

while [[ "$NAMESPACE" == "" ]]; do
	read -p "What is the Namespace you'd like to use? " NAMESPACE
done

while [[ "$MODULE" == "" ]]; do
	read -p "What is the name of your module? " MODULE
done

while [[ "$AUTHOR" == "" ]]; do
	read -p "What name should I use for author? " AUTHOR
done

PROJECT_NAME="$NAMESPACE"_"$MODULE"
NAMESPACE_LOWER=`echo $NAMESPACE | awk '{print tolower($0)}'`
MODULE_LOWER=`echo $MODULE | awk '{print tolower($0)}'`

echo "Creating module $PROJECT_NAME"

if [[ -f 'skel.tar' ]]; then
	tar -xf skel.tar
fi

if [[ ! -d 'builds' ]]; then
	mkdir builds
fi

if [[ -d 'skel' ]]; then
	if [[ -d "builds/$PROJECT_NAME" ]]; then
		echo "Deleting previous build"
		rm -fr "builds/$PROJECT_NAME"
	fi

	for LINE in `find skel`; do
		BUILD=`echo $LINE | 	sed "s/skel/builds\/$PROJECT_NAME/" | \
								sed "s/modules/foobar/g" | \
								sed "s/Namespace/$NAMESPACE/g" | \
								sed "s/namespace/$NAMESPACE_LOWER/g" | \
								sed "s/Module/$MODULE/g" | \
								sed "s/module/$MODULE_LOWER/g" | \
								sed "s/foobar/modules/g"`
		# Test if $LINE is a directory
		if [[ -d $LINE ]]; then
			#echo "Creating directory $BUILD"
			mkdir -p $BUILD
		else
			# Test file type
			echo $LINE | grep '\.xml$' > /dev/null 2>&1
			if [[ $? -eq 0 ]]; then
				# this is an XML file
				cat $LINE | sed "s/ModuleCreator/$AUTHOR/g" | \
							sed "s/\[Namespace\]/$NAMESPACE/g" | \
							sed "s/\[namespace\]/$NAMESPACE_LOWER/g" | \
							sed "s/\[Module\]/$MODULE/g" | \
							sed "s/\[module\]/$MODULE_LOWER/g" | \
							tr -d "\r" > $BUILD
			else
				cat $LINE | sed "s/ModuleCreator/$AUTHOR/g" | \
							sed "s/<Namespace>/$NAMESPACE/g" | \
							sed "s/<namespace>/$NAMESPACE_LOWER/g" | \
							sed "s/<Module>/$MODULE/g" | \
							sed "s/<module>/$MODULE_LOWER/g" | \
							tr -d "\r" > $BUILD
			fi
						
		fi
	done
else
	echo "Could not find the skel/ directory. Exiting..."
	exit 1
fi

if [[ -f builds/"$PROJECT_NAME".tar.gz ]]; then
	mv builds/"$PROJECT_NAME".tar.gz builds/"$PROJECT_NAME".tar.gz.old
	echo "builds/$PROJECT_NAME.tar.gz moved to builds/$PROJECT_NAME.tar.gz.old"
fi

cd builds/"$PROJECT_NAME" && tar -zcf ../"$PROJECT_NAME".tar.gz *
cd - > /dev/null 2>&1
rm -fr builds/"$PROJECT_NAME"
rm -fr skel

echo "builds/$PROJECT_NAME.tar.gz created."
echo "Finished."
