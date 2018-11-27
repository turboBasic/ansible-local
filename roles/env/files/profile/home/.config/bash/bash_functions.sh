#
# this file needs to be sourced either by bash or zsh
#

TRACE_SCRIPT=${TRACE_SCRIPT:+"${TRACE_SCRIPT}:"}${BASH_SOURCE}



function echoerr()
{
	cat <<< ${@} 1>&2
}



# No arguments: `git status`
# With arguments: acts like `git`

function g()
{
    if [[ ${#} > 0 ]]
    then
        git ${@}
    else
        git status
    fi
}



function normalizePath()
{
	# if no parameters provided, read them from pipeline
	declare MY_INPUT=${*:-$( </dev/stdin )}
	declare item

	# delete consequent '/' and trim last '/'
	for item in ${MY_INPUT}
	do
		item=$( echo ${item} | tr -s / )
		echo ${item%/}
	done
}



function filterBlank()
{
	while read line
	do
		echo ${line} | sed '/^\s*$/d'
	done
}



function isInPath()
{
	#[[ :${PATH}: == *:${1}:* ]]
	declare result

	echo ${PATH} | tr -s / | sed 's#/:#:#g;s/:/\n/g' | grep -q "^${1}$" && result=found || result=''
	[[ ${result} == found ]]
}



function lsd()
{
    \ls --classify --hide-control-chars ${@} | grep /$
}



function lsf()
{
    \ls --classify --hide-control-chars ${@} | grep --invert-match /$
}



function splitString()
{
	declare POSITIONAL=()
	declare DELIMITER=''
	declare DEFAULT=''
	declare item
	declare key

	while [[ ${#} -gt 0 ]]
	do
		key=${1}

		case ${key} in
			-d | --delimiter)
				DELIMITER=${2}
				shift 				# past argument
				shift 				# past value
				;;
			--default)
				DEFAULT=YES
				shift
				;;
			*)    					# unknown option
				POSITIONAL+=(${1}) 	# save it in an array for later
				shift
				;;
		esac
	done

	# if DELIMITER is not defined or empty, set it to <space>
	DELIMITER=${DELIMITER:-\ }

	# if no parameters provided, read them from pipeline
	if [[ ${#POSITIONAL} -eq 0 ]]
	then
		POSITIONAL=$(< /dev/stdin)
	fi

	for item in ${POSITIONAL[@]}
	do
		echo ${item//$DELIMITER/$'\n'}
	done
}


# append to PATH if directory exists
function pathAppend()
{
    for arg in ${@}
    do
        arg=$(normalizePath $arg)
        if [[ :${PATH}: != *:${arg}:*  &&  -d ${arg} ]]
        then
            export PATH=${PATH:+"${PATH}:"}${arg}
        fi
    done
}


# prepend to PATH if directory exists
function pathPrepend()
{
    for arg in ${@}
    do
        arg=$(normalizePath $arg)
        if [[ :${PATH}: != *:${arg}:*  &&  -d ${arg} ]]
        then
            export PATH=${arg}${PATH:+":${PATH}"}
        fi
    done
}


# timestamp
function timeStamp()
{
    declare LONG=NO
    declare FORMAT='+%Y%m%d-%H%M%S'

    while [[ ${#} -gt 0 ]]
    do
        key=${1}

        case ${key} in
            -l | --long)
                LONG=YES
                shift
                ;;
            *)                      # unknown option
                echoerr "timeStamp:: Unknown argument(s): ${key}"
                return 1
                ;;
        esac
    done

    if [[ ${LONG} == YES ]]
    then
        FORMAT+='-%N'
    fi

    date ${FORMAT}
}


function sourceDirectory()
{
    TEMP=$(getopt --options hvf: --longoptions help,verbose,files: --name 'sourceDirectory' -- "$@")
    if [[ ${?} != 0 ]]
    then 
        echo "Terminating..." >&2
        return 1
    fi
    eval set -- "${TEMP}"
    
    HELP=
    VERBOSE=
    FILES="*.sh"
    
    while true
    do
        case "${1}" in
            -h | --help )       HELP=true; shift ;;
            -v | --verbose )    VERBOSE=true; shift ;;
            -f | --files )      FILES="${2}"; shift 2 ;;
            -- )                shift; break ;;
            * )                 break ;;
        esac
    done
    
    [[ ${VERBOSE} ]] && cat <<ENDOFOPTIONS
OPTIONS: 
    help=${HELP}
    verbose=${VERBOSE}
    files=${FILES}

DIRECTORY=${1}

ENDOFOPTIONS


    [[ ${HELP} ]] && cat <<ENDOFHELP
sourceDirectory: sources all files inside a directory

sourceDirectory [OPTIONS] DIRECTORY

OPTIONS:
    -h, --help      prints this message
    -v, --verbose   verbose output
    -f, --files     mask for files which will be sourced. Should be a valid file glob
    
DIRECTORY:
    name of directory from where files are going to be sourced
    
ENDOFHELP

    
    if [[ -d "${1}" ]] && ! find "${1}/." ! -name . -prune -exec false {} +
    then
        [[ ${VERBOSE} ]] && echo "start sourcing files from non-empty directory: ${1}"
        for f in "${1}"/${FILES}
        do
	    [[ ${VERBOSE} ]] && echo "sourcing file: ${f}"
            source "${f}"
        done
    elif [[ -f "${item}" ]]
    then
        [[ ${VERBOSE} ]] && echo "sourcing file: ${1}"
        source "${1}"
    elif [[ -d "${1}" ]]
    then
        [[ ${VERBOSE} ]] && echo "directory ${1} is empty, skipping it"
    else    
        echoerr "${1} not found!"
	echoerr ""
	return 1
    fi
}


function echoargs()
{
    printf "%d args:" "$#"
    printf " <%s>" "$@"
    echo
}


if [[ ${BASH_VERSION} ]]
then
    export -f echoerr
    export -f filterBlank
    export -f g
    export -f lsd
    export -f lsf
    export -f normalizePath
    export -f pathAppend
    export -f pathPrepend
    export -f splitString
    export -f timeStamp
fi

