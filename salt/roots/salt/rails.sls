export PATH=/home/vagrant/.rbenv/bin/:$PATH && eval "$(rbenv init -)" && bundle install:
  cmd.run:
    - cwd: /home/vagrant/Course-Coda
    - user: vagrant

export PATH=/home/vagrant/.rbenv/bin/:$PATH && eval "$(rbenv init -)" && rake db:create:
  cmd.run:
    - cwd: /home/vagrant/Course-Coda

echo localhost:5432:ctec_development:caesar:password > ~/.pgpass && chmod 600 ~/.pgpass:
  cmd.run:
    - user: vagrant

pg_restore -i -h localhost -p 5432 -U caesar -d coursecoda_development  -v ctec.sql:
  cmd.run:
    - cwd: /home/vagrant/Course-Coda
    - user: vagrant
