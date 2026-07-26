#!/bin/bash

# Uso:
#   bash run_all_windows.sh step5_input.psf step7_production.dcd
#
# Exemplo:
#   bash run_all_windows.sh step5_input.psf step7_production.dcd

PSF="$1"
DCD="$2"
TCL_SCRIPT="2extratifica_pdb.tcl"

if [ -z "$PSF" ] || [ -z "$DCD" ]; then
  echo "Uso: bash run_all_windows.sh arquivo.psf arquivo.dcd"
  exit 1
fi

if [ ! -f "$PSF" ]; then
  echo "Erro: PSF não encontrado: $PSF"
  exit 1
fi

if [ ! -f "$DCD" ]; then
  echo "Erro: DCD não encontrado: $DCD"
  exit 1
fi

if [ ! -f "$TCL_SCRIPT" ]; then
  echo "Erro: script TCL não encontrado: $TCL_SCRIPT"
  exit 1
fi

# ==============================
# Definição das janelas ABF
# ==============================

win=1
lower=-35
width=3
step=2
upper_limit=35

# Limpa registro anterior, se existir
rm -f pdb_sources.dat

while true; do

  upper=$((lower + width))

  # Ajusta a última janela para terminar exatamente em +35
  if [ "$upper" -gt "$upper_limit" ]; then
    upper=$upper_limit
  fi

  echo "========================================="
  echo "Rodando janela $win : [$lower, $upper]"
  echo "========================================="

  vmd -dispdev text -e "$TCL_SCRIPT" -args "$PSF" "$DCD" "$win" "$lower" "$upper"

  # Para quando a última janela atingir +35
  if [ "$upper" -eq "$upper_limit" ]; then
    break
  fi

  lower=$((lower + step))
  win=$((win + 1))

done

echo "Todas as janelas foram processadas."
