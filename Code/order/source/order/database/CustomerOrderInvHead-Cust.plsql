-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderInvHead
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
PROCEDURE Create_Invoice_Head (
   invoice_id_                  IN OUT NUMBER,
   company_                     IN     VARCHAR2,
   order_no_                    IN     VARCHAR2,
   customer_no_                 IN     VARCHAR2,
   customer_no_pay_             IN     VARCHAR2,
   authorize_name_              IN     VARCHAR2,
   date_entered_                IN     DATE,
   cust_ref_                    IN     VARCHAR2,
   ship_via_desc_               IN     VARCHAR2,
   forward_agent_id_            IN     VARCHAR2,
   label_note_                  IN     VARCHAR2,
   delivery_terms_desc_         IN     VARCHAR2,
   del_terms_location_          IN     VARCHAR2,
   pay_term_id_                 IN     VARCHAR2,
   currency_code_               IN     VARCHAR2,
   ship_addr_no_                IN     VARCHAR2,
   customer_no_pay_addr_no_     IN     VARCHAR2,
   bill_addr_no_                IN     VARCHAR2,
   wanted_delivery_date_        IN     DATE,
   invoice_type_                IN     VARCHAR2,
   number_reference_            IN     VARCHAR2,
   series_reference_            IN     VARCHAR2,
   contract_                    IN     VARCHAR2,
   js_invoice_state_db_         IN     VARCHAR2,
   currency_rate_type_          IN     VARCHAR2,
   collect_                     IN     VARCHAR2     DEFAULT 'FALSE',
   rma_no_                      IN     NUMBER       DEFAULT  NULL,
   shipment_id_                 IN     NUMBER       DEFAULT  NULL,
   adv_invoice_                 IN     VARCHAR2     DEFAULT  NULL,
   adv_pay_base_date_           IN     DATE         DEFAULT  NULL,
   sb_reference_no_             IN     VARCHAR2     DEFAULT  NULL,
   use_ref_inv_curr_rate_       IN     VARCHAR2     DEFAULT 'FALSE',
   ledger_item_id_              IN     VARCHAR2     DEFAULT  NULL,
   ledger_item_series_id_       IN     VARCHAR2     DEFAULT  NULL,
   ledger_item_version_id_      IN     NUMBER       DEFAULT  NULL,
   aggregation_no_              IN     NUMBER       DEFAULT  NULL,   
   final_settlement_            IN     VARCHAR2     DEFAULT 'FALSE',
   project_id_                  IN     VARCHAR2     DEFAULT  NULL,
   tax_id_number_               IN     VARCHAR2     DEFAULT  NULL,
   tax_id_type_                 IN     VARCHAR2     DEFAULT  NULL,
   branch_                      IN     VARCHAR2     DEFAULT  NULL,
   supply_country_db_           IN     VARCHAR2     DEFAULT  NULL,
   invoice_date_                IN     DATE         DEFAULT  NULL,
   use_price_incl_tax_db_       IN     VARCHAR2     DEFAULT 'FALSE',
   wht_amount_base_             IN     VARCHAR2     DEFAULT  NULL, 
   curr_rate_new_               IN     NUMBER       DEFAULT  NULL,
   tax_curr_rate_new_           IN     NUMBER       DEFAULT  NULL,
   correction_reason_id_        IN     VARCHAR2     DEFAULT  NULL,
   correction_reason_           IN     VARCHAR2     DEFAULT  NULL,
   is_simulated_                IN     VARCHAR2     DEFAULT 'FALSE',
   invoice_reason_id_           IN     VARCHAR2     DEFAULT  NULL,
   service_code_                IN     VARCHAR2     DEFAULT  NULL,
   prepay_adv_inv_id_           IN     NUMBER       DEFAULT  NULL,
   prepayment_type_code_        IN     VARCHAR2     DEFAULT  NULL,
   related_uuid_number_         IN     VARCHAR2     DEFAULT  NULL,
   invoice_tax_id_number_       IN     VARCHAR2     DEFAULT  NULL,
   delivery_tax_id_number_      IN     VARCHAR2     DEFAULT  NULL,
   use_delivery_inv_address_db_ IN     VARCHAR2     DEFAULT 'FALSE',
   national_bank_code_          IN     VARCHAR2     DEFAULT  NULL,
   nature_of_business_          IN     VARCHAR2     DEFAULT  NULL,
   supply_type_code_            IN     VARCHAR2     DEFAULT  NULL,
   component_a_                 IN     VARCHAR2     DEFAULT  NULL,
   component_b_                 IN     VARCHAR2     DEFAULT  NULL,
   component_c_                 IN     VARCHAR2     DEFAULT  NULL,
   sequence_number_             IN     VARCHAR2     DEFAULT  NULL,
   customs_declaration_no_      IN     VARCHAR2     DEFAULT  NULL,
   customs_declaration_date_    IN     DATE         DEFAULT  NULL,
   document_type_code_          IN     VARCHAR2     DEFAULT  NULL,
   tax_exemption_reason_        IN     VARCHAR2     DEFAULT  NULL,
   refund_note_db_              IN     VARCHAR2     DEFAULT  'FALSE',
   due_date_                    IN     DATE         DEFAULT  NULL )
IS
BEGIN
   --Add pre-processing code here
   Desc_Denied_Party_API.Call_Process_flow(
                           party_id_   => customer_no_,
                           address_id_ => ship_addr_no_,
                           party_type_ => 'CUSTOMER');
                           
   super(invoice_id_, company_, order_no_, customer_no_, customer_no_pay_, authorize_name_, date_entered_, cust_ref_, ship_via_desc_, forward_agent_id_, label_note_, delivery_terms_desc_, del_terms_location_, pay_term_id_, currency_code_, ship_addr_no_, customer_no_pay_addr_no_, bill_addr_no_, wanted_delivery_date_, invoice_type_, number_reference_, series_reference_, contract_, js_invoice_state_db_, currency_rate_type_, collect_, rma_no_, shipment_id_, adv_invoice_, adv_pay_base_date_, sb_reference_no_, use_ref_inv_curr_rate_, ledger_item_id_, ledger_item_series_id_, ledger_item_version_id_, aggregation_no_, final_settlement_, project_id_, tax_id_number_, tax_id_type_, branch_, supply_country_db_, invoice_date_, use_price_incl_tax_db_, wht_amount_base_, curr_rate_new_, tax_curr_rate_new_, correction_reason_id_, correction_reason_, is_simulated_, invoice_reason_id_, service_code_, prepay_adv_inv_id_, prepayment_type_code_, related_uuid_number_, invoice_tax_id_number_, delivery_tax_id_number_, use_delivery_inv_address_db_, national_bank_code_, nature_of_business_, supply_type_code_, component_a_, component_b_, component_c_, sequence_number_, customs_declaration_no_, customs_declaration_date_, document_type_code_, tax_exemption_reason_, refund_note_db_, due_date_);
   --Add post-processing code here
END Create_Invoice_Head;



