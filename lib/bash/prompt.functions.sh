#!/bin/bash

function prompt() {

	#local R='\e[0;31m' # Red
	#local G='\e[0;32m' # Green
	#local Y='\e[0;33m' # Yellow
	#local B='\e[0;34m' # Blue
	#local M='\e[0;35m' # Purple
	#local C='\e[0;36m' # Cyan
	#local W='\e[0;37m' # White
	
	#local EMK='\e[1;30m' # Black - Bold
	local EMR='\e[1;31m' # Red
	local EMG='\e[1;32m' # Green
	local EMY='\e[1;33m' # Yellow
	#local EMB='\e[1;34m' # Blue
	#local EMM='\e[1;35m' # Purple
	#local EMC='\e[1;36m' # Cyan
	#local EMW='\e[1;37m' # White
	
	#local UK='\e[4;30m' # Black - Underline
	local UR='\e[4;31m' # Red
	#local UG='\e[4;32m' # Green
	#local UY='\e[4;33m' # Yellow
	local UB='\e[4;34m' # Blue
	#local UM='\e[4;35m' # Purple
	#local UC='\e[4;36m' # Cyan
	#local UW='\e[4;37m' # White
	
	#local BK='\e[40m'   # Black - Background
	local BR='\e[41m'   # Red
	#local BG='\e[42m'   # Green
	#local BY='\e[43m'   # Yellow
	#local BB='\e[44m'   # Blue
	#local BM='\e[45m'   # Purple
	#local BC='\e[46m'   # Cyan
	#local BW='\e[47m'   # White
	
	# High Intensty
	local HBK='\e[0;90m'       # Black
	#local HR='\e[0;91m'         # Red
	#local HG='\e[0;92m'       # Green
	local HY='\e[0;93m'      # Yellow
	local HB='\e[0;94m'        # Blue
	#local HM='\e[0;95m'      # Purple
	#local HC='\e[0;96m'        # Cyan
	#local HW='\e[0;97m'       # White
	
	# Bold High Intensty
	#local BIBlack='\e[1;90m'      # Black
	#local BIRed='\e[1;91m'        # Red
	#local BIGreen='\e[1;92m'      # Green
	#local BIYellow='\e[1;93m'     # Yellow
	#local BIBlue='\e[1;94m'       # Blue
	#local BIPurple='\e[1;95m'     # Purple
	#local BICyan='\e[1;96m'       # Cyan
	#local BIWhite='\e[1;97m'      # White
	
	# High Intensty backgrounds
	#local On_IBlack='\e[0;100m'   # Black
	#local On_IRed='\e[0;101m'     # Red
	#local On_IGreen='\e[0;102m'   # Green
	#local On_IYellow='\e[0;103m'  # Yellow
	#local On_IBlue='\e[0;104m'    # Blue
	#local On_IPurple='\e[10;95m'  # Purple
	#local On_ICyan='\e[0;106m'    # Cyan
	#local On_IWhite='\e[0;107m'   # White
	
	local RST='\e[0m'    # Text Reset

	local PWR_STATUS=""

	function prompt_power() {
		# default: bold red
		local color="${EMR}"

		# check battery status
		local batt_stat=$(acpi | awk '{print $4}' | tr -d , | tr -d %)
		
		# check ac adapter status
		local adap_stat=$(acpi | awk '{print $3}')
	
		if [ "$batt_stat" -eq "100" ] ;then
			color="${UB}"
		elif [ "$batt_stat" -gt "75" ] ;then
			color="${EMG}"
		elif [ "$batt_stat" -gt "60" ] && [ "$batt_stat" -le 75 ] ;then
			color="${EMY}"
		fi
	
		PWR_STATUS="| \[${color}\]${batt_stat}\[${RST}\] "
	}

	function check_acpi_cap() {
		( [ `which acpi` = "" ] \
			|| `which acpi` 2>&1 | grep -i "no support" ) \
			|| return 1 
		return 1
	}

	check_acpi_cap 2>&1> /dev/null

	if [ "$?" = "0" ] ;then
		prompt_power
	fi
	
	PS1="${PWR_STATUS}"

	PS1+="|"

	PS1+=" \[${UR}\]"
	PS1+="\!"
	PS1+="\[${RST}\]"

	PS1+=","

	PS1+="\[${UR}\]"
	PS1+="\#"
	PS1+="\[${RST}\] "
	PS1+="|"

	PS1+=" \[${HY}\]"
	PS1+="\[${BR}\]"
	PS1+="\u@\H"
	PS1+="\[${RST}\] "

	PS1+="|"

	PS1+="\n"

	PS1+="\[${HB}\]"
	PS1+="\w"
	PS1+="\[${RST}\]"
	
	PS1+="\n"

	PS1+="\\$"

}
