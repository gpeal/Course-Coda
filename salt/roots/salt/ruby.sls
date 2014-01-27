ruby-2.0.0-p247:
  rbenv.installed:
    - default: True
    - require:
      - pkg: rbenv-deps

install-bunder-gem:
  cmd.run:
    - name: eval "$(rbenv init -)" && gem install bundler && rbenv rehash
    - shell: /bin/bash
    - user: root
    - env: RBENV_ROOT=/usr/local/rbenv, PATH="/usr/local/rbenv/bin:$PATH"
    - onlyif: which ruby | grep rbenv
    - require:
      - pkg: rbenv-deps