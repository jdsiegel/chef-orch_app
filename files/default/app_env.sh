if [[ -f "$HOME/.env" ]]; then
  export `cat $HOME/.env`
fi
