mode="$(supergfxctl -g)"
state="$(supergfxctl -S)"
echo "{\"text\":\"$mode\", \"tooltip\":\"$state\"}"
exit 0
