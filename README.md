# cdh-tools
Playbook for cloudera hadoop auto install

## Playbook Description
- `cluster.yml` install cloudera manager server and agent playbook
- `client.yml` install hadoop client use cluster config

## Inventory Description
Host Group | Description
:--- | :---
local            | localhost
master           | the host well be install cloudera manager server
slave            | the host well be install cloudera manager agent
client           | the host well be install hadoop client

## Roles Description
Role | Description
:--- | :---
`ntp`                | init ntp server
`kdc`                | init kdc server
`common`             | init host(thp,swappiness,firewall,/etc/hosts...)
`install_scm_common` | install cloudera manager common packages(jdk..)
`install_scm_server` | install cloudera manager server packages
`install_scm_agent`  | install cloudera manager agent packages
`install_client`     | install hadoop client
`download_cdh_management_pkg` | download cloudera management packages to localhost
`download_cdh_parcel_pkg`     | download cloudera cdh parcel packages to server hosts


## Other Description
- `group_vars/all`: global vars
- `tools/install_ansible.sh`: a bash script which can install ansible on localhost
- `playbooks/*`: test playbooks

## Example

+ install cluster

    ```bash
    ansible-playbook -i hosts cluster.yml -k
    ```
