#!/bin/bash
su $(id -un 1000) -l -c "env DISPLAY=:0 legion_gui --use_legion_cli_to_write"
