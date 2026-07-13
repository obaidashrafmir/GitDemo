-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderFlow
--  Component:    ORDER
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
PROCEDURE Release___ (
   order_no_                   IN VARCHAR2,
   sales_promotion_calculated_ IN BOOLEAN,
   discount_calculated_        IN BOOLEAN)
IS
BEGIN
   --Add pre-processing code here
   Desc_Denied_Party_API.Call_Process_flow(
                           party_id_   => Customer_Order_API.Get_Customer_No(order_no_),
                           address_id_ => Customer_Order_API.Get_Ship_Addr_No(order_no_),
                           party_type_ => 'CUSTOMER');
   super(order_no_, sales_promotion_calculated_, discount_calculated_);
   --Add post-processing code here
END Release___;


@Override
PROCEDURE Report_Picking___ (
   order_no_     IN VARCHAR2,
   pick_list_no_ IN VARCHAR2,
   location_no_  IN VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   Desc_Denied_Party_API.Call_Process_flow(
                           party_id_   => Customer_Order_API.Get_Customer_No(order_no_),
                           address_id_ => Customer_Order_API.Get_Ship_Addr_No(order_no_),
                           party_type_ => 'CUSTOMER');
                           
   super(order_no_, pick_list_no_, location_no_);
   --Add post-processing code here
END Report_Picking___;


