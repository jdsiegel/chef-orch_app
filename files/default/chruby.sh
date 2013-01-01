. /usr/local/share/chruby/chruby.sh

RUBIES=(/opt/rubies/*)

if [[ -f "$HOME/.ruby-version" ]]; then
  chruby `cat $HOME/.ruby-version`
fi
