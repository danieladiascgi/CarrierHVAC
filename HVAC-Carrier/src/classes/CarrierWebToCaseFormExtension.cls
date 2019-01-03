/**
* @ Developer     : Tejas jambekar
* @date_created   : 03/20/2017
* @Description    :  This extension class was created for Web-to-Case form for RC Part counter associates, This class helps RC part counter associates to create a case from outside salesforce.
* @functions      : 1. createCase   - This function helps counter associates to create a case after Submit button is clicked on CarrerWebToCaseForm, There is server side validation in place which checks various conditions, This function also checks for a Contact record present in system and if present it will associate the Contact and it's account to newly created case else it will create only Contact of type "Non-residential" and associate it to case. This method also checks if any product is present in system with the part number entered in form and if yes it will associate the part to case else it will just log the entered part number.
*                   
                    
* 
***/
public class CarrierWebToCaseFormExtension {
 public transient string fileName 
    {    get;set;    }
    
    public transient Blob fileBody 
    {    get;set;    }

    public Case newCase{get;set;}
     
    /*public List<SelectOption> Options{ get;set; }
    public string selectedEquipment { get;set; }
    public string selectedPurpose{get;set;}
    public String enteredName{get;set;}
    public String enteredEmail{get;set;}
    List<List<SObject>> findContact=new List<List<SObject>>();
    public Integer i=0;
    public String keepDescription;*/
    /*reCaptcha Changes Start*/
      // The API endpoint for the reCAPTCHA service
    
    /*reCaptcha Changes End*/
    public String enteredName{get;set;}
    List<List<SObject>> findContact=new List<List<SObject>>();
    public Integer i=0;
    public String keepDescription;
    
     GOOGLE_RECAPTCHA__c recaptchaSettings = GOOGLE_RECAPTCHA__c.getValues('All Servers');
     public String publicKey { 
        get { return recaptchaSettings.Public_Key__c; }
    }
    private String privateKey = recaptchaSettings.Private_Key__c;
    public Boolean verified { get; private set; }
    
    public String contactFirstName{get; set;}
    public String contactLastName{get; set;}
    public String contactEmail{get; set;}
    public String phoneNumber{get; set;}
    public String hvacId{get; set;}
    public String shipTo{get; set;}
    public String payload{get; set;}
    public Contact createContactIfNotPresent{get; set;}
    public Account createAccountIfNotPresent{get; set;}
    
    public String purpose{get; set;}
    public String subPurpose{get; set;}
    
    public CarrierWebToCaseFormExtension(ApexPages.StandardController controller) {
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
        newCase=new case();
        newCase.RecordTypeId=recordTypeId;
        newCase.OwnerId = [select Id from Group where Name='CBP' and Type = 'Queue'].Id;
        
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
        this.phoneNumber = decrypt.getPhoneNo(payload);
    }
    
