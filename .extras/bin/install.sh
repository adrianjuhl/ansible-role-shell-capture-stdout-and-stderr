#!/usr/bin/env bash

# Install the capture_stdout_and_stderr function support script.

usage()
{
  cat <<USAGE_TEXT
Usage:  ${THIS_SCRIPT_NAME}
            [--requires_become=<true|false>]
            [--dry_run] [--show_diff]
            [--help | -h]
            [--script_debug]

Install the capture_stdout_and_stderr function support script.

Available options:
    --requires_become=<true|false>
        Is privilege escalation required? Defaults to true.
    --dry_run
        Run the role without making changes.
    --show_diff
        Run the role in diff mode.
    --help, -h
        Print this help and exit.
    --script_debug
        Print script debug info.
USAGE_TEXT
}

main()
{
  initialize
  parse_script_params "${@}"
  install_thycotic_cli
}

install_thycotic_cli()
{
  export ANSIBLE_ROLES_PATH=${THIS_SCRIPT_DIRECTORY}/../.ansible/roles/:${HOME}/.ansible/roles/

  # Install the dependencies of the playbook:
  echo "running ansible-galaxy...."
  ANSIBLE_ROLES_PATH=${HOME}/.ansible/roles/ ansible-galaxy install --role-file=${THIS_SCRIPT_DIRECTORY}/../.ansible/roles/requirements.yml --force
  last_command_return_code="$?"
  if [ "${last_command_return_code}" -ne 0 ]; then
    msg "Error: ansible-galaxy role installations failed."
    abort_script
  fi
  echo "ansible-galaxy done"

  ASK_BECOME_PASS_OPTION=""
  if [ "${REQUIRES_BECOME}" = "${TRUE_STRING}" ]; then
    ASK_BECOME_PASS_OPTION="--ask-become-pass"
  fi

  echo "running playbook...."
  ansible-playbook ${ANSIBLE_CHECK_MODE_ARGUMENT} ${ANSIBLE_DIFF_MODE_ARGUMENT} ${ASK_BECOME_PASS_OPTION} -v \
    --inventory="localhost," \
    --connection=local \
    --extra-vars="local_playbook__install_shell_capture_stdout_and_stderr__requires_become=${REQUIRES_BECOME}" \
    ${THIS_SCRIPT_DIRECTORY}/../.ansible/playbooks/install.yml
  echo "playbook done"
}

parse_script_params()
{
  #msg "script params (${#}) are: ${@}"
  # default values of variables set from params
  REQUIRES_BECOME="${TRUE_STRING}"
  REQUIRES_BECOME_PARAM=""
  ANSIBLE_CHECK_MODE_ARGUMENT=""
  ANSIBLE_DIFF_MODE_ARGUMENT=""
  SCRIPT_DEBUG_OPTION="${FALSE_STRING}"
  while [ "${#}" -gt 0 ]
  do
    case "${1-}" in
      --requires_become=*)
        REQUIRES_BECOME_PARAM="${1#*=}"
        ;;
      --dry_run)
        ANSIBLE_CHECK_MODE_ARGUMENT="--check"
        ;;
      --show_diff)
        ANSIBLE_DIFF_MODE_ARGUMENT="--diff"
        ;;
      --help | -h)
        usage
        exit
        ;;
      --script_debug)
        set -x
        SCRIPT_DEBUG_OPTION="${TRUE_STRING}"
        ;;
      -?*)
        msg "Error: Unknown parameter: ${1}"
        msg "Use --help for usage help"
        abort_script
        ;;
      *) break ;;
    esac
    shift
  done
  case "${REQUIRES_BECOME_PARAM}" in
    "true")
      REQUIRES_BECOME="${TRUE_STRING}"
      ;;
    "false")
      REQUIRES_BECOME="${FALSE_STRING}"
      ;;
    "")
      REQUIRES_BECOME="${TRUE_STRING}"
      ;;
    *)
      msg "Error: Invalid requires_become param value: ${REQUIRES_BECOME_PARAM}, expected one of: true, false"
      abort_script
      ;;
  esac
}

initialize()
{
  set -o pipefail
  THIS_SCRIPT_PROCESS_ID=$$
  initialize_abort_script_config
  initialize_this_script_directory_variable
  initialize_this_script_name_variable
  initialize_true_and_false_strings
}

initialize_this_script_directory_variable()
{
  # Determines the value of THIS_SCRIPT_DIRECTORY, the absolute directory name where this script resides.
  # See: https://www.binaryphile.com/bash/2020/01/12/determining-the-location-of-your-script-in-bash.html
  # See: https://stackoverflow.com/a/67149152
  local last_command_return_code
  THIS_SCRIPT_DIRECTORY=$(cd "$(dirname -- "${BASH_SOURCE[0]}")" || exit 1; cd -P -- "$(dirname "$(readlink -- "${BASH_SOURCE[0]}" || echo .)")" || exit 1; pwd)
  last_command_return_code="$?"
  if [ "${last_command_return_code}" -gt 0 ]; then
    # This should not occur for the above command pipeline.
    msg
    msg "Error: Failed to determine the value of this_script_directory."
    msg
    abort_script
  fi
}

initialize_this_script_name_variable()
{
  local path_to_invoked_script
  local default_script_name
  path_to_invoked_script="${BASH_SOURCE[0]}"
  default_script_name=""
  if grep -q '/dev/fd' <(dirname "${path_to_invoked_script}"); then
    # The script was invoked via process substitution
    if [ -z "${default_script_name}" ]; then
      THIS_SCRIPT_NAME="<script invoked via file descriptor (process substitution) and no default name set>"
    else
      THIS_SCRIPT_NAME="${default_script_name}"
    fi
  else
    THIS_SCRIPT_NAME="$(basename "${path_to_invoked_script}")"
  fi
}

initialize_true_and_false_strings()
{
  # Bash doesn't have a native true/false, just strings and numbers,
  # so this is as clear as it can be, using, for example:
  # if [ "${my_boolean_var}" = "${TRUE_STRING}" ]; then
  # where previously 'my_boolean_var' is set to either ${TRUE_STRING} or ${FALSE_STRING}
  TRUE_STRING="true"
  FALSE_STRING="false"
}

initialize_abort_script_config()
{
  # Exit shell script from within the script or from any subshell within this script - adapted from:
  # https://cravencode.com/post/essentials/exit-shell-script-from-subshell/
  # Exit with exit status 1 if this (top level process of this script) receives the SIGUSR1 signal.
  # See also the abort_script() function which sends the signal.
  trap "exit 1" SIGUSR1
}

abort_script()
{
  echo >&2 "aborting..."
  kill -SIGUSR1 ${THIS_SCRIPT_PROCESS_ID}
  exit
}

msg()
{
  echo >&2 -e "${@}"
}

# Main entry into the script - call the main() function
main "${@}"
