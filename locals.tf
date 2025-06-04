locals {
  subscriptions = {
    for s in data.azurerm_subscriptions.available.subscriptions :
    s.display_name => s.subscription_id
  }
}