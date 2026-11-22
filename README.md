# Linux IAM Automation
Ansible and Bash automation for managing Linux users, groups, sudo access, and password policy on a RHEL-family system.

## Role groups
- **admins:** Full sudo, set through a sudoers file in `/etc/sudoers.d/`.
- **developers:** No sudo. 
- **deployers:** Can use sudo to restart a short list of named services, and nothing else.
- **helpdesk:** Can unlock accounts, force a password change at next login, and view password aging info. They are blocked from doing any of this on root and admin accounts.
- **contractors:** No sudo. Each contractor has an account expiry date and a 60-day maximum password age.
- **auditors:** Read access to the audit log. I set `log_group` in `/etc/audit/auditd.conf` to `auditors`.
  
Service account:
 
- **svc-backup:** A system account with the `nologin` shell and no home directory or password.

### Passwords
 
- Each new account gets its own random 20-character temporary password, generated on the control machine with Ansible's `password` lookup.
- Passwords are hashed with SHA-512 (random salt, 100000 rounds) before they reach the machine.
- Newly created accounts are forced to change their password at first login.

## Audit script
 
`audit-users.sh` is a read-only report that checks each account. 

Checks:
- **UID 0 accounts:** Any account other than root that has UID 0.
- **Locked accounts:** Regular user accounts (UID 1000 and up) that are locked.

## Repo layout
 
```
linux-iam-automation/
├── README.md
├── group_vars/
│   └── all.yml
├── templates/
│   └── helpdesk_sudoers.j2
├── audit-users.sh
├── site.yml
```