    public PageReference createCase()
    {
          /* Added for re-Captcha Start*/
        
        if((contactFirstName!=null && contactFirstName!='') || (contactLastName!=null && contactLastName!='')){
            enteredName = contactFirstName + ' '+ contactLastName;
        }
        if(contactLastName=='' || contactLastName==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact Last Name'));
            this.verified = false;
            return null;
        }
        if (contactEmail == null || contactEmail =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Contact Email'));
            this.verified = false;
            return null;
        }
        //Added code change made subject mandatory as it was requested by Margret May-30-2017 Start
        if(purpose==null || purpose=='' || purpose=='None'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Purpose'));
            this.verified = false;
            return null;
        }
		if(subPurpose==null || subPurpose=='' || subPurpose=='None'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Sub-Purpose'));
            this.verified = false;
            return null;
        }
        newCase.CCC_Purpose__c = purpose;
        newCase.CCC_Sub_Purpose__c = subPurpose;
        if (newCase.Subject == null || newCase.Subject =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Subject'));
            this.verified = false;
            return null;
        }
        //Added code change made subject mandatory as it was requested by Margret May-30-2017 End
        if (newCase.CCC_Purpose__c != null && newCase.CCC_Purpose__c!='' && (newCase.CCC_Purpose__c=='Technical/Part Info' || newCase.CCC_Purpose__c=='Pricing/Quoting') && (newCase.CCC_Model_Number__c==null || newCase.CCC_Model_Number__c=='' || newCase.CCC_Serial_Number__c==null || newCase.CCC_Serial_Number__c==''))
        {
            //if(newCase.CCC_Model_Number__c==null || newCase.CCC_Model_Number__c=='' || newCase.CCC_Serial_Number__c==null || newCase.CCC_Serial_Number__c==''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Model # and Serial #'));
            this.verified = false;
            	return null;
            //}
            
        }if (newCase.CCC_Purpose__c != null && newCase.CCC_Purpose__c!='' && newCase.CCC_Purpose__c=='Order Status and Maintenance' && (newCase.CCC_Customer_PO__c==null || newCase.CCC_Customer_PO__c==''))
        {
            //if(newCase.CCC_Customer_PO__c==null || newCase.CCC_Customer_PO__c==''){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Customer PO #'));
            this.verified = false;
            	return null;
            //}
        }else
        { 
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
        newcase.RecordTypeId=recordTypeId;
        
        newCase.Status='Open';
        newCase.Origin='Web';
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
        
        //newCase.Description=newCase.Description+' '+ 'Name:'+ contactFirstName+' '+contactLastName;
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
        
            try{
                System.debug('#Part Number:'+newCase.CCC_Part_Number__c);
                if(newCase.CCC_Part_Number__c!=null && newCase.CCC_Part_Number__c!=''){
                    List<Product2> parts = [Select Id, Name from Product2 where Name=:newCase.CCC_Part_Number__c];
                    if(parts!=null && parts.size()>0){
                        if(parts.size()==1){
                        	newCase.CCC_Part__c = parts.get(0).Id;
                        }    
                        if(parts.size()>1){
                        	newCase.Description=keepDescription+' '+ 'Part Number:'+ newCase.CCC_Part_Number__c+' Multiple Parts were found with the provided Part Number';
                    	}
                    }
                    
                        
                }
            }Catch(Exception E){
                system.debug('#Part Number:'+E.getMessage());
            }
        
        String descData = descriptionWithAllDetails();
        newCase.SuppliedEmail = contactEmail;
        newCase.Description = (newCase.Description==null? ''+ '\n' + descData:newCase.Description+ '\n' + descData) ;   
        insert newCase;
        EmailMessage msg = new EmailMessage();
        msg.Subject = newCase.Subject;
        String textBody = newCase.Description;
        textBody = textBody.replaceAll('null', ' ');
        msg.TextBody = textBody;
        msg.FromAddress = contactEmail;
        msg.FromName = contactLastName+', '+ contactFirstName;
        msg.ToAddress = 'rcdcmatechsupport@carrier.utc.com';
        //msg.Status = 'New';
        msg.Incoming = true;
        msg.ParentId = newCAse.Id;
        insert msg;
        newCase.New_Msg__c = false;
        update newCase;
        if(fileBody != null && fileName != null)
        {
          Attachment myAttachment  = new Attachment();
          myAttachment.Body = fileBody;
          myAttachment.Name = fileName;
          myAttachment.ParentId = newCase.Id;
          insert myAttachment;
          
        }
       
       //return Page.SiteWebCaseCreationMsg;
       String url = '/apex/SiteWebCaseCreationMsg?value='+payload;
       PageReference pr = new PageReference(url);
       return pr;
  }
    
       return null;  
        
        
        }
    //Added methods for reCaptcha Start
       public String descriptionWithAllDetails(){
        String toReturn = '';
        //toReturn = addNewLine(toReturn);
        toReturn = toReturn + 'Name  :  '+enteredName;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Email  :  '+contactEmail;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Phone  :  '+phoneNumber;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Purpose  :  '+newCase.CCC_Purpose__c;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Sub-Purpose  :  '+newCase.CCC_Sub_Purpose__c;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Priority  :  '+newCase.Priority;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Part Number  :  '+newCase.CCC_Part_Number__c;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Quantity  :  '+newCase.CCC_Part_Quantity__c;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Customer PO#  :  '+newCase.CCC_Customer_PO__c;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Model#  :  '+newCase.CCC_Model_Number__c;
        toReturn = addNewLine(toReturn);
        toReturn = toReturn+'Serial#  :  '+newCase.CCC_Serial_Number__c;
        //toReturn = addNewLine(toReturn);
        
        return toReturn;
    }
    public String addNewLine(String toReturnStr){
        toReturnStr = toReturnStr+'\n';
        return toReturnStr;
    }
    //Added methods for reCaptcha End
    //Added for Custom Purpose and Sub Purpose Start
    public List<SelectOption> getPurposes()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- Select ---'));        
        options.add(new SelectOption('System Issues','System Issues'));
        options.add(new SelectOption('New Account/Set Up/Changes','New Account/Set Up/Changes'));
		options.add(new SelectOption('Technical/Part Info','Technical/Part Info'));
		options.add(new SelectOption('Freight, Shipping, Tracking','Freight, Shipping, Tracking'));
		options.add(new SelectOption('Part Availability/Lead Time','Part Availability/Lead Time'));
		options.add(new SelectOption('Order Status and Maintenance','Order Status and Maintenance'));
		options.add(new SelectOption('Pricing/Quoting','Pricing/Quoting'));
		options.add(new SelectOption('RM/Credit Issue','RM/Credit Issue'));
		options.add(new SelectOption('Document Reprints','Document Reprints'));
		options.add(new SelectOption('Expedite','Expedite'));
        return options;
    }
    
    public List<SelectOption> getSubPurposes()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(purpose == 'System Issues')
        {       
            options.add(new SelectOption('C10 Down','C10 Down'));
            options.add(new SelectOption('EPIC','EPIC'));
            options.add(new SelectOption('HVAC Partners','HVAC Partners'));
            options.add(new SelectOption('Mobile App','Mobile App'));
        }
        else if(purpose == 'New Account/Set Up/Changes')
        {       
            options.add(new SelectOption('Address Changes','Address Changes'));
            options.add(new SelectOption('New Account Set Up','New Account Set Up'));
        }
        else if(purpose == 'Technical/Part Info')
        {       
            options.add(new SelectOption('Base Model (Customer Build)','Base Model (Customer Build)'));
            options.add(new SelectOption('Info not on EPIC/EPMS','Info not on EPIC/EPMS'));
            options.add(new SelectOption('Part ID/Part Look Up','Part ID/Part Look Up'));
        }
        else if(purpose == 'Freight, Shipping, Tracking')
        {       
            options.add(new SelectOption('Change Freight Carrier','Change Freight Carrier'));
            options.add(new SelectOption('Change/Update Ship To','Change/Update Ship To'));
            options.add(new SelectOption('Freight Claim/Damage','Freight Claim/Damage'));
            options.add(new SelectOption('Incorrect Freight Carrer','Incorrect Freight Carrer'));
            options.add(new SelectOption('Incorrect Freight Charge','Freight Claim/Damage'));
            options.add(new SelectOption('Incorrect Paperwork','Incorrect Paperwork'));
            options.add(new SelectOption('Tracking Info','Tracking Info'));
        }
        else if(purpose == 'Part Availability/Lead Time')
        {       
            options.add(new SelectOption('Availability & Pricing Inquiry','Availability & Pricing Inquiry'));
            options.add(new SelectOption('Weight & Dimensions','Weight & Dimensions'));
            
        }
        else if(purpose == 'Order Status and Maintenance')
        {       
            options.add(new SelectOption('Add Items','Add Items'));
            options.add(new SelectOption('Cancel order/item','Cancel order/item'));
            options.add(new SelectOption('Change Order Priority','Change Order Priority'));
            options.add(new SelectOption('Checking Status','Checking Status'));
            options.add(new SelectOption('Order Not Invoiced','Order Not Invoiced'));
        }
        else if(purpose == 'Pricing/Quoting')
        {       
            options.add(new SelectOption('Price Code Review','Price Code Review'));
            options.add(new SelectOption('Quote','Quote'));
            options.add(new SelectOption('Quote Follow Up','Quote Follow Up'));
        }
        else if(purpose == 'RM/Credit Issue')
        {       
            options.add(new SelectOption('RM Issues/Investigation','RM Issues/Investigation'));
            
        }
        else if(purpose == 'Document Reprints')
        {       
            options.add(new SelectOption('Acknowledgement Reprint','Acknowledgement Reprint'));
            options.add(new SelectOption('Invoice Reprint','Invoice Reprint'));
            options.add(new SelectOption('MSDS Sheets','MSDS Sheets'));
            options.add(new SelectOption('Reprint packing list', 'Reprint packing list'));
            options.add(new SelectOption('RM Reprint','RM Reprint'));
            //options.add(new SelectOption('MSDS Sheets','Manipur'));
        }
        else if(purpose == 'Expedite')
        {       
            options.add(new SelectOption('Expedite','Expedite'));
            
        }
        else
        {
            options.add(new SelectOption('None','--- Select ---'));
        }      
        return options;
    }
    
    //Added for Custom Purpose and Sub Purpose End
}