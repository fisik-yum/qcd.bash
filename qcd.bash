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

#!/bin/bash

# default configuration - can be overriden after sourcing in .bashrc
export QCD_MINIMUMLINES=8
export QCD_HOME="$HOME"

export dirlist="" # don't override this!

qcd-transparent ()
{
    cd "$@"
    if ! [[ "$(realpath $(pwd))" == "$QCD_HOME" ]]; then
        dirlist+='"'$(pwd)'"'" "
        if ! [[ "$1" = .. ]]; then
            __qcd_check
        fi
    fi

}

qcd ()
{ 
    tdir=$(__qcd_rcread $1)
    if ! [[ $tdir == "" ]]; then
        cd $tdir
    else
        echo "qcd: $1: No such tag"
    fi
}

qcd-add () #$dir
{
    if [[ $1 == "." ]]; then
        __qcd_tagprompt $(realpath $(pwd))
    elif [[ -z "${1// }" || $1 == ".." ]]; then
        while true; do
            read -e -p "Enter directory: " loc
            if [[ -z "${loc// }" ]]; then
                echo "Please enter a valid directory."
            else
                __qcd_tagprompt $loc
                break
            fi
        done
    else
        __qcd_tagprompt $1
    fi
}

qcd_init ()
{
    QCD_HOME=$(realpath "$QCD_HOME")
    if ! [ -f "$QCD_HOME/.qcdrc" ]; then
        touch "$QCD_HOME/.qcdrc"
    fi
}

__qcd_check ()
{
    num=$(echo -n $dirlist | grep -Fo '"'$(realpath $(pwd))'"' | wc -l)
    if [[ $num -eq QCD_MINIMUMLINES && $(__qcd_rccheck $(realpath $(pwd))) ]]; then
        read -p "qcd: Create tag [yN]?" yn
            case $yn in
                [Yy]* )  __qcd_tagprompt "$(realpath $(pwd))" ; return 0;;
                [Nn]* ) return 1;;
                * ) return 1;;
            esac
    fi
}

__qcd_tagprompt () #$value
{
    while true; do
        read -p "Enter tag name: " name
        if [[ -z "${name// }" || ! $(__qcd_rcread $name) == "" ]]; then
            echo "Please enter a valid name. The name specified may already be in use."
        else
            __qcd_rcwrite $name $(realpath $(pwd))
            break
        fi
    done

}

__qcd_rcwrite () #$key $value
{
    if [[ $(__qcd_rcread $1) == "" ]]; then
        echo -e "$1" "$2"  >> "$QCD_HOME/.qcdrc"
    else
        echo "qcd: $1: Tag already exists"
    fi

}


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


__qcd_rccheck () #$value
{
    input="$QCD_HOME/.qcdrc"
    while IFS= read -r line
    do
        key=${line%% *}
        value=${line#* }
        if [[ $1 = $value ]]; then
            return 1 
        fi
    done < "$input"
    return 0
}
