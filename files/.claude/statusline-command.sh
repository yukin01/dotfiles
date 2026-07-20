#!/bin/bash
# Statusline: model name + Claude Code context usage + Claude.ai rate limits (5h / 7d).
# Replaces the previous `user@host:path` (PS1-derived) statusline per user request.
# Truecolor (Dracula-inspired) palette: model name in bold purple, usage bars
# colored green/yellow/red by severity, labels/separators/reset-time dimmed gray.
# Docs: https://code.claude.com/docs/ja/statusline

input=$(cat)

get() { printf '%s' "$input" | jq -r "$1 // empty"; }

model_name=$(get '.model.display_name')
ctx_used=$(get '.context_window.used_percentage')
five_pct=$(get '.rate_limits.five_hour.used_percentage')
five_reset=$(get '.rate_limits.five_hour.resets_at')
week_pct=$(get '.rate_limits.seven_day.used_percentage')
week_reset=$(get '.rate_limits.seven_day.resets_at')

BAR_WIDTH=6

# Dracula palette (truecolor R;G;B).
PURPLE='189;147;249'   # model name
GREEN='80;250;123'     # normal usage (<70%)
YELLOW='241;250;140'   # warning (>=70%)
RED='255;85;85'        # critical (>=90%)
GRAY='98;114;164'      # labels / separators / reset time ("comment")
DIM='68;71;90'         # empty bar cells ("current line")
RESET=$'\033[00m'

fg() { printf '\033[38;2;%sm' "$1"; }

# Severity color (R;G;B) for a 0-100 percentage.
color_for() {
  awk -v p="$1" -v g="$GREEN" -v y="$YELLOW" -v r="$RED" \
    'BEGIN{ if (p+0>=90) print r; else if (p+0>=70) print y; else print g }'
}

# Number of filled bar cells (0..BAR_WIDTH) for a 0-100 percentage.
count_filled() {
  awk -v p="$1" -v w="$BAR_WIDTH" 'BEGIN{ if (p+0<0) p=0; if (p+0>100) p=100; print int(p/100*w+0.5) }'
}

repeat_char() {
  local char="$1" n="$2" out="" i
  for ((i = 0; i < n; i++)); do out+="$char"; done
  printf '%s' "$out"
}

# Two-tone block bar: filled cells in severity color, empty cells dimmed gray.
make_bar() {
  local pct="$1" sev="$2" filled empty
  filled=$(count_filled "$pct")
  empty=$(( BAR_WIDTH - filled ))
  printf '%s%s%s%s%s' \
    "$(fg "$sev")" "$(repeat_char '▓' "$filled")" \
    "$(fg "$DIM")" "$(repeat_char '░' "$empty")" \
    "$RESET"
}

# Format seconds-until-reset (unix epoch) as:
#   >=24h  -> "DdHHhMMm" (e.g. 118h05m -> 4d22h05m)
#   1-24h  -> "HhMMm"    (e.g. 3h42m)
#   <1h    -> "Mm"       (e.g. 42m)
# Empty if unavailable.
fmt_reset() {
  local epoch="$1" now diff total_h d h m
  [ -z "$epoch" ] && return
  epoch="${epoch%%.*}"
  now=$(date +%s)
  diff=$(( epoch - now ))
  [ "$diff" -lt 0 ] && diff=0
  m=$(( (diff % 3600) / 60 ))
  total_h=$(( diff / 3600 ))
  if [ "$total_h" -ge 24 ]; then
    d=$(( total_h / 24 ))
    h=$(( total_h % 24 ))
    printf '%dd%02dh%02dm' "$d" "$h" "$m"
  elif [ "$total_h" -ge 1 ]; then
    printf '%dh%02dm' "$total_h" "$m"
  else
    printf '%dm' "$m"
  fi
}

segments=()

if [ -n "$model_name" ]; then
  segments+=("$(printf '\033[1m%s%s%s' "$(fg "$PURPLE")" "$model_name" "$RESET")")
fi

if [ -n "$ctx_used" ]; then
  sev=$(color_for "$ctx_used")
  bar=$(make_bar "$ctx_used" "$sev")
  segments+=("$(printf '%sCtx %s%s %s%.0f%%%s' \
    "$(fg "$GRAY")" "$RESET" "$bar" "$(fg "$sev")" "$ctx_used" "$RESET")")
fi

if [ -n "$five_pct" ]; then
  sev=$(color_for "$five_pct")
  bar=$(make_bar "$five_pct" "$sev")
  r=$(fmt_reset "$five_reset")
  if [ -n "$r" ]; then
    segments+=("$(printf '%s5h %s%s %s%.0f%%%s %s(%s)%s' \
      "$(fg "$GRAY")" "$RESET" "$bar" "$(fg "$sev")" "$five_pct" "$RESET" "$(fg "$GRAY")" "$r" "$RESET")")
  else
    segments+=("$(printf '%s5h %s%s %s%.0f%%%s' \
      "$(fg "$GRAY")" "$RESET" "$bar" "$(fg "$sev")" "$five_pct" "$RESET")")
  fi
fi

if [ -n "$week_pct" ]; then
  sev=$(color_for "$week_pct")
  bar=$(make_bar "$week_pct" "$sev")
  r=$(fmt_reset "$week_reset")
  if [ -n "$r" ]; then
    segments+=("$(printf '%s7d %s%s %s%.0f%%%s %s(%s)%s' \
      "$(fg "$GRAY")" "$RESET" "$bar" "$(fg "$sev")" "$week_pct" "$RESET" "$(fg "$GRAY")" "$r" "$RESET")")
  else
    segments+=("$(printf '%s7d %s%s %s%.0f%%%s' \
      "$(fg "$GRAY")" "$RESET" "$bar" "$(fg "$sev")" "$week_pct" "$RESET")")
  fi
fi

if [ ${#segments[@]} -eq 0 ]; then
  printf '%sCC usage: n/a%s' "$(fg "$GRAY")" "$RESET"
  exit 0
fi

sep="$(fg "$GRAY") | ${RESET}"
joined=""
for seg in "${segments[@]}"; do
  if [ -z "$joined" ]; then
    joined="$seg"
  else
    joined="$joined$sep$seg"
  fi
done
printf '%s' "$joined"
