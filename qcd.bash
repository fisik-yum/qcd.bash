#!/bin/bash

# qcd.bash - a somewhat smarter cd command
#    Copyright (C) 2024  fisik_yum
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.


# default configuration - can be overriden after sourcing in .bashrc
export QCD_HOME="$HOME"
export QCD_TABCOMPLETE=1



qcd ()
{
    while getopts "hl" flag
    do
        case "${flag}" in
            h)echo "USAGE: qcd [-h|-l|tag {modifiers}]" && return;; 
	        l)cat "$QCD_HOME/.qcdrc" && return;;
            *);; 
        esac
    done

    tdir=$(__qcd_process "$1" "$2")
    if ! [[ "$tdir" == "" ]]; then
        cd "$tdir" || return
    else
        echo "qcd: $1 $2: No such tag"
    fi

    
}


qcd_init ()
{
    QCD_HOME=$(realpath "$QCD_HOME")
    if ! [ -f "$QCD_HOME/.qcdrc" ]; then
        touch "$QCD_HOME/.qcdrc"
    fi
    if [[ $QCD_TABCOMPLETE ]]; then
        complete -F __qcd_listtags qcd
    fi

}

__qcd_rcwrite () #$key $value
{
    if [[ $(__qcd_rcread $1) == "" ]]; then
        echo -e "$1" "$2"  >> "$QCD_HOME/.qcdrc"
    else
        echo "qcd: $1: Tag already exists"
    fi

}

# read/transform some sort of command
__qcd_rcread () #$key
{
    input="$QCD_HOME/.qcdrc"
    while IFS= read -r line
    do
        key=${line%% *}
        value=${line#* }
        if [[ $1 == $key ]]; then
            echo $value
            return 0 
        fi
    done < "$input"
    return 1
}

__qcd_process() { # $op $mod
    #check if positional operation
    if [[ "$(echo "$(echo "$1" | tail -c 2)")" == "d" ]]; then
        if [[ "${1::-1}" =~ ^[0-9]+$ ]]; then
            ret=""
            for i in $(seq "${1::-1}"); do
                ret=$ret"../"
            done
        echo "$ret""$2"
        return 0
        fi
    fi
    # check if key
    ret="$(__qcd_rcread $1)"
    if ! [[ "$ret" == "" ]]; then
        echo "$ret""$2" 
        return 0
    fi
    echo "$ret"
    return 1
    
}

__qcd_listtags ()
{
    input="$QCD_HOME/.qcdrc"
    while IFS= read -r line
    do
        key=${line%% *}
        COMPREPLY+=($key)
    done < "$input"
}
