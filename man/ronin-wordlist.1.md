# ronin-wordlist 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin wordlist` [*options*] [*TEMPLATE*]

## DESCRIPTION

Builds and/or mutates Wordlists.

## ARGUMENTS

*TEMPLATE*
	Options word template to generate the wordlist with
	(`alpha:7 numeric:1-3`).

## OPTIONS

`-v`, `--[no-]verbose`
	Enable verbose output.

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

`-i`, `--input` *FILE*
	The input text FILE to parse.

`-o`, `--output` *PATH*
	The output PATH to write the wordlist to.

`-m`, `--mutations` *STRING*:*SUBSTITUTE*
	Mutations to apply to the words. If STRING is found within a word,
	it will be replaced with SUBSTITUTE.

## EXAMPLES

`ronin wordlist alpha:7 numeric:1-3`
	Enumerates through every possible word, with each word beginning with
	seven alphabetic characters and ending in 1-3 numeric characters.

`ronin wordlist --input text.txt -m e:3 -m a:@ -m o:0`
	Builds a wordlist from a text file, applying basic "leet-speak"
	mutation rules to each word.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

