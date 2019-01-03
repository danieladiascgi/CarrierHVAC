public class SearchContact {
    Public String accountId {get; set;}    
    Public list <Contact> conList {get;set;}        
    Public List<List<SObject>> findContact  {get;set;} 
    Public list<wrapcontact> wrapcontactList { get; set; }
    Public list<contact> selectedcontacts{get;set;}
    //Public double ZipCode{get;set;}
    Public String ZipCode{get;set;}
    Public String searchstring {get;set;}
    Public String conid {get;set;}
    Public String  queryStr {get;set;}    
    Public list <Account> accList {get;set;} 
    Public String caseid{get;set;}
    Public  List<Contact> contactList {get;set;} 
    Public  Boolean isSuccess{get;set;}
    Public Boolean isNotShow {get;set;}
    Public Boolean isShow {get;set;}
    Public String ConEmail{get;set;} 
    Public String CEmail{get;set;}    
    Public Boolean isSingleContact{get;set;}
    Public String FirstName{get;set;}
    Public String LastName{get;set;}
    Public String Email{get;set;}
    Public String selected{get;set;}
    Public String Phone{get;set;}
    Public String Fax{get;set;}
    Public String MailingStreet{get;set;}
    Public String MailingCity{get;set;}
    Public String MailingState{get;set;}
    Public String MailingCountry{get;set;}
    Public String MobilePhone{get;set;}
    Public String MailingPostalCode{get;set;}
    list<contact> editConRole = new list<contact>();   
    public string selected1{get;set;}
    Public Boolean isInternalUser{get;set;}
    Public String BillingCity{get;set;}
    Public String BillingState{get;set;}
    Public String BillingCountry{get;set;}
    public String BillingStreet{get;set;}
    public String Name{get;set;}
    Public String Site{get;set;}
    Public String Type{get;set;}
    Public Contact cnt{get;set;}
    Public Boolean displayAccount {get; set;}  
    Public Boolean display {get; set;} 
    Public Boolean display1 {get; set;} 
    Public Boolean display2 {get; set;}
    Public Boolean UpdateAccountFlag {get; set;} 
    Public Boolean UpdateCreateAccountFlag {get; set;}
    Public Boolean conSearch {get; set;}           
    public String contactid {get; set;}
    public boolean flag {get;set;}
    /*Contact search using Conf number*/
    Public string ConfirmationNo {get;set;}
    Public string searchId {get;set;}
    public List<Contact> contactResults;
    Public string PhoneNo2 {get;set;}
    public List<ContactWrapper> Results{get;set;}
    public List<ContactWrapper> contactWrapperList;
    CCC_ErrorLog errlog=new CCC_ErrorLog();
    public Account account { get; set; }
    public Contact contact { get; set; }
    // public Case caseobj { get; set; }
    String contactName = null;
    
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
    public Boolean ShowPHDBResult{get;set;}
    public Boolean PHDBContact{get;set;}
    
    Public SearchContact(ApexPages.StandardController stdController){     
        /* query = ApexPages.currentPage().getParameters().get('nameValue');
if(query!=null && query.length()>0){
runQuery();
}
show=false;*/
        System.debug('@conid:'+conid);
        isSingleContact=false;                   
        conSearch = true;
        flag=false;
        displayAccount = false;
        display=true;
        display1=false;
        display2=false;
        UpdateAccountFlag = false;
        ShowPHDBResult=true;
        PHDBContact=false;
        cnt = new Contact();
        isShow=true;
        String stage =System.label.System_Email_for_Duplicate_Contact;
        System.debug('@custom:'+stage);
        string email='';
        List<String> emaillist = new List<String>();
        List<String> emailListFinal = new List<String>();
        Boolean flag = false;
        if(stage != '' && stage != null){
            email = stage;
            emaillist = email.split(';');
        }
        System.debug('@emaillist:'+emaillist);
        
        for (integer i = 0; i < emaillist.size(); i++) {
            // emailListFinal.add('\''+ emaillist[i] + '\''); 
            emailListFinal.add( emaillist[i] );
        }
        System.debug('@emailListFinal:'+emailListFinal);
        wrapcontactList =new list<wrapcontact>();
        CaseId=apexpages.currentPage().getparameters().get('id');
        
        if(CaseId != null && CaseId.length()>0)
        {
            // List<Contact> contactList1 = new List<Contact>();
            case c=[Select Id,ContactId,AccountId, SuppliedEmail from case where id=:caseid];
            System.debug('#SuppliedEmail:'+c.SuppliedEmail);
            
            //String searchstring = c.SuppliedEmail;
            
            if(c.ContactId!=null){
                Contact con = [Select Id,Name,Email from Contact where Id=:C.ContactId];
                if(con.Email!=null && con.Email!=''){
                    
                    ConEmail=con.Email;
                }else{
                    if(c.SuppliedEmail!=null && c.SuppliedEmail!=''){
                        ConEmail=c.SuppliedEmail;
                    } 
                }
            }else{
                if(c.SuppliedEmail!=null && c.SuppliedEmail!=''){
                    ConEmail=c.SuppliedEmail;
                }
            }
            /*Contact Search using Conf# number*/
            account = (c.AccountId == null) ? new Account() : [SELECT Name, Phone, BillingCountry FROM Account WHERE Id = :c.AccountId];
                contact = (c.ContactId == null) ? new contact() : [SELECT firstName,lastName,Phone,Otherphone,HomePhone,mobilephone,mailingStreet,email,MailingCity,MailingState,
                                                                   MailingCountry,MailingPostalcode,RecordTypeId FROM Contact WHERE Id = :c.ContactId];
                                                                       
                                                                       //Changed to United States from USA, Reference Defect ID is DEF0000524
                                                                       contact.MailingCountry='United States';
            contactName=contact.firstName+' '+contact.lastName;
            
            /*--------------------Contact Search using Conf# number end --------------------------*/
            
            if(c.SuppliedEmail!=null && c.SuppliedEmail!=''){
                //ConEmail=c.SuppliedEmail; 
                string mail =c.SuppliedEmail;
                System.debug('mail:'+mail);
                for(string str:emailListFinal){
                    system.debug(str+'-'+mail); 
                    // if(str!=null && str!=''){
                    if(str==mail){ 
                        System.debug('inside if:');
                        CEmail='';
                        system.debug('CEmail:'+CEmail); 
                        //break;
                        
                    } 
                    else{
                        system.debug('Else:');                        
                        
                        CEmail=mail;
                        system.debug('CEmail:'+CEmail);                        
                        
                        //break;
                    }
                    // }
                    if(CEmail==''|| CEmail==null)
                    {
                        break;
                        system.debug('after break');
                    }
                }
            }
            if(c.ContactId!=null){
                Contact conn = [Select Id,Name,Email from Contact where Id=:C.ContactId];
                if(conn.Email!=null && conn.Email!=''){
                    findContact= [FIND :conn.Email IN Email Fields RETURNING Contact(name)]; 
                    contactList = ((List<Contact>)findContact[0]);                       
                    system.debug('@findContact'+contactList);
                }else{
                    if(c.SuppliedEmail!=null && c.SuppliedEmail!=''){
                        string m=c.SuppliedEmail;
                        for(string str1:emailListFinal){
                            system.debug(str1+'-'+m); 
                            // if(str!=null && str!=''){
                            if(str1==m){ 
                                System.debug('inside if:');
                                ConEmail='';
                                system.debug('ConEmail:'+CEmail); 
                                //break;
                                
                            } 
                            else{
                                system.debug('Else:');                        
                                
                                ConEmail=m;
                                system.debug('ConEmail:'+ConEmail);                        
                                
                                //break;
                            }
                            // }
                            if(ConEmail==''|| ConEmail==null)
                            {
                                break;
                                system.debug('after break');
                            }
                            
                            findContact= [FIND :c.SuppliedEmail IN Email Fields RETURNING Contact(name)]; 
                            contactList = ((List<Contact>)findContact[0]);                       
                            system.debug('@findContact'+contactList); 
                        }
                    }
                }
            }else{
                
                if(c.SuppliedEmail!=null && c.SuppliedEmail!=''){ 
                    string m=c.SuppliedEmail;
                    for(string str1:emailListFinal){
                        system.debug(str1+'-'+m); 
                        // if(str!=null && str!=''){
                        if(str1==m){ 
                            System.debug('inside if:');
                            ConEmail='';
                            system.debug('ConEmail:'+ConEmail); 
                            //break;
                            
                        } 
                        else{
                            system.debug('Else:');                        
                            
                            ConEmail=m;
                            system.debug('ConEmail:'+ConEmail);                        
                            
                            //break;
                        }
                        // }
                        if(ConEmail==''|| ConEmail==null)
                        {
                            break;
                            system.debug('after break');
                        }
                        
                        findContact= [FIND :c.SuppliedEmail IN Email Fields RETURNING Contact(name)]; 
                        contactList = ((List<Contact>)findContact[0]);                       
                        system.debug('@findContact'+contactList); 
                    }
                }
            }
            if(contactList!=null && contactList.size()>0){
                System.debug('Inside if');
                List<Contact> conlist = [select id,FirstName,LastName,email,RecordTypeId,CCC_Account_Address__c,Account.name,Account.RecordTypeId,Account.IsPartner,Phone from contact where id=:contactList order by LastModifiedDate desc];
                System.debug('#Con List:'+conlist);
                for(contact eachCont: conlist){
                    wrapcontactList.add(new wrapcontact(eachCont));
                }
            }
            system.debug('wrapcontactList'+wrapcontactList);
            
        }
    }
    
    Public void SearchResult(){ 
        Case c = new case();       
        conList = New List<contact>();
        wrapcontactList =new list<wrapcontact>();       
        if(ConEmail.length() > 1){
            String searchstring = ConEmail; 
            String searchQuery = 'FIND \'' + searchstring + '\' IN ALL FIELDS RETURNING Contact(id),Account(id) limit 10';
            List<List <sObject>> searchList = search.query(searchQuery);
            conList  = ((List<contact>)searchList[0]);
            // cnt1=[select FirstName,LastName,email,RecordTypeId,CCC_Account_Address__c,Account.name,Account.RecordTypeId,Account.IsPartner from contact where id=:conlist ];
            for(contact c1:[select FirstName,LastName,email,id,RecordTypeId,CCC_Account_Address__c,Account.name,Account.RecordTypeId,Account.IsPartner from contact where id=:conlist order by LastModifiedDate desc]){
                wrapcontactList.add(new wrapcontact(c1));
                System.debug('@result'+wrapcontactList);
            }
            if( conList.size() == 0 ){
                ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sorry, no results found'));
                return;
            }
        }
        else{
            ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
            return;
        }
        
        
    }
    
    Public list<contact> ProcessSelected(){
        list<contact> selectedContacts1=new list<contact>();        
        for(wrapcontact wrapobj:wrapcontactlist){
            if(wrapobj.isSelected==true){
                selectedcontacts1.add(wrapobj.conn);              
            }
            
        }return selectedcontacts1;
    }
    
    Public void Save(){
        isShow=true;
        isNotShow=false;
        list<contact>selectedContacts2=new list<contact>();  
        selectedcontacts2= ProcessSelected();
        System.debug('#selectedcontacts2:'+selectedcontacts2);
        if(selectedcontacts2!=null && selectedcontacts2.size()==1){
            isSingleContact=true;
            System.debug('#isSingleContact:'+isSingleContact);
            Case cse=[select contactid,id,accountid from case where id=:caseid];
            System.debug('@id'+caseid);
            cse.ContactId= selectedcontacts2[0].id;            
            Contact ct=[select id,Accountid from contact where id=:selectedcontacts2[0].id];
            if(ct.AccountId!=null || ct.AccountId!=''){
                cse.AccountId=ct.AccountId;
            }
            update cse;          
            System.debug('@id'+cse.ContactId);
            
        } 
        
        /* String str = ApexPages.currentPage().getUrl().subStringAfter('/').substringBefore('?');
return new PageReference('/apex/' + str).setRedirect(true); 
Pagereference pr = New PageReference(ApexPages.currentPage().getURL());
pr.setRedirect(true);*/
        
    }
    
    Public void CreateTicket(){
        isShow=true;
        isNotShow=false;
        
        // list<contact> insertedlist = new list<contact>();
        list<Duplicate_Contact_Records__c> insertedlist1 = new list<Duplicate_Contact_Records__c>();
        list<contact>selectedContacts3=new list<contact>();  
        selectedcontacts3= ProcessSelected();
        if(selectedContacts3!=null && selectedContacts3.size()>0){
            Defect_Tracker__c dft = new Defect_Tracker__c();
            dft.Category__c='Maintenance';
            dft.Functionality__c='Duplicate Contact';
            dft.Type__c='Duplicate';
            dft.Status__c='Assigned';
            dft.Affected_User__c=UserInfo.getUserId();
            RecordType type =[Select id,Name from Recordtype where Name='Duplicate Contact'];
            dft.RecordTypeId=type.Id;
            System.debug('record'+dft.RecordTypeId);
            insert dft;          
            Defect_Tracker__c ticket =[select id,name from Defect_Tracker__c order by CreatedDate desc limit 1];
            for(contact c2:selectedcontacts3){
                //RecordType rtt = new RecordType();
                //c2.Observation__c=dft.Id;
                Duplicate_Contact_Records__c d = new Duplicate_Contact_Records__c();
                d.Observation__c=dft.id;             
                System.debug('@id'+d.Observation__c);
                d.Email_del__c=c2.Email;
                d.Name__c=c2.Id;
                d.Name=c2.FirstName;
                d.Account_Name__c=c2.account.name;
                // if((MailingStreet!=null && MailingStreet!='') || (MailingCity!=null && MailingCity!='') || (MailingState!=null && MailingState!='') || (MailingCountry!=null && MailingCountry!='')){
                d.Account_Address__c=c2.CCC_Account_Address__c;
                d.Partner_Account__c=c2.account.IsPartner;
                if(c2.RecordTypeId!=null  &&  c2.account.RecordTypeId!=null){                
                    RecordType rc=[Select Id,Name from RecordType where Id=:c2.RecordTypeId];
                    RecordType rt=[Select Id,Name from RecordType where Id=:c2.account.RecordTypeId];
                    d.Account_Record_Type__c=rt.Name;
                    d.Contact_Record_Type__c=rc.Name;
                    System.debug('@name'+d.Account_Record_Type__c);
                }
                insertedlist1.add(d);
                // insertedlist.add(c2);
                
            }
            // update insertedlist;
            insert insertedlist1;
            ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Ticket has been raised Succesfully!! Ticket Number:'+ticket.Name));
            return;
            
        }     
        /*Pagereference pr = New PageReference(ApexPages.currentPage().getURL());
pr.setRedirect(true);
String url = '/apex/SearchContact_Msg';
PageReference pr = new PageReference(url);
return pr;*/
        
        
    }
    
    Public class wrapcontact{
        public contact conn{get;set;}
        public boolean isSelected{get;set;}
        public wrapcontact(contact c){
            conn=c;
            isSelected=false;
        }
    }
    
    Public List<SelectOption> getRecordType() {
        List<SelectOption>RecordType = new List<SelectOption>();
        RecordType.add(new SelectOption('Residential Contact','Residential Contact'));  
        RecordType.add(new SelectOption('Non-Residential Contact','Non-Residential Contact')); 
        return RecordType;      
    }
    
    Public void Cancel(){
        isShow=true; 
        isNOTShow=false; 
    }
    
    
    Public PageReference valueChanged(){
        list<contact> cse2=[SELECT id,accountid,FirstName,LastName,Phone,Fax,MailingStreet,RecordType.Name,MailingCity,MailingState,MailingCountry,MailingPostalCode,MobilePhone,account.RecordTypeId FROM contact where id=:selected1 limit 1];
        System.debug('selected1'+selected1);
        System.debug('updated:'+cse2);       
        list<contact> toupdate=new  list<contact>();
        //  System.debug('edit1.RecordType.Name:'+cse2[0].RecordType.Name);    
        //  System.debug('account.RecordTypeId:'+cse2[0].account.RecordTypeId);    
        for(Contact edit1:cse2){
            if(edit1.account.RecordTypeId != null){
                RecordType rt2=[select id,name from RecordType where name=:edit1.RecordType.Name];
                RecordType rt3=[select id,name from RecordType where id=:edit1.account.RecordTypeId];
                
                // System.debug('@record1:'+edit1.account.RecordType.id);           
                
                if((rt3.id!=null || rt3.id!='') && conid!=null){ 
                    System.debug('@record:'+rt2);
                    if(rt3.Name=='Residential Address' ){
                        
                        if(this.selected=='Non-Residential Contact'){
                            //flag=true;
                            ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'RecordType cannot be changed!!'));
                        }
                    }
                    else if(rt3.Name=='Partner' || rt3.Name=='Customer'){
                        
                        if(this.selected=='Residential Contact'){
                            //flag=true;
                            ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'RecordType Cannot be changed!!')); 
                        }
                    }
                    else{}
                    
                }
            }
        }
        //Get account Record Type check if it is from Edit.
        //if account Record type is Residential and Selectd is Non-Residential then show a Apex.pageMessage error
        if(selected == 'Non-Residential Contact'){
            //displayAccount = true;
            display= false;
            display1=true;
        }
        
        if(selected == 'Residential Contact') {
            // displayAccount = false;
            display= true;
            display1=false;           
        }
        
        if(selected == 'Residential Contact' && display2==true) {
            // displayAccount = false;
            display= false;
            display1=false;            
        }
        if(selected == 'Non-Residential Contact' && display2==true) {
            // displayAccount = false;
            display= false;
            display1=false;
            
        }
        
        
        return null;
    } 
    
    Public  void SaveContact(){
        isShow=false;
        isNotShow=true; 
        PHDBContact=false;
        if(LastName!=null && LastName.length()>0){
            system.debug('inside SaveContact');
            System.debug('selected'+selected);
            RecordType rd= [Select Id,Name from RecordType where Name=:selected]; 
            Case cse1=[select contactid,id,SuppliedEmail from case where id=:CaseId limit 1];
            Account acct = new Account();
            String nameToReturn = 'Residential - ';
            String differentiator = ',';
            if(selected=='Residential Contact'){
                system.debug('inside if');
                if((MailingStreet==null || MailingStreet=='') && (MailingCity==null || MailingCity=='') && (MailingState==null || MailingState=='') && (MailingCountry==null || MailingCountry=='')&& (MailingPostalCode==null || MailingPostalCode=='') ){
                    system.debug('inside else');  
                    acct.Name='Residential-'+LastName+'-'+CEmail;
                    acct.RecordTypeId = [Select Id, Name from RecordType where sobjectType='Account' and Name='Residential Address'].Id;
                    system.debug('acct.Name'+acct.Name);
                    system.debug('acct.RecordTypeId'+acct.RecordTypeId);
                    
                } 
                else if(MailingStreet!=null || MailingStreet!='' || MailingCity!=null || MailingCity!='' || MailingState!=null || MailingState!='' || MailingCountry!=null || MailingCountry!=''|| MailingPostalCode!=null || MailingPostalCode!=''){
                    if(MailingStreet!=null && MailingStreet.length()>0){
                        nameToReturn = nameToReturn + MailingStreet;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    if(MailingCity!=null && MailingCity.length()>0){
                        nameToReturn = nameToReturn + MailingCity;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    if(MailingState!=null && MailingState.length()>0){
                        nameToReturn = nameToReturn + MailingState;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    
                    if(MailingCountry!=null && MailingCountry.length()>0){
                        nameToReturn = nameToReturn + MailingCountry;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    if(MailingPostalCode!=null && MailingPostalCode.length()>0){
                        nameToReturn = nameToReturn + MailingPostalCode;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    if(nameToReturn!=null && nameToReturn.length()>0 && nameToReturn.endsWith(differentiator)){
                        nameToReturn = nameToReturn.substring(0, nameToReturn.lastIndexOf(differentiator));
                    }
                    acct.BillingStreet=MailingStreet;
                    acct.BillingCity=MailingCity;
                    acct.BillingState=MailingState;
                    acct.BillingCountry=MailingCountry;
                    acct.BillingPostalCode=MailingPostalCode;
                    acct.Phone=Phone;
                    
                    acct.RecordTypeId = [Select Id, Name from RecordType where sobjectType='Account' and Name='Residential Address'].Id;
                    acct.Name=nameToReturn;
                }	
                
                insert acct;
                cnt.AccountId =acct.Id;
                cnt.FirstName=FirstName;
                cnt.LastName=LastName;
                // cnt.Email=cse1.SuppliedEmail;
                cnt.Email=CEmail;
                cnt.Phone=Phone;
                cnt.Fax=Fax;
                cnt.RecordTypeId=rd.Id;
                cnt.MailingStreet=MailingStreet;
                cnt.MailingCity=MailingCity;
                cnt.MailingState=MailingState;
                cnt.MailingCountry=MailingCountry;
                cnt.MailingPostalCode=MailingPostalCode;
                cnt.MobilePhone=MobilePhone;
                system.debug('cnt'+cnt);
                insert cnt;
            }
            if(selected=='Non-Residential Contact'){        
                cnt.FirstName=FirstName;
                cnt.LastName=LastName;
                // cnt.Email=cse1.SuppliedEmail;
                cnt.Email=CEmail;
                cnt.Phone=Phone;
                cnt.Fax=Fax;
                cnt.RecordTypeId=rd.Id;
                cnt.MailingStreet=MailingStreet;
                cnt.MailingCity=MailingCity;
                cnt.MailingState=MailingState;
                cnt.MailingCountry=MailingCountry;
                cnt.MailingPostalCode=MailingPostalCode;
                cnt.MobilePhone=MobilePhone;
                system.debug('cnt'+cnt);
                insert cnt;  
                ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Contact has been created and associated successfully!!'));
                //return;
            }
            System.debug('#CaseId got from url:'+CaseId);
            if(CaseId!=null && CaseId.length()>0){
                Case cse=[select contactid,id,SuppliedEmail,AccountId from case where id=:CaseId];
                cse.ContactId=cnt.Id;
                if(selected=='Residential Contact'){
                    cse.AccountId=acct.Id;  
                }
                update cse; 
                if(selected=='Residential Contact'){ 
                    cse.AccountId=cnt.Id;
                    isSuccess=true;
                }
                
                
            }
        }
        
    }
    
    /*---------------------------------------Save PHDB Contact------------------------------------- */
    Public  void SavePHDBContact(){
        system.debug('****inside SavePHDBContact****');
        isShow=false;
        isNotShow=false; 
        PHDBContact=true;
        if(contact.LastName!=null && contact.LastName.length()>0){
            system.debug('inside SaveContact');
            System.debug('selected'+selected);
            RecordType rd= [Select Id,Name from RecordType where Name=:selected]; 
            Case cse1=[select contactid,id,SuppliedEmail from case where id=:CaseId limit 1];
            Account acct = new Account();
            String nameToReturn = 'Residential - ';
            String differentiator = ',';
            if(selected=='Residential Contact'){
                system.debug('inside if');
                if((contact.MailingStreet==null || contact.MailingStreet=='') && (contact.MailingCity==null || contact.MailingCity=='') && (contact.MailingState==null || contact.MailingState=='') && (contact.MailingCountry==null || contact.MailingCountry=='')&& (contact.MailingPostalCode==null || contact.MailingPostalCode=='') ){
                    system.debug('inside else');  
                    acct.Name='Residential-'+LastName+'-'+CEmail;
                    acct.RecordTypeId = [Select Id, Name from RecordType where sobjectType='Account' and Name='Residential Address'].Id;
                    system.debug('acct.Name'+acct.Name);
                    system.debug('acct.RecordTypeId'+acct.RecordTypeId);
                    
                } 
                else if(contact.MailingStreet!=null || contact.MailingStreet!='' || contact.MailingCity!=null || contact.MailingCity!='' || contact.MailingState!=null || contact.MailingState!='' || contact.MailingCountry!=null || contact.MailingCountry!=''|| contact.MailingPostalCode!=null || contact.MailingPostalCode!=''){
                    if(contact.MailingStreet!=null && contact.MailingStreet.length()>0){
                        nameToReturn = nameToReturn + contact.MailingStreet;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    if(contact.MailingCity!=null && contact.MailingCity.length()>0){
                        nameToReturn = nameToReturn + contact.MailingCity;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    if(contact.MailingState!=null && contact.MailingState.length()>0){
                        nameToReturn = nameToReturn + contact.MailingState;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    
                    if(contact.MailingCountry!=null && contact.MailingCountry.length()>0){
                        nameToReturn = nameToReturn + contact.MailingCountry;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    if(contact.MailingPostalCode!=null && contact.MailingPostalCode.length()>0){
                        nameToReturn = nameToReturn + contact.MailingPostalCode;
                        nameToReturn = nameToReturn + differentiator;
                    }
                    if(nameToReturn!=null && nameToReturn.length()>0 && nameToReturn.endsWith(differentiator)){
                        nameToReturn = nameToReturn.substring(0, nameToReturn.lastIndexOf(differentiator));
                    }
                    
                    acct.RecordTypeId = [Select Id, Name from RecordType where sobjectType='Account' and Name='Residential Address'].Id;
                    acct.Name=nameToReturn;
                }	
                
                insert acct;
                cnt.AccountId =acct.Id;
                cnt.FirstName=contact.FirstName;
                cnt.LastName=contact.LastName;
                cnt.Email=contact.Email;
                cnt.Phone=contact.Phone;
                cnt.Fax=contact.Fax;
                cnt.RecordTypeId=rd.Id;
                cnt.MailingStreet=contact.MailingStreet;
                cnt.MailingCity=contact.MailingCity;
                cnt.MailingState=contact.MailingState;
                cnt.MailingCountry=contact.MailingCountry;
                cnt.MailingPostalCode=contact.MailingPostalCode;
                cnt.MobilePhone=contact.MobilePhone;
                system.debug('cnt'+cnt);
                insert cnt;
            }
            /* if(selected=='Non-Residential Contact'){        
cnt.FirstName=contact.FirstName;
cnt.LastName=contact.LastName;
cnt.Email=cse1.SuppliedEmail;
cnt.Phone=contact.Phone;
cnt.Fax=contact.Fax;
cnt.RecordTypeId=rd.Id;
cnt.MailingStreet=contact.MailingStreet;
cnt.MailingCity=contact.MailingCity;
cnt.MailingState=contact.MailingState;
cnt.MailingCountry=contact.MailingCountry;
cnt.MailingPostalCode=contact.MailingPostalCode;
cnt.MobilePhone=contact.MobilePhone;
system.debug('cnt'+cnt);
insert cnt;  
ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Contact has been created and associated successfully!!'));
//return;
}*/
            System.debug('#CaseId got from url:'+CaseId);
            if(CaseId!=null && CaseId.length()>0){
                Case cse=[select contactid,id,SuppliedEmail,AccountId from case where id=:CaseId];
                cse.ContactId=cnt.Id;
                if(selected=='Residential Contact'){
                    cse.AccountId=acct.Id;  
                }
                update cse; 
                /*  if(selected=='Residential Contact'){ 
cse.AccountId=cnt.Id;
isSuccess=true;
}*/
                
                
            }
        }
        
    }
    /*---------------------------------------End of Save PHDB Contact------------------------------------- */
    Public void RunQuery(){      
        accList = New List<account>();
        if(queryStr.length() > 1){
            String queryStr = '*'+queryStr+'*';
            String searchQuery1 = 'FIND \'' + queryStr + '\' IN All FIELDS RETURNING Account(Id,Name, BillingStreet, BillingCity, BillingState, Site, Type) limit 2000';
            List<List <sObject>> searchList1 = search.query(searchQuery1);
            accList  = ((List<account>)searchList1[0]);
            if( accList.size() == 0){
                ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sorry, no results found'));
                return;               
            }
        }
        else{
            ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
            return;
        }
        
    }
    
    Public void  onClick(){
        System.debug('conName'+accountId);
        if(CaseId!=null && CaseId.length()>0){
            Case c=[Select Accountid,id from Case where id=:CaseId];
            c.Accountid=accountId;
            update c;
            Contact cnt2 =[select id,name from contact order by CreatedDate desc limit 1];
            cnt2.AccountId=accountId;
            update cnt2;
            c.AccountId=cnt.Id;                  
            isSuccess=true;    
        }
    }
    
    Public void SaveAcct(){
        System.debug('#Inside Save Acct');
        if(Name==null || Name==''){
            ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sorry, no results found'));                
        }else{
            System.debug('#Inside This:'+Name);
            Account acc = new Account();
            acc.Name=Name;
            acc.BillingCity=BillingCity;
            acc.BillingState=BillingState;
            acc.BillingCountry=BillingCountry;
            acc.BillingStreet=BillingStreet;
            acc.BillingPostalCode=ZipCode;
            acc.Site=Site; 
            acc.Type='Partner';
            acc.Phone = Phone;
            insert acc;
            System.debug('#acct Inserted:'+acc);
            System.debug('#Cnt Id:'+cnt.Id);
            if(selected1 !=null)
            {
                Contact cnt1 =[select id,name from contact where Id=:selected1 order by CreatedDate desc limit 1];
                cnt1.AccountId=acc.id;
                update cnt1;
                System.debug('#Contact Updated Successfully:'+cnt1);
            }
            if(CaseId!=null && CaseId.length()>0){
                Case cse1=[Select AccountId,Contactid from Case where Id=:caseid];
                cse1.AccountId=acc.Id;      
                update cse1;
                System.debug('#Case Updated Successfully:'+cse1);
                cse1.AccountId=cnt.Id;       
                System.debug(cse1.AccountId);
                
            }
        }
    } 
    
    Public void SaveandAccount(){        
        SaveContact();        
        conSearch = false;
        isNotShow=false;         
        displayAccount = true;
    }
    
    public void edit(){
        System.debug('#Contact Id to Edit:'+conid);
        isShow=false;
        isNotShow=true;	
        display2=true;
        display=false;
        PHDBContact=false;        
        editConRole  = [SELECT id,FirstName,LastName,Phone,Fax,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode,RecordTypeId,MobilePhone, RecordType.Name,Email,AccountId FROM contact where id=:conid limit 1];       
        System.debug('@conid:'+editConRole);
        selected1=conid;
        System.debug('selected:'+selected1);
        for(Contact edit:editConRole){
            FirstName=edit.FirstName;
            LastName=edit.LastName;
            Phone=edit.Phone;
            MailingStreet=edit.MailingStreet;
            MailingCity=edit.MailingCity;
            MailingState=edit.MailingState;
            MailingCountry=edit.MailingCountry;
            MobilePhone=edit.MobilePhone;
            MailingPostalCode=edit.MailingPostalCode;
            Fax=edit.Fax;
            CEmail=edit.Email;
            selected=edit.RecordType.Name;
            
        }     
        
        System.debug('list:'+editConRole);
        if(editConRole!=null && editConRole.size()>0 && editConRole.get(0).AccountId==null&& selected == 'Residential Contact' ){
            display2=false;
            UpdateAccountFlag = true;
            UpdateCreateAccountFlag=false;
        }
        if(editConRole!=null && editConRole.size()>0 && editConRole.get(0).AccountId==null&& selected == 'Non-Residential Contact' ){
            display2=false;
            UpdateAccountFlag = false;
            UpdateCreateAccountFlag=true;
        }
        
        if(editConRole!=null && editConRole.size()>0 && editConRole.get(0).AccountId!=null&&(selected == 'Non-Residential Contact'||selected == 'Residential Contact') ){
            display2=true;
            UpdateAccountFlag = false;
            UpdateCreateAccountFlag=false;
        }
        
        System.debug('#UpdateAccountFlag:'+UpdateAccountFlag);
    }
    
    public void editnew(){
        // System.debug('#Contact Id to Edit:'+conid);
        isShow=false;
        isNotShow=false;	
        display2=false;
        display=false;
        PHDBContact=true;
        ShowPHDBResult =false;
        display=true;
        contact=new contact();
        //  editConRole  = [SELECT id,FirstName,LastName,Phone,Fax,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode,RecordTypeId,MobilePhone, RecordType.Name,Email,AccountId FROM contact where id=:conid limit 1];       
        // System.debug('@conid:'+editConRole);
        //  selected1=conid;
        //  System.debug('selected:'+selected1);
        //  for(Contact edit:editConRole){
        for (PHDBInfoWrapper a :PHDBContactsInfo) {
            // if(a.wrapperid == PHDBRecordid){ 
            system.debug('*****inside if*****');
            
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
            // IsResidentialReadOnly=False;
            // IsResidential=true;
            // } 
        }
        
        
        System.debug('contact:'+contact.Email);
        /* if(editConRole!=null && editConRole.size()>0 && editConRole.get(0).AccountId==null&& selected == 'Residential Contact' ){
display2=false;
UpdateAccountFlag = true;
UpdateCreateAccountFlag=false;
}
if(editConRole!=null && editConRole.size()>0 && editConRole.get(0).AccountId==null&& selected == 'Non-Residential Contact' ){
display2=false;
UpdateAccountFlag = false;
UpdateCreateAccountFlag=true;
}

if(editConRole!=null && editConRole.size()>0 && editConRole.get(0).AccountId!=null&&(selected == 'Non-Residential Contact'||selected == 'Residential Contact') ){
display2=true;
UpdateAccountFlag = false;
UpdateCreateAccountFlag=false;
}

System.debug('#UpdateAccountFlag:'+UpdateAccountFlag);*/
        insert contact;
        
    }
    public void SaveEdit(){       
        system.debug('selected' +selected );
        list<contact> cse2=[SELECT id,accountid,FirstName,LastName,Phone,Fax,MailingStreet,RecordType.Name,MailingCity,MailingState,MailingCountry,MobilePhone,account.RecordTypeId,Email FROM contact where id=:selected1 limit 1];
        System.debug('selected1'+selected1);
        System.debug('updated:'+cse2);       
        list<contact> toupdate=new  list<contact>();
        System.debug('edit1.RecordType.Name:'+cse2[0].RecordType.Name);    
        System.debug('account.RecordTypeId:'+cse2[0].account.RecordTypeId);    
        for(Contact edit1:cse2){
            if(edit1.account.RecordTypeId != null){
                RecordType rt2=[select id,name from RecordType where name=:edit1.RecordType.Name];
                RecordType rt3=[select id,name from RecordType where id=:edit1.account.RecordTypeId];
                
                // System.debug('@record1:'+edit1.account.RecordType.id);           
                
                if(rt3.id!=null || rt3.id!=''){ 
                    System.debug('@record:'+rt2);
                    if(rt3.Name=='Residential Address' ){
                        string RecordTypeId = [Select Id, Name from RecordType where sobjectType='Contact' and Name=:this.selected].Id;
                        edit1.FirstName=FirstName;
                        edit1.LastName=LastName;               
                        edit1.Phone=Phone;
                        edit1.MailingStreet=MailingStreet;
                        edit1.MailingCity=MailingCity;
                        edit1.MailingState=MailingState;
                        edit1.MailingCountry=MailingCountry;
                        edit1.MobilePhone=MobilePhone;
                        edit1.MailingPostalCode=MailingPostalCode;
                        edit1.Fax=Fax;
                        
                        edit1.Email=CEmail;
                        system.debug('*********selected***********'+selected);
                        if(rt2.Name=='Non-Residential Contact'){
                            edit1.RecordTypeId=RecordTypeId;
                            system.debug('update'+selected);
                        }
                        system.debug('edit1'+edit1);
                        toupdate.add(edit1);
                    } 
                    
                    else if(rt3.Name=='Partner' || rt3.Name=='Customer'){
                        string RecordTypeId = [Select Id, Name from RecordType where sobjectType='Contact' and Name=:this.selected].Id;
                        edit1.FirstName=FirstName;
                        edit1.LastName=LastName;
                        edit1.Phone=Phone;
                        edit1.MailingStreet=MailingStreet;
                        edit1.MailingCity=MailingCity;
                        edit1.MailingState=MailingState;
                        edit1.MailingCountry=MailingCountry;
                        edit1.Fax=Fax;
                        edit1.MailingPostalCode=MailingPostalCode;
                        edit1.MobilePhone=MobilePhone;
                        edit1.Email=CEmail;
                        if(rt2.Name=='Residential Contact'){
                            edit1.RecordTypeId=RecordTypeId;
                            system.debug('updatepertner'+selected);
                        }
                        system.debug('edit1'+edit1);
                        
                        toupdate.add(edit1);                        
                    } 
                    
                } else{
                    ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'ERROR'));
                    
                }
            }else{
                ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Account RecordType is Empty'));
                
            }
            
        }
        update toupdate;
        // ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Contact Updated Successfully'));
        Case c4=[Select contactid,id from case where id=:caseid];
        if(toupdate!=null && toupdate.size()>0){
            c4.contactid=toupdate[0].id;
            update c4;          
        }ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Contact Updated Successfully'));
        
    }
    
    
    
    public void SelectLink(){
        System.debug('inside selectlink:'+caseid);    
        Case c3=[Select id,contactid,accountId from Case where id=:caseid];
        System.debug('#caseid:'+caseid);
        c3.contactid=conid; 
        Contact ct1=[select id,Accountid from contact where id=:c3.contactid];
        if(ct1.accountId!=null) {
            c3.accountId=ct1.accountId;
        } else{
            ct1.Accountid=c3.accountId;
            update ct1;
        }
        update c3;
        /* pagereference page=new pagereference('/'+c3);
page.setRedirect(true);
return page;
*/
        
        
    }
    public void SaveEditAndAccount(){       
        system.debug('selected' +selected );
        list<contact> cse2=[SELECT id,accountid,FirstName,LastName,Phone,Fax,MobilePhone,MailingStreet,RecordType.Name,MailingCity,MailingState,MailingCountry,account.RecordTypeId,Email FROM contact where id=:selected1 limit 1];
        System.debug('selected1'+selected1);
        System.debug('updated:'+cse2);       
        list<contact> toupdate=new  list<contact>();
        System.debug('edit1.RecordType.Name:'+cse2[0].RecordType.Name);    
        System.debug('account.RecordTypeId:'+cse2[0].account.RecordTypeId);    
        for(Contact edit1:cse2){
            if(edit1.account.RecordTypeId != null){
                RecordType rt2=[select id,name from RecordType where name=:edit1.RecordType.Name];
                RecordType rt3=[select id,name from RecordType where id=:edit1.account.RecordTypeId];
                
                // System.debug('@record1:'+edit1.account.RecordType.id);           
                
                if(rt3.id!=null || rt3.id!=''){ 
                    System.debug('@record:'+rt2);
                    if(rt3.Name=='Residential Address' ){
                        string RecordTypeId = [Select Id, Name from RecordType where sobjectType='Contact' and Name=:this.selected].Id;
                        edit1.FirstName=FirstName;
                        edit1.LastName=LastName;               
                        edit1.Phone=Phone;
                        edit1.MailingStreet=MailingStreet;
                        edit1.MailingCity=MailingCity;
                        edit1.MailingState=MailingState;
                        edit1.MailingCountry=MailingCountry;
                        edit1.Fax=Fax;
                        edit1.MailingPostalCode=MailingPostalCode;
                        edit1.MobilePhone=MobilePhone;
                        edit1.Email=CEmail;
                        system.debug('*********selected***********'+selected);
                        if(rt2.Name=='Non-Residential Contact'){
                            edit1.RecordTypeId=RecordTypeId;
                            system.debug('update'+selected);
                        }
                        system.debug('edit1'+edit1);
                        toupdate.add(edit1);
                    } 
                    
                    else if(rt3.Name=='Partner' || rt3.Name=='Customer'){
                        string RecordTypeId = [Select Id, Name from RecordType where sobjectType='Contact' and Name=:this.selected].Id;
                        edit1.FirstName=FirstName;
                        edit1.LastName=LastName;
                        edit1.Phone=Phone;
                        edit1.MailingStreet=MailingStreet;
                        edit1.MailingCity=MailingCity;
                        edit1.MailingState=MailingState;
                        edit1.MailingCountry=MailingCountry;
                        edit1.MailingPostalCode=MailingPostalCode;
                        edit1.Fax=Fax;
                        edit1.MobilePhone=MobilePhone;
                        if(rt2.Name=='Residential Contact'){
                            edit1.RecordTypeId=RecordTypeId;
                            system.debug('updatepertner'+selected);
                        }
                        system.debug('edit1'+edit1);
                        
                        toupdate.add(edit1);                        
                    } 
                    
                } else{
                    ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'ERROR'));
                    
                }
            }else{
                ApexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Account RecordType is Empty'));
                
            }
            
        }
        update toupdate;
        // ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Contact Updated Successfully'));
        Case c4=[Select contactid,id from case where id=:caseid];
        if(toupdate!=null && toupdate.size()>0){
            c4.contactid=toupdate[0].id;
            update c4;          
        }ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Contact Updated Successfully'));
        
    }
    Public void CancelAccount(){
        conSearch=true;
        isShow=true; 
        isNOTShow=false;
        displayAccount=false;
        
        
    }
    Public  void UpdateContact(){
        CaseId=apexpages.currentPage().getparameters().get('id');
        system.debug('CaseId'+CaseId);
        isShow=false;
        isNotShow=true;
        // UpdateContact =false;
        
        if(LastName!=null && LastName.length()>0){
            system.debug('inside SaveContact');
            System.debug('selected'+selected);
            RecordType rd= [Select Id,Name from RecordType where Name=:selected]; 
            Case cse1=[select contactid,id,SuppliedEmail from case where id=:CaseId limit 1];
            system.debug('case'+cse1.ContactId);
            system.debug('case SuppliedEmail'+cse1.SuppliedEmail);
            if(selected1!=null){
                //Contact con=[SELECT id,accountid,FirstName,LastName,Phone,Fax,MailingStreet,RecordType.Name,MailingCity,MailingState,MailingCountry,account.RecordTypeId,Email FROM contact where id=:cse1.ContactId limit 1];
                Contact con=[SELECT id,accountid,FirstName,LastName,Phone,Fax,MailingStreet,RecordType.Name,MailingCity,MailingState,MailingCountry,account.RecordTypeId,Email FROM contact where id=:selected1 limit 1];
                
                system.debug('con new'+con);
                //  Account acct = new Account();
                Account acct = new Account();
                String nameToReturn = 'Residential - ';
                String differentiator = ',';
                System.debug('#selected:'+selected);
                if(selected=='Residential Contact'){
                    system.debug('inside if');
                    if((MailingStreet==null || MailingStreet=='') && (MailingCity==null || MailingCity=='') && (MailingState==null || MailingState=='') && (MailingCountry==null || MailingCountry=='')&& (MailingPostalCode==null || MailingPostalCode=='')){
                        system.debug('inside else');  
                        acct.Name='Residential-'+LastName+'-'+CEmail;
                        acct.RecordTypeId = [Select Id, Name from RecordType where sobjectType='Account' and Name='Residential Address'].Id;
                        system.debug('acct.Name'+acct.Name);
                        system.debug('acct.RecordTypeId'+acct.RecordTypeId);
                        
                    } 
                    else if(MailingStreet!=null || MailingStreet!='' || MailingCity!=null || MailingCity!='' || MailingState!=null || MailingState!='' || MailingCountry!=null || MailingCountry!='' || MailingPostalCode!=null || MailingPostalCode!='' ){
                        if(MailingStreet!=null && MailingStreet.length()>0){
                            nameToReturn = nameToReturn + MailingStreet;
                            nameToReturn = nameToReturn + differentiator;
                        }
                        if(MailingCity!=null && MailingCity.length()>0){
                            nameToReturn = nameToReturn + MailingCity;
                            nameToReturn = nameToReturn + differentiator;
                        }
                        if(MailingState!=null && MailingState.length()>0){
                            nameToReturn = nameToReturn + MailingState;
                            nameToReturn = nameToReturn + differentiator;
                        }
                        
                        if(MailingCountry!=null && MailingCountry.length()>0){
                            nameToReturn = nameToReturn + MailingCountry;
                            nameToReturn = nameToReturn + differentiator;
                        }
                        if(MailingPostalCode!=null && MailingPostalCode.length()>0){
                            nameToReturn = nameToReturn + MailingPostalCode;
                            nameToReturn = nameToReturn + differentiator;
                        }
                        if(nameToReturn!=null && nameToReturn.length()>0 && nameToReturn.endsWith(differentiator)){
                            nameToReturn = nameToReturn.substring(0, nameToReturn.lastIndexOf(differentiator));
                        }
                        
                        acct.RecordTypeId = [Select Id, Name from RecordType where sobjectType='Account' and Name='Residential Address'].Id;
                        acct.Name=nameToReturn;
                    }	
                    
                    if(con.AccountId==null || con.AccountId==''){
                        acct.BillingStreet=MailingStreet;
                        acct.BillingCity=MailingCity;
                        acct.BillingState=MailingState;
                        acct.BillingCountry=MailingCountry;
                        acct.BillingPostalCode=MailingPostalCode;
                        acct.Phone=Phone;
                        insert acct;
                        con.AccountId =acct.Id;
                    }
                    
                    
                    
                    con.FirstName=FirstName;
                    con.LastName=LastName;
                    con.Email=CEmail;
                    con.Phone=Phone;
                    con.Fax=Fax;
                    con.MobilePhone=MobilePhone;
                    con.RecordTypeId=rd.Id;
                    con.MailingStreet=MailingStreet;
                    con.MailingCity=MailingCity;
                    con.MailingState=MailingState;
                    con.MailingCountry=MailingCountry; 
                    
                    system.debug('cnt'+cnt);
                    // update con;
                }
                if(selected=='Non-Residential Contact'){        
                    con.FirstName=FirstName;
                    con.LastName=LastName;
                    con.Email=CEmail;
                    con.Phone=Phone;
                    con.Fax=Fax;
                    con.MobilePhone=MobilePhone;
                    con.RecordTypeId=rd.Id;
                    con.MailingStreet=MailingStreet;
                    con.MailingCity=MailingCity;
                    con.MailingState=MailingState;
                    con.MailingCountry=MailingCountry;    
                    system.debug('cnt'+cnt);
                    // update con;
                    if(UpdateCreateAccountFlag==false)
                    {
                        ApexPages.addmessage(new apexpages.message(apexpages.severity.CONFIRM, 'Contact has been created and associated successfully!!'));
                    }
                    //return;
                }
                update con;    
                System.debug('#CaseId got from url:'+CaseId);
                if(CaseId!=null && CaseId.length()>0){
                    System.debug('#Inside here!');
                    Case cse=[select contactid,id,SuppliedEmail,AccountId from case where id=:CaseId];
                    cse.ContactId=con.Id;
                    if(selected=='Residential Contact'){
                        //cse.AccountId=acct.Id;
                        cse.AccountId=con.AccountId;  
                    }
                    update cse; 
                    System.debug('#CaseUpdated Successfully!'+con.Id);
                    if(selected=='Residential Contact'){ 
                        //cse.AccountId=con.Id;
                        isSuccess=true;
                    }
                    
                    
                }
            }
            
        }
    }
    Public void SaveandCreateAccount(){        
        UpdateContact();        
        conSearch = false;
        isNotShow=false;
        display2=false;
        displayAccount = true;
    }
    /*Contact Search using Confirmation Number*/
    public list<contact> contactSearch(){
        system.debug('********inside contactSearch********');
        isShow=false;
        isNotShow=false;
        ShowPHDBResult=true;
        try{  
            // ResidentialFromURL1 = ApexPages.currentPage().getParameters().get('ResidentialFlagFromURL');
            system.debug('ConfirmationNo...'+ConfirmationNo);
            // system.debug('ResidentialFromURL1...'+ResidentialFromURL1);
            // if(ResidentialFromURL1!=null){
            //     ResidentialFromURL=Boolean.valueOf(ResidentialFromURL1);
            //  }
            String searchTerms = '';
            /*  String rId = Apexpages.currentpage().getparameters().get('searchbutton');

if(searchId=='true'){
Contact.Phone=Contact.Phone;  
}
else{
Contact.Phone=ApexPages.currentPage().getParameters().get('phoneFromURL1');

}*/
            
            //Form search terms based on Input from User
            if(Contact.LastName!=null){
                searchTerms = searchTerms + '("' + Contact.LastName + '")';
            }
            /*  if(Contact.Phone!=null && Contact.Phone!=''){
if(!String.isEmpty(searchTerms)){
searchTerms += ' OR ';
}
searchTerms += '("' + Contact.Phone + '")';
}*/
            
            
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
            
            // PhoneNo2 = Contact.Phone;
            PhoneNo2 ='';
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
    public void getPHDBContactInfo1(String Lastname, String Street,String PhoneNo2 ,String PostalCode,String FirstName,String City,String ConfirmationNo, String email){
        
        PHDBContactsInfo=new List<PHDBInfoWrapper>();
        system.debug('PHDBContactsInfo'+PHDBContactsInfo);
        getPHDBInfo(Lastname,Street,null,PhoneNo2,PostalCode,firstName,City,ConfirmationNo,email);
        
    }
    
    public void getPHDBContactInfo(String Lastname, String Street,String Phone,String PostalCode,String FirstName,String City,String ConfirmationNo, String email){
        
        PHDBContactsInfo=new List<PHDBInfoWrapper>();
        getPHDBInfo(Lastname,Street,Phone,null,PostalCode,firstName,City,ConfirmationNo,email);
        
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
    @TestVisible 
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
    
    
    
    
}