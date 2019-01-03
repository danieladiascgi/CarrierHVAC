public class DSMNonCaseSearchExtLinkController {

    Public Case objCase{get;set;}
    public Contact objContact{get; set;}
    public List<DSM_Distributor_Directory__c> listAllDistNames{get; set;}
    public List<DSM_Distributor_Directory__c> listAllDistCarrier{get; set;}
    public List<DSM_Distributor_Directory__c> listAllDistBrynt{get; set;}
    public List<DSM_Distributor_Directory__c> listAllDistPayne{get; set;}
    public List<DSM_Distributor_Directory__c> lstdist{get; set;}
    public List<AggregateResult> countyList{get;set;}
    public List<AggregateResult> stateList{get;set;}
    public string searchDSMText{get;set;}
    
    public list<SelectOption> BrandOption {get; set;} 
    public list<SelectOption> CountyOption {get; set;} 
    public list<SelectOption> StateOption {get; set;} 
    
    public Boolean isdistributorPanelVisible{get; set;}
    public String CountyOptionSelected {get; set;}
    public String StateOptionSelected {get; set;}
    public String brandSelected{get; set;}
    public String countySelected{get; set;}
    public String stateSelected{get; set;} 
    public string state{get;set;}
    public String county{get;set;}
    public DSM_Distributor_Directory__c paramRec{get;set;}
    public String selectedDistIdForCaseCreation{get; set;}
    public String dealerName{get; set;}
    public String dealerPhone{get; set;}
    public String brand{get;set;}
    public String AccountNameDistLoctBtn{get;set;}
    public String AccountIdDistLoctBtn{get;set;}
    public String AccountId{get; set;}
    public boolean isTier1Required{get; set;}
    public boolean isDescriptionRendered{get; set;}
    
    public list<String> AlphaList {get; set;}
    public String AlphaFilter {get; set;}
    public String SearchName {get; set;}
    public String SearchBillingAddress {get; set;} 
    private String SaveSearchName;
    private String SaveSearchBillingAddress;
    private String QueryDSM;
    public String SortFieldSave;
    public String source{get; set;}
    public Id caseId{get; set;}
    public Id caseId2{get; set;}
    public Boolean isCreateCaseDisplayed{get; set;}
    public Boolean isUpdateCaseDisplayed{get; set;}
    public String caseNumber{get; set;}
    public Boolean isCaseCreated{get; set;}
    
    public String firstName{get; set;}
    public String lastName{get;set;}
    public String email{get; set;}
    public String dealerPhoneDistLoctBtn{get;set;}
    public String ContactId{get; set;}
    public String selectedContactName{get; set;}
    public String AccountName{get; set;}
    public String ContactIdNew{get;set;}
    public String AccountDistLoctBtn{get;set;}
    public boolean displayBrand{get;set;}
    
     //public string brand {get;set;}
    public DSMNonCaseSearchExtLinkController(ApexPages.StandardController controller){
        
        String getParamtr = ApexPages.currentPage().getParameters().get('valPassed');
        String getParamtr2 = ApexPages.currentPage().getParameters().get('brandname');
        this.dealerName = ApexPages.currentPage().getParameters().get('dealerName');
        this.dealerPhone = ApexPages.currentPage().getParameters().get('dealerPhone');
        this.AccountId =ApexPages.currentPage().getParameters().get('selectedDealerId');
        this.ContactId =ApexPages.currentPage().getParameters().get('selectedContactId');
        this.selectedContactName = ApexPages.currentPage().getParameters().get('selectedContactName'); 
        this.AccountName = ApexPages.currentPage().getParameters().get('selectedDealerName');
        this.AccountNameDistLoctBtn = ApexPages.currentPage().getParameters().get('accountName');
        this.AccountDistLoctBtn = ApexPages.currentPage().getParameters().get('accountNameDistLoctBtn');
        this.AccountIdDistLoctBtn = ApexPages.currentPage().getParameters().get('selectedAccountId');
        this.dealerPhoneDistLoctBtn= ApexPages.currentPage().getParameters().get('dealerPhoneDistLoctBtn'); 
        this.caseId = ApexPages.currentPage().getParameters().get('caseId');
        source = ApexPages.currentPage().getParameters().get('source');
        this.firstName = ApexPages.currentPage().getParameters().get('firstName');
        this.lastName = ApexPages.currentPage().getparameters().get('lastName');
        this.email = ApexPages.currentPage().getparameters().get('email'); 
        listAllDistNames = new List<DSM_Distributor_Directory__c>();
        listAllDistCarrier = new List<DSM_Distributor_Directory__c>();
        listAllDistBrynt = new List<DSM_Distributor_Directory__c>();
        listAllDistPayne = new List<DSM_Distributor_Directory__c>();
        stateList = new List<AggregateResult>();  
        BrandOption = new list<SelectOption>();
        CountyOption = new list<SelectOption>();
        StateOption = new LIST<SelectOption>();
        brandSelected = getParamtr2;
        CountyOptionSelected = '';
        StateOptionSelected = '';
        state = '';
        county = '';
        selectedDistIdForCaseCreation = '';
        isCreateCaseDisplayed = false;
        if(source!=null && source.length()>0 && source=='SmartSearch'){
            isCreateCaseDisplayed = true;
        }else{
            isCreateCaseDisplayed = false;
        }
        isUpdateCaseDisplayed = false;
        if(source!=null && source.length()>0 && source=='DistLoctBtn'){
            isUpdateCaseDisplayed = true;
        }else{
            isUpdateCaseDisplayed = false;
        }
        
         if(brand!=null && brand.length()>0)
        {
            displayBrand=false;
        }
        else
        {
          // brand=brandSelected;
           displayBrand=true; 
        }
        //isCreateCaseDisplayed = true;
        // initialization alpha list
        AlphaList = new list<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'All'};
        SortFieldSave = SortField;
        AlphaFilter = 'All';
        // list generation
        //BuildQuery(); 
        
        User loggedInUser = [Select Id, Profile.Name from User where Id=:UserInfo.getUserId()];
        if(loggedInUser!=null && loggedInUser.Profile.Name!=null && loggedInUser.Profile.Name.length()>0 && loggedInUser.Profile.Name.contains('Tier 1')){
            isTier1Required = false;
        }else{
            isTier1Required = true;
        }
        if(getParamtr!=null && getParamtr.length()>0 && getParamtr=='CAN' && !loggedInUser.Profile.Name.contains('Tier 1')){
            isDescriptionRendered = true;
        }else{
            isDescriptionRendered = false;
        }
    }
    
    public String SortField {
        get { if (SortField == null) {SortField = 'Name'; } return SortField;  }
        set; 
    }
    
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; } return SortDirection;  }
        set;
    }
    
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            AlphaFilter = 'All';
            SortFieldSave = SortField;
        }
        // run the query again
        BuildQuery();
    }
    
    
    public void createCase(){
        System.debug('AccountId..'+AccountId);
        System.debug('dealerName..'+dealerName);
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consumer Relations').getRecordTypeId();
        DSM_Distributor_Directory__c dsm = [Select Id,Brand__c,Account_ID__c,Contact_ID__c,Contact1_ID__c,Contact_Name__c,Distributor_Name__c from DSM_Distributor_Directory__c where Id = :selectedDistIdForCaseCreation];
        Case cs = new Case();
        if(AccountId!=null && AccountId.length()>0){
        	cs.AccountId = AccountId;    
        }else if(source!=null && source.length()>0 && source=='SmartSearch' && dealerName!=null && dealerName.length()>0){
            AccountId = createDealerAccount(dealerName);
            cs.AccountId = AccountId;
        }        
        cs.recordTypeId = recTypeId;
        cs.CCC_Brand__c = dsm.Brand__c;
        cs.Status = 'Closed';
        cs.Reason = 'Referral Completed';
        cs.Origin = 'Phone';
        cs.CCC_Purpose__c = 'Referral';
        cs.CCC_Sub_Purpose__c = 'Distributor';
        cs.OwnerId = [select Id from Group where Name='Tier1' and Type = 'Queue'].Id;
        List<User> dsmUserLst = [Select Id,Name from User where ContactId=:dsm.Contact1_ID__c];
        if(dsmUserLst!=null && dsmUserLst.size()>0){
            User dsmUsr = dsmUserLst.get(0);
            cs.CCC_DSM_Contact__c = dsmUsr.Id;
            cs.CCC_DSM__c = dsmUsr.Name;
        }
        
        //cs.ContactId = dsm.Contact_ID__c;
        //cs.ContactId = contactId;
        cs.Current_Servicing_Dealer__c = dealerName;
        cs.CCC_Dealer_s_Phone_No__c = dealerPhone;
        //cs.CCC_Distributor_Name__c = dsm.Account_ID__c;
        cs.CCC_Distributor_s_Name__c = dsm.Account_ID__c;
        cs.CCC_Distributor_Name__c = dsm.Account_ID__c;
        cs.CCC_Turn_Back_Code__c = 'Not Applicable';
        cs.Subject = 'Tech Support';
        cs.Description = 'Refer to Distributor';
        insert cs;
        caseNumber = [Select Id, CaseNumber from Case where Id=:cs.Id].CaseNumber;
        //caseNumber = cs.Id;
        isCaseCreated = true;
        PageReference redirectSuccess = new ApexPages.StandardController(cs).view();
        redirectSuccess.setRedirect(true);
        //return (redirectSuccess); 
    }
    
     public pagereference updateCase(){
        System.debug('AccountDistLoctBtn..'+AccountDistLoctBtn);
        System.debug('dealerPhoneDistLoctBtn..'+dealerPhoneDistLoctBtn);
       // Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consumer Relations').getRecordTypeId();
        DSM_Distributor_Directory__c dsm = [Select Id,Brand__c,Account_ID__c,Contact_ID__c,Contact1_ID__c,Contact_Name__c,Distributor_Name__c from DSM_Distributor_Directory__c where Id = :selectedDistIdForCaseCreation];
        Case c = [select CCC_Purpose__c,CCC_Sub_Purpose__c,AccountId,ContactId,CCC_Brand__c,Status,Reason,Origin,CCC_DSM_Contact__c,
                  CCC_DSM__c,Current_Servicing_Dealer__c,CCC_Dealer_s_Phone_No__c,CCC_Distributor_s_Name__c,CCC_Distributor_Name__c,CCC_Turn_Back_Code__c,Subject,
                  Description from Case where id=:caseId];
        
         c.CCC_Purpose__c = 'Referral';
         c.CCC_Sub_Purpose__c = 'Distributor';
        //Update Account to case if account is present else create new account 
         if(AccountIdDistLoctBtn!=null && AccountIdDistLoctBtn.length()>0){
             system.debug('if');
        	c.AccountId = AccountIdDistLoctBtn;    
        }
        else if(AccountDistLoctBtn!=null && AccountDistLoctBtn!=''){
            AccountId = createDealerAccount(AccountDistLoctBtn);
            c.AccountId = AccountId;
        }
         else{}
        
        
        //Update Contact if contact is present else create new contact
         if(ContactId!=null && ContactId.length()>0)
         {
            system.debug('ContactIdExist#########'+ContactId); 
            c.ContactId = ContactId; 
             
         }
         else if(firstName!=null && lastName != null && email != null )
         {
             system.debug('ContactIdNotExist#########'+ContactId);
             ContactIdNew = createDealerContact(firstName, lastName, email, dealerPhone);
             c.ContactId = ContactIdNew;
         } 
         else
         {}
         //Associate sender's email to contact if contact email is null
         Contact con = [select email,AccountId from Contact where id=:c.ContactId];
         if(con.Email==null && con.Email=='')
         {
             con.Email=email;
             update con;
         }
         if(con.AccountId==null && con.AccountId==''&& AccountIdDistLoctBtn!=null){
          con.AccountId = AccountIdDistLoctBtn; 
         }
         else{
           con.AccountId = AccountId; 
         }
         update con;
         
        
        c.CCC_Brand__c = dsm.Brand__c;
      //  c.Status = 'Closed';
        c.Reason = 'Referral Completed';
        c.Origin = 'Phone';
       // c.CCC_Purpose__c = 'Referral';
       // c.CCC_Sub_Purpose__c = 'Distributor';
       // cs.OwnerId = [select Id from Group where Name='Tier1' and Type = 'Queue'].Id;
        List<User> dsmUserLst = [Select Id,Name from User where ContactId=:dsm.Contact1_ID__c];
        if(dsmUserLst!=null && dsmUserLst.size()>0){
            User dsmUsr = dsmUserLst.get(0);
          //  c.CCC_DSM_Contact__c = dsmUsr.Id;
           // c.CCC_DSM__c = dsmUsr.Name;
        }
        
        //cs.ContactId = dsm.Contact_ID__c;
        //cs.ContactId = contactId;
        c.Current_Servicing_Dealer__c = AccountDistLoctBtn;
        c.CCC_Dealer_s_Phone_No__c = dealerPhone;
        //cs.CCC_Distributor_Name__c = dsm.Account_ID__c;
        c.CCC_Distributor_s_Name__c = dsm.Account_ID__c;
        c.CCC_Distributor_Name__c = dsm.Account_ID__c;
        c.CCC_Turn_Back_Code__c = 'Not Applicable';
       // c.Subject = 'Tech Support';
       // c.Description = 'Refer to Distributor';
        update c;
        system.debug('update case'+c);
        caseNumber = [Select Id, CaseNumber from Case where Id=:c.Id].CaseNumber;
       
        isCaseCreated = true;
        PageReference redirectSuccess = new ApexPages.StandardController(c).view();
        redirectSuccess.setRedirect(true);
        return redirectSuccess; 
    }
    
    public PageReference init(){
        this.caseId2 = ApexPages.currentPage().getParameters().get('id');
        
        objCase = [SELECT CCC_Purpose__c,CCC_Sub_Purpose__c,AccountId,ContactId,Status,Reason,Origin,CCC_DSM_Contact__c,
                  CCC_DSM__c,Current_Servicing_Dealer__c,CCC_Dealer_s_Phone_No__c, contact.MailingStreet,contact.MailingState,
                   contact.MailingCity,contact.MailingPostalCode,Contact.Phone,CCC_Brand__c,
				  CCC_Distributor_s_Name__c,CCC_Turn_Back_Code__c FROM Case where Id=:caseId2];
       // System.debug('#objCase Contact:'+objCase.ContactId);
       // System.debug('#objCase Brand:'+objCase.CCC_Brand__c);
        if(objCase.contactId==null || (objCase.contact.MailingPostalCode==null)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Case should have contact/zip associated!!!'));
            return null;
        }
        if(objCase.CCC_Brand__c==null || objCase.CCC_Brand__c.length()==0){
            System.debug('#inside brand');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Case should have brand associated, Please select Brand !!!'));
           // isPrimaryEquipSelEnabled = true;
            return null;
        }
      // lstAsset = getAllAssets();
        /*PageReference redirectPage = new PageReference('/'+objCase.Id);
redirectPage.setRedirect(true);
return redirectPage;*/
        if(objCase.CCC_Brand__c!=null || objCase.CCC_Brand__c!='')
        {
        updateCaseForVerifiedContact();
       // long now = datetime.now().gettime();
       // while(datetime.now().gettime()-now<5000);
      /*  PageReference redirectSuccess = new ApexPages.StandardController(objCase).view();
        redirectSuccess.setRedirect(true);
        return redirectSuccess;*/   
        }
        // searchDSM();
        //return proceedWithAssignment();
       // return null;
        PageReference redirectSuccess = new ApexPages.StandardController(objCase).view();
        redirectSuccess.setRedirect(true);
        return redirectSuccess;
    }
    
    public pagereference updateCaseForVerifiedContact(){
     
        
        displayBrand = false;  
        String brandSelected = ApexPages.currentPage().getParameters().get('param');
        System.debug('#proceed method');
        objContact = [Select Id,MailingState,Enrichment_Payload__c,Phone from Contact where Id=:objCase.ContactId];
        System.debug('#objContact:'+objContact);
        //objCase = [Select Id,contact.MailingState from case where Id=:objCase.ContactId];
        //System.debug('#objCase :'+objCase);
        if(objContact.Enrichment_Payload__c==null || objContact.Enrichment_Payload__c.length()==0){
            System.debug('#Inside Enrichment_Payload__c null');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Address is not verified!!!'));
        }else{
            System.debug('contact.MailingPostalCode:'+objCase.contact.MailingPostalCode);
            String zip = String.valueOf(objCase.contact.MailingPostalCode);
            System.debug('contact.MailingState :'+objCase.contact.MailingState);
            String State = String.valueOf(objCase.contact.MailingState);
            System.debug('#State:'+State);
            System.debug('contact.Phone:'+objCase.contact.Phone);
            String Ph= String.valueOf(objCase.contact.Phone);
            //ph = [Select Phone from contact where Phone LIKE '905%'];
            String stateCode = '';
            String countryCode = '';
            System.debug('#zip:'+zip);
            if(!zip.isAlphanumericSpace() && (objContact.Enrichment_Payload__c.contains('STATE_FIPS_CODE') || objContact.Enrichment_Payload__c.contains('COUNTY_FIPS_CODE'))){
                Dom.Document doc = new Dom.Document();
                String enrichmentPayload = objContact.Enrichment_Payload__c;
                if(enrichmentPayload!=null && enrichmentPayload.length()>0 && enrichmentPayload.contains('&lt;')){
                    enrichmentPayload = enrichmentPayload.replaceAll('&lt;', '<');
                    enrichmentPayload = enrichmentPayload.replaceAll('&gt;', '>');
                }
                System.debug('#Enrichment Payload after correction:'+enrichmentPayload);
                doc.load(enrichmentPayload);
                Dom.XMLNode root = doc.getRootElement(); 
                stateCode =  root.getChildElement('STATE_FIPS_CODE',root.getNamespace()).gettext();
                countryCode =  root.getChildElement('COUNTY_FIPS_CODE',root.getNamespace()).gettext();
            }      
            System.debug('State_Fips_Code :'+stateCode);
            System.debug('County_Fips_Code :'+countryCode);
            System.debug('##Brand:'+objCase.CCC_Brand__c);
            String brand = '';
            brand = objCase.CCC_Brand__c;
            if((brand==null || brand.length()==0) && brandSelected!=null && brandSelected.length()>0){
                brand  = brandSelected;
            }
            if(objCase.CCC_Brand__c!=null && objCase.CCC_Brand__c.equals('CAR')){
                brand = 'Carrier';
            }else if(objCase.CCC_Brand__c!=null && objCase.CCC_Brand__c.equals('BRY')){
                brand = 'Bryant';
            }else if(objCase.CCC_Brand__c!=null && objCase.CCC_Brand__c.equals('PAY')){
                brand = 'Payne';
            }
            objCase.CCC_Brand__c = brand;
            String fipsCode = stateCode + countryCode;
            System.debug('#FIPS Code:'+fipsCode);
             DSM_Distributor_Directory__c dsm = [select id, Distributor_Name__c, Contact_Name__c,Distributor_ID__c,Contact_Id__c,Contact1_ID__c,Account_ID__c from DSM_Distributor_Directory__c where FIPS_Code__c =: fipsCode AND Brand__c =:brand];      
            //String zip = String.valueOf(contact.MailingPostalCode);
           // DSM_Distributor_Directory__c dsm = [Select Id,Brand__c,Account_ID__c,Contact_ID__c,Contact1_ID__c,Contact_Name__c,Distributor_Name__c from DSM_Distributor_Directory__c where Id = :selectedDistIdForCaseCreation];
            objCase.CCC_Purpose__c = 'Referral';
            objCase.CCC_Sub_Purpose__c = 'Distributor';
            objCase.Reason = 'Referral Completed';
            objCase.Origin = 'Phone';
            List<User> dsmUserLst = [Select Id,Name from User where ContactId=:dsm.Contact1_ID__c];
            if(dsmUserLst!=null && dsmUserLst.size()>0){
            User dsmUsr = dsmUserLst.get(0);
           // objCase.CCC_DSM_Contact__c = dsmUsr.Id;
           // objCase.CCC_DSM__c = dsmUsr.Name;
            objCase.Current_Servicing_Dealer__c = dsm.Distributor_Name__c;
            objCase.CCC_Dealer_s_Phone_No__c = Ph;
        //cs.CCC_Distributor_Name__c = dsm.Account_ID__c;
            objCase.CCC_Distributor_s_Name__c = dsm.Account_ID__c;
            objCase.CCC_Distributor_Name__c = dsm.Account_ID__c;
            objCase.CCC_Turn_Back_Code__c = 'Not Applicable';
        }
            update objCase;
        
        }
        PageReference redirectSuccess = new ApexPages.StandardController(objCase).view();
        redirectSuccess.setRedirect(true);
        return redirectSuccess;
      //  return null;
    }  
    
     public void BuildQuery() {
       // StdSetControllerAccount = null;
        String QueryWhere = '';
        
        if (AlphaFilter == null || AlphaFilter.trim().length() == 0) {
            AlphaFilter = 'All';
        }
        
        QueryDSM = 'SELECT id, Distributor_Name__c, Contact_Name__c,County_Name__c,State__c,TSM__c, Phone__c, Email__c, Brand__c,Distributor_ID__c , Account_Address__c, Account_ID__r.BillingStreet, Account_ID__r.BillingCity, Account_ID__r.BillingState, Account_ID__r.BillingPostalCode, Account_ID__r.BillingCountry, Description__c  ' +
            ' FROM DSM_Distributor_Directory__c'; 
          
        
        if (AlphaFilter == 'Other') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' < \'A\' OR ' + 
                                    String.escapeSingleQuotes(SortField) + ' > \'Z\') AND (NOT ' + 
                                    String.escapeSingleQuotes(SortField) + ' LIKE \'Z%\') ');
        } else if (AlphaFilter != 'All') {
            system.debug('AAAA'+AlphaFilter);       
            QueryWhere = BuildWhere(QueryWhere, '(County_Name__c '  + ' LIKE \'' + String.escapeSingleQuotes(AlphaFilter) + '%\')' );
        }else if(AlphaFilter == 'All'){
            QueryWhere = BuildWhere(QueryWhere, '(Name '  + ' <>\'\')' );
        }
         system.debug('QueryWhere'+QueryWhere);
             if(StateOptionSelected=='CAN'){
                    QueryWhere += ' and Country__c = '+ '\'CANADA\'';
                }else{
                    QueryWhere += ' and State__c = '+ '\''+StateOptionSelected+'\' and Country__c= \'USA\'';
                    system.debug('QueryWhere:' + QueryWhere);
                }
             if(brandSelected !=null && brandSelected.length()>0 )
             {
                  QueryWhere += ' and Brand__c = \''+brandSelected+'\'';
                 system.debug('QueryWhere*****:' + QueryWhere);
             }
        if (SaveSearchName != null) {
            System.debug('#Inside here!:SaveSearchName:'+SaveSearchName);
            QueryWhere = BuildWhere(QueryWhere, ' (County_Name__c LIKE \'%' + String.escapeSingleQuotes(SaveSearchName) + '%\')');
        }
        if (SaveSearchBillingAddress != null) {
            System.debug('#Inside there!:SaveSearchBillingAddress:'+SaveSearchBillingAddress);
            QueryWhere = BuildWhere(QueryWhere, '((County_Name__c LIKE \'%' + String.escapeSingleQuotes(SaveSearchBillingAddress) + '%\'))' );
            system.debug('QueryWherebefore:' + QueryWhere);
           
            
        }
         
        
        QueryDSM += QueryWhere;
          system.debug('QueryDSM:' + QueryDSM);
         listAllDistNames = Database.query(QueryDSM);
         System.debug('#listAllDistNames Size:'+listAllDistNames.size());
         System.debug('#listAllDistNames:'+listAllDistNames);
        //QueryDSM += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) + ' LIMIT 10000';
        
       
    }
    
    /***
    * BuildWhere - build soql string for where criteria 
    ***/
    public String BuildWhere(String QW, String Cond) {
        if (QW == '') {
            return ' WHERE ' + Cond;
        } else {
            return QW + ' AND ' + Cond;
        }
    }
    
    public Pagereference searchDist(){
        String getParam = ApexPages.currentPage().getParameters().get('valPassed');
        String getParam2 = ApexPages.currentPage().getParameters().get('brandSelected');
        System.debug('getParam'+getParam);
        System.debug('getParam2'+getParam2);
        //StateOptionSelected = stateSelected;
        //System.debug('stateSelected'+stateSelected);
        CountyOptionSelected = countySelected;
        if(brandSelected==null || brandSelected==''){
            brandSelected=getParam2;
        }
        
        System.debug('brandSelected***************'+brandSelected);
        StateOptionSelected = getParam;
        CountyOptionSelected = null;
        string soql= '';
        lstDist = new List<DSM_Distributor_Directory__c>();
        
        if((StateOptionSelected == null || StateOptionSelected == '' || StateOptionSelected == '--None--') && (CountyOptionSelected == null || CountyOptionSelected == '' || CountyOptionSelected == '--None--') && (brandSelected == null || brandSelected == '' || brandSelected == '--None--'))
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select value');
            ApexPages.addMessage(myMsg); 
            listAllDistNames.clear();
            listAllDistCarrier.clear();
            listAllDistBrynt.clear();
            listAllDistPayne.clear();
        }
        
        else{
            soql = 'select id, Distributor_Name__c, Contact_Name__c,County_Name__c,State__c,TSM__c, Phone__c, Email__c, Brand__c,Distributor_ID__c , Account_Address__c, Account_ID__r.BillingStreet, Account_ID__r.BillingCity, Account_ID__r.BillingState, Account_ID__r.BillingPostalCode, Account_ID__r.BillingCountry, Description__c from DSM_Distributor_Directory__c ' ; 
            if(StateOptionSelected !=null && StateOptionSelected != '' && StateOptionSelected != '--None--'){
                if(StateOptionSelected=='CAN'){
                    soql += ' Where Country__c = '+ '\'CANADA\'';
                }else{
                    soql += ' Where State__c = '+ '\''+StateOptionSelected+'\' and Country__c= \'USA\'';
                }
                
            }  
            if(CountyOptionSelected !=null && CountyOptionSelected != '' && CountyOptionSelected != '--None--'){
                soql += soql.indexOf('Where') !=-1 ? ' and County_Name__c = '+ '\''+CountyOptionSelected+'\'':' Where County_Name__c = '+ '\''+CountyOptionSelected+'\'';             
            }  
            System.debug('Soql '+ soql + ' index '  + soql.indexOf('Where') );    
            if(brandSelected !=null && brandSelected != '' && brandSelected != '--None--'){
                soql += soql.indexOf('Where') !=-1 ? ' and Brand__c = '+ '\''+brandSelected+'\'' : ' Where Brand__c = '+ '\''+brandSelected+'\'';             
            }  
            soql += ' order by County_Name__c limit 500'  ;
            lstdist = Database.query(soql);
            system.debug('soql'+soql);
            
            system.debug('lstdist'+lstdist); 
            system.debug('lstdist'+lstdist.size());  
            
            if(lstdist != null && lstdist.size()>0){
                listAllDistNames.clear();
                listAllDistCarrier.clear();
                listAllDistBrynt.clear();
                listAllDistPayne.clear();
                for(Integer i=0;i<lstdist.size();i++){
                   // listAllDistNames.add(lstdist.get(i));
                   
                   
                     system.debug('lstdistbrand*********'+lstdist.get(i).Brand__c);
                    if(lstdist.get(i).Brand__c!=null && lstdist.get(i).Brand__c.length()>0 && lstdist.get(i).Brand__c=='Carrier'){
                        listAllDistCarrier.add(lstdist.get(i));
                        listAllDistNames=listAllDistCarrier;
                        system.debug('listAllDistNamesCarrier*********'+listAllDistNames);
                        
                    }else if(lstdist.get(i).Brand__c!=null && lstdist.get(i).Brand__c.length()>0 && lstdist.get(i).Brand__c=='Bryant'){
                        listAllDistBrynt.add(lstdist.get(i));
                        listAllDistNames=listAllDistBrynt;
                         system.debug('listAllDistNamesBryant*********'+listAllDistNames);
                    }else if(lstdist.get(i).Brand__c!=null && lstdist.get(i).Brand__c.length()>0 && lstdist.get(i).Brand__c=='Payne'){
                        listAllDistPayne.add(lstdist.get(i));
                         listAllDistNames=listAllDistPayne;
                         system.debug('listAllDistNamesPayne*********'+listAllDistNames);
                    }
                }
                isdistributorPanelVisible = true;
            }
            else{
                system.debug('else loop');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No records found'));
                listAllDistNames.clear();
                listAllDistCarrier.clear();
            	listAllDistBrynt.clear();
            	listAllDistPayne.clear();
            }
        }
        system.debug('listAllDistNames'+listAllDistNames);
        return null;
    }
    
    /** createDealerAccount- Creating new Account **/
    
    public String createDealerAccount(String accountName){
        Account acc = new account();
           // acc.Name = 'xxx';
           system.debug('Dealername'+dealerName);
            acc.Name = accountName;
            acc.Type ='Dealer';
           // acc.Phone = accountPhone;
            acc.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            insert acc;
            System.debug('#acc:'+acc);
            return acc.id;
       }
    /** createDealerContact- Creating new contact **/
    
     public String createDealerContact(String firstName, String lastname, String email, String dealerPhone){
       Contact con = new Contact();
           // acc.Name = 'xxx';
            con.LastName = lastname;
            con.FirstName = firstName;
            con.Email = email;
            con.Phone = dealerPhone;
            insert con;
            System.debug('##################con:'+con);
            return con.Id;
            
    }
    

}