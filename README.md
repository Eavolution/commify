# comma

## Description
Puts commas in numbers to sepereate thousands to help readability. Reads number from command line argument or STDIN and writes formatted number to STDOUT.

## How to build
Clone and run `stack build` in the project directory. If you don't have stack installed follow the instructions below or go to https://docs.haskellstack.org/en/stable/README/ for more detailed instructions.
### UNIX
```
curl -sSL https://get.haskellstack.org/ | sh
```
### Windows
```
wget -qO- https://get.haskellstack.org/ | sh
```
After building, move/copy the produced executable (the location is output when `stack build` is run) to a location in the PATH (ie /usr/local/bin)