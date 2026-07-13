-----------------------------------------------------------------------------
--
--  Logical unit: DescDeniedParty
--  Component:    ENTERP
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
PROCEDURE Call_Process_flow(
   party_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2,
   party_type_ IN VARCHAR2
   )
IS
    
  incld_resp_info_ boolean := sys.diutil.int_to_bool(0);
  in_order_ boolean := sys.diutil.int_to_bool(0);
  fail_notify_ boolean := sys.diutil.int_to_bool(0);
  url_params_ PLSQLAP_DOCUMENT_API.DOCUMENT;
  query_parameters_ PLSQLAP_DOCUMENT_API.DOCUMENT;
  header_params_ PLSQLAP_DOCUMENT_API.DOCUMENT;
  auth_params_ PLSQLAP_DOCUMENT_API.DOCUMENT;
  http_req_headers_ VARCHAR2(2000);
  xml_ CLOB ;
  key_ref_ VARCHAR2(2000);
  name_ VARCHAR2(2000);
  address1_ VARCHAR2(2000);
  address2_ VARCHAR2(2000);
  address3_ VARCHAR2(2000);
  city_     VARCHAR2(2000);
  state_     VARCHAR2(2000);
  zip_code_     VARCHAR2(2000);
  country_     VARCHAR2(2000);
   
  CURSOR get_party_address IS
   SELECT customer_info_api.Get_Name(customer_id) name, address1, address2, address3, city, state, zip_code, country
     FROM Customer_Info_Address
     WHERE customer_id= party_id_
     AND address_id = address_id_
     AND party_type_ = 'CUSTOMER'

   UNION ALL

   SELECT supplier_info_api.Get_Name(supplier_ID) name, address1, address2, address3, city, state, zip_code, country
     FROM Supplier_Info_Address
     WHERE supplier_id= party_id_
     AND address_id = address_id_
     AND party_type_ = 'SUPPLIER';
BEGIN
   
   client_sys.clear_attr(key_ref_);
   client_sys.add_to_attr('PARTY_ID', party_id_, key_ref_);
   client_sys.add_to_attr('ADDRESS_ID', address_id_, key_ref_);
   client_sys.add_to_attr('PARTY_TYPE', party_type_, key_ref_);
   
   OPEN get_party_address;
   FETCH get_party_address INTO name_, address1_, address2_, address3_, city_, state_, zip_code_, country_;
   CLOSE get_party_address;
   
   xml_ := '{"__type":"searchrequest:http://eim.visualcompliance.com/RPSService/2016/11", 
            "sguid":"", 
            "stransid":"", 
            "ssecno":"xxxxxxxxxx", 
            "spassword":"xxxxxxxxxx", 
            "smodes":"", 
            "srpsgroupbypass":"", 
            "searches":[{"__type":"search:http://eim.visualcompliance.com/RPSService/2016/11","soptionalid":"", 
            "sname":"'||name_||'", 
            "scompany":"", 
            "saddress1":"'||address1_||'", 
            "saddress2":"'||address2_||'", 
            "saddress3":"'||address3_||'", 
            "scity":"'||city_||'", 
            "sstate":"'||state_||'", 
            "szip":"'||zip_code_||'", 
            "scountry":"'||country_||'", 
            "selective1":"", 
            "selective2":"", 
            "selective3":"", 
            "selective4":"", 
            "selective5":"", 
            "selective6":"", 
            "selective7":"", 
            "selective8":""}]}';
         
   http_req_headers_ := 'Accept-Encoding:gzip,
                           Content-Type:application/json,
                           Accept:application/json, 
                           Host:rps.visualcompliance.com,
                           User-Agent:Apache-HttpClient/4.1.1 (java 1.5)';
 
    Plsql_Rest_Sender_API.Call_Rest_EndPoint2(rest_service_ => 'DEMOSERVICE',
                                            xml_ => xml_,
                                            url_params_ => url_params_,
                                            callback_func_ => 'desc_denied_party_api.process_flow_response',
                                            http_method_ => 'POST',
                                            http_req_headers_ => http_req_headers_,
                                            query_parameters_ => query_parameters_,
                                            header_params_ => header_params_,
                                            incld_resp_info_ => incld_resp_info_,
                                            fnd_user_ => fnd_session_api.get_fnd_user,
                                            key_ref_ => key_ref_,
                                            sender_ => 'IFS',
                                            receiver_ => 'DEMORECEIVER',
                                            message_type_ => '',
                                            subject_ => '',
                                            in_order_ => in_order_,
                                            fail_notify_ => fail_notify_,
                                            failed_callback_fun_ => '',
                                            accepted_res_codes_ => '',
                                            auth_params_ => auth_params_);
                                           
   
