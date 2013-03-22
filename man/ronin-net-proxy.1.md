# ronin-net-proxy 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin net:proxy` [*options*] SERVER

## DESCRIPTION

Starts the Ronin TCP/UDP Proxy.

## ARGUMENTS

*SERVER*
	The `host:port` of the server to proxy.

## OPTIONS

`--[no-]tcp`
	Enables or disables TCP mode.

`--[no-]ssl`
  Enables or disables SSL mode.

`--[no-]udp`
	Enables or disables UDP mode.

`--[no-]hexdump`
	Enables or disables hexdump mode.

`--host` HOST
	The HOST the proxy will listen on. Defaults to "0.0.0.0".

`--port` PORT
	The PORT the proxy will listen on.

`--rewrite-client` */REGEXP/:STRING*
	Replace REGEXP with STRING in every client message.

`--rewrite-server` */REGEXP/:STRING*
	Replace REGEXP with STRING in every server message.

`--rewrite` */REGEXP/:STRING*
	Replace REGEXP with STRING in every message.

`--ignore-client` */REGEXP/*
	Ignore messages from the client matching the REGEXP.

`--ignore-server` */REGEXP/*
	Ignore messages from the server matching the REGEXP.

`--ignore` */REGEXP/*
	Ignore messages matching the REGEXP.

`--close-client` */REGEXP/*
	Closes the connection if the client sends a message matching the REGEXP.

`--close-server` */REGEXP/*
	Closes the connection if the server sends a message matching the REGEXP.

`--close` */REGEXP/*
	Closes the connection if the client or server sends a message matching
	the REGEXP.

`--reset-client` */REGEXP/*
	Reset the connection if the client sends a message matching the REGEXP.

`--reset-server` */REGEXP/*
	Reset the connection if the server sends a message matching the REGEXP.

`--reset` */REGEXP/*
	Reset the connection if the client or server sends a message matching
	the REGEXP.

`-v`, `--[no-]verbose`
	Enable verbose output.

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

