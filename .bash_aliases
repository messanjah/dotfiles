# Rails
alias server='cd /vagrant/procore && bin/rails s -b 0.0.0.0'
alias console='cd /vagrant/procore && bin/rails c'
alias db='cd /home/vagrant/procore && bundle exec rails db'
alias spec='cd /home/vagrant/procore && RAILS_ENV=test bundle exec rake spec --trace'
alias guard='cd /home/vagrant/procore && bundle exec guard'
alias be='bundle exec'
alias resque='cd /home/vagrant/procore && bundle exec rake resque:work QUEUE=* VVERBOSE=1'
alias puma='cd /vagrant/procore && puma -b tcp://0.0.0.0 -p 3000'

# Nginx
alias nstart='sudo /usr/local/nginx/sbin/nginx'
alias nstop='sudo /usr/local/nginx/sbin/nginx -s stop'
alias ntail='tail -f /usr/local/nginx/logs/access.log /usr/local/nginx/logs/error.log'

# Git
alias git=hub