END;

PROCEDURE process_flow_response(
   msg_ IN CLOB, 
   app_msg_id_  IN VARCHAR2 , 
   key_ref_     IN VARCHAR2,
   fnd_user_    IN VARCHAR2
   )
IS
  alert_type_ VARCHAR2(200);
  notes_ VARCHAR2(2000);
  party_type_ VARCHAR2(200);
  party_id_ VARCHAR2(200);
  address_id_ VARCHAR2(200);
  
  CURSOR get_alert_and_note IS 
   SELECT jt.alerttype, jt.notes
   FROM JSON_TABLE(
            msg_,
            '$.searches[*]'
            COLUMNS (
                sname    VARCHAR2(100) PATH '$.sname',
                scompany VARCHAR2(100) PATH '$.scompany',
                NESTED PATH '$.results[*]' COLUMNS (
                    alerttype VARCHAR2(100) PATH '$.alerttype',
                    notes VARCHAR2(1000) PATH '$.notes'
                )
            )
        ) jt;
  
BEGIN
  
  OPEN get_alert_and_note;
  FETCH get_alert_and_note INTO alert_type_, notes_;
  CLOSE  get_alert_and_note;
  
  party_id_ := client_sys.get_item_value('PARTY_ID', key_ref_);
  party_type_ := client_sys.get_item_value('PARTY_TYPE', key_ref_);
  address_id_ := client_sys.get_item_value('ADDRESS_ID', key_ref_);
  
   IF nvl(alert_type_,'TR') IN ('Y','R','DR','TR') THEN
      IF party_type_ = 'CUSTOMER' THEN
         Disable_Customer (party_id_ ,
                           address_id_  ,
                           notes_         ,
                           'INPROCESS'   ,
                           alert_type_       );
      ELSIF party_type_ = 'SUPPLIER' THEN
         Disable_Supplier (party_id_ ,
                           address_id_  ,
                           notes_        ,
                           'INPROCESS'   ,
                           alert_type_      );
      END IF;
   ELSE
      IF party_type_ = 'CUSTOMER' AND Is_Currently_Denied (party_id_, party_type_) THEN
        Enable_Customer(party_id_,
                        address_id_ ,
                        notes_,
                        'INPROCESS',
                        alert_type_); 
      
      ELSIF party_type_ = 'SUPPLIER' AND Is_Currently_Denied (party_id_, party_type_) THEN
         Enable_Supplier (party_id_ ,
                          address_id_  ,
                          notes_         ,
                          'INPROCESS'  ,
                          alert_type_ ); 
      END IF;
      
   END IF;

  
END;

PROCEDURE Call_Background_Job
IS
   CURSOR get_party_to_screen IS
      SELECT c.customer_id party_id,
             c.NAME party_name,
             cad.address_id, cad.address1, cad.address2, cad.address3, cad.city, cad.country, cad.zip_code, 'CUSTOMER' party_type
        FROM customer_info_tab c
        LEFT JOIN customer_info_address cad
        ON c.customer_id   = cad.customer_id
        AND TRUNC(SYSDATE) BETWEEN NVL(cad.valid_from, (SYSDATE -1)) AND NVL(cad.valid_to , (SYSDATE +1))
       WHERE c.customer_id NOT IN (
               SELECT h.party_id
                 FROM desc_denied_party_hist_tab h
                WHERE h.party_type = 'CUSTOMER'
                   AND NVL(h.compliance_check_date,(SYSDATE-60)) >= ADD_MONTHS(SYSDATE, -1))
         
