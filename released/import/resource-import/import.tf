import {
  to = btp_subaccount.my_imported_subaccount
  id = var.subaccount_id
}

import {
  to = btp_subaccount_entitlement.my_imported_entitlement
  id = "${var.subaccount_id},${var.service_name},${var.service_plan_name}"
}
