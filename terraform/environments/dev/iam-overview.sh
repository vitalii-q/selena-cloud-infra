#!/bin/bash

echo "===== CUSTOMER-MANAGED IAM ROLES WITH POLICIES ====="

for role in $(aws iam list-roles \
  --query 'Roles[?starts_with(RoleName, `AWSServiceRoleFor`) == `false`].RoleName' \
  --output text); do

  policies=$(aws iam list-attached-role-policies \
    --role-name "$role" \
    --query 'AttachedPolicies[].PolicyName' \
    --output text)

  if [ -n "$policies" ]; then
    echo
    echo "Role: $role"
    echo "  Policies:"
    for p in $policies; do
      echo "    - $p"
    done
  fi
done
