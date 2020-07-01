#!/bin/bash

# Rename broker statements and move/sort them to the right portfolio folder
# | Files will be renamed: YYYYMMDD_HHMMSS_{type}_{stock}.pdf
# | Supported brokers: comdirect, ING, Trade Republic
# | Dependencies: pdfgrep

# Path variables for the input and output folders
_PDF_PATH="$HOME/Documents/broker"
_COMDIRECT_PATH="$HOME/Documents/broker/comdirect"
_COMDIRECT_1302_PATH="$HOME/Documents/broker/comdirect.1302"
_COMDIRECT_1508_PATH="$HOME/Documents/broker/comdirect.1508"
_ING_PATH="$HOME/Documents/broker/ING"
_TRADE_REPUBLIC_PATH="$HOME/Documents/broker/Trade.Republic"
_TRADE_REPUBLIC_1302_PATH="$HOME/Documents/broker/Trade.Republic.1302"

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }

# Rename comdirect invoices
_comdirect() {
  # pdfgrep the date
  date=$(pdfgrep --max-count 1 --ignore-case 'Geschaeftstag|Geschäftstag|Datum:|zahlbar ab|Investment-Ausschüttung vom|Dividende vom' "$1" | tr -dc '0-9')
  [ ${#date} -gt 8 ] && date=$(pdfgrep --max-count 1 --ignore-case 'Geschtag' "$1" | tr -dc '0-9')
  [ ${#date} == 6 ] && date=$(echo "$date" | tr -d . | sed 's/.\{4\}/&20/')
  # Format the date to YYYYMMDD
  date=$(date -j -f "%d%m%Y" "$date" +%Y%m%d)
  name=$date'_'

  # pdfgrep the time for buy or sell orders
  time=$(pdfgrep --ignore-case 'Handelszeit' "$1" | awk '{print $3}' | tr -d :)
  [ -z "$time" ] || name+=$time'_'

  # pdfgrep the type of the invoice (buy order, sell order or dividend)
  type=$(pdfgrep --max-count 1 --ignore-case 'Wertpapierkauf|Wertpapierverkauf|Dividendengutschrift|Ertragsgutschrift' "$1" | awk '{print $1}')
  # Check name of the pdf for the type (tax invoice, portfolio changes, splits)
  [ -z "$type" ] && [[ "$1" == *"Steuer"* ]] && type='Steuer'
  [ -z "$type" ] && [[ "$1" == *"Bestandsveraenderung"* ]] || [[ "$1" == *"Ein-Ausbuchung"* ]] && type='Bestandsveraenderung'
  [ -z "$type" ] && [[ "$1" == *"Buchungsanzeige"* ]] && type='Buchungsanzeige'
  [ -z "$type" ] || name+=$type'_'

  # pdfgrep the name of the stock
  [[ "$type" == *"kauf"* ]] && stock=$(pdfgrep -A 1 'Wertpapier-Bezeichnung' "$1" | sed -n 2p | rev | cut -d ' ' -f2- | rev | sed -e 's/^[ \t]*//')
  [[ "$type" == *"gutschrift"* ]] && stock=$(pdfgrep -A 1 'Wertpapier-Bezeichnung' "$1" | sed -n 2p | tr -s ' ' | cut -d ' ' -f4- | rev | cut -d ' ' -f2- | rev | sed -e 's/^[ \t]*//')
  [[ "$type" == *"Steuer"* ]] && stock=$(pdfgrep 'Stk.' "$1" | tr -s ' ' | cut -d ' ' -f4- | rev | cut -d ' ' -f8- | rev | sed -e 's/^[ \t]*//')
  [[ "$type" == *"Bestandsveraenderung"* ]] && stock=$(pdfgrep -A 1 'VERWAHRUNGSART' "$1" | sed -n 2p | tr -s ' ' | cut -d ' ' -f5- | sed -e 's/^[ \t]*//')
  [[ "$type" == *"Buchungsanzeige"* ]] && stock=$(pdfgrep -A 1 'unter Ausbuchung von:' "$1" | sed -n 2p | rev | cut -d ' ' -f3- | rev | sed -e 's/^[ \t]*//')
  [ -z "$stock" ] || name+=$stock

  # Remove suffixes from stock names, replace spaces with dots, replace up to three special chars next to one another for one dot
  name=$(echo "$name" | sed -e "s/ Inc.*//g" -e "s/ SE.*//g" -e "s/ AG.*//g" -e "s/.ETF.*//g" -e "s/ Corp.*//g" -e "s/ PLC.*//g" -e "s/ N\.V.*//g" -e "s/ S\.A.*//g" -e "s/.Navne.*//g" | tr -s ' ' | tr ' ' '.' | sed -e 's/[().,-]\{1,3\}/\./g' | sed 's/\.$//')
  name+='.pdf'

  # Rename the pdf and move the pdf to the right portfolio folder
  pdfgrep -q 'Long Phi Do' "$1" && _info "comdirect: ldo_$name" && mv -i "$1" "$_COMDIRECT_PATH/ldo_$name" && return
  pdfgrep -q 'Phi Phung Tran' "$1" && _info "comdirect.1302: ptr_$name" && mv -i "$1" "$_COMDIRECT_1302_PATH/ptr_$name" && return
  pdfgrep -q 'Huu Nhan Do' "$1" && _info "comdirect.1508: ndo_$name" && mv -i "$1" "$_COMDIRECT_1508_PATH/ndo_$name" && return
}

# Rename ING invoices
_ing() {
  # pdfgrep the date
  date=$(pdfgrep --ignore-case 'datum' "$1" | awk '{print $5}')
  # Format the date to YYYYMMDD
  date=$(date -j -f "%d.%m.%Y" "$date" +%Y%m%d)
  name=$date'_'

  # pdfgrep the type of the invoice (buy order, sell order)
  type=$(pdfgrep --ignore-case 'Wertpapierabrechnung' "$1" | awk '{print $2}')
  # pdfgrep the time for buy or sell orders
  time=$(pdfgrep --ignore-case 'Ausführungstag / -zeit' "$1" | awk '{print $6}' | tr -d :)
  [ -z "$type" ] || name+=$time'_'$type'_'

  # pdfgrep the type of the invoice (dividend)
  type=$(pdfgrep --max-count 1 --ignore-case 'Dividendengutschrift' "$1" | awk '{print $1}')
  [ -z "$type" ] || name+=$type'_'
  # Check name of the pdf for the type (portfolio changes, splits)
  [[ "$1" == *"Bestandsveraenderung"* ]] && name+='Bestandsveraenderung.pdf'

  # Remove suffixes from stock names
  stock=$(pdfgrep --ignore-case 'Wertpapierbezeichnung' "$1" | awk -F" " '{$1=""; print $0}' | sed -e 's/^[ \t]*//' | sed -e "s/ Inc.*//g" -e "s/ SE.*//g" -e "s/ AG.*//g" -e "s/.ETF.*//g" -e "s/ Corp.*//g" -e "s/  PLC.*//g" -e "s/ N\.V.*//g" -e "s/ Registered Shares.*//g" -e "s/ Reg. Shares.*//g" -e "s/ S\.A.*//g" -e "s/.Navne.*//g")
  [ -z "$stock" ] || name+=$stock'.pdf'

  # Replace spaces with dots, replace up to three special chars next to one another for one dot
  name=$(echo "$name" | tr ' ' '.' | sed -e 's/[().,-]\{1,3\}/\./g')

  # Rename and move the pdf
  pdfgrep -q 'Long Phi Do' "$1" && _info "ING: ldo_$name" && mv -i "$1" "$_ING_PATH/ldo_$name"
}

# Rename Trade Republic invoices
_trade_republic() {
  # pdfgrep the date
  date=$(pdfgrep --ignore-case 'datum' "$1" | awk '{print $4}')
  # Format the date to YYYYMMDD
  date=$(date -j -f "%d.%m.%Y" "$date" +%Y%m%d)
  name=$date'_'

  # pdfgrep the type of the invoice (buy order, sell order)
  type=$(pdfgrep --ignore-case 'Order Kauf|Order Verkauf' "$1" | awk 'OFS="_" {print $6,$2}' | tr -d :)
  [ -z "$type" ] || name+=$type'_'
  # pdfgrep the type of the invoice (stock savings plan, dividend)
  type=$(pdfgrep --ignore-case 'Sparplanausführung|mit dem Ex-Tag' "$1" | awk '{print $1}' | sed 's/ü/ue/g')
  [ -z "$type" ] || name+=$type'_'
  # pdfgrep the type of the invoice (splits)
  type=$(pdfgrep --ignore-case 'Reverse Split' "$1" | awk '{print $2}' | tr '[:upper:]' '[:lower:]')
  [ -z "$type" ] || name+=$type'_'

  # Remove suffixes from stock names
  stock=$(pdfgrep --ignore-case ' in Girosammelverwahrung.| in Wertpapierrechnung.' "$1" | sed -e "s/ Inc.*//g" -e "s/ SE.*//g" -e "s/ AG.*//g" -e "s/.ETF.*//g" -e "s/ Corp.*//g" -e "s/ PLC.*//g" -e "s/ N\.V.*//g" -e "s/ Registered Shares.*//g" -e "s/ Reg. Shares.*//g" -e "s/ S\.A.*//g" -e "s/.Navne.*//g")
  [ -z "$stock" ] || name+=$stock'.pdf'

  # Replace spaces with dots, replace up to three special chars next to one another for one dot
  name=$(echo "$name" | tr ' ' '.' | sed -e 's/[().,-]\{1,3\}/\./g')

  # Rename the pdf and move the pdf to the right portfolio folder
  pdfgrep -q 'Long Phi Do' "$1" && _info "Trade.Republic: ldo_$name" && mv -i "$1" "$_TRADE_REPUBLIC_PATH/ldo_$name" && return
  pdfgrep -q 'Phi Phung Tran' "$1" && _info "Trade.Republic.1302: $name" && mv -i "$1" "$_TRADE_REPUBLIC_1302_PATH/ptr_$name" && return
}

# Rename comdirect statements
_comdirect_report() {
  # pdfgrep the date and set the type (broker statement, tax statement) based on the name of the pdf
  [[ "$1" == *"Finanzreport"* ]] && date=$(pdfgrep --max-count 1 'Finanzreport' "$1" | awk '{print $5}') && type='Finanzreport'
  [[ "$1" == *"Jahressteuerbescheinigung"* ]] && date=$(pdfgrep --max-count 1 'Datum' "$1" | awk '{print $2}') && type='Jahressteuerbescheinigung'

  # Format the date to YYYYMMDD
  date=$(date -j -f "%d.%m.%Y" "$date" +%Y%m%d)
  name=$date'_'$type'.pdf'

  # Rename the pdf and move the pdf to the right portfolio folder
  pdfgrep -q 'Long Phi Do' "$1" && _info "comdirect: ldo_$name" && mv -i "$1" "$_COMDIRECT_PATH/reports/ldo_$name" && return
  pdfgrep -q 'Phi Phung Tran' "$1" && _info "comdirect.1302: ptr_$name" && mv -i "$1" "$_COMDIRECT_1302_PATH/reports/ptr_$name" && return
  pdfgrep -q 'Huu Nhan Do' "$1" && _info "comdirect.1508: ndo_$name" && mv -i "$1" "$_COMDIRECT_1508_PATH/reports/ndo_$name" && return
}

# Rename ING statements
_ing_report() {
  # pdfgrep the date and set the type (broker statement, tax statement) based on the name of the pdf
  [[ "$1" == *"Depotauszug"* ]] && date=$(pdfgrep --max-count 1 'Datum' "$1" | awk '{print $5}') && type='Depotauszug'
  [[ "$1" == *"Ertraegnisaufstellung"* ]] && date=$(pdfgrep --max-count 1 'Frankfurt/Main,' "$1" | awk '{print $3}') && type='Ertraegnisaufstellung'
  [[ "$1" == *"teuerbescheinigung"* ]] && date=$(pdfgrep --max-count 1 'Frankfurt/Main,' "$1" | awk '{print $2}') && type='Steuerbescheinigung'
  [[ "$1" == *"Verlustverrechnung"* ]] && date=$(pdfgrep --max-count 1 'Datum' "$1" | awk '{print $9}') && type='Verlustverrechnung'
  [[ "$type" == *"Verlustverrechnung"* ]] && pdfgrep -q 'Zusatzbeleg' "$1" && type+='.Zusatzbeleg'

  # Format the date to YYYYMMDD
  date=$(date -j -f "%d.%m.%Y" "$date" +%Y%m%d)
  name=$date'_'$type'.pdf'

  # Rename and move the pdf
  pdfgrep -q 'Long Phi Do' "$1" && _info "ING: ldo_$name" && mv -i "$1" "$_ING_PATH/reports/ldo_$name" && return
}

for pdf in $(rg --max-depth 1 -t pdf --files "$_PDF_PATH"); do
  # pdfgrep the broker name and call the corresponding method to rename the broker statements
  pdfgrep -q 'comdirect bank' "$pdf" && pdfgrep -q 'Finanzreport|Steuerbescheinigung' "$pdf" && _comdirect_report "$pdf" && continue
  pdfgrep -q 'ING-DiBa AG' "$pdf" && pdfgrep -q 'Jahresdepotauszug|Depotauszug|Erträgnisaufstellung|Steuerbescheinigung|Verlustverrechnung' "$pdf" && _ing_report "$pdf" && continue

  # pdfgrep the broker name and call the corresponding method to rename the broker invoices
  pdfgrep -q 'ING-DiBa AG · 60628 Frankfurt am Main' "$pdf" && _ing "$pdf" && continue
  pdfgrep -q 'comdirect bank' "$pdf" && _comdirect "$pdf" && continue
  pdfgrep -q 'TRADE REPUBLIC BANK GMBH' "$pdf" && _trade_republic "$pdf" && continue
done
