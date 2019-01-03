@isTest(SeeAllData=true)
public class CCC_ProdRegistrationSubmitExtTest {
    public static Case caseRecToUpdate{get; set;}
    public static CCC_Case_Ownership_Matrix__c com{get;set;}
    private static transient Map<String, Id> recordTypeIds;  
    private static transient Map<String, Schema.SObjectType> gd; 
    public static testMethod void startTest(){
        caseRecToUpdate = new Case();
        com = new CCC_Case_Ownership_Matrix__c();
        com.Has_Contract__c = false;
        com.Name = '200';
        caseRecToUpdate.Subject = 'Testing';
        caseRecToUpdate.Description = 'Testing';
        caseRecToUpdate.CCC_Purpose__c = 'Xfr to Prd.Reg— Warranty 1, ext 1064';
        caseRecToUpdate.CCC_Customer_Type__c = 'Commercial';
        caseRecToUpdate.Status = 'Open';
        caseRecToUpdate.CCC_WarrantyCommunity_Purpose__c = 'Add Equipment to Original Confirmation';
        String recordTypeId = getRecordTypeIdByName('Case', 'Product Registration');
        caseRecToUpdate.RecordTypeId = RecordTypeId;
        insert com;
        insert caseRecToUpdate;
        ApexPages.StandardController stdCon = new ApexPages.StandardController(caseRecToUpdate);
        CCC_ProdRegistrationSubmitExt ext = new CCC_ProdRegistrationSubmitExt(stdCon);
        ext.submitAndRedirect();
        caseRecToUpdate.CCC_Purpose__c = '';
        caseRecToUpdate.CCC_WarrantyCommunity_Purpose__c = '';
        update caseRecToUpdate;
        ext.submitAndRedirect();
        caseRecToUpdate.CCC_WarrantyCommunity_Purpose__c = 'Cancel Registration';
        caseRecToUpdate.CCC_Customer_Type__c = 'Commercial';
        caseRecToUpdate.CCC_Model_Number__c = '12345';
        caseRecToUpdate.Service_Bench_Contract_Number__c = '123';
        com.Has_Contract__c = true;
        update com;
        update caseRecToUpdate;
        ext.isInternalUser = true;
        ext.submitAndRedirect();
    }
    public static Id getRecordTypeIdByName(String objectType, String recordType){
        if(recordTypeIds == null)
        {
            recordTypeIds = new Map<String, Id>();
        }
        
        String sKey = objectType + '|' + recordType;
        if(recordTypeIds.get(sKey) == null)
        {
            Schema.DescribeSobjectResult objDesc = describeSObject(objectType);
            System.assert(objDesc != null, 'Invalid objectType ' + objectType);          
            Map<String, Schema.RecordTypeInfo> rtInfos = objDesc.getRecordTypeInfosByName(); 
            for(String rtName: rtInfos.keySet())
            {
                RecordTypeInfo rt = rtInfos.get(rtName);
                if(rt != null)
                {
                    String sKey2 = objectType + '|' + rtName;
                    recordTypeIds.put(sKey2, rt.getRecordTypeId());              
                }
            }
        }
        
        return recordTypeIds.get(sKey);
    }
    private static Schema.DescribeSObjectResult describeSObject(String objectType)
    {
        Schema.SObjectType ot = getObjectType(objectType);
        if(ot == null) return null;
        return ot.getDescribe();
    } 
    private static Schema.SObjectType getObjectType(String objectType)
    {
        if(gd == null)
            gd = Schema.getGlobalDescribe();
        Schema.SObjectType ot = gd.get(objectType);
        return ot;      
    } 
}