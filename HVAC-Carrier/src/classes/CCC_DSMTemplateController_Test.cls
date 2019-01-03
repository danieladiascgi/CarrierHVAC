@isTest
private class CCC_DSMTemplateController_Test {
    static testMethod void verifyAccountDescriptionsWhereOverwritten(){          
        test.startTest();                  
            Asset a = new Asset(Name = 'Test Account ', CCC_Model_Number__c = '123', Brand__c = 'test');
            insert a;
            Asset testAssetId = [SELECT Id, Name, CCC_Model_Number__c, Brand__c FROM Asset WHERE CCC_Model_Number__c = '123'];

            Case testCase = new Case(Status ='New', Origin='Phone', Subject='This is a test case for testCaseForForum');
            insert(testCase);
            Case testCaseId = [SELECT Id, CaseNumber, Status, Origin, Subject FROM Case WHERE Subject='This is a test case for testCaseForForum'];

            CCC_junctionCaseAsset__c testJCA = new CCC_junctionCaseAsset__c(Case__c =  testCaseId.Id, Asset__c = testAssetId.Id);
            insert(testJCA);
            
            CCC_DSMTemplateController dSMTC= new CCC_DSMTemplateController();
            dSMTC.getjunRecords();            
        test.stopTest();        
    }
}