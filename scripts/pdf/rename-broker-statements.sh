#!/bin/bash

# Rename broker statements and move/sort them to the right portfolio folder
# | Files will be renamed: YYYYMMDD_HHMMSS_{type}_{stock}.pdf
# | Supported brokers: comdirect, ING, Trade Republic, Scalable Capital
# | Dependencies: pdfgrep

# Path variables for the input and output folders
_PDF_PATH="$HOME/Downloads/broker"
_COMDIRECT_PATH="$_PDF_PATH/comdirect"
_COMDIRECT_1302_PATH="$_PDF_PATH/comdirect.1302"
_COMDIRECT_1508_PATH="$_PDF_PATH/comdirect.1508"
_ING_PATH="$_PDF_PATH/broker/ING"
_SCALABLE_PATH="$_PDF_PATH/Scalable.Capital"
_SCALABLE_1302_PATH="$_PDF_PATH/Scalable.Capital.1302"
_SCALABLE_1508_PATH="$_PDF_PATH/Scalable.Capital.1508"
_TRADE_REPUBLIC_PATH="$_PDF_PATH/Trade.Republic"
_TRADE_REPUBLIC_1302_PATH="$_PDF_PATH/Trade.Republic.1302"

#TODO ganz am Anfang durchgehen und spaces durch _ ersetzen

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
  [ -z "$type" ] && [[ "$1" == *"Bestandsveraenderung"* ]] || [[ "$1" == *"Ein-Ausbuchung"* ]] && type='Bestandsveraenderung'
  [ -z "$type" ] && [[ "$1" == *"Buchungsanzeige"* ]] && type='Buchungsanzeige'
  [ -z "$type" ] || name+=$type'_'

  # Betrag nur bei Kauf, Verkauf, Dividende
  gesamt=$(pdfgrep --max-count 1 -A 1 'Valuta' "$1" | awk '/[0-9,]/ {print $NF}')
  [ -z "$gesamt" ] || name+='['$(echo "$gesamt" | tr -d '.')']_'

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

  # DEBUG HELPER
  # _info "$1 > $name" && return

  # Rename the pdf and move the pdf to the right portfolio folder
  pdfgrep -q 'Long' "$1" && _info "comdirect: ldo_$name" && mv -i "$1" "$_COMDIRECT_PATH/ldo_$name" && return
  pdfgrep -q 'Phung' "$1" && _info "comdirect.1302: ptr_$name" && mv -i "$1" "$_COMDIRECT_1302_PATH/ptr_$name" && return
  pdfgrep -q 'Nhan' "$1" && _info "comdirect.1508: ndo_$name" && mv -i "$1" "$_COMDIRECT_1508_PATH/ndo_$name" && return
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
  pdfgrep -q 'Long' "$1" && _info "ING: ldo_$name" && mv -i "$1" "$_ING_PATH/ldo_$name"
}

