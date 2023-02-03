# ~/.zprofile
Integrated_mode=$(lspci | grep 'Radeon Vega Series')
if [ "$(tty)" = "/dev/tty1" ]; then 
    if [ $Integrated_mode ]; then
        exec hyp
    else
        exec hyp-nvidia
    fi
fi