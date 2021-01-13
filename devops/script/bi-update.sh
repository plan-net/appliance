#!/bin/bash

touch "/home/$SUDO_USER/.pnbi_salt/.upgrade"
"/home/$SUDO_USER/.pnbi_salt/update-bi.py"