# Rename Scalable Capital invoices
_scalable_capital() {
  isStockInvoice=$(pdfgrep --max-count 1 'Wertpapierabrechnung' "$1")
  # TODO pdfgrep stock (splits)
  # TODO add early returns and error logging

  if [[ -n "$isStockInvoice" ]]; then
    # GET DATE AND TIME OF TRANSACTION
    isStockPlanInvoice=$(pdfgrep --max-count 1 'ext.Vermögensverw.' "$1")
    if [[ -n "$isStockPlanInvoice" ]]; then
      # pdfgrep the date
      date=$(pdfgrep -B 2 'Zeitzone der Handelsuhrzeit:' "$1" | awk '/[0-9]+[.\/-][0-9]+[.\/-][0-9]+/ {print $1}' | tr -d :)
      # Format the date to YYYYMMDD
      date=$(date -j -f "%d.%m.%Y" "$date" +%Y%m%d)
      name=$date'_'

      # pdfgrep the time for buy or sell orders
      time=$(pdfgrep -B 2 'Zeitzone der Handelsuhrzeit:' "$1" | awk '/[0-9]/ {print $2}' | tr -d :)
      [ -z "$time" ] || name+=$time'_'
    else
      # pdfgrep the date
      date=$(pdfgrep -B 2 'Zeitzone der Handelsuhrzeit:' "$1" | awk '{print $9}' | grep -v '^[[:space:]]*$')
      # Format the date to YYYYMMDD
      date=$(date -j -f "%d.%m.%Y" "$date" +%Y%m%d)
      name=$date'_'

      # pdfgrep the time for buy or sell orders
      time=$(pdfgrep -B 2 'Zeitzone der Handelsuhrzeit:' "$1" | awk '{print $10}' | tr -d : | grep -v '^[[:space:]]*$')
      [ -z "$time" ] || name+=$time'_'
    fi

    # pdfgrep the type of the invoice (buy order, sell order)
    type=$(pdfgrep --max-count 1 'Wertpapierabrechnung' "$1" | awk '{print $2}')
    [ -z "$type" ] || name+=$type'_'

    # Betrag
    gesamt=$(pdfgrep --max-count 1 'Valuta' "$1" | awk '{print $NF}')
    [ -z "$gesamt" ] || name+='['$(echo "$gesamt" | tr -d '.')']_'

    # FSA
    fsa=$(pdfgrep --max-count 1 'Freistellungsauftrag' "$1")
    [ -z "$fsa" ] || name+='FSA_'

    # add Steuer
    kap=$(pdfgrep --max-count 1 'Kapitalertragsteuer    ' "$1" | awk '{gsub(/-$/, ""); print $NF}')
    kir=$(pdfgrep --max-count 1 'Kirchensteuer ' "$1" | awk '{gsub(/-$/, ""); print $NF}')
    soli=$(pdfgrep --max-count 1 'Solidaritätszuschlag' "$1" | awk '{gsub(/-$/, ""); print $NF}')
    if [[ -n "$kap" ]]; then
      steuer=$(echo -e "$kap\n$soli\n$kir" | awk '{gsub(/-$/, ""); sum+=$NF} END {print sum}')
      [ -z "$steuer" ] || name+='ST_['$steuer']_'
    fi

    # AVT
    avt=$(pdfgrep --max-count 1 'Aktienverlust' "$1" | awk '{$1=""; $2=""; $3=""; $4=""; $(NF-1)=""; $NF=""; gsub(/^[ \t]+/,""); print}')
    if [[ -n "$avt" ]]; then
      if [[ "$avt" == *' -  '  ]]; then
        # wenn - am Ende, dann war es Profitgeschaeft und ich muss die theoretischen Steuern berechnen
        name+='AVT_ST_'
      else
        # wenn kein - am Ende, dann war es Verlustgeschaeft und ich muss die Steuerrueckerstattung berechnen
        name+='AVT_RU_'
      fi

      # TODO will not work values with 2 or more thousand separators like 1.234.567.89
      avt_value=$(echo "$avt" | awk '{gsub(/ -  $/, ""); print $NF}' | tr ',' '.' | sed 's/\([0-9]\)\.\([0-9]\{3\}\)/\1\2/g')
      if pdfgrep -q 'Tran' "$1"; then
        if [[ -n "$avt_value" ]]; then
          avt_kap=$(bc -l <<< "$avt_value * 0.2451")
          avt_soli=$(bc -l <<< "$avt_kap * 0.055")
          avt_kir=$(bc -l <<< "$avt_kap * 0.08")
          avt_st=$(bc -l <<< "$avt_kap + $avt_soli + $avt_kir")
        fi
      else
        if [[ -n "$avt_value" ]]; then
          avt_kap=$(bc -l <<< "$avt_value * 0.25")
          avt_soli=$(bc -l <<< "$avt_kap * 0.055")
          avt_st=$(bc -l <<< "$avt_kap + $avt_soli")
        fi
      fi
      [ -z "$avt_st" ] || name+='['$(bc -l <<< "scale=2; $avt_st / 1")']_'
    fi

    # Get stock name
    stock=$(pdfgrep --max-count 1 'STK ' "$1" | awk '{$1=""; $2=""; $(NF-1)=""; $NF=""; gsub(/^[ \t]+/,""); print}')
    [ -z "$stock" ] && _info "ERROR $1" && return
    [ -z "$stock" ] || name+=$stock'.pdf'
  fi

  isDivInvoice=$(pdfgrep --max-count 1 'Ausschüttung' "$1")
  if [[ -n "$isDivInvoice" ]]; then
    # pdfgrep the date
    date=$(pdfgrep --max-count 1 'Valuta:' "$1" | awk '{print $6}')
    # Format the date to YYYYMMDD
    date=$(date -j -f "%d.%m.%Y" "$date" +%Y%m%d)
    name=$date'_Dividende_'

    gesamt=$(pdfgrep --max-count 1 'Valuta:' "$1" | awk '{print $NF}')
    [ -z "$gesamt" ] || name+='['$(echo "$gesamt" | tr -d '.')']_'

    # Get stock name
    stock=$(pdfgrep --max-count 1 'STK ' "$1" | awk '{$1=""; $2=""; $(NF-2)=""; $(NF-1)=""; $NF=""; gsub(/^[ \t]+/,""); print}')
    [ -z "$stock" ] && _info "ERROR $1" && return
    [ -z "$stock" ] || name+=$stock'.pdf'
  fi

  # Replace spaces with dots, replace up to three special chars next to one another for one dot
  name=$(echo "$name" | tr ' ' '.' | sed -e 's/[().,-]\{1,3\}/\./g')

  # DEBUG HELPER
  # _info "$1 > $name" && return

  # Rename the pdf and move the pdf to the right portfolio folder
  pdfgrep -q 'Long' "$1" && _info "$1 > Scalable.Capital: ldo_$name" && mv -i "$1" "$_SCALABLE_PATH/ldo_$name" && return
  pdfgrep -q 'Huu' "$1" && _info "$1 > Scalable.Capital.1508: ndo_$name" && mv -i "$1" "$_SCALABLE_1508_PATH/ndo_$name" && return
  pdfgrep -q 'Tran' "$1" && _info "$1 > Scalable.Capital.1302: ptr_$name" && mv -i "$1" "$_SCALABLE_1302_PATH/ptr_$name" && return
}

