terraform {
    required_version = ">=1.9.0, < 2.0.0" 
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"           
            #version = "~>4.0"
            version = "~>3.0"
        }
        random = {
            source  = "hashicorp/random"
            version = ">= 3.5.0, < 4.0.0"
        }  
        helm = {
            source  = "hashicorp/helm"
            version = "~> 2.0"
        }     
    }
}

provider "azurerm" {    
    features {}     
} 

