#!/bin/sh

if [ "`git fetch --dry-run`" != "" ]; then
    echo "need to update"
else
    echo "all up-to-date"
fi
