public class EPIC_And_EPMS_Form_Controller {
    public Boolean displayNoBrowserIssue{get;set;}
    public Boolean displayWebBrowserIssue{get;set;}
    public string selectedValue{get;set;}
    public String enteredName{get;set;}
    public String contactFirstName{get; set;}
    public String contactLastName{get; set;}
    public String contactEmail{get; set;}
    public String phoneNumber{get; set;}
    public String serialNumber{get; set;}
    public String modelNumber{get; set;}
    public String comments{get; set;}
    public String webBrowserVersion{get; set;}
    public Boolean verified { get; private set;}
    public Case newCase{get;set;}
    public boolean isInternalUser{get;set;}
    List<List<SObject>> findContact=new List<List<SObject>>();
    public Integer i=0;
    public String keepDescription;
    public Contact createContactIfNotPresent{get; set;}
    public Account createAccountIfNotPresent{get; set;}
    public String hvacId{get; set;}
    public String type{get; set;}
    public String payload{get; set;}
    public String shipTo{get; set;}
    public String productAffected{get; set;}
    Map<String, String> epicProductAffectedAndGroupType{get; set;}
    Map<String, String> epmsProductAffectedAndGroupType{get; set;}
    // public String selected  {get;set;}
    public transient string fileName 
    {    get;set;    }
    
    public Blob fileBody 
    {    get;set;    }
    Public transient List<Attachment> myAttachments{get;set;}
    public transient List<Attachment> attachments;
    
    
    public transient Id sobjId {get; set;}
    
    // list of new attachments to add
    public List<Attachment> newAttachments {get; set;}
    
    // the number of new attachments to add to the list when the user clicks 'Add More'
    public static final Integer NUM_ATTACHMENTS_TO_ADD=4;
    public List<SelectOption> getWebBrowserOptions() {
        
        List<SelectOption> WebBrowserOptions = new List<SelectOption>();
        WebBrowserOptions.add(new SelectOption('--None--','--None--'));
        WebBrowserOptions.add(new SelectOption('Aftermarket/Totaline','Aftermarket/Totaline'));
        WebBrowserOptions.add(new SelectOption('Air/Water Cooled Chiller','Air/Water Cooled Chiller'));
        WebBrowserOptions.add(new SelectOption('Air Handler','Air Handler'));
        WebBrowserOptions.add(new SelectOption('Boilers','Boilers'));
        WebBrowserOptions.add(new SelectOption('Commercial Applied Chiller','Commercial Applied Chiller'));
        WebBrowserOptions.add(new SelectOption('Commercial Condenser','Commercial Condenser'));
        WebBrowserOptions.add(new SelectOption('Commercial Splits','Commercial Splits'));
        WebBrowserOptions.add(new SelectOption('Dehumidifiers','Dehumidifiers'));
        WebBrowserOptions.add(new SelectOption('Ductless Splits','Ductless Splits'));
        WebBrowserOptions.add(new SelectOption('EPIC','EPIC'));
        WebBrowserOptions.add(new SelectOption('Energy Recovery Ventilators','Energy Recovery Ventilators'));
        // WebBrowserOptions.add(new SelectOption('EPMS','EPMS'));
        WebBrowserOptions.add(new SelectOption('Fan Coil','Fan Coil'));
        WebBrowserOptions.add(new SelectOption('Furnace Coil','Furnace Coil'));
        WebBrowserOptions.add(new SelectOption('Furnaces','Furnaces'));
        WebBrowserOptions.add(new SelectOption('Generators','Generators'));
        WebBrowserOptions.add(new SelectOption('Geothermal','Geothermal'));
        WebBrowserOptions.add(new SelectOption('Heat Recovery Ventilators','Heat Recovery Ventilators'));
        WebBrowserOptions.add(new SelectOption('Humidifiers','Humidifiers'));
        WebBrowserOptions.add(new SelectOption('Packaged Terminal Air Conditioners(PTAC)','Packaged Terminal Air Conditioners(PTAC)'));
        WebBrowserOptions.add(new SelectOption('Residential Splits','Residential Splits'));
        WebBrowserOptions.add(new SelectOption('Rooftop Units','Rooftop Units'));
        WebBrowserOptions.add(new SelectOption('Room Air Conditioners(RAC)','Room Air Conditioners(RAC)'));
        
        WebBrowserOptions.add(new SelectOption('Screw/Semi-Hermetic Compressors','Screw/Semi-Hermetic Compressors'));
        WebBrowserOptions.add(new SelectOption('Small Packaged Product(SPP)','Small Packaged Product(SPP)'));
        //WebBrowserOptions.add(new SelectOption('Splits','Splits'));
        //WebBrowserOptions.add(new SelectOption('Totaline','Totaline'));
        WebBrowserOptions.add(new SelectOption('UV Lights','UV Lights'));
        WebBrowserOptions.add(new SelectOption('Variable Refrigerant Flow Unit(VRF)','Variable Refrigerant Flow Unit(VRF)'));
        WebBrowserOptions.add(new SelectOption('Vertical Packaged Air Conditioners(VPAC)','Vertical Packaged Air Conditioners(VPAC)'));
        WebBrowserOptions.add(new SelectOption('Water Source Heat Pump','Water Source Heat Pump'));
        
        
        
        return WebBrowserOptions;
    }
    
    
    
