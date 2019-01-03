@isTest
public class ServiceBenchFetchRestAPI_test {

public static testMethod void testPostRestService(){
        
    ServiceBenchFetchRestAPI.partDetails pd = new ServiceBenchFetchRestAPI.partDetails();
    Warranty_Claim__c wc =new Warranty_Claim__c();
    wc.Application_Type__c = 'Te345345';
    wc.Claim_Status__c = 'REV';
    wc.Name = 'Te345345';
 //     insert wc;
    Parts__c pr = new Parts__c();
 //   pr.partNo__c = '63GFVT5';
    pr.Warranty_Claim__c = wc.Id;
    pd.CasualPart = false;
    pd.CompetitorPart = false;
    pd.FailedPartInstallDate = Date.today();
    pd.FailedPartQuantity = '5';
    pd.PartMarkUp = 55.55;
    pd.PartDisposition = '';
    pd.PartPriceExtended = 55.545;
    pd.ReplacePartDescription = '';
    pd.ReplacePartInvoiceNumber = 55;
    pd.ReplacedPartNo = '';
    pd.ReplacedPartSerialNo = '';
    pd.ReplacePartQuantity = 5;
    pd.UnitPrice = 55.564;
    pd.FailedPartNo = '';
     
    //insert pr;
    List<ServiceBenchFetchRestAPI.partDetails> pdlst = new List<ServiceBenchFetchRestAPI.partDetails>();
   // pd = new partDetails();
   // pd.partNo ='63GFVT5';
    pdlst.add(pd);
    ServiceBenchFetchRestAPI.wrapObj res = new ServiceBenchFetchRestAPI.wrapObj();
   
    res.ClaimStatus = wc.Claim_Status__c;
    res.claimApptype = wc.Application_Type__c;
    res.partDetails = pdlst;
    String JsonMsg=JSON.serialize(res);
    Test.startTest();
    RestRequest req = new RestRequest(); 
    RestResponse response = new RestResponse();
     
    req.requestURI = '/services/apexrest/ServiceBenchReviewQueue';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response = response;
    
    ServiceBenchFetchRestAPI.ResponseHandler resHandler = new ServiceBenchFetchRestAPI.ResponseHandler();
    resHandler = ServiceBenchFetchRestAPI.doPost(res);
  //  System.assert(resHandler.Status.contains('Success-Inserted'));//Assert the response has message as expected 
  //  System.assert(resHandler.ErrorCode.contains('Done'));
    Test.stopTest();
    

    }   
    
}