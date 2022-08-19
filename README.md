# commify

## Description
Puts commas in numbers to sepereate thousands to help readability. Reads number from command line argument or STDIN and writes formatted number to STDOUT.

This, and the argument parser it uses, are heavily work in progress as I'm learning Haskell.

## How to build
If you don't have stack installed go to https://docs.haskellstack.org/en/stable/README/ for instructions.

Recursively clone the repo (as it relies on a submodule), then run `stack build` in the commify directory.

Stack will build the executable, the output will display where it built the executable to. Move or copy this executable to somewhere in the `$PATH` to use as a command line tool.

## Usage
Run `commify -h` after building to view the help text.

As of now it defaults to formatting the number in the UK style (1,000.00), but that can be switched to other styles through the command line switches shown in the help text.

### Examples

```
$ commify 123456789
$ 123,456,789
```
```
$ commify 123456.123456
$ 123,456.123456
```
```
$ commify -e 123456,123456
$ 123.456,123456
```
```
$ commify --custom=/* 123456/123456
$ 123*456/123456
```
As of now due to the work in progress nature of the parser, the -c (--custom) switch must be immediately followed by a '=' immediately followed by the two characters, with no spaces or quotes. I am working on adding the ability to put spaces and quotes in.