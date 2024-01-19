# qcd

`qcd.bash` (short for "quick-cd") is a bash script that "replaces" the traditional `cd` command. It allows you quickly cd to a tagged directory using the `qcd` command, while attempting to preserve `cd`. Arguments to `cd` are passed transparently, and it prompts the user to create a tag when a directory is visited often during a shell session.

qcd was inspired by [warpdrive-go](https://github.com/quackduck/warpdrive-go)

#### Installation

First source the file in your rcfile and call the initialization function
`source /path/to/qcd.bash`

Then create an alias mapping `cd` to `qcd-transparent`
`alias cd="qcd-transparent"`

### Configuration
Behavior can be modified after sourcing `qcd`.
```
QCD_MINIMUMLINES=8 # "popularness" threshold
QCD_HOME="$HOME" # home for the qcd data file
```

### Manually adding a tag
`qcd-add /the/entire/path/`

##### License
qcd.bash is licensed under the GNU AGPLv3
