Disable swap:
  cmd.run:
  - name: swapoff -a
  - unless: test $(swapon -s | wc -l) -eq 0

Remove swap from fstab:
  file.replace:
  - name: /etc/fstab
  - pattern: '^([^#].*\sswap\s.*)$'
  - repl: '# \1'
