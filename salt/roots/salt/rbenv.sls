#
# ruby deps
#

rbenv-deps:
  pkg.installed:
    - names:
      - git
      - build-essential
      - openssl
      - curl
      - zlib1g
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-0
      - libsqlite3-dev
      - sqlite3
      - libxml2-dev
      - libxslt1-dev
      - autoconf
      - libc6-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - subversion

#
# rbenv and ruby-build installation
#

/home/vagrant/.rbenv:
  file.directory:
    - makedirs: True
    - user: vagrant

https://github.com/sstephenson/rbenv.git:
  git.latest:
    - user: vagrant
    - rev: master
    - target: /home/vagrant/.rbenv
    - force: True
    - require:
      - pkg: rbenv-deps
      - file: /home/vagrant/.rbenv

https://github.com/sstephenson/ruby-build.git:
  git.latest:
    - user: vagrant
    - rev: master
    - target: /home/vagrant/.rbenv/plugins/ruby-build
    - force: True f
    - require:
      - git: https://github.com/sstephenson/rbenv.git
      - file: /home/vagrant/.rbenv

/home/vagrant/.profile:
  file.append:
    - user: vagrant
    - text:
      - export PATH="$HOME/.rbenv/bin:$PATH"
      - eval "$(rbenv init -)"
    - require:
      - git: https://github.com/sstephenson/rbenv.git


#
# ruby installation
#

/home/vagrant/.rbenv/bin/rbenv install {{ pillar['ruby']['version'] }} -f:
  cmd.run:
  - user: vagrant
  - require:
    - git: https://github.com/sstephenson/ruby-build.git

/home/vagrant/.rbenv/bin/rbenv rehash:
  cmd.run:
  - user: vagrant
  - require:
    - cmd: /home/vagrant/.rbenv/bin/rbenv install {{ pillar['ruby']['version'] }} -f

/home/vagrant/.rbenv/bin/rbenv global {{ pillar['ruby']['version'] }}:
  cmd.run:
  - user: vagrant
  - require:
    - cmd: /home/vagrant/.rbenv/bin/rbenv rehash