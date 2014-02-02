bundler:
  gem.installed:
    - runas: root

rails:
  gem.installed:
    - version: 4.0.2
    - runas: vagrant

mailcatcher:
  gem.installed:
    - version: 0.5.12
    - runas: vagrant
    - ri: False
    - rdoc: False