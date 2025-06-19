
## Development cycle

While the role is in development, the role can be imported by including the following in the requirements.yml file:
```
- src: https://github.com/adrianjuhl/ansible-role-shell-capture-stdout-and-stderr
  scm: git
  version: 1.2.3-develop-WIP-1
  name: adrianjuhl.shell_capture_stdout_and_stderr
```
(where version is a branch name)

Once a version of the role is stable:
- (optionally) rebase/squash onto main
- create a tag
```
$ git tag 1.2.3
$ git push origin 1.2.3
```

Then, [import the role into Ansible Galaxy](https://ansible.readthedocs.io/projects/galaxy-ng/en/latest/community/userguide/#importing-roles) (the --role_name parameter is necessary for multi-word-role-name due to [broken import code](https://forum.ansible.com/t/ansible-galaxy-s-role-import-enhancements-and-fixes-for-the-new-year/3206/3)):
```
ansible-galaxy role import --role-name=$(yq '.galaxy_info.role_name' meta/main.yml) adrianjuhl ansible-role-shell-capture-stdout-and-stderr
```

Then, the requirements.yml file section can be updated to refer to the ansible galaxy role name and version like:
```
- src: adrianjuhl.shell_capture_stdout_and_stderr
  version: 1.2.3
```
(where version is a tag value)


## ansible-galaxy role import
```
$ ansible-galaxy role import --role-name=$(yq '.galaxy_info.role_name' meta/main.yml) adrianjuhl ansible-role-shell-capture-stdout-and-stderr
```
