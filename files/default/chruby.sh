. /usr/local/share/chruby/chruby.sh

RUBIES=(/usr/local/ruby/*)

if [[ -f "$HOME/.ruby-version" ]]; then
  chruby `cat $HOME/.ruby-version`
fi
