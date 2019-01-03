public class CaseEmailCheck_Controller {
    
    //Variables declaration
    public case currentCase; // to hold the case record
    PageReference pageRef;  // to redirect page to record detail page
    boolean flag=false; // not to refersh the page infinite

    
    
    public CaseEmailCheck_Controller(ApexPages.StandardController stdcontroller) {
        
        //fetch the record information
        this.currentcase=(case)stdcontroller.getRecord();
        
    }
    
    
    public pageReference init(){
        
        //Below query fetches the New_Msg__c which is defined to identify if there are any new emails received againest to this record.
        currentcase=[select Id, New_Msg__c from Case where Id=:currentcase.Id ];
        List<EmailMessage> allEmails= new List<EmailMessage>();
        //Below query fetches the emails which are present on the associated case record.
        allEmails=[Select Id, Status from EmailMessage where ParentId=:currentcase.Id];
        if(allEmails != null)
        {
            for(Emailmessage mail:allEmails)
            {
                //below condition is to check if there is any unread/New email existed on the record.
                if(mail.status == '0')
                {
                    flag=true;
                    
                }
            }
            
            if(flag)
            {
                //if there is any new unread/New email, then we should not update the case record, so below code simply returns the null value
                return null;
            }
            //Record should not be refreshed if New_Msg__c is already "false" on the record.
            // If New_Msg__c equals to true and if there are no unread/New emails and below block will be executed to update the record.
            else if(currentcase.New_Msg__c==true){
                currentcase.New_Msg__c=false;
                Database.update(CurrentCase);
                pageRef = new pagereference('/' + Currentcase.Id);
                PageRef.setRedirect(true);
                return PageRef;
            }
            
            return null;
            
        }
        else{
            return null;
        }
    }
    
    public PageReference caseCommentUncheck()
    {
          //Below query fetches the New_Msg__c which is defined to identify if there are any new emails received againest to this record.
        currentcase=[select Id, New_Comment__c from Case where Id=:currentcase.Id ];
           
            
             if(currentcase.New_Comment__c==true){
                currentcase.New_Comment__c=false;
                Database.update(CurrentCase);
                pageRef = new pagereference('/apex/CaseDetails?id=' + Currentcase.Id);
                PageRef.setRedirect(true);
                return PageRef;
            }
            
            return null;
            

    }
}