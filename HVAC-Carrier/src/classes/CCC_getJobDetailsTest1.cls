@isTest(SeeAllData=true)
public class CCC_getJobDetailsTest1{
Static testMethod void method1(){
CCC_getJobDetails getjob=new CCC_getJobDetails();
Case newCase=new Case();
newcase=[Select Id from case limit 1];
CCC_getJobDetails.getJobDetails(newCase.Id);
    Case cse = [select id from Case where CCC_Serial_Number__c<>null AND CCC_Model_Number__c<>null limit 1];
    Test.setMock(HttpCalloutMock.class,new CCC_HttpResponseGeneratorEquipSearchTest());           
    CCC_getJobDetails.getProductFamilyDetails(cse.Id);
    CCC_getJobDetails.DiscreteModelNumbersWrapper wrp = new CCC_getJobDetails.DiscreteModelNumbersWrapper();
    wrp.dataQualityIndicator = 0;
    wrp.derivedMfgDate = '';
    wrp.discreetNo = '';
    wrp.mfgDate = '';
    wrp.MfgPlant = '';
    wrp.mfgWeek = 0;
    wrp.mfgYear = 0;
    wrp.model = '';
    wrp.msg = '';
    wrp.ProductFamily = '';
    wrp.selected = false;
    wrp.serial = '';
    wrp.serialVerified = false;
    wrp.shippedDate = '';
    wrp.shipTo = '';
    wrp.suGuid = '';
}
}