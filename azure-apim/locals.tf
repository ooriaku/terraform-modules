

locals {
  api_operations = flatten([
    for api in var.apis : [
      for op in api.operations : {
        key          = "${api.name}/${op.operation_id}"
        api_name     = api.name
        operation_id = op.operation_id
        display_name = op.display_name
        method       = op.method
        url_template = op.url_template
        description  = op.description
        policy_xml   = op.policy_xml
      }
    ]
  ])

  product_apis = flatten([
    for p in var.products : [
      for api_name in p.api_names : {
        key        = "${p.product_id}/${api_name}"
        product_id = p.product_id
        api_name   = api_name
      }
    ]
  ])
}

