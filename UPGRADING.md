# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v1.0.0

### Key Changes

- This module now requires a minimum AWS provider version of 6.0 to support the `region` parameter. If you are using multiple AWS provider blocks, please read [migrating from multiple provider configurations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/enhanced-region-support#migrating-from-multiple-provider-configurations).
