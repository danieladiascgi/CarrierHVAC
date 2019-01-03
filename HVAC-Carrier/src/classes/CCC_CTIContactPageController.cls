/**
* @ Developer     : Ishita Sharma
* @date_created   : 1/14/2016
* @functions      : 1. AssignTSMUser   - Looks for TSM User in the Account Team and makes the same user owner of Account.
*                   2. AccountHierarchy- Fetches all the accounts in heirarchy five level up and 3 level down along with the Siblings Account heirarchy.
*
* @Date Modified  : <1/15/2016> Sudheer  : 1.mobilephone to Phone field in the query
<1/27/2016> Ishita   : 2.Contact default value shall be USA.
<4/29/2016> Sudheer  : Changed the Contact country default value to from USA to United States as to inline with CC360 functionlity.
Reference is DEF0000524   
<1/27/2016> Ishita   : 3.If Is residential : Residential Is mandatory 

CRP 2 FeedBack :
<2/3/2016> Ishita   : 1. Case type shall be displayed based on the User profile on Contact Search page
<2/3/2016> Ishita   : 2. Change label prefix â€œMailingâ€ on all fields in Contact CTI Search Visualforce Page
<2/3/2016> Ishita   : 3. Add hyperlink to SFDC contact results records in CTI Contact Search page to navigate to the Contact record directly on click.
<2/5/2016> Ishita   : 4. Changed Controller name from CCCCTIContactPageCloneController to CCC_CTIContactPageController
<3/5/2016> Ishita   : 5. Method : getPHDBInfo : Used Reusabe class CCC_Integration helper to invoke PHDB servise

CRP3 Feedback :
<29/3/2016> Ishita   : 1. Changed "And" condition to "OR" in Contact Search

*
* 
***/

public class CCC_CTIContactPageController {
    
    /*Variable Declarations */
    public Account account { get; set; }
    public Contact contact { get; set; }
    public Case caseobj { get; set; }
    public List<ContactWrapper> Results{get;set;}
    public Id uniqueContactId {get;set;}
    public List<Contact> contactResults;
    public boolean isResidential { get; set; }
    public boolean IsResidentialReadOnly { get; set; }
    public List<ContactWrapper> contactWrapperList;
    public Id selectedCaseType{get;set;}
    Public string searchId {get;set;}
    Public string ConfirmationNo {get;set;}
    Public string PhoneNo2 {get;set;}
    /*Declarations for Error record*/
    String contactName = null;
    String caseName;
    
    /*Declarations for PHDB*/
    Public List<PHDBInfoWrapper> lstDisNum {get;set;}
    Public List<PHDBInfoWrapper> PHDBContactsInfo {get;set;}
    public list<PHDBInfoWrapper> PHDBContactsInfoFinal{get;set;}
    public Boolean PHDBRecord {get;set;}
    public String PHDBRecordid {get;set;}
    public String strUrl{get;set;}
    public String responseStr{get;set;}
    public String phoneFromURL;
    public String ResidentialFromURL1{get;set;}
    public Boolean ResidentialFromURL;
    
    
    CCC_ErrorLog errlog=new CCC_ErrorLog();
    /* _______________________________________________________ Class Constructor ,Get Record Type Method ___________________________________________________________________________________________________________________________*/
    
