-----------------------------------------------------------------------------
--
--  Logical unit: DescDeniedPartyHist
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
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('LOG_ID',    DESC_DENIED_PARTY_HIST_SEQ.NEXTVAL, attr_);
   Client_SYS.Add_To_Attr('DENIED',    'FALSE',                             attr_);
   Client_SYS.Add_To_Attr('CALL_TYPE',    'EDITED',                             attr_);
END Prepare_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DESC_DENIED_PARTY_HIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.log_id IS NULL THEN
      newrec_.log_id := DESC_DENIED_PARTY_HIST_SEQ.NEXTVAL;
   END IF;
   IF newrec_.end_user IS NULL THEN
      newrec_.end_user := Fnd_Session_API.Get_Fnd_User;
   END IF;
   IF newrec_.call_type IS NULL THEN
      newrec_.call_type := 'EDITED';
   END IF;
   IF newrec_.compliance_check_date IS NULL THEN
      newrec_.compliance_check_date := trunc(sysdate);
   END IF;
   
   
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
PROCEDURE Insert_Log_Record (
   party_id_             IN VARCHAR2,
   party_type_           IN VARCHAR2,
   address_id_           IN VARCHAR2,
   country_id_           IN VARCHAR2,
   call_type_            IN VARCHAR2,
   alert_                IN VARCHAR2,
   denied_               IN VARCHAR2,
   date_deactivated_     IN DATE     DEFAULT NULL,
   date_activated_       IN DATE     DEFAULT NULL )
IS
   newrec_      DESC_DENIED_PARTY_HIST_TAB%ROWTYPE;
BEGIN
   --newrec_.log_id                := DESC_DENIED_PARTY_HIST_SEQ.NEXTVAL;
   newrec_.party_id              := party_id_;
   newrec_.party_type            := party_type_;
   newrec_.address_id            := address_id_;
   newrec_.country_id            := country_id_;
   newrec_.call_type             := call_type_;
   newrec_.compliance_check_date := SYSDATE;
   newrec_.alert                 := alert_;
   newrec_.denied                := NVL(denied_, 'FALSE');
   newrec_.date_deactivated      := date_deactivated_;
   newrec_.date_activated        := date_activated_;
   newrec_.end_user              := Fnd_Session_API.Get_Fnd_User;
   New___(newrec_);
END Insert_Log_Record;