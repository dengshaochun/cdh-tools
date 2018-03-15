#! /usr/bin/env bash

if [[  -f /sys/kernel/mm/redhat_transparent_hugepage/enabled ]]; then
    echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
    echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
elif [[ -f /sys/kernel/mm/transparent_hugepage/enabled ]]; then
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
    echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi

echo "ok=true  changed=true name='dengsc'" 