UNION ALL

   SELECT s.supplier_id party_id,
             s.NAME party_name,
             sad.address_id, sad.address1, sad.address2, sad.address3, sad.city, sad.country, sad.zip_code, 'SUPPLIER' party_type
        FROM supplier_info_tab s
        LEFT JOIN Supplier_info_address sad
        ON s.supplier_id  = sad.supplier_id 
        AND TRUNC(SYSDATE) BETWEEN NVL(sad.valid_from, (SYSDATE -1)) AND NVL(sad.valid_to , (SYSDATE +1))
       WHERE s.supplier_id NOT IN (
               SELECT h.party_id
                 FROM desc_denied_party_hist_tab h
                WHERE h.party_type = 'SUPPLIER'
                   AND NVL(h.compliance_check_date,(SYSDATE-60)) >= ADD_MONTHS(SYSDATE, -1));
BEGIN
   
   FOR rec_ IN get_party_to_screen loop
      Call_Process_flow(
      rec_.party_id,
      rec_.address_id,
      rec_.party_type);
   END LOOP;
   
END;

PROCEDURE Disable_Customer (
   customer_no_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   msg_         IN VARCHAR2,
   call_type_   IN VARCHAR2,
   alert_       IN VARCHAR2)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   attr1_      VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   
   CURSOR get_cust_ord_customer IS
   SELECT objid, objversion 
   FROM cust_ord_customer
   WHERE customer_no = customer_no_;
   
   CURSOR get_Customer_Info_Address IS
   SELECT objid, objversion 
   FROM Customer_Info_Address
   WHERE customer_id = customer_no_;
   
   CURSOR get_Identity_Invoice_Info IS
   SELECT objid, objversion 
   FROM Identity_Invoice_Info
   WHERE customer_id = customer_no_;
BEGIN
   -- Sales/Customer area: set expire date so new orders cannot be created
   BEGIN
      OPEN get_cust_ord_customer;
      FETCH get_cust_ord_customer INTO objid_, objversion_;
      CLOSE get_cust_ord_customer;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('DATE_DEL', TRUNC(SYSDATE), attr_);
    
      Cust_Ord_Customer_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
  
   END;

   -- Address: set valid_to so address is no longer valid
   IF address_id_ IS NOT NULL THEN
      BEGIN
         OPEN get_Customer_Info_Address;
         FETCH get_Customer_Info_Address INTO objid_, objversion_;
         CLOSE get_Customer_Info_Address;
         
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('VALID_TO', TRUNC(SYSDATE), attr_);
         
         Customer_Info_Address_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
     
      END;
   END IF;

   -- Invoice area: set inactive date
   BEGIN
      OPEN get_Identity_Invoice_Info;
      FETCH get_Identity_Invoice_Info INTO objid_, objversion_;
      CLOSE get_Identity_Invoice_Info;
         
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('EXPIRE_DATE', TRUNC(SYSDATE), attr_);
    
      Identity_Invoice_Info_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   
   END;

   -- Insert/update IFS Denied Party - Customer record
   BEGIN
      client_sys.clear_attr(attr_);
      client_sys.add_to_attr('CUSTOMER_ID',customer_no_,attr_);
      client_sys.add_to_attr('ADDRESS_ID',address_id_,attr_);
      client_sys.add_to_attr('COUNTRY_CODE',customer_info_api.Get_Country_db(customer_no_),attr_);
      client_sys.add_to_attr('ORDER_COUNTRY',customer_info_api.Get_Country_db(customer_no_),attr_);
      client_sys.add_to_attr('NOTE',msg_,attr_);
      
      attr1_ := attr_;
      License_Denied_Customer_API.New__(info_, objid_, objversion_, attr_, 'DO');
      License_Denied_Country_API.New__(info_, objid_, objversion_, attr1_, 'DO');
  
   END;
   
   BEGIN
      Desc_Denied_Party_Hist_API.Insert_Log_Record(customer_no_, 'CUSTOMER',address_id_,customer_info_api.Get_Country_db(customer_no_),call_type_,alert_,'TRUE',TRUNC(SYSDATE));
   END;
