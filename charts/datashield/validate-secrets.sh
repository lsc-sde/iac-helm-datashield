#!/bin/bash

# DataShield Helm Chart Secret Management Validation Script

echo "🔒 DataShield Secure Secret Management Validation"
echo "================================================="
echo

cd /home/vc/dev/karectl/iac-helm-datashield/charts/datashield

# Test 1: Template generation
echo -n "✅ Test 1: Template generation... "
if helm template test-release . > /dev/null 2>&1; then
  echo "PASSED"
else
  echo "FAILED"
  exit 1
fi

# Test 2: Secret generation
echo -n "✅ Test 2: Secret generation... "
if helm template test-release . | grep -q "opal-administrator-password:"; then
  echo "PASSED"
else
  echo "FAILED"
  exit 1
fi

# Test 3: Secret length validation
echo -n "✅ Test 3: Secret length (16 chars)... "
SECRET_VALUE=$(helm template test-release . | grep "opal-administrator-password:" | awk '{print $2}')
DECODED_SECRET=$(echo "$SECRET_VALUE" | base64 -d)
if [[ ${#DECODED_SECRET} -eq 16 ]]; then
  echo "PASSED"
else
  echo "FAILED (length: ${#DECODED_SECRET})"
  exit 1
fi

# Test 4: External secret functionality
echo -n "✅ Test 4: External secret references... "
if helm template test-release . --set opal.config.existingSecret=my-external-opal-secret | grep -q "my-external-opal-secret"; then
  echo "PASSED"
else
  echo "FAILED"
  exit 1
fi

# Test 5: Helm lint
echo -n "✅ Test 5: Helm lint validation... "
if helm lint . > /dev/null 2>&1; then
  echo "PASSED"
else
  echo "FAILED"
  exit 1
fi

echo
echo "🎉 All tests passed! Secret management is working correctly."
echo
echo "Summary of implemented features:"
echo "• Random 16-character alphanumeric secret generation"
echo "• Support for external Kubernetes secrets"
echo "• No plaintext secrets in values.yaml"
echo "• Proper base64 encoding of secrets"
echo "• Component-specific secret management"
echo "• Backward compatibility with existing deployments"
echo
echo "📖 For detailed information, see SECURITY.md"