# Rename Trade Republic invoices
_trade_republic() {
  # pdfgrep the date
  pdfgrep -q 'Limit-Order|Market-Order' "$1" && date=$(pdfgrep --ignore-case 'an der Lang & Schwarz Exchange.|an der Lang und Schwarz Exchange.|an der Tradegate Exchange.' "$1" | awk '{print $4}' | sed 's/,//')
  pdfgrep -q 'Dividende mit dem Ex-Tag|Ausschüttung mit dem Ex-Tag' "$1" && date=$(pdfgrep --ignore-case 'datum' "$1" | awk '{print $4}')
  pdfgrep -q ' mit Ex-Datum' "$1" && date=$(pdfgrep --ignore-case 'datum' "$1" -m 1 | awk '{print $4}')
  pdfgrep -q 'Sparplanausf' "$1" && date=$(pdfgrep --ignore-case 'an der Lang & Schwarz Exchange.|an der Lang und Schwarz Exchange.' "$1" | awk '{print $3}')

  # Format the date to YYYYMMDD
  # _info "$date"
  date=$(date -j -f "%d.%m.%Y" "$date" +%Y%m%d)
  name=$date'_'

  # pdfgrep the type of the invoice (buy order, sell order)
  type=$(pdfgrep --ignore-case 'Order Kauf|Order Verkauf' "$1" | awk 'OFS="_" {print $6,$2}' | tr -d :)
  [ -z "$type" ] || name+=$type'_'
  # pdfgrep the type of the invoice (stock savings plan, dividend)
  type=$(pdfgrep --ignore-case 'Sparplanausführung|mit dem Ex-Tag|mit Ex-Datum' "$1" | awk '{print $1}' | sed 's/ü/ue/g')
  [ -z "$type" ] || name+=$type'_'
  # pdfgrep the type of the invoice (splits)
  type=$(pdfgrep --ignore-case 'Reverse Split' "$1" | awk '{print $2}' | tr '[:upper:]' '[:lower:]')
  [ -z "$type" ] || name+=$type'_'

  # Remove suffixes from stock names
  stock=$(pdfgrep --ignore-case ' Wertpapierrechnung| in Girosammelverwahrung| in Wertpapierrechnung| im Girosammelverwahrung in Deutschland' "$1" | sed -e "s/ Inc.*//g" -e "s/ SE.*//g" -e "s/ AG.*//g" -e "s/.ETF.*//g" -e "s/ Corp.*//g" -e "s/ PLC.*//g" -e "s/ N\.V.*//g" -e "s/ Registered Shares.*//g" -e "s/ Reg. Shares.*//g" -e "s/ S\.A.*//g" -e "s/.Navne.*//g" -e "s/.Ltd.*//g" -e "s/.Oyj.*//g" -e "s/.Wertpapierrechnung.*//g" -e "s/.in Wertpapierrechnung.*//g" -e "s/.in Girosammelverwahrung in Deutschland.*//g" -e "s/.im Girosammelverwahrung in Deutschland.*//g" -e "s/Diese Abrechnung wird maschinell erstellt und daher nicht unterschrieben.*//g")
  [ -z "$stock" ] || name+=$stock'.pdf'

  # Replace spaces with dots, replace up to three special chars next to one another for one dot
  name=$(echo "$name" | tr ' ' '.' | sed -e 's/[().,-]\{1,3\}/\./g')

  # DEBUG HELPER
  # _info "$1 > $name" && return

  # Rename the pdf and move the pdf to the right portfolio folder
  pdfgrep -q 'Long' "$1" && _info "Trade.Republic: ldo_$name" && mv -i "$1" "$_TRADE_REPUBLIC_PATH/ldo_$name" && return
  pdfgrep -q 'Tran' "$1" && _info "Trade.Republic.1302: ptr_$name" && mv -i "$1" "$_TRADE_REPUBLIC_1302_PATH/ptr_$name" && return
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
  pdfgrep -q 'Long' "$1" && _info "comdirect: ldo_$name" && mv -i "$1" "$_COMDIRECT_PATH/reports/ldo_$name" && return
  pdfgrep -q 'Phung' "$1" && _info "comdirect.1302: ptr_$name" && mv -i "$1" "$_COMDIRECT_1302_PATH/reports/ptr_$name" && return
  pdfgrep -q 'Nhan' "$1" && _info "comdirect.1508: ndo_$name" && mv -i "$1" "$_COMDIRECT_1508_PATH/reports/ndo_$name" && return
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
  pdfgrep -q 'Long' "$1" && _info "ING: ldo_$name" && mv -i "$1" "$_ING_PATH/reports/ldo_$name" && return
}

