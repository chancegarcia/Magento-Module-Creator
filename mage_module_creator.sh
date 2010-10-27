#!/bin/bash

# Magento Module Creator
# Copyright (c) 2010 Erik Mitchell and The Dolan Company
# Creates Magento module based on simple user input provided at runtime
# Based on the Module Creator plugin by Netz98
# 	Daniel Nitz <d.nitz@netz98.de>
#	Copyright (c) 2008-2009 netz98 new media GmbH (http://www.netz98.de)
#	Credits for blank files go to alistek, Barbanet (contributer), Somesid (contributer) from the community:
#	http://www.magentocommerce.com/wiki/custom_module_with_custom_database_table
# License: http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)

read -p "What is the Namespace you'd like to use? " NAMESPACE

read -p "What is the name of your module? " MODULE

MODULE_LOWER=`echo $MODULE | awk '{print tolower($0)}'`

echo "Namespace is $NAMESPACE"
echo "Module is $MODULE"
echo "Lowercase is $MODULE_LOWER"
