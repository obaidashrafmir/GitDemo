-----------------------------------------------------------------------------
--
--  Logical unit: PurchaseOrder
--  Component:    PURCH
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
@Override
PROCEDURE Release (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   Desc_Denied_Party_API.Call_Process_flow(
                           party_id_   => Purchase_Order_API.Get_Vendor_No(order_no_),
                           address_id_ => supplier_info_address_api.Get_Default_Address(supplier_id_  => Purchase_Order_API.Get_Vendor_No(order_no_),
                                                            address_type_code_ => 'DELIVERY', -- check with business DELIVERY/INVOICE/VISIT/PAY
                                                            curr_date_         => trunc(sysdate)),
                           party_type_ => 'CUSTOMER');
   super(order_no_);
   --Add post-processing code here
END Release;


