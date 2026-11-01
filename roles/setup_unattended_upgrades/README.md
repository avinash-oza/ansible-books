# setup_unattended_upgrades

This role sets up automatic unattended upgrades on Ubuntu and Debian systems. It configures the system to automatically install security updates and optionally other package updates, with optional automatic reboot capability.

## Requirements

- Ubuntu or Debian-based system
- `ansible` 2.9+

## Role Variables

### Main Configuration Variables

- `unattended_upgrades_enable_security` (default: `true`)
  - Enable automatic security updates

- `unattended_upgrades_enable_all_updates` (default: `false`)
  - Enable automatic updates for non-security packages (e.g., new features, improvements)
  - When false, only security updates are installed

- `unattended_upgrades_enable_auto_reboot` (default: `false`)
  - Enable automatic reboot if required after installing updates

- `unattended_upgrades_auto_reboot_time` (default: `"04:00"`)
  - Time to auto-reboot in HH:MM format (24-hour)

- `unattended_upgrades_auto_reboot_with_users` (default: `false`)
  - Allow automatic reboot even if users are logged in

- `unattended_upgrades_mail` (default: `""`)
  - Email address for unattended-upgrades reports
  - Set to empty string to disable email notifications

- `unattended_upgrades_mail_report` (default: `"on-change"`)
  - Mail report type: `always`, `on-change`, or `only-on-error`

- `unattended_upgrades_package_blacklist` (default: `[]`)
  - List of packages that should not be automatically upgraded

- `unattended_upgrades_additional_options` (default: `[]`)
  - Additional APT::Unattended-Upgrade configuration options

- `unattended_upgrades_enable_periodic` (default: `true`)
  - Enable periodic configuration for automatic upgrades

- `unattended_upgrades_verify_config` (default: `true`)
  - Verify configuration by running a dry-run test

## Examples

### Basic Setup (Security Updates Only)

```yaml
- hosts: all
  roles:
    - setup_unattended_upgrades
```

### Enable All Updates with Auto-Reboot

```yaml
- hosts: all
  roles:
    - setup_unattended_upgrades
  vars:
    unattended_upgrades_enable_all_updates: true
    unattended_upgrades_enable_auto_reboot: true
    unattended_upgrades_auto_reboot_time: "03:00"
```

### Blacklist Specific Packages

```yaml
- hosts: all
  roles:
    - setup_unattended_upgrades
  vars:
    unattended_upgrades_package_blacklist:
      - postgresql
      - mysql-server
      - docker-ce
    unattended_upgrades_mail: "ops@example.com"
    unattended_upgrades_mail_report: "only-on-error"
```

## What This Role Does

1. **Installs packages:**
   - `unattended-upgrades`: Main package for automatic updates
   - `apt-listchanges`: For email notifications of changes

2. **Configures APT:**
   - Creates `/etc/apt/apt.conf.d/20auto-upgrades` for periodic update scheduling
   - Creates `/etc/apt/apt.conf.d/50unattended-upgrades` for unattended-upgrades options
   - Adds a systemd drop-in setting `RandomizedDelaySec=60min` for `apt-daily-upgrade.timer`

3. **Starts the service:**
   - Enables and starts the `unattended-upgrades` systemd service

4. **Verifies configuration:**
   - Optionally runs a dry-run test to verify the configuration

## Update Frequency

By default, this role configures:
- Check for updates daily
- Download upgradeable packages daily
- Install upgrades daily
- Auto-clean APT cache every 7 days

## Notes

- Security updates are always enabled by default
- Auto-reboot is disabled by default to prevent unexpected downtime
- The mail address defaults to `root` on localhost
- Logs are written to `/var/log/unattended-upgrades/`
- Configuration can be tested with: `sudo unattended-upgrade --dry-run --debug`

## License

As per the ansible-books repository
