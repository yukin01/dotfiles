function has() {
  type "$1" &>/dev/null
}

function contains() {
  echo "$1" | grep -x "$2" &>/dev/null
}

function echo_err() {
  echo -e "\033[0;31m$1\033[0m" 1>&2
}

function echo_exit() {
  echo_err "$1"
  exit 1
}
