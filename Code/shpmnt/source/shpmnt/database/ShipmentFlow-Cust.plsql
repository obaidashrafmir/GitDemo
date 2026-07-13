-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentFlow
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
------------------------------------------------------------------------------------------
--  Date    Sign       History
------      ------     -------------------------------------------------------------------

------------------------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Deliver_Shipment___ (
   shipment_id_              IN NUMBER,
   deliver_through_cs_       IN VARCHAR2,
   continue_flow_to_deliver_ IN VARCHAR2 )
IS
   
BEGIN
  
   IF (Shipment_API.Get_Receiver_Type_Db(shipment_id_) = 'CUSTOMER') THEN
      Desc_Denied_Party_API.Call_Process_flow(
         party_id_   => Shipment_API.Get_Receiver_Id(shipment_id_),
         address_id_ => Shipment_API.Get_Receiver_Addr_Id(shipment_id_),
         party_type_ => 'CUSTOMER');
   END IF;


   super(shipment_id_, deliver_through_cs_, continue_flow_to_deliver_);
   
   END Deliver_Shipment___;


@Override
PROCEDURE Start_Create_Pick_List__ (
   attr_ IN VARCHAR2 )
IS
        
BEGIN
   
   DECLARE
      pick_shipment_id_ NUMBER := TO_NUMBER(Client_SYS.Get_Item_Value('SHIPMENT_ID', attr_));
   BEGIN
      IF (pick_shipment_id_ IS NOT NULL AND
          Shipment_API.Get_Receiver_Type_Db(pick_shipment_id_) = 'CUSTOMER') THEN
         Desc_Denied_Party_API.Call_Process_flow(
            party_id_   => Shipment_API.Get_Receiver_Id(pick_shipment_id_),
            address_id_ => Shipment_API.Get_Receiver_Addr_Id(pick_shipment_id_),
            party_type_ => 'CUSTOMER');
      END IF;
   END;
  

   super(attr_);
   
END Start_Create_Pick_List__;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