    public CCC_CTIContactPageController() {
        
        Id id = ApexPages.currentPage().getParameters().get('id');
        phoneFromURL=ApexPages.currentPage().getParameters().get('phoneFromURL1');
        ResidentialFromURL1=ApexPages.currentPage().getParameters().get('isResidential1');
        system.debug('ConfirmationNo...'+ConfirmationNo);
        if(ResidentialFromURL1!=null){
            ResidentialFromURL=Boolean.valueOf(ResidentialFromURL1);
        }
        
        account = (id == null) ? new Account() : [SELECT Name, Phone, BillingCountry FROM Account WHERE Id = :id];
            contact = (id == null) ? new contact() : [SELECT firstName,lastName,Phone,Otherphone,HomePhone,mobilephone,mailingStreet,email,MailingCity,MailingState,
                                                      MailingCountry,MailingPostalcode,RecordTypeId FROM Contact WHERE Id = :id];
                                                          
                                                          //Changed to United States from USA, Reference Defect ID is DEF0000524
                                                          contact.MailingCountry='United States';
        contactName=contact.firstName+' '+contact.lastName;
        caseobj = (id == null) ? new Case()    : [SELECT id,Origin,Status,CCC_Application_Type__c FROM Case WHERE contact.id = :id];
            caseName=caseobj.id;
        if(phoneFromURL!=null && phoneFromURL!=''){
            contact.Phone=phoneFromURL;
            
        }
        if(ResidentialFromURL!=null ){
            isResidential=ResidentialFromURL;
            
        }
        else{
            isResidential= True;
        }
        
        
    }
    
    
    /*GetrecordtypeId : Method Fetching Record type id based on Recordtype Name and Sobject*/
    public recordtype GetrecordtypeId(String Recordtypename,String SobjectType){
        RecordType rt;
        if(Recordtypename!='' && SobjectType !=''){
            rt = [select Id from RecordType where Name =:Recordtypename AND IsActive = TRUE AND SobjectType =: SobjectType  ]; 
        }
        return rt;
    }
    
