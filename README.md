# qcd

`qcd.bash` (short for "quick-cd") is a bash script that "replaces" the traditional `cd` command. It allows you quickly cd to a tagged directory using the `qcd` command, while attempting to preserve `cd`. Arguments to `cd` are passed transparently, and it prompts the user to create a tag when a directory is visited often during a shell session.

qcd was inspired by [warpdrive-go](https://github.com/quackduck/warpdrive-go)

#### Installation
This has only been tested with bash. It should work with a bash-compatible shell, but I haven't tested.\
Add this to your `.bashrc` or `.somerc` 
```bash
source /path/to/qcd.bash 
alias cd="qcd-transparent"
qcd_init
```

### Configuration
Behavior can be modified after calling `qcd_init`.
```bash
QCD_MINIMUMLINES=8		# "popularness" threshold
QCD_HOME="$HOME"		# home for the qcd data file
QCD_TABCOMPLETE=1		# basic bash completion for the qcd command only
```

### Using qcd
```bash
qcd [-h|-l|tag]				# show help, list tags, or cd to a tagged directory
qcd-add /path/of/dir    # manually tag a path (can be "." or no path for full interactive mode)
```

##### License
qcd.bash is licensed under the GNU AGPLv3
