#!/bin/sh

echo "[Script Prompt] Build all *.c"
gcc -ggdb mepa_mdio-tool_connector.c -o mepa_test
echo "[Script Prompt] Build successful."