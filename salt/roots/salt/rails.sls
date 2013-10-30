export PATH=/home/vagrant/.rbenv/bin/:$PATH && eval "$(rbenv init -)" && bundle install:
  cmd.run:
    - cwd: /home/vagrant/Northwestern-CTECS
    - user: vagrant

export PATH=/home/vagrant/.rbenv/bin/:$PATH && eval "$(rbenv init -)" && rake db:create:
  cmd.run:
    - cwd: /home/vagrant/Northwestern-CTECS

psql -U caesar -d ctec_development -f ctec.sql:
  cmd.run:
    - cwd: /home/vagrant/Northwestern-CTECS
