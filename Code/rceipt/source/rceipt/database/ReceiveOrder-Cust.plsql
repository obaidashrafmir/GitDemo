-----------------------------------------------------------------------------
--
--  Logical unit: ReceiveOrder
--  Component:    RCEIPT
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
@Override
PROCEDURE Create_New_Receipt (
   receipt_rec_ IN OUT Receipt_Rec )
IS
BEGIN
   IF (receipt_rec_.receipt_info.source_ref_type = Logistics_Source_Ref_Type_API.DB_PURCHASE_ORDER) THEN
      DESC_DENIED_PARTY_API.Call_Process_Flow(
         party_id_   => receipt_rec_.receipt_info.sender_id,
         address_id_ => supplier_info_address_api.Get_Default_Address(supplier_id_  => receipt_rec_.receipt_info.sender_id,
                                                            address_type_code_ => 'DELIVERY', -- check with business DELIVERY/INVOICE/VISIT/PAY
                                                            curr_date_         => trunc(sysdate)),
         party_type_ => 'SUPPLIER');
   END IF;
   super(receipt_rec_);
   --Add post-processing code here
END Create_New_Receipt;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
