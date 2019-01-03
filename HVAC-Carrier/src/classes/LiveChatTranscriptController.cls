public class LiveChatTranscriptController{
    
    public Id caseId1{get; set;}
    public Id LiveChatId{get;set;}
    public String partNumber{get; set;}
    
    public LiveChatTranscriptController(ApexPages.StandardController controller){
        LivechatId=apexpages.currentPage().getparameters().get('Id');
        // partNumber = ApexPages.currentPage().getParameters().get('partNumber');
        System.debug('**LivechatId**'+LivechatId);
       // getcase();
    }  
    public void getCase(){
        LiveChatTranscript lct =[Select Id,CaseId from LiveChatTranscript where Id=:LivechatId];
        System.debug('livechat:'+lct);
        if(lct.CaseId!=null){
                        system.debug('@caseid'+CaseId1);

            CaseId1=lct.CaseId;  
            system.debug('@caseid'+CaseId1);
            
            CASE  c= [SELECT Id,CaseNumber,CCC_Part__c,CCC_Part_Number__c,CCC_Part_Quantity__c,CCC_Part_Description__c,
                      CCC_Planner__c,CCC_Product_Buyer__c,CCC_Vendor_Code__c,CCC_Vendor_Name__c,CCC_Stocking_Type__c,Material__c,
                      CCC_C10Order__c,CCC_Customer_PO__c,CCC_RCD_PO__c,CCC_Quote__c,CCC_RMA__c,CCC_RMA_Sent__c,CCC_Invoice__c,
                      CCC_Model_Number__c,CCC_Serial_Number__c from case where Id=:CaseId1];
            System.debug('case:'+c);
            partNumber=c.CCC_Part_Number__c;
            System.debug('#Part Number:'+partNumber);
            System.debug('#Part Lookup:'+c.CCC_Part__c);
            if(partNumber!=null && partNumber.length()>0 && c.CCC_Part__c==null){
                list<Product2> part =[Select id,Name,CCC_Parts_Quantity__c,
                                                              CCC_Buyer__c,CCC_ItemType__c,CCC_Planner__c,
                                                              Description,CCC_CasePack__c,
                                                              CCC_Vendor_Code__c,ProductCode,
                                                              CCC_Vendor_Name__c from product2 where name=:partNumber limit 1];
                System.debug('#Part Ret:'+part);
                if(part!=null && part.size()>0){
                    Product2 pt=part.get(0);
                    system.debug('product'+pt);
                    c.CCC_Part__c=pt.id;
                    System.debug('After assigning Part lookup'+c.CCC_Part__c);
                    update c;
                }
                
                //return c;
                
            }
        }
        
       // return null;
        
    }
    
}