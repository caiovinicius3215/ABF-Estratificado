#!/bin/bash

SCRIPT="3_setupdirs.sh"

if [ ! -f "$SCRIPT" ]; then
  echo "Erro: script não encontrado: $SCRIPT"
  exit 1
fi

win=1
lower=-35
width=3
step=2
upper_limit=35

while true; do
  upper=$((lower + width))

  if [ "$upper" -gt "$upper_limit" ]; then
    upper=$upper_limit
  fi

  win_padded=$(printf "%02d" "$win")

  echo "Criando janela $win_padded [$lower,$upper]"

  bash "$SCRIPT" "$win" "$lower" "$upper"

  if [ "$upper" -eq "$upper_limit" ]; then
    break
  fi

  lower=$((lower + step))
  win=$((win + 1))
done

echo "Todas as janelas foram processadas."
