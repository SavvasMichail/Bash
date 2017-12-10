#!/bin/bash

#####################################################################################################
## The script retrieves all the Oracle package specifications and bodys of the current working
## directory and
##	a) Converts them to unix format (dos2unix)
##	b) Populates their output filename (i.e MyPackage.bdy will be wMyPackage.bdy)
##	c) Run the oracle wrap command
##	d) Move the wrapped files to their destination and change the permissions
#####################################################################################################

OutputDir="WrappedFiles"
CurrentDir=`pwd`
TargetDir=$CurrentDir/$OutputDir/

echo "The target directory is: "$TargetDir

if [ -d "$TargetDir" ]; then
	echo -n "The directory exists. Press d for delete or r for reuse existing directory:"
	read -n 1 UserInput
	echo ""
	if [ "$UserInput" == "d" ]; then
		rm -f $TargetDir/*
		rmdir $TargetDir
		mkdir $TargetDir
	fi
else
	mkdir $TargetDir
fi

tmpInVar=''
tempOutVar=''

for file in $CurrentDir/*.{bdy,spc}
do
	if [ -f "$file" ]; then
		echo "Input File [$file]"
		dos2unix ${file}
		tmpInVar=`basename $file`
		tempOutVar=$CurrentDir/w`basename $file`
		
		echo "Output File [$tempOutVar]"
		#touch $tempOutVar
		wrap iname=$file oname=$tempOutVar edebug=wrap_new_sql
		mv ${tempOutVar} $TargetDir
		
		chmod 775 $TargetDir
	fi
done
