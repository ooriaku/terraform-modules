# Azure Event-Hub  Module

## Summary 

Event Hubs can process and store events, data, or telemetry produced by distributed software and devices

## Inputs


| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of Event Hub Namespace  | `none` | `none` | yes |
| `location` | Region where the Azure resources are  deploy into  | `none` | `none` | yes |
| `resource_group_name` |Resource group name for the deployed resource in Azure| `none` | `none` | yes |
| `tags` | A list of tags to be applied   | `map(any)` | `empty` | yes |
| `sku` | tags used to  identitfy the event hub in Azurerm   | `none` | `Standard` | yes |
| `capacity` | Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20   | `number` | `1` | yes |
| `auto_inflate` | Is Auto Inflate enabled for the EventHub Namespace, and what is maximum throughput?   | `object({})` | `null` | yes |
| `authorization_rules` | Authorization rules to add to the namespace. For hub use `hubs` variable to add authorization keys   | `list(object({})` | `empty` | yes |
| `hubs` | A list of event hubs to add to namespace   | `list(object({})` | `empty` | yes |



## Outputs


| Name | Description | 
|------|-------------|
| `namespace_id` | Display Id of Event Hub Namespace  |
| `hub_ids` | Display Map of hubs and their ids  |
| `keys` | Map of hubs with keys => primary_key / secondary_key mapping |