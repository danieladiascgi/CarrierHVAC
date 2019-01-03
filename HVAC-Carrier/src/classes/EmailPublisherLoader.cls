global class EmailPublisherLoader implements QuickAction.QuickActionDefaultsHandler {  
   // Empty constructor  
   string varStatusvalue; 
   global EmailPublisherLoader() {  
   }  
   public string customLabelValue{get;set;}  
   // The main interface method  
   global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) {  
     QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = null;  
     // Check if the quick action is the standard Case Feed send email action  
     for (Integer j = 0; j < defaults.size(); j++) {  
       if (defaults.get(j) instanceof QuickAction.SendEmailQuickActionDefaults &&   
         defaults.get(j).getTargetSObject().getSObjectType() ==   
           EmailMessage.sObjectType &&   
         defaults.get(j).getActionName().equals('Case.Email') &&   
         defaults.get(j).getActionType().equals('Email')) {  
           sendEmailDefaults =   
             (QuickAction.SendEmailQuickActionDefaults)defaults.get(j);  
           break;  
       }  
     }  
     if (sendEmailDefaults != null) {  
       try{
           Case c = [SELECT CaseNumber,CCC_Purpose__c,RecordType.Name, Origin, Type FROM Case   
                WHERE Id=:sendEmailDefaults.getContextId()];  
           EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject();    
           // Set From address to make sure each email goes from sales@inmobi.com  
          // System.debug('rec type '+ c.RecordType.Name);
           if(c.RecordType.Name == 'National Accounts' ){
           
              // System.debug('Purpose ' + c.CCC_Purpose__c);
               National_Account_Purpose__c objPurpose = new National_Account_Purpose__c();
             //  system.debug('c.CCC_Purpose__c :'+c.CCC_Purpose__c);
              // system.debug('National_Account_Purpose__c.getValues(c.CCC_Purpose__c) ' +  National_Account_Purpose__c.getValues(c.CCC_Purpose__c) );

                if(c.CCC_Purpose__c!=null & National_Account_Purpose__c.getValues(c.CCC_Purpose__c)!=null){
                   objPurpose = National_Account_Purpose__c.getValues(c.CCC_Purpose__c);                   
                   emailMessage.FromAddress = objPurpose.EmailAddress__c;  
                   //system.debug('objPurpose  ' + objPurpose.EmailAddress__c);
               }
               else
               {
              // system.debug('>>>???? '+National_Account_Purpose__c.getValues('Order Processing').EmailAddress__c);
                   emailMessage.FromAddress = National_Account_Purpose__c.getValues('Order Processing').EmailAddress__c; 
               }

           
                      
           }else if(c.Origin!=null && c.Origin=='RC Community' && c.RecordType.Name == 'Replacement Component (RC)'){
               String roleId = UserInfo.getUserRoleId();
               String roleName = '';
               if(roleId!=null && roleId.length()>0){
                   roleName = [Select Id, Name from UserRole where Id=:roleId].Name;
               }
               if(roleId!=null && !roleName.startsWith('RC Tech Support')){
                   List<EmailTemplate> custRespTemplate = [Select Id from EmailTemplate where Name='CBP Customer Response'];
                   if(custRespTemplate!=null && custRespTemplate.size()>0){
                        sendEmailDefaults.setTemplateId(custRespTemplate.get(0).Id);    
                   }
               }
               
               
           }else if(c.Type!=null && c.Type=='EPIC' && c.RecordType.Name == 'Replacement Component (RC)'){
               List<EmailTemplate> epicCmtsTemplate = [Select Id from EmailTemplate where Name='EPIC Comments'];
                   if(epicCmtsTemplate!=null && epicCmtsTemplate.size()>0){
                        sendEmailDefaults.setTemplateId(epicCmtsTemplate.get(0).Id);    
                   }
           }                    
           
       }catch (System.CalloutException e){
           System.debug('ERROR:' + e);
       }
       
      }
  }  
 // return email address, Email Address is a from Address and this value is stored in custom label Email Address Label  
 private String getfromAddress(String reason) {  
    customLabelValue = System.Label.Email_Address_Label ;  
                 return customLabelValue;   
     }   
 }