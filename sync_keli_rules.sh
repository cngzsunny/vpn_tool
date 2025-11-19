#!/bin/zsh
set -e

BASE_AGENT="Loon/912 CFNetwork/3860.300.31 Darwin/25.2.0"
OUTPUT_DIR="Loon/Rule/keli"
mkdir -p "$OUTPUT_DIR"

FILES=("AI.list" "GoogleVoice.list" "Global.list" "LAN_SPLITTER" "REGION_SPLITTER")
URLS=("https://kelee.one/Tool/Loon/Lsr/AI.lsr" \
      "https://rule.kelee.one/Loon/GoogleVoice.lsr" \
      "https://rule.kelee.one/Loon/Global.lsr" \
      "https://kelee.one/Tool/Loon/Lsr/LAN_SPLITTER" \
      "https://kelee.one/Tool/Loon/Lsr/REGION_SPLITTER")

for (( idx=1; idx<=${#FILES[@]}; idx++ )); do
  FILE="${FILES[$idx]}"
  URL="${URLS[$idx]}"
  OUTPUT="$OUTPUT_DIR/$FILE"

  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -A "$BASE_AGENT" -L --connect-timeout 10 "$URL")
  if [[ "$HTTP_CODE" != "200" ]]; then
    echo "Warning: HTTP code $HTTP_CODE for $FILE. Skipping download."
    continue
  fi

  curl -s -A "$BASE_AGENT" -L --retry 3 --retry-delay 5 --connect-timeout 10 "$URL" -o "$OUTPUT"
  echo "Downloaded $FILE"
done

echo "All downloads finished."
