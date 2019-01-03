public class QuoteProFormController {
   
   // public string selectedValue{get;set;}
    public String enteredName{get;set;}
    public String contactFirstName{get; set;}
    public String contactLastName{get; set;}
    public String contactEmail{get; set;}
    public String Phone{get; set;}
   // public String serialNumber{get; set;}
  //  public String modelNumber{get; set;}
  //  public String webBrowserVersion{get; set;}
    public Boolean verified { get; private set;}
    public Case newCase{get;set;}
    public boolean isInternalUser{get;set;}
    List<List<SObject>> findContact=new List<List<SObject>>();
    public Integer i=0;
    public String keepDescription;
    public Contact createContactIfNotPresent{get; set;}
 //   public Account createAccountIfNotPresent{get; set;}
    public String hvacId{get; set;}
    public String type{get; set;}
    public String payload{get; set;}
    public String shipTo{get; set;}
  //  public String productAffected{get; set;}
    public string cntFirstName{get;set;}
    public string cntLastName{get;set;}
    public string cntEmail{get;set;}
    public string PhoneNumber{get;set;}
    public string QPUserID{get;set;}
   // Map<String, String> epicProductAffectedAndGroupType{get; set;}
   // Map<String, String> epmsProductAffectedAndGroupType{get; set;}
    public transient string fileName{get;set;}
    public Blob fileBody{get;set;}
    Public transient List<Attachment> myAttachments{get;set;}
    public transient List<Attachment> attachments;
    Public String selected{get;set;}
    public String priorityselected{get;set;}
    public string hid{get;set;}
    public string message{get;set;}
    //public datetime BidTiming{get;set;}
    public transient Id sobjId {get; set;}
    // list of new attachments to add
    public List<Attachment> newAttachments {get; set;}
    // the number of new attachments to add to the list when the user clicks 'Add More'
    public static final Integer NUM_ATTACHMENTS_TO_ADD=4;
    
    
    public List<SelectOption> getoptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('Catalogs','Catalogs'));
        options.add(new SelectOption('Configuration','Configuration'));
        options.add(new SelectOption('Customer and Contact Management ','Customer and Contact Management'));
        options.add(new SelectOption('Digital Content Management','Digital Content Management'));
        options.add(new SelectOption('E-Cat Integration','E-Cat Integration'));
        options.add(new SelectOption('End User Settings','End User Settings'));
        options.add(new SelectOption('Engineer to Order (ETO)','Engineer to Order (ETO)'));
        options.add(new SelectOption('Management Approval Process','Management Approval Process'));
        options.add(new SelectOption('Management Approval Setup','Management Approval Setup'));
        options.add(new SelectOption('Ordering','Ordering'));
        options.add(new SelectOption('Pricing','Pricing'));
        options.add(new SelectOption('Proposals','Proposals'));
        options.add(new SelectOption('Projects & Quotes','Projects & Quotes'));
        options.add(new SelectOption('Reporting','Reporting'));
        options.add(new SelectOption('Security Setups','Security Setups'));
        options.add(new SelectOption('Sharing Projects','Sharing Projects'));
        options.add(new SelectOption('Vendor Management','Vendor Management'));
        
        
        return options;
    }
    
    public List<SelectOption> getpriority() {
        List<SelectOption> priority = new List<SelectOption>();
        priority.add(new SelectOption('Low','Low'));
        priority.add(new SelectOption('Medium','Medium'));
        priority.add(new SelectOption('High','High'));
        return priority;
        
    }
    public QuoteProFormController(ApexPages.StandardController stdController){
        this.addMore();
        isInternalUser = false;        
        User user1 = [select Id,Profile.UserLicense.Name from User where Id = :userinfo.getUserId() limit 1];
        if(user1.Profile.UserLicense.Name =='Partner Community'){
            isInternalUser = true;
        } 
        newCase=new case();
        cntFirstName = ApexPages.currentPage().getParameters().get('fname');
        cntLastName = ApexPages.currentPage().getParameters().get('lname');
        cntEmail = ApexPages.currentPage().getParameters().get('email');
        hid =  ApexPages.currentPage().getParameters().get('hvacid'); 
        payload = ApexPages.currentPage().getParameters().get('value');
        if(payload!=null && payload.length()>0){
            parsePayloadAndGetValues(payload);    
        }
        System.debug('cntFirstName:'+cntFirstName);
        System.debug('cntFirstName1:'+this.contactFirstName);
        this.message='Please decide number of spaces for attachments before uploading. Clicking "Add More" will clear already uploaded files.';
    }
    
    
    public PageReference createCase(){
        
        if((cntFirstName!=null && cntFirstName!='') || (cntLastName!=null && cntLastName!='')){
            enteredName = cntFirstName + ' '+ cntLastName;
        }
        
        if(cntFirstName==null || cntFirstName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact First Name'));
            this.verified = false;
            return null;
        }
        if(cntLastName==null || cntLastName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact Last Name'));
            this.verified = false;
            return null;
        }
        if (cntEmail == null || cntEmail =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Email'));
            return null;
        }
        if(newCase.Subject != null && newCase.Subject !='')
        {
            newCase.Subject=newCase.Subject+'-'+ '"Web Case"'+'\n';
        }
        else
        {
            newCase.Subject= '"QuotePro Web Comments - Web Case"'+'\n';
        }
        newCase.Status='Open';
        newCase.Origin='Web Quote Pro';
        newCase.CCC_Customer_Type__c='QuotePro';
        keepDescription=newCase.Description;
        if(selected!='--None--'){
            newCase.CCC_Sub_Purpose__c = selected;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Sub Purpose'));
            return null;
        }
        newCase.CCC_Purpose__c='QuotePro';
        newCase.Priority=priorityselected;
        System.debug(' newCase.Priority'+priorityselected);
       /* if(priorityselected=='High'){
           if(newCase.SAP_Quote__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Quote ID Number'));
                return null;
            }
            if(newCase.Bid_Timing__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Bid Timing'));
                return null;
            }
            if(newCase.Project_ID_Number__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Project ID Number'));
                return null;
            }
            
        }*/
        try{
            List<Contact> contLst = [Select Id from Contact where HVAC_Contact_Id__c=:hid order by createddate desc];
            system.debug('-------------->querying and assigning the contacts to list'+contLst);
            if(cntFirstName!=this.contactFirstName || cntLastName!=this.contactLastName){
                contLst = null;
            }
            if(contLst!=null && contLst.size()>0 && contLst.size()==1){
                Contact eachContact = contLst.get(0);
                newCase.ContactId = eachContact.Id;
                if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                  newCase.Description=newCase.Description+'\n'+ 'This Case is CreatedBy:['+this.contactFirstName+' '+this.contactLastName+']\n';
                }else{
                    newCase.Description=newCase.Description;
                }
            }else if(contLst!=null && contLst.size()>0 && contLst.size()>1){
                Contact eachContact = contLst.get(0);
                newCase.ContactId = eachContact.Id;
                newCase.Description=keepDescription+'\n'+'Multiple Contacts were found with the provided HVACID'+'\n';
            }else{
                System.debug('#Contact Email:'+cntEmail);
                findContact= [FIND :cntEmail IN Email Fields RETURNING Contact(Id)];
                system.debug('---------------> SOQL Value'+findContact);
                
                Contact [] contactList = ((List<Contact>)findContact[0]);
                contactList=[Select Id, Email, AccountId from Contact where Id in:contactList];
                system.debug('-------------->querying and assigning the contacts to list'+contactList);
                system.debug('-------------->querying and assigning the contacts to list Size'+contactList.size());
                
                if(contactList.size() == 1)
                {
                    newCase.ContactId=contactList[0].Id;
                    if(newCase.Description == null)
                    {
                       if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                            newCase.Description=''+'\n'+ 'This Case is CreatedBy:['+this.contactFirstName+' '+this.contactLastName+']\n';
                        }else{
                          newCase.Description='';
 
                        }
                    }else{
                        if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                            newCase.Description=newCase.Description+'\n'+ 'This Case is CreatedBy:['+this.contactFirstName+' '+this.contactLastName+']\n';
                        }else{
                          newCase.Description=newCase.Description;
 
                        }
                    }
                }
                else if(contactList.size()>1)
                {
                    system.debug('---------------> inside the Else if condition where contactlist is more than 1 value');
                    i = contactList.size();
                    for(Contact getEmail:contactList)
                    {
                        system.debug('------------->Enetered in to for loop which is inside the else if condition');
                        System.debug('#i:'+i);
                        if(getEmail.Email==cntEmail && i<=2)
                        {
                            System.debug('#Inside this loop!');
                            newCase.ContactId=getEmail.Id;
                            if(getEmail.AccountId!=null && getEmail.AccountId!=''){
                                newCase.AccountId = getEmail.AccountId;
                            }
                            i++;
                            system.debug('---------------> inside the Email Match if condition'+ i);
                            System.debug('#cntFN:'+cntFirstName);
                            System.debug('#contactFirstName:'+this.contactFirstName);
                            System.debug('#cntLN:'+cntLastName);
                            System.debug('#contactLastName:'+this.contactLastName);
                            if(newCase.Description == null)
                            {
                                if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                                    newCase.Description=''+'\n'+ 'This Case is CreatedBy:['+this.contactFirstName+' '+this.contactLastName+']\n';
                                }else{
                                    newCase.Description='';
                                    
                                }
                            }else{
                                if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                                    newCase.Description=newCase.Description+'\n'+ 'This Case is CreatedBy:['+this.contactFirstName+' '+this.contactLastName+']\n';
                                }else{
                                  newCase.Description=newCase.Description;
         
                                }
                            }
                            
                            if(i==1)
                            {
                                if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                                    newCase.Description=newCase.Description+'\n'+ 'This Case is CreatedBy:['+this.contactFirstName+' '+this.contactLastName+']\n';
                                }else{
                                    newCase.Description=newCase.Description+'\n';
                                }
                            }
                            
                        }  
                    }
                }
                else
                {
                    system.debug('---------------->Entered into else condition');
                    if(newCase.Description == null)
                    {
                        if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                            newCase.Description=''+'\n'+ 'This Case is CreatedBy:['+this.contactFirstName+' '+this.contactLastName+']\n';
                        }else{
                            newCase.Description='';
                            
                        }
                    }else{
                        if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                            newCase.Description=newCase.Description+'\n'+ 'This Case is CreatedBy:['+this.contactFirstName+' '+this.contactLastName+']\n';
                        }else{
                          newCase.Description=newCase.Description;
 
                        }
                    }
                    if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                        newCase.Description=newCase.Description+'\n'+'This Case is CreatedBy:['+ this.contactFirstName+' '+this.contactLastName+ '] Email:['+' '+this.contactEmail+'] '+'\n'+'No contacts were found with the provided Email Address so creating a contact'+'\n';
                    }else{
                        newCase.Description=newCase.Description+'\n'+'No contacts were found with the provided Email Address so creating a contact'+'\n'; 
                    }
                    
                    /*createAccountIfNotPresent = new Account();
                    createAccountIfNotPresent.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
                    createAccountIfNotPresent.Name = newCase.Subject;
                    insert createAccountIfNotPresent;*/
                    createContactIfNotPresent = new Contact();
                    //createContactIfNotPresent.AccountId = createAccountIfNotPresent.Id;
                    Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Non-Residential Contact').getRecordTypeId();
                    createContactIfNotPresent.RecordTypeId = contactRecordTypeId;
                    createContactIfNotPresent.LastName = cntLastName;
                    createContactIfNotPresent.FirstName = cntFirstName;
                    createContactIfNotPresent.Phone = PhoneNumber;
                    createContactIfNotPresent.Email = cntEmail;
                    createContactIfNotPresent.MailingCountry = 'USA';
                    insert createContactIfNotPresent;
                    System.debug('#Contact Inserted Successfully:'+createContactIfNotPresent);
                    newCase.ContactId = createContactIfNotPresent.Id;
                    
                }
                
                if(i==2)
                {
                    newCase.ContactId=null;
                    if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                        newCase.Description=keepDescription+'\n'+'This Case is CreatedBy:'+this.contactFirstName+' '+ 'Email:'+' '+cntEmail+' '+'\n'+'Multiple Contacts were found with the provided Email Address'+'\n';
                        system.debug('---------------> Inside the i==2 if condition');
                    }else{
                        newCase.Description=keepDescription+'\n'+'Multiple Contacts were found with the provided Email Address'+'\n';
                    }
                    
                    
                }
            }
        }
        
        Catch(Exception E)
        {
            system.debug(E.getMessage());
        }
                        
                        /*try{
                List<Account> accountList = [Select Id from Account where CCC_HVACPID__c =:hid];
                system.debug('-------------->querying and assigning the contacts to list'+accountList);
                
                if(accountList.size() == 1)
                {
                newCase.AccountId=accountList[0].Id;
                }
                else if(accountList.size()>1)
                {
                system.debug('---------------> inside the Else if condition where accountlist is more than 1 value');
                for(Account getHvac:accountList)
                {
                system.debug('------------->Enetered in to for loop which is inside the else if condition');
                if(getHvac.CCC_HVACPID__c==hid && i<2)
                {
                
                newCase.AccountId=getHvac.Id;
                if(getHvac.Id!=null && getHvac.Id!=''){
                newCase.AccountId = getHvac.Id;
                }
                i++;
                system.debug('---------------> inside the Email Match if condition'+ i);
                
                }  
                }
                }
                else
                {
                system.debug('---------------->Entered into else condition');
                if(newCase.Description == null)
                {
                newCase.Description='';
                }
                
                if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                
                newCase.Description=newCase.Description+'\n'+'This Case is CreatedBy:'+this.contactFirstName+' '+ 'HVACPID:'+' '+ this.hvacId+' '+'\n'+'No Accounts were found with the provided HVAC ID so creating a case without account'+'\n';
                }else{
                newCase.Description=newCase.Description+'\n'+'No Accounts were found with the provided HVAC ID so creating a case without account'+'\n';
                }

                createAccountIfNotPresent = new Account();
                Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
                createAccountIfNotPresent.RecordTypeId = AccountRecordTypeId;
                createAccountIfNotPresent.Name = hvacId;
                createAccountIfNotPresent.Name = newCase.Subject;
                createAccountIfNotPresent.CCC_HVACPID__c= hvacID;
                insert createAccountIfNotPresent;
                newCase.AccountId = createAccountIfNotPresent.Id;
                createContactIfNotPresent = new Contact();
                createContactIfNotPresent.AccountId = createAccountIfNotPresent.Id;
                Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Non-Residential Contact').getRecordTypeId();
                createContactIfNotPresent.RecordTypeId = contactRecordTypeId;
                createContactIfNotPresent.LastName = cntLastName;
                createContactIfNotPresent.FirstName = cntFirstName;
                createContactIfNotPresent.Phone = PhoneNumber;
                createContactIfNotPresent.Email = cntEmail;
                createContactIfNotPresent.MailingCountry = 'USA';
                insert createContactIfNotPresent;
                System.debug('#Contact Inserted Successfully:'+createContactIfNotPresent);
                newCase.ContactId = createContactIfNotPresent.Id;
                
                }
                
                if(i==2)
                {
                newCase.ContactId=null;
                if(cntFirstName!=this.contactFirstName && cntLastName!=this.contactLastName){
                newCase.Description=keepDescription+'\n'+ 'This Case is CreatedBy:'+this.contactFirstName+' '+ 'Email:'+' '+this.contactEmail+' '+'\n'+'Multiple Contacts were found with the provided Email Address'+'\n';
                system.debug('---------------> Inside the i==2 if condition');
                }else{
                newCase.Description=keepDescription+'\n'+'Multiple Contacts were found with the provided Email Address'+'\n';
                }
                }
                
                }
                
                Catch(Exception E)
                {
                system.debug(E.getMessage());
                }*/
        newCase.OwnerId = [select Id from Group where Name='QuotePro' and Type = 'Queue'].Id;
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
        newcase.RecordTypeId=recordTypeId;
        insert newCase;
        sobjId = newCase.Id;
        save();
        String url = '/apex/QuoteProForm_Msg?value='+payload;
        PageReference pr = new PageReference(url);
        return pr;
    } 
    
    public void addMore()
    {
        List<Attachment> tempAttachments = new List<Attachment>();
        System.debug('#newAttachments:'+newAttachments);
        if(newAttachments==null){
            newAttachments = new List<Attachment>{new Attachment()};
                }
        // append NUM_ATTACHMENTS_TO_ADD to the new attachments list
        for (Integer idx=0; idx<NUM_ATTACHMENTS_TO_ADD; idx++)
        {
            newAttachments.add(new Attachment());
        }
        tempAttachments.addAll(newAttachments);
        for(Attachment eachAttachment : newAttachments){
            eachAttachment.Body = null;
        }
    }
    
    // Save action method
    public void save()
    {
        List<Attachment> toInsert=new List<Attachment>();
        for (Attachment newAtt : newAttachments)
        {
            if (newAtt.Body!=null)
            {
                newAtt.parentId=sobjId;
                // newAtt.parentId=newCase.id;
                toInsert.add(newAtt);
            }
        }
        insert toInsert;
        newAttachments.clear();
        newAttachments.add(new Attachment());
        // null the list of existing attachments - this will be rebuilt when the page is refreshed
        attachments=null;
    }
    
    
    public void parsePayloadAndGetValues(String payload){
        System.debug('#payload:'+payload);
        //payload = 'SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
        if(payload.contains(' ')){
            payload = payload.replaceAll(' ', '+');
        }
        System.debug('#payload after:'+payload);
        JWTDecryptFinal decrypt = new JWTDecryptFinal();
        this.contactFirstName = decrypt.getFirstNameDecrypt(payload);
        cntFirstName=this.contactFirstName;
        System.debug('cntFirstName'+cntFirstName);
        this.contactLastName = decrypt.getLastNameDecrypt(payload);
        cntLastName=this.contactLastName;
        this.contactEmail = decrypt.getEmailDecrypt(payload);
        cntEmail=  this.contactEmail;
        System.debug('cntEmail'+cntEmail);
        this.hvacId = decrypt.getHVACIDDecrypt(payload);
        hid=this.hvacId;
        newCase.Hvac_Username__c = decrypt.getUsername(payload);
    }
    /* Public PageReference valueChanged(){
        if(this.selected=='None'){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Subpurpose'));            
        
        }
        return null;
        }*/
}