    /* ______________________________________________________Save and Create :Case,Contact,Account______________________________________________________________________________________________________*/
    /**
* This method will  create Account ,Contact and case based on Checkbox Is Residential , if checked Account would be created else not
@Developer :Ishita Sharma 
**/
    public PageReference save() {
        Id RecordtypeIdacc; 
        Id RecordtypeIdcontact;
        String accountName;
        system.debug('ConfirmationNo...'+ConfirmationNo);
        try {
            
            String Recordtypename,SobjectType;
            if (contact.Lastname == null || contact.Lastname == '')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the Last Name to Proceed Further'));
                return null;
            }
            if(selectedCaseType == null ){
                apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR,'Please Select Case Type'));
                return null;       
            }
            if (contact.Phone == null || contact.Phone == '')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the Phone No. to Proceed Further'));
                return null;
            }
            if (contact.mailingPostalCode == null || contact.mailingPostalCode == '')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the Postal/Zip Code to Proceed Further'));
                return null;
            }
            
            /* If Is residential Checkbox is checked*/
            if(isResidential) {
                system.debug('isResidential...'+isResidential);
                RecordtypeIdacc =GetrecordtypeId('Residential Address','Account').id;
                RecordtypeIdcontact=GetrecordtypeId('Residential Contact','Contact').Id;
                
                //account=new account();
                
                if(Contact.Id != null)
                {
                    caseobj= new Case();
                    if(account.Id != null){
                        caseobj.AccountId=account.id;
                        
                    }
                    caseobj.Contactid=contact.id;
                    caseobj.origin='Phone';
                    caseobj.Status='Open';
                    caseobj.CCC_Application_Type__c='Residential';
                    caseobj.RecordTypeId=selectedCaseType;
                    upsert(caseobj);
                }
                else
                {
                    /*Create Account */
                    accountName='Residential'+contact.MailingPostalcode;
                    accountName = this.getAccountName(contact);
                    account.Name=accountName;
                    account.BillingCountry=contact.MailingCountry;
                    account.BillingState=contact.MailingState;
                    account.BillingCity=contact.MailingCity;
                    
                    //Below logic to find a country based on zip code
                    // DEF0000762
                    
                    String tempPostalCode = contact.MailingPostalcode;
                    boolean alpha = false;
                    List<String> chars = tempPostalCode.split('|');
                    for (String s : chars)
                    {
                        if (s.isAlpha())
                        {
                            alpha = true;
                            break;
                        }
                    } 
                    
                    //Ends the logic here              
                    
                    if(alpha)
                    {
                        account.BillingPostalCode=contact.MailingPostalcode;
                        account.ShippingPostalcode=contact.MailingPostalcode;
                        account.BillingCountry='Canada';
                        account.ShippingCountry='Canada';
                        contact.MailingCountry='Canada';
                    }
                    else
                    {
                        account.BillingPostalCode=contact.MailingPostalcode;
                        account.ShippingPostalcode=contact.MailingPostalcode;
                        account.BillingCountry=contact.MailingCountry;
                        account.ShippingCountry=contact.MailingCountry;
                    }
                    
                    
                    account.BillingStreet=contact.MailingStreet;
                    account.ShippingState=contact.MailingState;
                    account.ShippingCity=contact.MailingCity;
                    account.ShippingStreet=contact.MailingStreet;
                    account.RecordTypeID=RecordtypeIdacc;
                    upsert(account);
                    
                    /*Create Contact */
                    contact.RecordTypeID=RecordtypeIdcontact;
                    if(account.Id != null)
                    {
                        contact.AccountId=account.Id;
                    }
                    system.debug('@@@@@@@@@'+Contact.Id);
                    contact.RecordTypeID=RecordtypeIdcontact;
                    upsert(contact);
                    
                    system.debug('------->'+Contact.Id);
                    /*Create Case */
                    if(contact.Id != null )
                    {
                        caseobj= new Case();
                        if(account.Id != null){
                            caseobj.AccountId=account.id;
                            
                        }
                        caseobj.Contactid=contact.id;
                        caseobj.origin='Phone';
                        caseobj.Status='Open';
                        caseobj.CCC_Application_Type__c='Residential';
                        caseobj.RecordTypeId=selectedCaseType;
                        upsert(caseobj);
                    }
                }
                
                
                
                
                
                
                /*Open Case View Page */
                
                PageReference redirectSuccess = new ApexPages.StandardController(caseobj).view();
                redirectSuccess.setRedirect(true);
                //return (redirectSuccess);
                return null;
                
            } 
            /* If Is residential Checkbox is  not checked*/
            else{
                RecordtypeIdcontact=contact.RecordTypeID=GetrecordtypeId('Non-Residential Contact','Contact').Id;
                contact.RecordTypeID=RecordtypeIdcontact;
                upsert(contact);
                
                /*Create Case */
                if(contact.Id != null)
                {
                    caseobj= new Case(Contactid=contact.id,origin='Phone',Status='Open',RecordTypeId=selectedCaseType);
                    upsert(caseobj);
                }
                
                /*Open Case View Page */
                
                PageReference redirectSuccess = new ApexPages.StandardController(caseobj).view();
                redirectSuccess.setRedirect(true);
                return (redirectSuccess);
                
            }
            
            
        }catch(System.DMLException e) {
            /* Insert error record for each exception caught */
            CCC_Error_log__c log = new CCC_Error_log__c (CCC_Source__c='CTI Contact Page' ,CCC_Line_no__c= e.getLineNumber(), 
                                                         CCC_Message__c = e.getMessage(),CCC_Type__c= e.getTypeName(),
                                                         CCC_Stack_Trace__c= e.getStackTraceString(),
                                                         CCC_Additional_Information__c='contactName ='+' '+contactName+'Case Id ='+' '+caseName); 
            Insert log;
            return null;
        }
        
    }
    
    /* ______________________________________________________Contact Search________________________________________________________________________________________________________*/
    /**
* This method will returning Contacts based on Phone,First Name ,Mailing Street or Last Name Or Email [Search on combination basis also]
* @Developer :Ishita Sharma
**/
    public list<contact> contactSearch(){
        try{  
            ResidentialFromURL1 = ApexPages.currentPage().getParameters().get('ResidentialFlagFromURL');
            system.debug('ConfirmationNo...'+ConfirmationNo);
            system.debug('ResidentialFromURL1...'+ResidentialFromURL1);
            if(ResidentialFromURL1!=null){
                ResidentialFromURL=Boolean.valueOf(ResidentialFromURL1);
            }
            String searchTerms = '';
            String rId = Apexpages.currentpage().getparameters().get('searchbutton');
            
            if(searchId=='true'){
                Contact.Phone=Contact.Phone;  
            }
            else{
                Contact.Phone=ApexPages.currentPage().getParameters().get('phoneFromURL1');
                
            }
            //Form search terms based on Input from User
            if(Contact.LastName!=null){
                searchTerms = searchTerms + '("' + Contact.LastName + '")';
            }
            if(Contact.Phone!=null && Contact.Phone!=''){
                if(!String.isEmpty(searchTerms)){
                    searchTerms += ' OR ';
                }
                searchTerms += '("' + Contact.Phone + '")';
            }
            
            
            if(Contact.MailingPostalCode!=null){
                if(!String.isEmpty(searchTerms)){
                    searchTerms += ' OR ';
                }
                searchTerms += '("' + Contact.MailingPostalCode + '")';
            }
            
            if(Contact.firstname!=null){
                if(!String.isEmpty(searchTerms)){
                    searchTerms += ' OR ';
                }
                searchTerms += '("' + Contact.firstname + '")';
            }
            if(Contact.mailingStreet!=null){
                if(!String.isEmpty(searchTerms)){
                    searchTerms += ' OR ';
                }
                searchTerms += '("' + Contact.mailingStreet + '")';
            }
            if(Contact.Email!=null){
                if(!String.isEmpty(searchTerms)){
                    searchTerms += ' OR ';
                }
                searchTerms += '("' + Contact.Email + '")';
            }
            
            PhoneNo2 = Contact.Phone;
            system.debug('-c--'+ PhoneNo2);
            getPHDBContactInfo1(contact.Lastname,contact.mailingStreet,PhoneNo2,contact.MailingPostalcode,contact.FirstName,contact.MailingCity,ConfirmationNo,contact.Email); 
            // SOSL Query Returning all results based on Serch terms From Internal SFDC contacts
            if( searchTerms.length() >1){
                contactResults=(List<contact>)[FIND :searchTerms RETURNING Contact(Id,Recordtype.name, FirstName,Name,Lastname, Email,HomePhone,Otherphone, Phone,Mobilephone,mailingStreet,
                                                                                   MailingCity,MailingState,MailingCountry,MailingPostalcode,AccountId,Account.Name)][0];
                
                if(null != contactResults && contactResults.size() > 0){
                    Results = getAllResults();
                }
            } 
            
            //Show  message on Page if no contacts exist in the system with matching search Term
            if(null == contactResults || contactResults.size() == 0 || searchTerms.length() <=1){
                Results=new List<ContactWrapper>();
                Results.clear(); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Contacts Found in the internal system for the Entered Search Criteria/No Search Criteria Entered '));
            }
            //Invoke PHDB Service Method, return matching results from PHDB service
            getPHDBContactInfo(contact.Lastname,contact.mailingStreet,Contact.Phone,contact.MailingPostalcode,contact.FirstName,contact.MailingCity,ConfirmationNo,contact.Email);  
            
        }
        
        Catch(Exception e){
            If(e.getMessage().contains('search term must be longer than one character')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Contacts Found in the internal system for the Entered Search Criteria/No Search Criteria Entered '));     
            }  
        } 
        return null;
    }
    
    /* ______________________________________________________Methods Returning wrapper Records and populating the same________________________________________________________________________________________________________*/
    
    /**
* This method returns Wrapper List of Contacts 
* @Developer :Ishita Sharma
**/
    
    public List<ContactWrapper> getAllResults() {
        contactWrapperList = new List<ContactWrapper>();
        for(Contact con : contactResults){
            contactWrapperList.add(new ContactWrapper(con,false));
        }
        return contactWrapperList;
    }
    
    /**
* This method Populates details of Wrapper Records in Contact Input Section 
* @Developer :Ishita Sharma
**/
    public void populateDetails(){
        //contact = new Contact();
        if(null != uniqueContactId ){
            contact = [select Id, FirstName,Lastname,Recordtype.name,HomePhone,Otherphone,phone,Email,Mobilephone,mailingStreet,MailingCity,MailingState,
                       MailingCountry,MailingPostalcode from Contact where id =: uniqueContactId Limit 1 ];
            selectedCaseType=null;
            if(contact.Recordtype.name=='Residential Contact'){
                IsResidentialReadOnly= true;
                IsResidential = true;
            }
            else{
                IsResidentialReadOnly=true;
                IsResidential = false;
            }
            
        }
    }
    
    /* ______________________________________________________Fetch Case Type methods based on Profile_________________________________________________________________________________________________________*/
    
    /**
* This method  Fetches All Case Record Types which are active
* @Developer :Ishita Sharma
**/
    public static List<String> GetAvailableRecordTypeNamesForSObject(Schema.SObjectType objType) {
        List<String> names = new List<String>();
        List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
        if (infos.size() > 1) {
            for (RecordTypeInfo i : infos) {
                if (i.isAvailable()) {
                    names.add(i.getName());
                }
            }
        } 
        // Otherwise there's just the Master record type,
        // so add it in, since it MUST always be available
        else names.add(infos[0].getName());
        return names;
    }
    
    
    /**
* This method  Fetches All Case Types which are active
* @Developer :Ishita Sharma
**/
    public List<selectOption> getCaseType() {
        List<String> availableCaseTypes =GetAvailableRecordTypeNamesForSObject(Case.SObjectType);
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', '- None -')); 
        
        for (RecordType recordtype : [SELECT Id, Name FROM RecordType where SobjectType = 'Case' AND IsActive = TRUE AND Name in:availableCaseTypes]) { 
            options.add(new selectOption(recordtype.id, recordtype.Name)); 
            
            
        }
        return options; //return the picklist options
    }
    
    /* ______________________________________________________Reset Methods___________________________________________________________________________________________________________*/
    
    /**
* Method resetting all Contact input
* @Developer :Ishita Sharma
**/
    public void clearDetails(){
        /*Clearing Account details on Reset*/
        account  = new Account();
        contact = new Contact();
        //Changed to United States from USA, Reference Defect ID is DEF0000524
        contact.MailingCountry='United States';
        IsResidentialReadOnly=false;
        if(ResidentialFromURL!=null){
            IsResidential=ResidentialFromURL;
        }
        else{
            IsResidential=True;
        }
        selectedCaseType=null;
        ConfirmationNo='';
        
    }
    
    /*clearContact : Method resetting all Contact input along with Wrapper contact records */
    public void clearContact(){
        contact = new Contact();
        Results.clear();
        contactWrapperList.clear();
        
    }
    
    /* ______________________________________________________Wrapper Class_______________________________________________________________________________________________________________*/
    
    /*Wrapper Class */
    public class ContactWrapper{
        public Contact contactRec {get;set;}
        public boolean isSelected {get;set;}
        
        /*Wrapper Constructor */
        public ContactWrapper(Contact contactRec, boolean isSelected){
            this.contactRec = contactRec;
            this.isSelected = isSelected;
        }
    }
    
    
    
    /* *********************************************************************************************************************************************************************************************
********************************************************************PHDB Integration Code********************************************************************************************************************************
**********************************************************************************************************************************************************************************************/
    
    /**
* This method will call the PHDB webservice which fetches the contact details.
* @Parameters - String Lastname,String Street,String Phone, String PostalCode,String FirstName,String City
* @Developer :Ishita Sharma
**/
    public void getPHDBContactInfo(String Lastname, String Street,String Phone,String PostalCode,String FirstName,String City,String ConfirmationNo, String email){
        
        PHDBContactsInfo=new List<PHDBInfoWrapper>();
        getPHDBInfo(Lastname,Street,Phone,null,PostalCode,firstName,City,ConfirmationNo,email);
        
    }
    
    public void getPHDBContactInfo1(String Lastname, String Street,String PhoneNo2 ,String PostalCode,String FirstName,String City,String ConfirmationNo, String email){
        
        PHDBContactsInfo=new List<PHDBInfoWrapper>();
        getPHDBInfo(Lastname,Street,null,PhoneNo2,PostalCode,firstName,City,ConfirmationNo,email);
        
    }
    
    private void getPHDBInfo(String Lastname, String Street,String Phone,String PhoneNo2 , String PostalCode,String FirstName,String City,String ConfirmationNo,String email) { 
        
        try{
            Integer Count=0;
            lstDisNum=new List<PHDBInfoWrapper>();
            String response = new CCC_IntegrationHelper().getPHDBInformation( Lastname,  Street, Phone,PhoneNo2 ,  PostalCode, FirstName, City,null,ConfirmationNo,null,null,null,null,email,null,null);
            PHDBInfoWrapper ob1=(PHDBInfoWrapper)JSON.deserialize(response,PHDBInfoWrapper.class);
            lstDisNum.add(ob1);
            PHDBContactsInfo=new List<PHDBInfoWrapper>();
            if(lstDisNum != null) {
                for (PHDBInfoWrapper wrapper :lstDisNum) {
                    if(wrapper!=null){
                        PHDBContactsInfo.addAll(wrapper.registrationDataResults);
                        if(PHDBContactsInfo == null || PHDBContactsInfo.size()==0){
                            system.debug('---------->1');
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Contacts Found in the PHDB '));
                        }
                        
                    }
                    if(wrapper == null ){
                        system.debug('---------->2');
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Contacts Found in the PHDB '));
                        
                    }
                } 
            }
            PHDBContactsInfoFinal = new List<PHDBInfoWrapper>();
            for(PHDBInfoWrapper wrapper1:PHDBContactsInfo){
                
                wrapper1.wrapperid=String.valueOf(count);
                
                PHDBContactsInfoFinal.add(wrapper1);
                count++;
            }
            if(lstDisNum == null || lstDisNum.size()==0){
                system.debug('---------->3');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Contacts Found in the PHDB '));
            }
            
        }catch(System.CalloutException e) {
            errlog.ErrorLogCalloutException(e,'PHDB WebService','CCC_CTIContactPageController');
            system.debug('---------->4');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Contacts Found in the PHDB '));
            
        }
        
        Catch(Exception e){
            system.debug('---------->5');
            //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
            errlog.ErrorLogException(e,'PHDB WebService','CCC_CTIContactPageController');
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Contacts Found in the PHDB '));
        }
        
    }
    
    
    /**
* This method will Populate details of Wrapper Records in Contact Input Section
* @Developer :Ishita Sharma
**/
    
    public void populateDetailsPHDB(){
        cleardetails();
        if(lstDisNum != null) {
            for (PHDBInfoWrapper a :PHDBContactsInfo) {
                if(a.wrapperid == PHDBRecordid){ 
                    
                    contact.MailingStreet=a.consumer_Address1;
                    String Firstnamestr=a.consumer_Name;
                    String[] Firstnamestrsplit=Firstnamestr.split(',');
                    contact.FirstName=Firstnamestrsplit[0];
                    contact.LastName=Firstnamestrsplit[1];
                    contact.MailingPostalcode=a.consumer_Zip;
                    contact.MailingState=a.consumer_State;
                    contact.MailingCountry=a.consumer_Country;
                    contact.phone=a.consumer_Phone1;
                    contact.MailingCity=a.consumer_City;
                    contact.Email=a.consumer_Email;
                    ConfirmationNo =a.confirmationNumber;
                    IsResidentialReadOnly=False;
                    IsResidential=true;
                    
                } 
                
            }
        }
    }
    /*______________________________________________Wrapper class for PHDB__________________________________________________________________________________________________*/
    //wrapper Class for reponse
    public class PHDBInfoWrapper {
        public String consumer_Name{get;set;}
        public string consumer_Address1{get;set;}
        public String consumer_City {get;set;}
        public string serial{get;set;}
        public String consumer_State {get ; set;}
        public String consumer_Country {get ; set;}
        public String consumer_Zip{get;set;}
        public String consumer_Phone2{get;set;}
        public String consumer_Phone1{get;set;}
        public String consumer_Email{get;set;}
        public String model{get;set;}
        public String consumer_BusinessName{get;set;}
        public string consumer_Address2{get;set;}
        public String equip_Address1 {get;set;}
        public string equip_Address2{get;set;}
        public String equip_City {get ; set;}
        public String equip_State {get ; set;}
        public String equip_Country{get;set;}
        public String equip_Zip{get;set;}
        
        public String dealerName {get;set;}
        public string dealerPhone{get;set;}
        public String mfgAcctNum {get ; set;}
        public String serviceBenchID {get ; set;}
        public String hvacpId{get;set;}
        public String equip_Description{get;set;}
        public String registrationNumber{get;set;}
        public String confirmationNumber{get;set;}
        public String source{get;set;}
        public String comments{get;set;}
        public boolean selected {get;set;}
        public String wrapperid{get;set;}
        public PHDBInfoWrapper wraperRecord;
        public list<PHDBInfoWrapper> registrationDataResults{get;set;}
        public Contact contactRec {get;set;}
        
        public PHDBInfoWrapper(Contact contactRec, boolean isSelected){
            this.contactRec = contactRec;
            this.selected = isSelected;
        }
        
    }
    
    public String getAccountName(Contact cont){
        String nameToReturn = 'Residential - ';
        String differentiator = ',';
        if((cont.MailingStreet!=null && cont.MailingStreet.length()>0) || (cont.MailingCity!=null && cont.MailingCity.length()>0) || (cont.MailingState!=null && cont.MailingState.length()>0) /*|| (cont.MailingPostalCode!=null && cont.MailingPostalCode.length()>0) || (cont.MailingCountry!=null && cont.MailingCountry.length()>0)*/){
            if(cont.MailingStreet!=null && cont.MailingStreet.length()>0){
                nameToReturn = nameToReturn + cont.MailingStreet;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingCity!=null && cont.MailingCity.length()>0){
                nameToReturn = nameToReturn + cont.MailingCity;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingState!=null && cont.MailingState.length()>0){
                nameToReturn = nameToReturn + cont.MailingState;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingPostalCode!=null && cont.MailingPostalCode.length()>0){
                nameToReturn = nameToReturn + cont.MailingPostalCode;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingCountry!=null && cont.MailingCountry.length()>0){
                nameToReturn = nameToReturn + cont.MailingCountry;
                nameToReturn = nameToReturn + differentiator;
            }
            if(nameToReturn!=null && nameToReturn.length()>0 && nameToReturn.endsWith(differentiator)){
                nameToReturn = nameToReturn.substring(0, nameToReturn.lastIndexOf(differentiator));
            }
            
        }else if(cont.LastName!=null && cont.LastName.length()>0){
            nameToReturn = nameToReturn + cont.LastName;
            nameToReturn = nameToReturn + differentiator;
            if(cont.MailingPostalCode!=null && cont.MailingPostalCode.length()>0){
                nameToReturn = nameToReturn + cont.MailingPostalCode;
                nameToReturn = nameToReturn + differentiator;
            }
            if(cont.MailingCountry!=null && cont.MailingCountry.length()>0){
                nameToReturn = nameToReturn + cont.MailingCountry;
            }
            if(nameToReturn!=null && nameToReturn.length()>0 && nameToReturn.endsWith(differentiator)){
                nameToReturn = nameToReturn.substring(0, nameToReturn.lastIndexOf(differentiator));
            }
        }
        
        return nameToReturn;
    }
    public PageReference SaveContactandAccount() {
        Id RecordtypeIdacc; 
        Id RecordtypeIdcontact;
        String accountName;
        system.debug('ConfirmationNo...'+ConfirmationNo);
        try {
            
            String Recordtypename,SobjectType;
            if (contact.Lastname == null || contact.Lastname == '')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the Last Name to Proceed Further'));
                return null;
            }
            /*if(selectedCaseType == null ){
                apexpages.addmessage(new apexpages.message(ApexPages.severity.ERROR,'Please Select Case Type'));
                return null;       
            }*/
            if (contact.Phone == null || contact.Phone == '')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the Phone No. to Proceed Further'));
                return null;
            }
            if (contact.mailingPostalCode == null || contact.mailingPostalCode == '')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the Postal/Zip Code to Proceed Further'));
                return null;
            }
            
            /* If Is residential Checkbox is checked*/
            if(isResidential) {
                system.debug('isResidential...'+isResidential);
                RecordtypeIdacc =GetrecordtypeId('Residential Address','Account').id;
                RecordtypeIdcontact=GetrecordtypeId('Residential Contact','Contact').Id;
                
                //account=new account();
                
        
                if(Contact.Id == null)
                {
                    /*Create Account */
                    accountName='Residential'+contact.MailingPostalcode;
                    accountName = this.getAccountName(contact);
                    account.Name=accountName;
                    account.BillingCountry=contact.MailingCountry;
                    account.BillingState=contact.MailingState;
                    account.BillingCity=contact.MailingCity;
                    
                    //Below logic to find a country based on zip code
                    // DEF0000762
                    
                    String tempPostalCode = contact.MailingPostalcode;
                    boolean alpha = false;
                    List<String> chars = tempPostalCode.split('|');
                    for (String s : chars)
                    {
                        if (s.isAlpha())
                        {
                            alpha = true;
                            break;
                        }
                    } 
                    
                    //Ends the logic here              
                    
                    if(alpha)
                    {
                        account.BillingPostalCode=contact.MailingPostalcode;
                        account.ShippingPostalcode=contact.MailingPostalcode;
                        account.BillingCountry='Canada';
                        account.ShippingCountry='Canada';
                        contact.MailingCountry='Canada';
                    }
                    else
                    {
                        account.BillingPostalCode=contact.MailingPostalcode;
                        account.ShippingPostalcode=contact.MailingPostalcode;
                        account.BillingCountry=contact.MailingCountry;
                        account.ShippingCountry=contact.MailingCountry;
                    }
                    
                    
                    account.BillingStreet=contact.MailingStreet;
                    account.ShippingState=contact.MailingState;
                    account.ShippingCity=contact.MailingCity;
                    account.ShippingStreet=contact.MailingStreet;
                    account.RecordTypeID=RecordtypeIdacc;
                    upsert(account);
                    
                    /*Create Contact */
                    contact.RecordTypeID=RecordtypeIdcontact;
                    if(account.Id != null)
                    {
                        contact.AccountId=account.Id;
                    }
                    system.debug('@@@@@@@@@'+Contact.Id);
                    contact.RecordTypeID=RecordtypeIdcontact;
                    upsert(contact);
                    
                    system.debug('------->'+Contact.Id);
              
                }
                
                
                
                
                
                
                /*Open Case View Page */
                
                //PageReference redirectSuccess = new ApexPages.StandardController(contact).view();
                //redirectSuccess.setRedirect(true);
                //return (redirectSuccess);
                return new PageReference('/'+contact.id);
                
            } 
            /* If Is residential Checkbox is  not checked*/
            else{
                RecordtypeIdcontact=contact.RecordTypeID=GetrecordtypeId('Non-Residential Contact','Contact').Id;
                contact.RecordTypeID=RecordtypeIdcontact;
                upsert(contact);
               /* PageReference redirectSuccess = new ApexPages.StandardController(contact).view();
                redirectSuccess.setRedirect(true);*/
                return new PageReference('/'+contact.id);
                
            }
            
            
        }catch(System.DMLException e) {
            /* Insert error record for each exception caught */
            CCC_Error_log__c log = new CCC_Error_log__c (CCC_Source__c='CTI Contact Page' ,CCC_Line_no__c= e.getLineNumber(), 
                                                         CCC_Message__c = e.getMessage(),CCC_Type__c= e.getTypeName(),
                                                         CCC_Stack_Trace__c= e.getStackTraceString(),
                                                         CCC_Additional_Information__c='contactName ='+' '+contactName+'Case Id ='+' '+caseName); 
            Insert log;
            return null;
        }
        
    }
}