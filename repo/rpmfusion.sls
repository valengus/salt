rpmfusion:
  pkg.installed:
    - sources:
      - rpmfusion-free-release: "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-{{ salt['grains.get']('osrelease') }}.noarch.rpm"
      - rpmfusion-nonfree-release: "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-{{ salt['grains.get']('osrelease') }}.noarch.rpm"