END Disable_Customer;


PROCEDURE Enable_Customer (
   customer_no_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   msg_         IN VARCHAR2,
   call_type_   IN VARCHAR2 ,
   alert_       IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   
   CURSOR get_cust_ord_customer IS
   SELECT objid, objversion 
   FROM cust_ord_customer
   WHERE customer_no = customer_no_;
   
   CURSOR get_Customer_Info_Address IS
   SELECT objid, objversion 
   FROM Customer_Info_Address
   WHERE customer_id = customer_no_;
   
   CURSOR get_Identity_Invoice_Info IS
   SELECT objid, objversion 
   FROM Identity_Invoice_Info
   WHERE customer_id = customer_no_;
BEGIN
   -- Clear expire date
   BEGIN
      OPEN get_cust_ord_customer;
      FETCH get_cust_ord_customer INTO objid_, objversion_;
      CLOSE get_cust_ord_customer;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('DATE_DEL', TO_DATE(NULL), attr_);
      
      Cust_Ord_Customer_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   
   END;

   -- Clear address valid_to
   IF address_id_ IS NOT NULL THEN
      BEGIN
         OPEN get_Customer_Info_Address;
         FETCH get_Customer_Info_Address INTO objid_, objversion_;
         CLOSE get_Customer_Info_Address;
         
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('VALID_TO', TO_DATE(NULL), attr_);
        
         Customer_Info_Address_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
      
      END;
   END IF;

   -- Clear inactive date
   BEGIN
      OPEN get_Identity_Invoice_Info;
      FETCH get_Identity_Invoice_Info INTO objid_, objversion_;
      CLOSE get_Identity_Invoice_Info;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('EXPIRE_DATE', TO_DATE(NULL), attr_);
     
      Identity_Invoice_Info_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   
   END;
   
   BEGIN
      Desc_Denied_Party_Hist_API.Insert_Log_Record(customer_no_, 'CUSTOMER',address_id_,customer_info_api.Get_Country_db(customer_no_),call_type_,alert_,'FALSE',TO_DATE(NULL),TRUNC(SYSDATE));
   END;
END Enable_Customer;

PROCEDURE Disable_Supplier (
   supplier_no_ IN VARCHAR2 ,
   address_id_  IN VARCHAR2,
   msg_         IN VARCHAR2,
   call_type_   IN VARCHAR2,
   alert_       IN VARCHAR2)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_purchase_parts IS
      SELECT vendor_no, part_no, contract, objid, objversion
        FROM purchase_part_supplier
       WHERE vendor_no = supplier_no_
         AND NVL(status_code_db,'1') = '2';
         
   CURSOR get_Supplier IS
          SELECT objid, objversion
          FROM Supplier
          WHERE vendor_no = supplier_no_;
   
   CURSOR get_identity_invoice_info IS
          SELECT objid, objversion 
          FROM IDENTITY_INVOICE_INFO
          WHERE supplier_id = supplier_no_;       
          
BEGIN
   -- Purchase/General: set expiration date
   BEGIN
     
      OPEN get_Supplier;
      FETCH get_Supplier INTO objid_, objversion_;
      CLOSE get_Supplier;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('DATE_DEL', TRUNC(SYSDATE), attr_);
      
      Supplier_Api.Modify__(info_, objid_, objversion_, attr_, 'DO');
   
   END;

   -- Invoice/General: set inactive date
   BEGIN
      OPEN get_identity_invoice_info;
      FETCH get_identity_invoice_info INTO objid_, objversion_;
      CLOSE get_identity_invoice_info;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('EXPIRE_DATE', TRUNC(SYSDATE), attr_);
      
      Identity_Invoice_Info_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   
   END;

   -- Purchase parts: set header flag to NOT Active
   FOR rec_ IN get_purchase_parts LOOP
      BEGIN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('STATUS_CODE_DB', '1', attr_);
         
         objid_      := rec_.objid;
         objversion_ := rec_.objversion;
         
         Purchase_Part_Supplier_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
      
      END;
   END LOOP;

   -- Insert/update IFS Denied Party - Supplier record
   BEGIN
     objid_ := '';
     objversion_ := '';
      client_sys.clear_attr(attr_);
      client_sys.add_to_attr('SUPPLIER_ID',supplier_no_,attr_);
      client_sys.add_to_attr('ADDRESS_ID',address_id_,attr_);
      client_sys.add_to_attr('COUNTRY_CODE',supplier_info_api.Get_Country_db(supplier_no_),attr_);
      client_sys.add_to_attr('ORDER_COUNTRY',supplier_info_api.Get_Country_db(supplier_no_),attr_);
      client_sys.add_to_attr('NOTE',msg_,attr_);
      
      License_Denied_Supplier_Api.New__(info_, objid_, objversion_, attr_, 'DO');
   
   END;
   
   BEGIN
      Desc_Denied_Party_Hist_API.Insert_Log_Record(supplier_no_, 'SUPPLIER',address_id_,supplier_info_api.Get_Country_db(supplier_no_),call_type_,alert_,'TRUE',TRUNC(SYSDATE));
   END;
END Disable_Supplier;

PROCEDURE Enable_Supplier (
   supplier_no_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   msg_         IN VARCHAR2,
   call_type_   IN VARCHAR2,
   alert_       IN VARCHAR2)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_purchase_parts IS
      SELECT vendor_no, part_no, contract, objid, objversion
        FROM purchase_part_supplier
       WHERE vendor_no = supplier_no_
         AND NVL(status_code_db,'1') = '1';
         
   CURSOR get_Supplier IS
          SELECT objid, objversion
          FROM Supplier
          WHERE vendor_no = supplier_no_;
   
   CURSOR get_identity_invoice_info IS
          SELECT objid, objversion 
          FROM IDENTITY_INVOICE_INFO
          WHERE supplier_id = supplier_no_; 
BEGIN
   -- Purchase/General: set expiration date
   BEGIN
     
      OPEN get_Supplier;
      FETCH get_Supplier INTO objid_, objversion_;
      CLOSE get_Supplier;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('DATE_DEL', TO_DATE(NULL), attr_);
      
      Supplier_Api.Modify__(info_, objid_, objversion_, attr_, 'DO');
   
   END;

   -- Invoice/General: set inactive date
   BEGIN
      OPEN get_identity_invoice_info;
      FETCH get_identity_invoice_info INTO objid_, objversion_;
      CLOSE get_identity_invoice_info;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('EXPIRE_DATE', TO_DATE(NULL), attr_);
      
      Identity_Invoice_Info_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   
   END;

   -- Purchase parts: set header flag to NOT Active
   FOR rec_ IN get_purchase_parts LOOP
      BEGIN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('STATUS_CODE_DB', '2', attr_);
         
         objid_      := rec_.objid;
         objversion_ := rec_.objversion;
         
         Purchase_Part_Supplier_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
      
      END;
   END LOOP;
   
   BEGIN
      Desc_Denied_Party_Hist_API.Insert_Log_Record(supplier_no_, 'SUPPLIER',address_id_,supplier_info_api.Get_Country_db(supplier_no_),call_type_,alert_,'FALSE',TO_DATE(NULL),TRUNC(SYSDATE));
   END;
END Enable_Supplier;

FUNCTION Is_Currently_Denied (
   party_id_   IN VARCHAR2,
   party_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   cnt_ NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO cnt_
     FROM desc_denied_party_hist_tab
    WHERE party_id   = party_id_
      AND party_type = party_type_
      AND denied     = 'TRUE'
      AND compliance_check_date = (
            SELECT MAX(h2.compliance_check_date)
              FROM desc_denied_party_hist_tab h2
             WHERE h2.party_id   = party_id_
               AND h2.party_type = party_type_);
   RETURN cnt_ > 0;
END Is_Currently_Denied;