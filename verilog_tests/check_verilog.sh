#!/bin/sh
# Compile top.v + sbc.v, then run every testbench exported from sbc.dig against sbc.v.
# Usage (from sbc_build):  sh verilog_tests/check_verilog.sh [path/to/sbc.v]
cd "$(dirname "$0")/.." || exit 1
V="${1:-sbc.v}"
echo "== compile top.v + $V"
iverilog -g2005 -Wall -o /tmp/sbc_top top.v "$V" && echo "   OK" || exit 1
for t in verilog_tests/sbc_*_tb.v; do
  iverilog -g2005 -o /tmp/sbc_tb "$V" "$t" || exit 1
  printf "%-40s %s\n" "$(basename "$t" _tb.v)" "$(vvp -n /tmp/sbc_tb | grep -v VCD | head -1)"
done