    public EPIC_And_EPMS_Form_Controller(ApexPages.StandardController stdController){
        this.addMore();
        isInternalUser = false;
        selectedValue = 'no';
        productAffected = '--None--';
        epicProductAffectedAndGroupType = new Map<String, String>();
        epicProductAffectedAndGroupType.put('Aftermarket/Totaline','Residential');
        epicProductAffectedAndGroupType.put('Boilers','Residential');
        epicProductAffectedAndGroupType.put('Ductless Splits','Residential');
        epicProductAffectedAndGroupType.put('Fan Coil','Residential');
        epicProductAffectedAndGroupType.put('Furnace Coil','Residential');
        epicProductAffectedAndGroupType.put('Furnaces','Residential');
        epicProductAffectedAndGroupType.put('Generators','Residential');
        epicProductAffectedAndGroupType.put('Geothermal','Residential');
        epicProductAffectedAndGroupType.put('Heat Recovery Ventilators','Residential');
        epicProductAffectedAndGroupType.put('Humidifiers','Residential');
        epicProductAffectedAndGroupType.put('Dehumidifiers','Residential');
        epicProductAffectedAndGroupType.put('UV Lights','Residential');
        epicProductAffectedAndGroupType.put('Packaged Terminal Air Conditioners(PTAC)','Residential');
        epicProductAffectedAndGroupType.put('Room Air Conditioners(RAC)','Residential');
        epicProductAffectedAndGroupType.put('Residential Splits','Residential');
        epicProductAffectedAndGroupType.put('Vertical Packaged Air Conditioners(VPAC)','Residential');
        epicProductAffectedAndGroupType.put('Variable Refrigerant Flow Unit(VRF)','Residential');
        epicProductAffectedAndGroupType.put('Air/Water Cooled Chiller','Commercial');
        epicProductAffectedAndGroupType.put('Air Handler','Commercial');
        epicProductAffectedAndGroupType.put('Commercial Applied Chiller','Commercial');
        epicProductAffectedAndGroupType.put('Commercial Condenser','Commercial');
        epicProductAffectedAndGroupType.put('Commercial Splits','Commercial');
        epicProductAffectedAndGroupType.put('Energy Recovery Ventilators','Commercial');
        epicProductAffectedAndGroupType.put('Rooftop Units','Commercial');
        epicProductAffectedAndGroupType.put('Small Packaged Product(SPP)','Commercial');
        epicProductAffectedAndGroupType.put('Water Source Heat Pump','Commercial');
        epicProductAffectedAndGroupType.put('Screw/Semi-Hermetic Compressors','Commercial');
        epicProductAffectedAndGroupType.put('EPIC','IT');
        epicProductAffectedAndGroupType.put('EPMS','IT');
        //  epicProductAffectedAndGroupType.put('Totaline','Aftermarket');
        
        epmsProductAffectedAndGroupType = new Map<String, String>();
        epmsProductAffectedAndGroupType.put('EPIC','IT');
        epmsProductAffectedAndGroupType.put('EPMS','IT');
        //  epmsProductAffectedAndGroupType.put('Totaline','Aftermarket');
        
        User user1 = [select Id,Profile.UserLicense.Name from User where Id = :userinfo.getUserId() limit 1];
        if(user1.Profile.UserLicense.Name =='Partner Community'){
            isInternalUser = true;
        } 
        displayNoBrowserIssue = true;
        newCase=new case();
        if(contactFirstName==null)
        {
            
            contactFirstName = ApexPages.currentPage().getParameters().get('fname');
            contactLastName = ApexPages.currentPage().getParameters().get('lname');
            contactEmail = ApexPages.currentPage().getParameters().get('email');      
            hvacId =  ApexPages.currentPage().getParameters().get('hvacid'); 
            type = ApexPages.currentPage().getParameters().get('Type');
            
            //payload = ApexPages.currentPage().getParameters().get('PL');
            payload = ApexPages.currentPage().getParameters().get('value');
            if(payload!=null && payload.length()>0){
                parsePayloadAndGetValues(payload);    
                
            }
        }
    }
    public PageReference renderSections(){    
        if(selectedValue.equalsIgnoreCase('yes')){
            displayWebBrowserIssue = true;
            displayNoBrowserIssue = false;
            
        }
        else{
            displayNoBrowserIssue = true;
            displayWebBrowserIssue = false;
            
        }
        return null;
        
    }
    
