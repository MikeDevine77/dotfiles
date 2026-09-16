
# checkinginputs allow...
# DP, USB-C, HDMI and display if they make error
  #OPTIND=1
  #verbose=0
  #name=""
##
#while getopts "h?vn:" opt; do
    #case "$opt" in
    #h|\?)
        #echo "Usage: $0 [-v] [-n name]"
        #exit 0
        #;;
    #v)  verbose=1
        #;;
    #c)  name=$OPTARG
        #;;
    #esac
#done


  # Back to the beginning now and get our opts

  #while getopts ':c:d:h:' opt; do
    ## and so on
	#echo [...]

#shift $((OPTIND-1))

#[ "${1:-}" = "--" ] && shift

#echo "verbose=$verbose, name='$name', Leftovers: $@"


if [[ "$(uname)" = "Darwin" ]]; then
        # Mac OSX
        # Switch over to Display Port to DP
				~/progz/m1ddc/m1ddc set input 15   

else
				echo "$(uname) not supported"
fi

