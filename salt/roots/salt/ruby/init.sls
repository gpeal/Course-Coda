include:
  - rvm

ruby-1.9.3:
  rvm.installed:
    - default: True
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps
      - user: rvm

mygemset:
  rvm.gemset_present:
    - ruby: ruby-1.9.3
    - require:
      - rvm: ruby-1.9.3