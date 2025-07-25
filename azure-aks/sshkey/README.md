# Secure Socket Shell (SSH) Module 


## Summary

Secure Socket Shell Module which has the type of Algorithm used for the generation of the  key's  (public and private) and its bits, also the location where the key resides locally

## Inputs


| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `public_ssh_key` | An ssh key set in the main variables of the terraform-azurerm-aks module to connect to the AKS cluster securely  | `none` | `none` | yes |

### Outputs

| Name | Description |
|------|-------------|
| `public_ssh_key` | output's the value of a generated ssh public key  |
