#!/bin/bash
# WordPress recovery script
# Use moltiple methods to recover from an infected wordpress website
#
# powered by bash
# Written by Noam Alum
#
# Documentation at https://ncode.codes/assets/single_snippet/Single_codes.php?code=wp_recovery
# GitHub page at https://github.com/Noam-Alum/wp_recovery/
#
# © Ncode. All rights reserved
# Visit ncode.codes for more scripts like this :)

### FUNCTIONS
## handle errors
function HandleError {
    echo "ERROR wp_recovery line: \"$BASH_COMMAND\" exited with status $?\n"
}
trap 'HandleError' ERR

## Get binary
function get_binary {
    trap 'HandleError' ERR

    # list all binaries
    wrsn_commands=("echo" "command" "ls" "tail" "grep" "read" "rm" "awk" "tr" "chown" "stat")

    # get binaries
    for binary in "${wrsn_commands[@]}"
    do
        # search for binary
        if [ ! -z "$(which $binary)" ]; then
            # set command to full path to binary
            export $binary="$(which $binary)"

        # try running the command if so use it as is
        elif [ ! -z "$($binary --help 2>/dev/null)" ]; then
            export $binary="$binary"

        # binary dependency missing exiting
        else
            # LOG--help
            echo "ERROR - binary dependency missing \"$binary\" exiting."

            # EXIT
            exit 1
        fi
    done
}

## CHECK ENVIRONMENT
function check_environment {
	#### get binary ####
	get_binary

	# check for wordpress root directory & mandatory file
	if [ ! -e "wp-includes/version.php" ]; then
		$echo -e "Not in websites root directory or file \"version.php\" does not exists."
        exit 1
	fi

	# check for WPCLI
    if [ ! -z "$(which wp)" ]; then
        # set command to full path to binary
        export wp="$(which wp)"

    # try running the command if so use it as is
    elif [ ! -z "$(wp --help 2>/dev/null)" ];then
        export wp="wp"

    # binary dependency missing exiting
    else
        $echo -e "Dependency \"WP-CLI\" is not installed.\n - Consider installing: https://wp-cli.org/#installing"

        # EXIT
        exit 1
    fi
}

## CHECK USER INPUT
function user_input {
    get_binary

    # fix issue with calling read from binary if it exists
    $read -p "test" r_test <<< "test"
    if [ -z "$r_test" ] && $command -v read > /dev/null; then
	    read="read"
    else
	    $echo "ERROR - error with binary \"read\""
	    
        # EXIT
        exit 1
    fi
    
    # get user input
    $read -p "Continue? [yes/no] : " user_answer < /dev/stdin

    while [ -z "$user_answer" ]; do
        $read -p "Continue? [yes/no] : " user_answer < /dev/stdin
    done

    while [ "$user_answer" != "yes" ] && [ "$user_answer" != "no" ]; do
        $read -p "Continue? [yes/no] : " user_answer < /dev/stdin
    done
}

## REMOVE FROM LIST
function alter_list {

    # get list name
    local list_name="$1"

    # get list contents
    local -n f_lst=$list_name

    while [ "$file_index" != "!" ]
    do
        $echo -e "\nFiles to be removed:\n$(for file in ${f_lst[@]}; do $echo " - $file"; done)\n"
        $read -p "What file would you like to remove from the list? [! to exit] : " file_index

        # REMOVE FROM LIST
        if [ "$file_index" != "!" ]; then
            f_lst=("${f_lst[@]/$file_index}")
        fi
    done
}

### MAIN
#### get binary ####
get_binary

# ASCII art for fun ;)
$echo "
 ________                __ ______                                                           
|  |  |  |.-----.----.--|  |   __ \.----.-----.-----.-----.                                  
|  |  |  ||  _  |   _|  _  |    __/|   _|  -__|__ --|__ --|                                  
|________||_____|__| |_____|___|   |__| |_____|_____|_____|                                  
                                                                                             
 ______                                               _______             __         __      
|   __ \.-----.----.-----.--.--.-----.----.--.--.    |     __|.----.----.|__|.-----.|  |_    
|      <|  -__|  __|  _  |  |  |  -__|   _|  |  |    |__     ||  __|   _||  ||  _  ||   _|__ 
|___|__||_____|____|_____|\___/|_____|__| |___  |    |_______||____|__|  |__||   __||____|__|
                                          |_____|                            |__|            
"

#### check environment #####
check_environment

# get WordPress version
wp_version="$($grep "wp_version = " wp-includes/version.php | $awk -F "[='\"]" '{print $3}' | $tr -d '[:space:]')"

# get owner
wp_owner="$($stat -c "%U" wp-includes/version.php)"

# list files to remove
bad_files=($($ls -a | $tail -n +3 | $grep -v 'wp-config.php\|wp-content\|.htaccess\|wp_recovery.sh'))

if [ ${#bad_files[@]} -lt 40 ]; then
    $echo -e "\nFiles to be removed:\n$(for file in ${bad_files[@]};do $echo " - $file";done)"
else
    $echo -e "\nFiles to be removed:\n$(for ((i=0; i<31; i++)); do $echo " - ${bad_files[$i]}";done)\n\netc...\n"
    $echo "would you like full list?"
    user_input

    if [ "$user_answer" == "yes" ]; then
        $echo -e "\nFull list of files to be removed:\n$(for file in ${bad_files[@]};do $echo " - $file";done)"
    fi
fi

# alter file list if needed
$echo -e "\nDo you wish to remove items from the list of files?\nWordPress files cannot be removed.\n"
user_input
if [ "$user_answer" == "yes" ]; then
    alter_list "bad_files"
fi

$echo -e "\nWould you like to continue removing files?"

user_input

if [ "$user_answer" == "yes" ]; then
    # remove infected files
    for file in ${bad_files[@]}
    do
        $rm -rf $file
    done
    $echo -e " - Finished removing files."

    # download core again
    $echo -e "\nIntalling core of wordpres version $wp_version"
    $wp core download --version=$wp_version --allow-root > /dev/null

    # if download failed try forced version
    if [ "$?" -ne "0" ]; then
        $echo -e "\nWordPress core installation faild, would you like to try forced version? (files related to wordpress will be removed.)"
        user_input
        if [ "$user_answer" == "yes" ]; then
            $wp core download --version=$wp_version --allow-root --force > /dev/null
        fi
    fi

    # fix owner
    $chown -R $wp_owner:$wp_owner * .htaccess &> /dev/null
    $echo -e "\n - Done.\n"
else
    $echo -e "\nok, bye :)\n"

    # EXIT
    exit 0
fi

##### Will be adding more ways to recover
##### Any one that would like to add is more than welcome
