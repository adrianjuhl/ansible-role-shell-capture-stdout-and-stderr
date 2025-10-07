# Ansible role: shell_capture_stdout_and_stderr

Installs [capture-stdout-and-stderr](https://github.com/adrianjuhl/adrianjuhl-shell-capture-stdout-and-stderr), a shell script with a contained function that provides the ability to capture the standard out and standard error of another command.

## Requirements

* This role requires root access by default (unless configured to install into a directory owned by the ansible user - see Role Variables section), so either run it in a playbook with a global `become: true`, or invoke the role with `become: true`.

## Role Variables

Role variables and their defaults.

**version**

    adrianjuhl__shell_capture_stdout_and_stderr__version: "0.6.0-rc-1"

The version of the script to install.

**ref_type**

    adrianjuhl__shell_capture_stdout_and_stderr__ref_type: "tags"

The ref type within the git repository of the version to be installed.
Valid values are "tags" or "heads".
The default of "tags" should be suitable for installing all realease versions of the script as each of these will be given a tag.
The value "heads" can be used in the case that a version from a branch is to be installed.

**install_bin_dir**

    adrianjuhl__shell_capture_stdout_and_stderr__install_bin_dir: "/usr/local/bin"

The directory where shell_capture_stdout_and_stderr is to be installed.

shell_capture_stdout_and_stderr could alternatively be installed into a user's directory, for example: `adrianjuhl__shell_capture_stdout_and_stderr__install_bin_dir: "{{ ansible_env.HOME }}/.local/bin"`, in which case the role will not need root access.

**script_name**

    adrianjuhl__shell_capture_stdout_and_stderr__script_name: "capture_stdout_and_stderr"

The name to give the script and containing folder.

**create_symbolic_link**

    adrianjuhl__shell_capture_stdout_and_stderr__create_symbolic_link: true

Whether to create a symbolic link from the install bin directory to the installed script in the versioned sub-directory. Boolean true or false value.

## Dependencies

None.

## Example Playbook
```
- hosts: "servers"
  roles:
    - { role: adrianjuhl.shell_capture_stdout_and_stderr, become: true }

or

- hosts: "servers"
  tasks:
    - name: "Install shell_capture_stdout_and_stderr"
      include_role:
        name: "adrianjuhl.shell_capture_stdout_and_stderr"
        apply:
          become: true

or (install into the user's ~/.local/bin directory)

- hosts: "servers"
  tasks:
    - name: "Install shell_capture_stdout_and_stderr"
      include_role:
        name: "adrianjuhl.shell_capture_stdout_and_stderr"
      vars:
        adrianjuhl__shell_capture_stdout_and_stderr__install_bin_dir: "{{ ansible_env.HOME }}/.local/bin"
```

## Extras

### Install script

For convenience, a bash script is also supplied that facilitates easy installation of this script on localhost (the script executes ansible-galaxy to install the role and then executes ansible-playbook to run a playbook that includes the shell_capture_stdout_and_stderr role).

The script can be run like this:
```
$ git clone git@github.com:adrianjuhl/ansible-role-shell-capture-stdout-and-stderr.git
$ cd ansible-role-shell-capture-stdout-and-stderr
$ .extras/bin/install.sh
```

## License

MIT

## Author Information

[Adrian Juhl](http://github.com/adrianjuhl)
