# Ansible role: shell_capture_stdout_and_stderr

Installs a shell script that provides a function that is able to capture the standard out and standard error of another call.

## Requirements

* Requires blah.
* This role requires root access by default (unless configured to install into a directory owned by the ansible user - see Role Variables section), so either run it in a playbook with a global `become: true`, or invoke the role with `become: true`.

## Role Variables

**install_bin_dir**

    adrianjuhl__shell_capture_stdout_and_stderr__install_bin_dir: "/usr/local/bin"

The directory where shell_capture_stdout_and_stderr is to be installed.

shell_capture_stdout_and_stderr could alternatively be installed into a user's directory, for example: `adrianjuhl__shell_capture_stdout_and_stderr__install_bin_dir: "{{ ansible_env.HOME }}/.local/bin"`, in which case the role will not need root access.

## Dependencies

None.

## Example Playbook
```
- hosts: servers
  roles:
    - { role: adrianjuhl.shell_capture_stdout_and_stderr, become: true }

or

- hosts: servers
  tasks:
    - name: Install shell_capture_stdout_and_stderr
      include_role:
        name: adrianjuhl.shell_capture_stdout_and_stderr
        apply:
          become: true

or (install into the user's ~/.local/bin directory)

- hosts: servers
  tasks:
    - name: Install shell_capture_stdout_and_stderr
      include_role:
        name: adrianjuhl.shell_capture_stdout_and_stderr
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
$ .extras/bin/install_thycotic_cli.sh
```

## License

MIT

## Author Information

[Adrian Juhl](http://github.com/adrianjuhl)
