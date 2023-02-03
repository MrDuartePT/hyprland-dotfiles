width=-550
state=$(supergfxctl -S)
ans=$(printf "Integrated\nCompute\nHybrid\nDedicated\nVFIO" |wofi --dmenu --width=5 -L 5 --style=$HOME/.config/waybar/modules/wofistyle.css --hide-scroll --location 3 --x $width -p "State: $state")
case $ans in
  Integrated)
    supergfxctl -m integrated
    ;;

  Compute)
    supergfxctl -m compute
    ;;
  Hybrid)
    supergfxctl -m hybrid && swaynag -t warning -m 'Must logout to complete graphics change' -b 'yes, exit sway' 'swaymsg exit'
    ;;
  Dedicated)
    supergfxctl -m dedicated  && swaynag -t warning -m 'Must logout to complete graphics change' -b 'yes, exit sway' 'swaymsg exit'
    ;;
  VFIO)
    supergfxctl -m vfio
    ;;
  *)
    echo $ans
    ;;
esac

echo $ans