for pdf in $(rg --max-depth 1 -t pdf --files "$_PDF_PATH"); do
  # pdfgrep the broker name and call the corresponding method to rename the broker statements
  pdfgrep -q '25449 Quickborn' "$pdf" && pdfgrep -q 'Finanzreport|Steuerbescheinigung' "$pdf" && _comdirect_report "$pdf" && continue
  pdfgrep -q 'ING-DiBa AG' "$pdf" && pdfgrep -q 'Jahresdepotauszug|Depotauszug|Erträgnisaufstellung|Steuerbescheinigung|Verlustverrechnung' "$pdf" && _ing_report "$pdf" && continue

  # pdfgrep the broker name and call the corresponding method to rename the broker invoices
  pdfgrep -q 'ING-DiBa AG · 60628 Frankfurt am Main' "$pdf" && _ing "$pdf" && continue
  pdfgrep -q '25449 Quickborn' "$pdf" && _comdirect "$pdf" && continue
  pdfgrep -q '25451 Quickborn' "$pdf" && _comdirect "$pdf" && continue
  pdfgrep -q 'Scalable Capital' "$pdf" && _scalable_capital "$pdf" && continue
  pdfgrep -q 'TRADE REPUBLIC BANK GMBH' "$pdf" && _trade_republic "$pdf" && continue
done
