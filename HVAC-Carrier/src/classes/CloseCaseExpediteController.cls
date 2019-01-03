public class CloseCaseExpediteController {
    public Id caseId{get; set;}
    public Expedite__c ex {get; set;}
   
    public CloseCaseExpediteController(ApexPages.StandardController cont){
        CaseId =apexpages.currentPage().getparameters().get('caseid');
        ex =(Expedite__c)cont.getRecord();
        ex.Status__c='Closed';
        ex=[ SELECT Id, Status__c, Solution__c,Resolution_Code__c,Internal_Comments__c, Subject__c, Description__c FROM Expedite__c where Id=:ex.id];
       
     
    }
    

public List<SelectOption> getStatusOptions() {
    
        List<SelectOption> statusOptions = new List<SelectOption>();
            
        statusOptions.add(new SelectOption('Closed','Closed'));
       // statusOptions.add(new SelectOption('Re-open','Re-open'));
    
        return statusOptions;
    }
    
    public List<SelectOption> getResolutionCodeOptions(){
        
        List<SelectOption> resolutionCodeOptions = new List<SelectOption>();
        
        resolutionCodeOptions.add(new SelectOption('','-None-'));
        resolutionCodeOptions.add(new SelectOption('No Action Required','No Action Required'));
        resolutionCodeOptions.add(new SelectOption('Provided Information','Provided Information'));
        resolutionCodeOptions.add(new SelectOption('Referred to CCS Service','Referred to CCS Service'));
        resolutionCodeOptions.add(new SelectOption('Referred to Credit Collections','Referred to Credit Collections'));
        resolutionCodeOptions.add(new SelectOption('Referred to Distributor','Referred to Distributor'));
        resolutionCodeOptions.add(new SelectOption('Referred to Quote','Referred to Quote'));
        resolutionCodeOptions.add(new SelectOption('Referred to Sales','Referred to Sales'));
        
        return resolutionCodeOptions;
    }

    public PageReference saveAndRedirect(){
        System.debug('#saveAndRedirect');
        upsert ex;
         
        PageReference redirectPage = new PageReference('/apex/SearchTB?caseid='+ex.Id);
        redirectPage.setRedirect(true);
   
    return redirectPage;
    }
    public PageReference saveAndClose(){
        ex.Status__c='Closed';
        upsert ex;
        PageReference redirectPage = new PageReference('/'+ex.Id);
        redirectPage.setRedirect(true);
        return redirectPage;
    }
    public PageReference cancel(){
        PageReference pr = new PageReference('/'+ex.Id);
        pr.setRedirect(true);
        return pr;
    }
}