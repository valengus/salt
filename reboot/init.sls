reboot:
  module.wait:
  - name: system.reboot
  - wait_for_reboot: True
