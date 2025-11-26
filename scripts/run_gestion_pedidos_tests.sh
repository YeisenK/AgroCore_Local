#!/bin/bash
# Test runner script for Gestion Pedidos feature

set -e

echo "════════════════════════════════════════════════════════════"
echo "  Running Gestion Pedidos Test Suite"
echo "════════════════════════════════════════════════════════════"
echo ""

# Run all gestion_pedidos tests
flutter test test/features/gestion_pedidos/

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  Tests Complete!"
echo "════════════════════════════════════════════════════════════"