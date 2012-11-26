# ronin-fuzzer 1 "April 2012" Ronin "User Manuals"

## SYNOPSIS

`ronin fuzzer` [*options*] [*TEMPLATE*]

## DESCRIPTION

Fuzzes data read from a *FILE* or from `STDIN`. The fuzzed data can be written
to output files, run in commands or sent to TCP/UDP services.

## OPTIONS

`-v`, `--[no-]verbose`
	Enable verbose output.

`-q`, `--[no-]quiet`
	Disable verbose output.

`--[no-]silent`
	Silence all output.

`-i`, `--input` *FILE*
	The input text FILE to parse. Data will be read from `STDIN` by default.

`-r`, `--rule` [*PATTERN*|*/REGEXP/*|STRING]:[*METHOD*|*STRING***N*[-*M*]]
	The rule to apply to the *INPUT*. Fuzzer rules consist of a pattern and 
	substitution. Patterns may be one of the following:

	* A name of a Ronin Regular Expression (ex: `unix_path`)
	* A custom Regular Expression (ex: `/\d+/`)
	* A plain String (ex: `example.com`).

	  Substitutions may be one of the following:

	* A method from `Ronin::Fuzzing` (ex: `bad_strings`)
	* A *STRING*, repeated *N* or *M* times (ex: `A*100-200`).

`-o`, `--output` *PATH*
	The output PATH to write the fuzzer to.

`-c`, `--command` *COMMAND*
	The command to run with the fuzzed data. All ocurrences of `#string#`
	will be replaced with the fuzzed data, and ocurrences of `#path#` will
	be replaced with the path to the fuzzed data.

`-t`, `--tcp` *HOST*:*PORT*
	The TCP service to send the fuzzed data to.

`-u`, `--udp` *HOST*:*PORT*
	The UDP service to send the fuzzed data to.

`-p`, `--pause` *SECONDS*
  Pause in between mutations.

## EXAMPLES

`ronin fuzzer -i http_request.txt -o bad.txt -r unix_path:bad_strings`
	Fuzzes a HTTP request, replacing every occurrence of a UNIX path, with
	strings from the `bad_strings` method.

## LINKS

Ronin Regular Expressions
	https://ronin-rb.dev/docs/ronin-support/Regexp.html

`Ronin::Fuzzing`
	https://ronin-rb.dev/docs/ronin-support/Ronin/Fuzzing.html

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

