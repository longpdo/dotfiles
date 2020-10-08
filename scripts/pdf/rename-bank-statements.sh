#!/bin/bash

# TODO check if everything works, no idea anymore what was the latest status

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }

_PDF_PATH="$HOME/Downloads/old_macbook/aktien"

for pdf in $(rg --max-depth 1 -t pdf --files "$_PDF_PATH"); do
  name=''

  date=$(pdfgrep --max-count 1 --ignore-case 'tag|zahlbar ab|Investment-Ausschüttung vom|Dividende vom' "$pdf" | tr -dc '0-9')
  [ ${#date} == 6 ] && date=$(echo "$date" | tr -d . | sed 's/.\{4\}/&20/')
  date=$(date -j -f "%d%m%Y" "$date" +%Y%m%d)
  name+=$date'_'

  time=$(pdfgrep --ignore-case 'Handelszeit' "$pdf" | awk '{print $3}' | tr -d :)
  [ -z "$time" ] || name+=$time'_'

  type=$(pdfgrep --max-count 1 --ignore-case 'Wertpapierkauf|Wertpapierverkauf|Dividendengutschrift|Ertragsgutschrift' "$pdf" | awk '{print $1}')
  [ -z "$type" ] && [[ "$pdf" == *"Steuer"* ]] && type='Steuer'
  [ -z "$type" ] && [[ "$pdf" == *"Bestandsveraenderung"* ]] || [[ "$pdf" == *"Ein-Ausbuchung"* ]] && type='Bestandsveraenderung'
  [ -z "$type" ] && [[ "$pdf" == *"Buchungsanzeige"* ]] && type='Buchungsanzeige'
  [ -z "$type" ] || name+=$type'_'

  [[ "$type" == *"kauf"* ]] && stock=$(pdfgrep -A 1 'Wertpapier-Bezeichnung' "$pdf" | sed -n 2p | rev | cut -d ' ' -f2- | rev | sed -e 's/^[ \t]*//')
  [[ "$type" == *"gutschrift"* ]] && stock=$(pdfgrep -A 1 'Wertpapier-Bezeichnung' "$pdf" | sed -n 2p | tr -s ' ' | cut -d ' ' -f4- | rev | cut -d ' ' -f2- | rev | sed -e 's/^[ \t]*//')
  [[ "$type" == *"Steuer"* ]] && stock=$(pdfgrep 'Stk.' "$pdf" | tr -s ' ' | cut -d ' ' -f4- | rev | cut -d ' ' -f8- | rev | sed -e 's/^[ \t]*//')
  [[ "$type" == *"Bestandsveraenderung"* ]] && stock=$(pdfgrep -A 1 'VERWAHRUNGSART' "$pdf" | sed -n 2p | tr -s ' ' | cut -d ' ' -f5- | sed -e 's/^[ \t]*//')
  [[ "$type" == *"Buchungsanzeige"* ]] && stock=$(pdfgrep -A 1 'unter Ausbuchung von:' "$pdf" | sed -n 2p | rev | cut -d ' ' -f3- | rev | sed -e 's/^[ \t]*//')
  [ -z "$stock" ] || name+=$stock

  name=$(echo "$name" | sed -e "s/.Inc.*//g" -e "s/.SE.*//g" -e "s/.AG.*//g" -e "s/.ETF.*//g" -e "s/.Corp.*//g" -e "s/.PLC.*//g" -e "s/.N.V.*//g" -e "s/.S.A.*//g" -e "s/.Navne.*//g" | tr ' ' '.' | sed -e 's/[().,-]\{1,3\}/\./g')

  _info "$name.pdf"
  # mv -i "$pdf" "$_PDF_PATH/$name.pdf"
done
