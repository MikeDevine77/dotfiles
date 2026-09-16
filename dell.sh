
checkinginputs allow...
DP, USB-C, HDMI and display if they make error

  OPTIND=1
  verbose=0
  name=""

while getopts "h?vn:" opt; do
    case "$opt" in
    h|\?)
        echo "Usage: $0 [-v] [-n name]"
        exit 0
        ;;
    v)  verbose=1
        ;;
    c)  name=$OPTARG
        ;;
    esac
done


  # Back to the beginning now and get our opts

  while getopts ':c:d:h:' opt; do
    # and so on
	echo [...]

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

echo "verbose=$verbose, name='$name', Leftovers: $@"


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # ...
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        # Switch over to Display Port
		~/progz/m1ddc set input 15   


elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
else
        # Unknown.
        echo "No handling for OS of ${OSTYPE}"
fi




