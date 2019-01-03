public class CarrierRoleCasePageExtension {

   
    public string fileName 
    {    get;set;    }
    
    public Blob fileBody 
    {    get;set;    }

    public Case newCase{get;set;}
    public List<SelectOption> Options{ get;set; }
    public string selectedEquipment { get;set; }
    public string selectedPurpose{get;set;}
    public string selectedRequestType{get;set;}
    public String request_type{get;set;}
    public String equipment_category{get;set;}
    public String support_group_to_assign_case{get;set;}
    public String enteredName{get;set;}
    public String enteredEmail{get;set;}
    List<List<SObject>> findContact=new List<List<SObject>>();
    public Integer i=0;
    public String keepDescription;

    GOOGLE_RECAPTCHA__c recaptchaSettings = GOOGLE_RECAPTCHA__c.getValues('All Servers');
     public String publicKey { 
        get { return recaptchaSettings.Public_Key__c; }
    }
    private String privateKey = recaptchaSettings.Private_Key__c;
    public Boolean verified { get; private set; }
    
    public CarrierRoleCasePageExtension(ApexPages.StandardController controller) {
        this.verified=false;
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Post Sale Support').getRecordTypeId();
        newCase=new case();
        newcase.RecordTypeId=recordTypeId;
               
       
    } 
    public List<SelectOption> getRequestType()
    {
        List<SelectOption> RequestTypeOptions = new List<SelectOption>();
     
        RequestTypeOptions.add(new SelectOption('None','--- Select ---'));        
        RequestTypeOptions.add(new SelectOption('International Request','International Request'));
        RequestTypeOptions.add(new SelectOption('Heavy Applied Design Data (16,17,19,23)','Heavy Applied Design Data (16,17,19,23)'));
        RequestTypeOptions.add(new SelectOption('Commercial Literature (over 25 tons)','Commercial Literature (over 25 tons)'));
        RequestTypeOptions.add(new SelectOption('Heavy Applied CCS Support /Re-Selections (16,17,19,23)','Heavy Applied CCS Support /Re-Selections (16,17,19,23)'));
        RequestTypeOptions.add(new SelectOption('Heavy Applied Start up/Warranty Support (16,17,19,23)','Heavy Applied Start up/Warranty Support (16,17,19,23)'));
        RequestTypeOptions.add(new SelectOption('Commercial Unitary Technical Support (over 25 tons)','Commercial Unitary Technical Support (over 25 tons)'));
        RequestTypeOptions.add(new SelectOption('Commercial Unitary Report Field Quality Issues (over 25 tons)','Commercial Unitary Report Field Quality Issues (over 25 tons)'));
        RequestTypeOptions.add(new SelectOption('Commercial Factory Support Engineer (over 25 tons)','Commercial Factory Support Engineer (over 25 tons)'));
     
        return RequestTypeOptions;
    }
    
    /* public List<SelectOption> getPickLstValue()
    {
         List<SelectOption> options1 = new List<SelectOption>();
         if(request_type == 'International Request')
        {       
            options1.add(new SelectOption('Commercial Products','Commercial Products'));
           // newCase.OwnerId = [select Id from Group where Name='CCC_ROLE_International' and Type = 'Queue'].Id;
        }
        else if(request_type == 'Heavy Applied Design Data (16,17,19,23)')
        {       
            options1.add(new SelectOption('Commercial Products','Commercial Products'));
        }
         else if(request_type == 'Commercial Literature (over 25 tons)')
        {       
            options1.add(new SelectOption('Commercial Products','Commercial Products'));
        } else if(request_type == 'Heavy Applied CCS Support /Re-Selections (16,17,19,23)')
        {       
            options1.add(new SelectOption('Applied Products','Applied Products'));
        } else if(request_type == 'Heavy Applied Start up/Warranty Support (16,17,19,23)')
        {       
            options1.add(new SelectOption('Applied Products','Applied Products'));
        } else if(request_type == 'Commercial Unitary Technical Support (over 25 tons)')
        {       
            options1.add(new SelectOption('Commercial Products','Commercial Products'));
        } else if(request_type == 'Commercial Unitary Report Field Quality Issues (over 25 tons)')
        {       
            options1.add(new SelectOption('Commercial Products','Commercial Products'));
        }else if(request_type == 'Commercial Factory Support Engineer (over 25 tons)')
        {       
            options1.add(new SelectOption('Commercial Products','Commercial Products'));
        }
        
        return options1;
                
    }
    
    public List<SelectOption> getPurposePickLstValue()
    {
        List<SelectOption> options2 = new List<SelectOption>();
        if(request_type == 'International Request')
        {       
            options2.add(new SelectOption('TSM Support','TSM Support'));
        }
        else if(request_type == 'Heavy Applied Design Data (16,17,19,23)')
        {       
            options2.add(new SelectOption('TSM Support','TSM Support'));
        }
        else if(request_type == 'Commercial Literature (over 25 tons)')
        {       
            options2.add(new SelectOption('TSM Support','TSM Support'));
        }
        else if(request_type == 'Heavy Applied CCS Support /Re-Selections (16,17,19,23)')
        {       
            options2.add(new SelectOption('TSM Support','TSM Support'));
        }
        else if(request_type == 'Heavy Applied Start up/Warranty Support (16,17,19,23)')
        {       
            options2.add(new SelectOption('TSM Support','TSM Support'));
        }
        else if(request_type == 'Commercial Unitary Technical Support (over 25 tons)')
        {       
            options2.add(new SelectOption('TSM Support','TSM Support'));
        }
        else if(request_type == 'Commercial Unitary Report Field Quality Issues (over 25 tons)')
        {       
            options2.add(new SelectOption('TSM Support','TSM Support'));
        }
        else if(request_type == 'Commercial Factory Support Engineer (over 25 tons)')
        {       
            options2.add(new SelectOption('PSE Support','PSE Support'));
        }
        
        
        return options2;           
    }*/
    
    public PageReference createCase()
    {
        this.verified = true;
        if (enteredEmail == null || enteredEmail =='')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Email'));
            return null;
        }else
        { 
        
       /* Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Post Sale Support').getRecordTypeId();
        newcase.RecordTypeId=recordTypeId;
       
        newCase.OwnerId = [select Id from Group where Name='ROLE-International' and Type = 'Queue'].Id;*/
        
        //newCase.CCC_Equipment_Category__c = equipment_category;
        //newCase.CCC_Equipment_Purpose__c = support_group_to_assign_case;
        newCase.Request_Type__c= request_type;
        newCase.Status='In Progress';
        newCase.Origin='Web';
         if(request_type == 'International Request')
        {
        newCase.OwnerId = [select Id from Group where Name='ROLE-International' and Type ='Queue'].Id;
        //newCase.CCC_Equipment_Category__c = 'Commercial Product';
        //newCase.CCC_Equipment_Purpose__c = 'TSM Support';
        }
        else if(request_type == 'Heavy Applied Design Data (16,17,19,23)')

        {
         newCase.OwnerId = [select Id from Group where Name='ROLE Call Center'and Type ='Queue'].Id;
         //newCase.CCC_Equipment_Category__c = 'Commercial Product';
         //newCase.CCC_Equipment_Purpose__c = 'TSM Support';
        }
        else if(request_type == 'Commercial Literature (over 25 tons)')

        {
         newCase.OwnerId = [select Id from Group where Name='ROLE Call Center'and Type ='Queue'].Id;
         //newCase.CCC_Equipment_Category__c = 'Commercial Product';
         //newCase.CCC_Equipment_Purpose__c = 'TSM Support';
        }

        else if(request_type == 'Heavy Applied CCS Support /Re-Selections (16,17,19,23)')
        {
         newCase.OwnerId = [select Id from Group where Name='CCS Service Engineers'and Type ='Queue'].Id;
         //newCase.CCC_Equipment_Category__c = 'Applied Product';
         //newCase.CCC_Equipment_Purpose__c = 'TSM Support';
        }

        else if(request_type == 'Heavy Applied Start up/Warranty Support (16,17,19,23)')

        {
         newCase.OwnerId = [select Id from Group where Name='Quality TSM Applied'and Type ='Queue'].Id;
         //newCase.CCC_Equipment_Category__c = 'Applied Product';
         //newCase.CCC_Equipment_Purpose__c = 'TSM Support';
        }

        else if(request_type == 'Commercial Unitary Technical Support (over 25 tons)')

        {
         newCase.OwnerId = [select Id from Group where Name='Commercial TSMs'and Type ='Queue'].Id;
         //newCase.CCC_Equipment_Category__c = 'Commercial Product';
         //newCase.CCC_Equipment_Purpose__c = 'TSM Support';
        }

        else if(request_type == 'Commercial Unitary Report Field Quality Issues (over 25 tons)')

        {
         newCase.OwnerId = [select Id from Group where Name='Commercial TSMs'and Type ='Queue'].Id;
         //newCase.CCC_Equipment_Category__c = 'Commercial Product';
         //newCase.CCC_Equipment_Purpose__c = 'TSM Support';
        }
        else if(request_type == 'Commercial Factory Support Engineer (over 25 tons)')

        {
         newCase.OwnerId = [select Id from Group where Name='Quality PSE Commercial'and Type ='Queue'].Id;
         //newCase.CCC_Equipment_Category__c = 'Commercial Product';
         //newCase.CCC_Equipment_Purpose__c = 'PSE Support';
        }


        keepDescription=newCase.Description;
        /*if(selectedEquipment != null)
        {
        newCase.CCC_Equipment_Category__c=selectedEquipment;
        }
        if(selectedPurpose != null)
        {
        newCase.CCC_Equipment_Purpose__c=selectedPurpose;
        }*/
        
        
        if(newCase.CCC_Model_Number__c != null && newCase.CCC_Model_Number__c !='')
        {
        newCase.Subject=newCase.CCC_Model_Number__c.substring(0,4)+'- '+ '"Web Case"';
        }
        try{
        
        findContact= [FIND :enteredEmail IN Email Fields RETURNING Contact(Id)];
        system.debug('---------------> SOQL Value'+findContact);
        
        Contact [] contactList = ((List<Contact>)findContact[0]);
        contactList=[Select Id, Email from Contact where Id in:contactList];
        system.debug('-------------->querying and assigning the contacts to list'+contactList);
                
        if(contactList.size() == 1)
        {
        newCase.ContactId=contactList[0].Id;
        if(newCase.Description == null)
        {
        newCase.Description='';
        }
        
        newCase.Description=newCase.Description+' '+ 'Name:'+ enteredName;
        }
        else if(contactList.size()>1)
        {
            system.debug('---------------> inside the Else if condition where contactlist is more than 1 value');
            for(Contact getEmail:contactList)
            {
              system.debug('------------->Enetered in to for loop which is inside the else if condition');
              if(getEmail.Email==enteredEmail && i<2)
              {
             
              newCase.ContactId=getEmail.Id;
              i++;
               system.debug('---------------> inside the Email Match if condition'+ i);
              if(newCase.Description == null)
                {
                    newCase.Description='';
                }
                
                if(i==1)
                {
                newCase.Description=newCase.Description+' '+ 'Name:'+ enteredName;
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
        newCase.Description=newCase.Description+' '+ 'Name:'+ enteredName+' '+ 'Email:'+' '+enteredEmail+' '+'No contacts were found with the provided Email Address';
        }
        
        if(i==2)
        {
        newCase.ContactId=null;
        newCase.Description=keepDescription+' '+ 'Name:'+ enteredName+' '+ 'Email:'+' '+enteredEmail+' '+'Multiple Contacts were found with the provided Email Address';
        system.debug('---------------> Inside the i==2 if condition');
        }

        }
        
        Catch(Exception E)
        {
        system.debug(E.getMessage());
        }
       
              
        insert newCase;
        
        if(fileBody != null && fileName != null)
        {
          Attachment myAttachment  = new Attachment();
          myAttachment.Body = fileBody;
          myAttachment.Name = fileName;
          myAttachment.ParentId = newCase.Id;
          insert myAttachment;
          
        }
       
       return Page.CustomerCommunityCaseCreationMsg;
  }
       return null;  
        
        
        }
    }