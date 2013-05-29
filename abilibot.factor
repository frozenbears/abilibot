USING: kernel io namespaces irc.client irc.client.chats irc.messages assocs sequences accessors splitting ;
FROM: sequences => join ;
IN: abilibot
SYMBOL: bot
SYMBOL: mychannel

: create-bot ( -- )
  "irc.freenode.org" irc-port "abilibot" f <irc-profile> <irc-client> bot set ;

: create-channel ( -- )
  "#inane" <irc-channel-chat> mychannel set ;

: connect ( -- )
  bot get connect-irc ;

: join-channel ( -- )
  mychannel get bot get attach-chat ;

: start-bot ( -- )
  create-bot
  create-channel
  connect
  join-channel ;

: say ( str -- )
  mychannel get speak ;

: argstring ( list -- str )
  rest " " join ;

: work ( args -- )
  "you're doing work, " swap argstring append "!" append say ;

: lookup ( command -- word )
  H{ { "!w" work } } at ;

: dispatch ( list -- )
  dup first lookup dup [ execute( list -- ) ] [ drop drop ] if ;

: tokenize ( str -- list )
  " " split ;

: hurr ( -- )
  "hurr" say ;

: listen ( -- msg )
  mychannel get hear ;

: respond ( msg -- )
  dup privmsg? [ text>> tokenize dispatch ] [ drop ]  if ; 

: forever ( quot -- ) inline
  [ t ] swap while ;

: be-ridiculous ( -- )
  listen respond ;

: abilibot ( -- )
  start-bot 
  [ be-ridiculous ] forever ;

MAIN: abilibot

