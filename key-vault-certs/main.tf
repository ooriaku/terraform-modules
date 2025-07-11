resource "azurerm_key_vault_certificate" "certs" {
    
    name         = "${var.certificate_name}"
    key_vault_id = var.key_vault_id

    certificate_policy {
        issuer_parameters {
            name = "Self"
        }

        key_properties {
            exportable = true
            key_size   = 2048
            key_type   = "RSA"
            #reuse_key  = true
            reuse_key  = true
        }

        lifetime_action {
            action {
                action_type = "AutoRenew"
            }

            trigger {
                days_before_expiry = var.days_before_expiry   #30
            }
        }

        secret_properties {
            content_type = "application/x-pkcs12"   #application/x-pkcs12 or application/x-pem-filed
        }


        x509_certificate_properties {
            # Server Authentication = 1.3.6.1.5.5.7.3.1
            # Client Authentication = 1.3.6.1.5.5.7.3.2
            extended_key_usage = ["1.3.6.1.5.5.7.3.1"]
            

            key_usage = [
                "cRLSign",
                "dataEncipherment",
                "digitalSignature",
                "keyAgreement",
                "keyCertSign",
                "keyEncipherment",
            ]

            subject_alternative_names {
                dns_names = var.dns_names
            }
            subject            = "${var.subject}"
            validity_in_months = "${var.validity_in_months}" #12
        }
    }

    
    lifecycle {
        #prevent_destroy = true        
        ignore_changes = [
            certificate,
            certificate_policy[0].x509_certificate_properties[0].validity_in_months        
        ]
    }
}


# resource "null_resource" "script" {
#     provisioner "local-exec" {
#         command = "Add-AzKeyVaultCertificate -VaultName ${var.key_vault_name} -Name ${ azurerm_key_vault_certificate.certs.name } -CertificatePolicy  ${ azurerm_key_vault_certificate.certs.certificate_policy}"
#         interpreter = ["powerShell", "-Command"]
#     }
#     depends_on = [azurerm_key_vault_certificate.certs]
# }