    public PageReference createCase(){
        
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
        if (contactEmail == null || contactEmail =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Email'));
            return null;
        }
        if(displayNoBrowserIssue == true){
            if (newCase.CCC_Model_Number__c == null || newCase.CCC_Model_Number__c =='')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Model Number'));
                return null;
            }
        }
        if(newCase.Comments__c == null || newCase.Comments__c ==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the comments'));
            this.verified = false;
            return null;
        }
        if(displayWebBrowserIssue == true){
            newCase.CCC_Purpose__c = 'System Issues';
        }
        else{
            newCase.CCC_Purpose__c = 'Technical/Part Info';
        }
        
        if(newCase.Subject != null && newCase.Subject !='')
        {
            newCase.Subject=newCase.Subject+'- '+ '"Web Case"';
        }
        else
        {
            newCase.Subject= '"RC Web Comments - Web Case"';
        }
        
        newCase.Status='Open';
        newCase.Origin='Web';
        if(type==null || type=='')
        {
            newCase.Type = 'EPIC'; 
        }
        else
        {
            newCase.Type = type;
        }
        keepDescription=newCase.Description;
        //newCase.Product_Effected__c = selected;
        newCase.Product_Effected__c = productAffected!=null && productAffected!='--None'?productAffected : '';
        if(newCase.Product_Effected__c!=null && newCase.Product_Effected__c!='' && Type!=null && Type!='' && Type=='EPIC'){
            if(epicProductAffectedAndGroupType.containsKey(newCase.Product_Effected__c)){
                newCase.Group_Type__c = epicProductAffectedAndGroupType.get(newCase.Product_Effected__c);
            }
        }else if(newCase.Product_Effected__c!=null && newCase.Product_Effected__c!='' && Type!=null && Type!='' && Type=='EPMS'){
            if(epmsProductAffectedAndGroupType.containsKey(newCase.Product_Effected__c)){
                newCase.Group_Type__c = epmsProductAffectedAndGroupType.get(newCase.Product_Effected__c);
            }
        }
        
        try{
            
            System.debug('#Contact Email:'+contactEmail);
            findContact= [FIND :contactEmail IN Email Fields RETURNING Contact(Id)];
            system.debug('---------------> SOQL Value'+findContact);
            
            Contact [] contactList = ((List<Contact>)findContact[0]);
            contactList=[Select Id, Email, AccountId from Contact where Id in:contactList order by Createddate desc];
            system.debug('-------------->querying and assigning the contacts to list'+contactList);
            
            if(contactList.size() == 1)
            {
                newCase.ContactId=contactList[0].Id;
                newCase.AccountId = contactList[0].AccountId; 
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
                createContactIfNotPresent.MailingCountry = 'USA';
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
      /*  try{
            
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
                Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Non-Residential Contact').getRecordTypeId();
                createContactIfNotPresent.RecordTypeId = contactRecordTypeId;
                createContactIfNotPresent.LastName = contactLastName;
                createContactIfNotPresent.FirstName = contactFirstName;
                createContactIfNotPresent.Phone = phoneNumber;
                createContactIfNotPresent.Email = contactEmail;
                createContactIfNotPresent.MailingCountry = 'USA';
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
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
        newcase.RecordTypeId=recordTypeId;
        
        if(displayNoBrowserIssue == true )
        {
            if(newCase.Product_Effected__c =='EPIC' || newCase.Product_Effected__c =='--None--')
            {
                newCase.OwnerId = [select Id from Group where DeveloperName='Generic' and Type = 'Queue'].Id;
            } 
        }
        
        if(displayWebBrowserIssue == true)
        {
            newCase.OwnerId = [select Id from Group where DeveloperName='RC_Web_Comments_IT' and Type = 'Queue'].Id;
            
        }
        
        insert newCase;
        sobjId = newCase.Id;
        save();
        
        String url = '/apex/EPIC_And_EPMS_Form_Msg?fname='+contactFirstName+'&lname='+contactLastName+'&email='+contactEmail+'&hvacid='+hvacId+'&Type='+type+'&value='+payload;
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
        //this.contactFirstName = decrypt.getFirstName(payload);
        this.contactFirstName = decrypt.getFirstNameDecrypt(payload);
        
        System.debug('#contactFN:'+contactFirstName);
        //this.contactLastName = decrypt.getLastName(payload);
        this.contactLastName = decrypt.getLastNameDecrypt(payload);
        
        //this.contactEmail = decrypt.getEmail(payload);
        this.contactEmail = decrypt.getEmailDecrypt(payload);
        
        this.hvacId = decrypt.getHVACIDDecrypt(payload);
        this.type = decrypt.getSHIPTODecrypt(payload);
        
    }
}