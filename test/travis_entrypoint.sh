#! /bin/sh

echo "Analyzing Flutter ..."
"./flutter/bin/flutter" analyze
"./flutter/bin/flutter" format -n --set-exit-if-changed .

echo "Running Test ..."
"./flutter/bin/flutter" test