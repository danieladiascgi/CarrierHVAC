public class CaseUpdateonFeedViewExt {
    public Case currentCase {get;set;}
    public string strPurpose {get;set;}
    public List<SelectOption> CCCPurpose{get;set;}
    public string strSubPurpose{get;set;}
    public String act{get;set;}
    public String readonly {get;set;}
    public CaseUpdateonFeedViewExt(ApexPages.StandardController controller) {
     ID CaseId= (ID)controller.getRecord().id;
     currentCase =[select id, CCC_Purpose__c,CCC_Sub_Purpose__c from case where id=:CaseId];
    
    }
    
     public void caseupdate() {
        strPurpose =System.currentPageReference().getParameters().get('Mahavir');
        strSubPurpose =System.currentPageReference().getParameters().get('Mahavir2');
        System.debug('!!!!!!!!!!!!!!!!!!!asish!!!!!!!!!!!!!LeadType!!!!!!!!!!!!!!!!!'+strPurpose );
        System.debug('!!!!!!!!!!!!!!!!!!!asish!!!!!!!!!!!!!LeadType!!!!!!!!!!!!!!!!!'+strSubPurpose );
        if(strPurpose !=Null && strSubPurpose !=Null){
            currentCase.CCC_Purpose__c =strPurpose ;
            currentCase.CCC_Sub_Purpose__c=strSubPurpose;
            update currentCase;
            readonly = 'true';
       
        }
        
     }
     public PageReference save() {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record has been updated successfully'));
           return null;
    }
    
}