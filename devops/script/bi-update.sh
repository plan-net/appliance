#!/bin/bash

touch "/home/$USER/.pnbi_salt/.upgrade"
"/home/$USER/.pnbi_salt/appliance/update-bi.py"
