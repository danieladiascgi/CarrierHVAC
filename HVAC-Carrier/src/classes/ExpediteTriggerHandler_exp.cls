public class ExpediteTriggerHandler_exp{
    public EmailMessage emailMsg {get; private set;}
    
    public  Void updateProductDetails(List<Expedite__c> objExpList) {
        
        List<Product2> objProd= new List<Product2>();
        //creating a set of IDs to map Part records with Exp Records.
        Set<Id> ExpId= new Set<id>();
        for(Expedite__c ObjExp:objExpList){
            //Add Product IDs to the case ID Set.
            ExpId.add(ObjExp.Part__c); 
        }
        /*Fetch all Product records where Id matches the Updated/Inserted Part field on Expedite Updated/Inserted  */
        //If statement starts.
        if(ExpId.Size()>0||ExpId!= null){
            MAP<ID ,Product2> mapCon = new MAP<ID ,Product2>([Select Id,CCC_Parts_Quantity__c,
                                                              CCC_Buyer__c,CCC_ItemType__c,CCC_Planner__c,
                                                              Description,CCC_CasePack__c,Name,
                                                              CCC_Vendor_Code__c,ProductCode,
                                                              CCC_Vendor_Name__c from Product2 where id IN:ExpId]);
            
            
            /*Iterate On all Case List and populate Product/Part data on Case Record  */  
            //for loop starts.
            for(Expedite__c ObjExp:objExpList){
                // if statement starts
                if(ObjExp.Part__c != null)
                {
                    //Maps Product Id to case's CCC_Part__c field.
                    Product2 prod= mapCon.get(ObjExp.Part__c);
                    //objCase.CCC_Part_Quantity__c = prod.CCC_CasePack__c;
                    ObjExp.Part_Number__c = prod.Name;
                    ObjExp.Buyer__c =  prod.CCC_Buyer__c;
                    ObjExp.Part_Description__c = prod.Description;
                    ObjExp.Vendor_Code__c= prod.CCC_Vendor_Code__c;
                    ObjExp.Vendor_Name__c = prod.CCC_Vendor_Name__c;
                    ObjExp.Stocking_Type__c = prod.CCC_ItemType__c;
                    ObjExp.Planner__c = prod.CCC_Planner__c;
                    if(prod.CCC_Planner__c!=null && prod.CCC_Planner__c.length()>0 && (prod.CCC_Planner__c.contains('Hills') || prod.CCC_Planner__c.contains('Gates') || prod.CCC_Planner__c.contains('Shurtleff'))){
                        objExp.OwnerId = [Select Id from User where Name='Lynda Jordan' limit 1].Id;
                    }else if(prod.CCC_Planner__c!=null && prod.CCC_Planner__c.length()>0 && (prod.CCC_Planner__c.contains('Grace') || prod.CCC_Planner__c.contains('Swoape') || prod.CCC_Planner__c.contains('Vito') || prod.CCC_Planner__c.contains('Sawdey'))){
                        objExp.OwnerId = [Select Id from User where Name='Paula Eastman' limit 1].Id;
                    }
                }  //if statement ends.
                
                //else statement ends.
            }  //for loop ends.
        }  //if statement ends.
    }
    
    
    
    public void UpdateEmailDetails(List<Expedite__c> objExpList) { 
        Set<Id> ExpCaseNos = new set<Id>();
        for(Expedite__c ObjExp : objExpList){ 
            ExpCaseNos.add(ObjExp.Case_Number__c);     
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage(); 
            EmailTemplate templateid = new EmailTemplate ();
            
            //  Id ContactId = [SELECT Id,Case_Number__r.ContactId FROM Expedite__c where id=:ObjExp.Id].Case_Number__r.ContactId;
            
            //  system.debug('ContactId'+ContactId);
            if(ObjExp.Expedite_Status__c=='Supplier #1'){
                templateid = [Select Id,Body from EmailTemplate where Name='Supplier 1'];
            }
            else if(ObjExp.Expedite_Status__c =='Supplier #2'){
                templateid = [Select Id,Body from EmailTemplate where Name='Supplier 2'];    
            }
            /*else if(ObjExp.Expedite_Status__c == 'Supplier #3'){
                templateid = [Select Id,Body from EmailTemplate where Name='Supplier Promise'];   
            }*/
            mail.setUseSignature(false);
            // mail.setTargetObjectId(ObjExp.Contact_Name__c);
            //  mail.settemplateid(templateid.id);
            // mail.setWhatId(ObjExp.Id);
            Id owdid = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='RCD Expediting'].get(0).id;
            Messaging.SingleEmailMessage email =
                Messaging.renderStoredEmailTemplate(templateid.id , ObjExp.Contact_Name__c , ObjExp.Id);
            mail.setHtmlBody(email.getHtmlBody());
            mail.setSubject(email.getSubject());
            mail.setPlainTextBody(email.getPlainTextBody());
            mail.setSaveAsActivity(false);
            mail.setReplyTo('rcdexpediting@carrier.utc.com');
            mail.setOrgWideEmailAddressId(owdid);
            if(ObjExp.Sender_s_Email__c!=null){
                String[] toAddresses = new String[] {(ObjExp.Sender_s_Email__c)};
                    mail.setToAddresses(toAddresses);
                Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{mail};
                    messaging.sendEmail(mailList);
                System.debug(mailList[0].getToAddresses());
                EmailMessage emailmsg = new EmailMessage();
                emailmsg.ToAddress=(mailList[0].getToAddresses())[0];
                emailmsg.Subject=(mailList[0].getSubject());
                emailmsg.ParentId=ObjExp.Case_Number__c;
                //  emailmsg.FromAddress=('rcdexpediting@carrier.utc.com');
                insert emailmsg; 
            }
        }
    }
}