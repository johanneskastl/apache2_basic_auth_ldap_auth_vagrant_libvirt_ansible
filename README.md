# Apache setup for playing around with authentication

This setup creates a VM with openSUSE 15.5 and installs apache2. It configures a
virtual host and creates the necessary directories, so you can test:

- unrestricted access
- basic authentication to the `http://.../basicauth/` endpoint
- LDAP authentication to the `http://.../ldap/` endpoint
- basic OR LDAP authentication to the `http://.../secret/` endpoint

Default OS is openSUSE Leap 15.5. Although that can be changed in the
Vagrantfile, please beware that this might break the Ansible provisioning.

The username and password for basic auth are extremely secure (ahem) and you
would never have guessed them: `vagrant-ansible-libvirt`

## Vagrant

1. You need vagrant obviously. And ansible. And git...
1. Fetch the box, per default this is `opensuse/Leap-15.5.x86_64`, using
   `vagrant box add opensuse/Leap-15.5.x86_64`.
1. Make sure the git submodules are fully working by issuing `git submodule init
   && git submodule update`
1. Run `vagrant up`
1. Find out the VM's IP (e.g. `vagrant address apache-server`, if you have
   vagrant address installed) and connect to <http://IP>.
1. You can find a script for testing all endpoints below.
1. Party!

## Prerequisites

Obviously you need a LDAP server for this, as well as proper credentials to talk
to this server.

**ATTENTION**: Only use this setup for testing and make sure you are not using
highly valuable credentials for this, as they are written to the VM's apache
configuration in cleartext...

## Providing the necessary LDAP variables

For the setup to work you need to provide the LDAP server URL as well as the
necessary credentials.

Create a file `ansible/group_vars/all/ldap.yml` that contains the following
three variables:

- `ldap_server_url`: URL to the LDAP server, see [the
  documentation](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapurl)
- `ldap_binddn_name`: BindDN to use for contacting the LDAP server
- `ldap_binddn_password`: password for the BindDN user

Example:

```
ldap_server_url: 'ldap://ldap.example.org/dc=example,dc=org'
ldap_binddn_name: 'cn=admin,dc=example,dc=org'
ldap_binddn_password: 'totallysecretpassword'
```

## Testing the setup

You can use the script `test_endpoints.sh` to test access to all of the
endpoints, by calling the script with the IP address as only argument.

Here is the script's output:

```bash
$ ./test.sh 192.0.2.123
This is the public directory
This is the basicauth directory
This is the secret directory
$
```

For testing the LDAP authentication, you can use curl against the `.../ldap/`
and `http://.../secret/` endpoints:

```bash
$ curl -s -u ldap-user:ldap-password "http://192.0.2.123/ldap/"
This is the ldap directory
$ curl -s -u ldap-user:ldap-password "http://192.0.2.123/secret/"
This is the secret directory
$
```

## Disabling the Ansible provisioning

In case you do not want Ansible to install teleport (because you want to install
it yourself), just comment out the following lines in the `Vagrantfile`:

```hcl
    node.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "ansible/playbook-all_nodes.yml"
    end # node.vm.provision
```

You also find all of the playbooks in the `ansible` folder.

## License

BSD-3-Clause

## Author Information

I am Johannes Kastl, reachable via kastl@b1-systems.de.
