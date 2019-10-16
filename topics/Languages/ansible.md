# Ansible Cheatsheet

- Cgroups and callbacks
```
sudo cgcreate -a user:user -t user:user > -g cpuacct,memory,pids:ansible_profile

# on ansible.cfg
callback_whitelist=cgroup_perf_recap[callback_cgroup_perf_recap]control_group=ansible_profile

cgexec -g cpuacct,memory,pids:ansible_profile > ansible-playbook deploy_webservers.yml
```

- Listen on handlers
```
# Listening to the "My handlers" event
- name: Listening to a notification
  debug:
    msg: First handler was notified
  listen: My handlers
```

- Add callback to ansible.cfg
```
callback_whitelist=timer, profile_tasks
```

- Concatenate 2 Arrays:
```
"{{ apache_base_packages | union(apache_optional_packages) }}"
```

- Avoid to fail by a lookup error
```
{{ lookup('file', 'my.file', errors='warn') | default("Default file content") }}
```

- Execute commands from Lookup on control node
```
{{ query('pipe', 'ls files') }}
```

- from yaml
```
my_yaml: "{{ lookup('file', '/path/to/my.yaml') | from_yaml }}"
```

- Loop over file lines
```
- name: Prints the first line of some files
  debug:
    msg: "{{ item[0] }}"
  loop:
    - "{{ query('lines', 'cat files/my.file') }}"
```

- dig over a host
```
# It needs python3-dns rpm

- name: Determinte if host's ip address is private
  debug:
    msg: "{{ lookup('dig', ansible_facts['hostname'] ) | ipaddr('private') }}"

"{{ lookup('dig', 'example.com', '@4.4.8.8,4.4.4.4) }}"

```

- Fail all if 1 steps fails
```
max_fail_percentage: 0
```

- Interacting with Tower API
```
- name: Delete an existing Ansible Tower Job Template using the uri module
  uri:
    url: "https://{{ tower_fqdn }}/api/v2/job_templates/{{ copy_template_name | urlencode }}/"
    validate_certs: no
    method: DELETE￼
    return_content: yes
    force_basic_auth: yes
    user: "{{ tower_user }}"
    password: "{{ tower_password }}"
    status_code: 204
```

- Sample of SmartHostFilter
```
ansible_facts.ansible_distribution:RedHat
```

- Change TLS cert for tower
```
semanage fcontext -a -t cert_t "/etc/tower(/.*)?"
restorecon -FvvR /etc/tower/
rm /etc/tower/tower.*
ipa-getcert request -f /etc/tower/tower.cert \> -k /etc/tower/tower.key
ansible-tower-service restart
```

- Grant role admin on Team
```
tower-cli role grant --user 'daniel' \> --target-team 'Developers' --type 'admin'
```
