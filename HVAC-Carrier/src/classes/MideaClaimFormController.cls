public class MideaClaimFormController {
   
 
    public string selectedValue1{get;set;}
    public Boolean claimSectionRender{get; set;}
    public Boolean claimSectionRender2{get; set;}
    public Boolean claimSectionRender3{get; set;}
    public Boolean claimSectionRender4{get; set;}
    public Boolean claimSectionRender5{get; set;}
    public Boolean claimSectionRender6{get; set;}
  //  public string selectedValue { get;set; }
 //   public Account acc{get;set;}
    public boolean isInternalUser{get;set;}
    //CCC_ErrorLog errlog= new CCC_ErrorLog();
    public Case newCase{get;set;}
  //  public List<Case> c{get;set;}
  //  public List<Case> c1{get;set;}
    public String contactFirstName{get; set;}
    public String contactLastName{get; set;}
    public String contactEmail{get; set;}
    public String phoneNumber{get; set;}
    public String hvacId{get; set;}
    public String shipTo{get; set;}
    public String payload{get; set;}
    public String distributorName{get; set;}
    public String Comments{get;set;}
 //   public Boolean chkBx{get;set;}
    public Contact createContactIfNotPresent{get; set;}
    public Account createAccountIfNotPresent{get; set;}
    public String enteredName{get;set;}
    List<List<SObject>> findContact=new List<List<SObject>>();
    public Integer i=0;
    public String keepDescription;
  /*  public string material;
    public string serial;
    public string custPO;
    public string invoice;
    public string credit;
    public string claimsPurpose;
    public string claimsSubPurpose;
    public string distClaim;
    public date moveDate;
    public string claimType;
    public string order;*/
    public boolean flag;
    public Boolean verified { get; private set;}
   // public List<Asset> updateAssetTosCode{get; set;}
    public transient string fileName 
    {    get;set;    }
    
    public Blob fileBody 
    {    get;set;    }
    Public transient List<Attachment> myAttachments{get;set;}
    
   
    public transient Id sobjId {get; set;}
    
    // list of existing attachments - populated on demand
    public transient List<Attachment> attachments;
    
    // list of new attachments to add
    public List<Attachment> newAttachments {get; set;}
    
    // the number of new attachments to add to the list when the user clicks 'Add More'
    public static final Integer NUM_ATTACHMENTS_TO_ADD=9;
    
    public boolean isValidate = true;
    

    
    /**
* @description :constructor call
**/
    public MideaClaimFormController(ApexPages.StandardController stdController){
        this.addMore();
        isInternalUser = false;
   //     showBlock1=false;
        User user1 = [select Id,Profile.UserLicense.Name from User where Id = :userinfo.getUserId() limit 1];
        if(user1.Profile.UserLicense.Name =='Partner Community'){
            isInternalUser = true;
        } 
       
        newCase=new case();
        newCase.Is_Claim__c = true;
        
        if(contactFirstName==null)
        {
            
            contactFirstName = ApexPages.currentPage().getParameters().get('fname');
            contactLastName = ApexPages.currentPage().getParameters().get('lname');
            contactEmail = ApexPages.currentPage().getParameters().get('email');      
            hvacId =  ApexPages.currentPage().getParameters().get('hvacid');  
            payload = ApexPages.currentPage().getParameters().get('value');
            if(payload!=null && payload.length()>0){
                parsePayloadAndGetValues(payload);    
            }
            
        }
        

     
        newAttachments=new List<Attachment>{new Attachment()};
        System.debug('#Const newAttachments:'+newAttachments);
        this.addMore();
        List<Account> acctLst = [Select Id, Name from Account where Sap_Ship_To__c =:shipTo limit 1]; 
        Account acct = (acctLst!=null && acctLst.size()>0)? acctLst.get(0) : null;
        if(acct!=null && acct.Name!=null && acct.Name!=''){
            distributorName = acct.Name;
        }
        claimSectionRender = false;
      
    }

     public MideaClaimFormController (){
     
    }
    
    public PageReference createCase()
    {
       
      
        if((contactFirstName!=null && contactFirstName!='') || (contactLastName!=null && contactLastName!='')){
            enteredName = contactFirstName + ' '+ contactLastName;
        }
        
        if(contactFirstName==null || contactFirstName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact First Name'));
            this.verified = false;
            return null;
        }
        if(contactLastName==null || contactLastName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact Last Name'));
            this.verified = false;
            return null;
        }
        
        if (newCase.Subject == null || newCase.Subject =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Subject'));
            this.verified = false;
            return null;
        }
        
        if (contactEmail == null || contactEmail =='')
        {
            system.debug('Email'+contactEmail);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact Email'));
            this.verified = false;
            return null;
        }
        
      /*  if (hvacId == null || hvacId =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the hvacId'));
            this.verified = false;
            return null;
        }*/
        
        
        if ( newCase.Description == null ||  newCase.Description =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Description'));
            this.verified = false;
            return null;
        }
         
        
        if ( newCase.Claims_Purpose__c == null ||  newCase.Claims_Purpose__c =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Claims Purpose'));
            this.verified = false;
            return null;
        }
        if ( newCase.Claims_Sub_Purpose__c == null ||  newCase.Claims_Sub_Purpose__c =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Claims SubPurpose'));
            this.verified = false;
            return null;
        }
        if(claimSectionRender3 == true || claimSectionRender == true){
        flag = false;
        for (Attachment newAtt : newAttachments)
        {
            if (newAtt.Body!=null)
            {
               flag = true;
                break;
            }
           
        }
        }
        if((newCase.Claims_Purpose__c == 'Parts Damage' &&  newCase.Claims_Sub_Purpose__c == 'Claim Request' && flag == false) || (newCase.Claims_Purpose__c == 'Equipment Damage' &&  newCase.Claims_Sub_Purpose__c == 'Claim Request' && flag == false)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Photographs are required on all damage claims'));
            this.verified = false;
            return null;
        }
        /* if(newCase.Claims_Purpose__c == 'Equipment Damage' && newCase.Claims_Sub_Purpose__c == 'Claim Request' && flag == false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Photographs are required on all damage claims'));
            this.verified = false;
            return null;
        }*/
        system.debug('flag'+flag);
            if(newcase.Claims_Order_Type__c == 'Equipment' || newcase.Claims_Order_Type__c == 'EQUIPMENT')
            {
              newcase.Claims_Order_Type__c = 'Equipment';
              Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
              newcase.RecordTypeId=recordTypeId;
            
          /*  if ( newCase.CCC_Claim_Type__c== null ||  newCase.CCC_Claim_Type__c =='')
             {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Claim Type'));
            this.verified = false;
            return null;
             }*/
            }
            
            else if (newcase.Claims_Order_Type__c == 'FAST Parts' || newcase.Claims_Order_Type__c == 'FAST PARTS')
            {
              newcase.Claims_Order_Type__c = 'FAST PARTS';
              Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
              newcase.RecordTypeId=recordTypeId;
              
            }
            else
            {
              newcase.Claims_Order_Type__c = 'PRICING';
              Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
              newcase.RecordTypeId=recordTypeId; 
            }
           /*   if ( newCase.CCC_Claim_Type__c== null ||  newCase.CCC_Claim_Type__c =='')
             {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Claim Type'));
            this.verified = false;
            return null;
             }*/
            
    
             
            newCase.Status='Open';
            newCase.Origin='Midea Pricing Claims';
            newCase.CCC_Brand__c='Midea';
            newCase.CCC_Customer_Type__c='Residential';
            keepDescription=newCase.Description;
            
               
       
            if(newCase.Subject != null && newCase.Subject !='')
            {
                newCase.Subject=newCase.Subject+'- '+ '"Web Case"';
            }
            try{
                
                System.debug('#Contact Email:'+contactEmail);
                findContact= [FIND :contactEmail IN Email Fields RETURNING Contact(Id)];
                system.debug('---------------> SOQL Value'+findContact);
                
                Contact [] contactList = ((List<Contact>)findContact[0]);
                contactList=[Select Id, Email, AccountId from Contact where Id in:contactList];
                system.debug('-------------->querying and assigning the contacts to list'+contactList);
                
                if(contactList.size() == 1)
                {
                    newCase.ContactId=contactList[0].Id;
                    if(newCase.Description == null)
                    {
                        newCase.Description='';
                    }
                    
                    
                }
                else if(contactList.size()>1)
                {
                    system.debug('---------------> inside the Else if condition where contactlist is more than 1 value');
                    for(Contact getEmail:contactList)
                    {
                        system.debug('------------->Enetered in to for loop which is inside the else if condition');
                        if(getEmail.Email==contactEmail && i<2)
                        {
                            
                            newCase.ContactId=getEmail.Id;
                            if(getEmail.AccountId!=null && getEmail.AccountId!=''){
                                newCase.AccountId = getEmail.AccountId;
                            }
                            i++;
                            system.debug('---------------> inside the Email Match if condition'+ i);
                            if(newCase.Description == null)
                            {
                                newCase.Description='';
                            }
                            
                            if(i==1)
                            {
                                newCase.Description=newCase.Description+' '+ 'Name:'+ contactFirstName+' '+contactLastName;
                            }
                            
                            
                            
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
                    newCase.Description=newCase.Description+' '+ 'Name:'+ enteredName+' '+ 'Email:'+' '+contactEmail+' '+'No contacts were found with the provided Email Address so creating a contact';
                    createAccountIfNotPresent = new Account();
                    createAccountIfNotPresent.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
                    createAccountIfNotPresent.Name = newCase.Subject;
                    //insert createAccountIfNotPresent;
                    
                    createContactIfNotPresent = new Contact();
                    //createContactIfNotPresent.AccountId = createAccountIfNotPresent.Id;
                    Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Non-Residential Contact').getRecordTypeId();
                    createContactIfNotPresent.RecordTypeId = contactRecordTypeId;
                    createContactIfNotPresent.LastName = contactLastName;
                    createContactIfNotPresent.FirstName = contactFirstName;
                    createContactIfNotPresent.Phone = phoneNumber;
                    createContactIfNotPresent.Email = contactEmail;
                    insert createContactIfNotPresent;
                    System.debug('#Contact Inserted Successfully:'+createContactIfNotPresent);
                    newCase.ContactId = createContactIfNotPresent.Id;
                    
                }
                
                if(i==2)
                {
                    newCase.ContactId=null;
                    newCase.Description=keepDescription+' '+ 'Name:'+ enteredName+' '+ 'Email:'+' '+contactEmail+' '+'Multiple Contacts were found with the provided Email Address';
                    system.debug('---------------> Inside the i==2 if condition');
                }
                
            }
            
            Catch(Exception E)
            {
                system.debug(E.getMessage());
            }
            
            
           /* try{
                
               
                List<Account> accountList = [Select Id from Account where CCC_HVACPID__c =:hvacId];
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
                        if(getHvac.CCC_HVACPID__c==hvacId && i<2)
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
                    newCase.Description=newCase.Description+' '+ 'Name:'+enteredName+' '+ 'HVACPID:'+' '+hvacId+' '+'No Accounts were found with the provided HVAC ID so creating a case without account';
                    createAccountIfNotPresent = new Account();
                    Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
                    createAccountIfNotPresent.RecordTypeId = AccountRecordTypeId;
                    // createAccountIfNotPresent.Name = hvacId;
                    createAccountIfNotPresent.Name = newCase.Subject;
                    createAccountIfNotPresent.CCC_HVACPID__c= hvacId;
                  //  insert createAccountIfNotPresent;
                 //   newCase.AccountId = createAccountIfNotPresent.Id;
                    
                    
                   // createContactIfNotPresent = new Contact();
                    //createContactIfNotPresent.AccountId = createAccountIfNotPresent.Id;
                    Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Non-Residential Contact').getRecordTypeId();
                    createContactIfNotPresent.RecordTypeId = contactRecordTypeId;
                    createContactIfNotPresent.LastName = contactLastName;
                    createContactIfNotPresent.FirstName = contactFirstName;
                    createContactIfNotPresent.Phone = phoneNumber;
                    createContactIfNotPresent.Email = contactEmail;
                    insert createContactIfNotPresent;
                    System.debug('#Contact Inserted Successfully:'+createContactIfNotPresent);
                    newCase.ContactId = createContactIfNotPresent.Id;
                    
                }
                
                if(i==2)
                {
                    newCase.ContactId=null;
                    newCase.Description=keepDescription+' '+ 'Name:'+ enteredName+' '+ 'Email:'+' '+contactEmail+' '+'Multiple Contacts were found with the provided Email Address';
                    system.debug('---------------> Inside the i==2 if condition');
                }
                
            }
            
            Catch(Exception E)
            {
                system.debug(E.getMessage());
            }*/
            if(newcase.Claims_Order_Type__c == 'Equipment')
            {
            newCase.OwnerId = [select Id from Group where Name='ICP Equipment Claim' and Type = 'Queue'].Id;
            }
            else if(newcase.Claims_Order_Type__c == 'FAST Parts' || newcase.Claims_Order_Type__c == 'FAST PARTS')
            {
            newCase.OwnerId = [select Id from Group where Name='ICP Fast Part Claim' and Type = 'Queue'].Id;
            }
            else  
            {
              newCase.OwnerId = [select Id from Group where Name='ICP Pricing Claim' and Type = 'Queue'].Id;   
            }
           
            
        
        
                System.debug('#newCase before Insert:'+newCase);
           
                insert newCase;
                System.debug('#newCase Id:'+newCase.Id);
                sobjId = newCase.Id;
                
                System.debug('#Attachments:'+newAttachments);
       
        
                save();
          
        
            
      
      
               

            String url = '/apex/Midea_Pricing_Claims_Msg?fname='+contactFirstName+'&lname='+contactLastName+'&email='+contactEmail+'&hvacid='+hvacid+'&value='+payload;
            PageReference pr = new PageReference(url);
            return pr;
        
    }

    
    
   
    
  
    // Add more attachments action method
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
        //this.contactFirstName = decrypt.getFirstName(payload);
        this.contactFirstName = decrypt.getFirstNameDecrypt(payload);
        
        System.debug('#contactFN:'+contactFirstName);
        //this.contactLastName = decrypt.getLastName(payload);
        this.contactLastName = decrypt.getLastNameDecrypt(payload);
        
        //this.contactEmail = decrypt.getEmail(payload);
        this.contactEmail = decrypt.getEmailDecrypt(payload);
        
        this.hvacId = decrypt.getHVACIDDecrypt(payload);
        this.shipTo = decrypt.getSHIPTODecrypt(payload);
        
    }
    public PageReference renderSections(){
         System.debug('#Inside renderSections');
        if(selectedValue1.equalsIgnoreCase('c')){
            System.debug('#Inside C');
            newCase.Claims_Order_Type__c= 'Equipment';
            newCase.CCC_Claim_Type__c='Residential';
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
            newCase.RecordTypeId=recordTypeId;
            claimSectionRender = true;
            claimSectionRender2 = false;
            claimSectionRender3 = false;
            claimSectionRender4 = false;
            claimSectionRender5 = false;
            claimSectionRender6 = false;
        }else if(selectedValue1.equalsIgnoreCase('pc')){
             System.debug('#Inside pc');
             newCase.Claims_Order_Type__c= 'Pricing';
             newCase.CCC_Claim_Type__c='Commercial';
             Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
             newcase.RecordTypeId=recordTypeId;
             claimSectionRender2 = true;
             claimSectionRender = false;
             claimSectionRender3 = false;
             claimSectionRender4 = false;
             claimSectionRender5 = false;
             claimSectionRender6 = false;
        }else if(selectedValue1.equalsIgnoreCase('fpc')){
             System.debug('#Inside fpc');
             newCase.Claims_Order_Type__c= 'FAST PARTS';
             Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
             newCase.RecordTypeId=recordTypeId;      
             claimSectionRender3 = true;
             claimSectionRender2 = false;
             claimSectionRender = false;
             claimSectionRender5 = false;
             claimSectionRender4 = false;
             claimSectionRender6 = false;
            
        }
    
        return null;
    }
    
    public PageReference renderSections2()
    {
         System.debug('#Inside renderSections2');
         
      if( newCase.Claims_Purpose__c == 'Parts Damage'|| newCase.Claims_Purpose__c == 'Parts Overage' || newCase.Claims_Purpose__c == 'Parts Returns'  )
            {
                system.debug('Inside parts damage');
                claimSectionRender4 = true;
                claimSectionRender5 = false;
                claimSectionRender6 = false;
            }
      else if (newCase.Claims_Purpose__c == 'Parts Shortage')
            {
                system.debug('outside parts damage');
                claimSectionRender4 = true; 
                claimSectionRender5 = true;
                claimSectionRender6 = false;
            }
        else if (newCase.Claims_Purpose__c == 'Equipment Shortage')
        {
               claimSectionRender4 = false; 
               claimSectionRender5 = false;
               claimSectionRender6 = true;
        }
        else
        {
               claimSectionRender4 = false; 
               claimSectionRender5 = false;
               claimSectionRender6 = false;
        }
        return null;
    }
    


}