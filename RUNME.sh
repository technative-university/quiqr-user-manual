#!/usr/bin/env sh
#(C)2019-2022 Pim Snel - https://github.com/mipmip/RUNME.sh
ALLARGS=("$@");CMDS=();DESC=();NARGS=$#;ARG1=$1;make_command(){ CMDS+=($1);DESC+=("$2");};usage(){ printf "\nUsage: %s [command]\n\nCommands:\n" $0;line="              ";for((i=0;i<=$(( ${#CMDS[*]} -1));i++));do printf "  %s %s ${DESC[$i]}\n" ${CMDS[$i]} "${line:${#CMDS[$i]}}";done;echo;};runme(){ if test $NARGS -gt 0;then eval "$ARG1"||usage;else usage;fi;}

prepare(){
 if test $NARGS -lt 2; then
   echo "Usage: ./RUNME.sh ${ARG1} [./markdown_file.md]"
   exit 1
 fi

 MARKDOWNFILE=${ALLARGS[1]}
}

##### PLACE YOUR COMMANDS BELOW #####

make_command "install_deps" "install or update exensions and other dependancies"
install_deps(){
  echo "Installing extension: TexNative"
  quarto add --no-prompt wearetechnative/texnative
  echo "Installing extension: Quarto TechNative Branding"
  quarto add --no-prompt TechNative-B-V/quarto-technative-branding
  echo "Installing extension: Quarto TechNative Presentation Template"
  quarto add --no-prompt TechNative-B-V/revealjs-technative-theme
}

make_command "render_auto" "auto render a markdown file on change"
render_auto(){
  prepare
  echo "Auto rendering. Press CTRL-C to quit."
  ls $MARKDOWNFILE | entr quarto render $MARKDOWNFILE
}

make_command "export_slide_to_pdf" "eport a slide to PDF"
export_slide_to_pdf(){
  prepare
  quarto render $MARKDOWNFILE
  SLIDE_BASENAME=`basename -s'.qmd' $MARKDOWNFILE`
  docker run --rm -t -v `pwd`:/slides astefanutti/decktape \
    /slides/output/slides/$SLIDE_BASENAME.html /slides/output/slides/$SLIDE_BASENAME.pdf
}

##### PLACE YOUR COMMANDS ABOVE #####

runme
