@IsTest(seeAllData=true)
public class CCC_RegistrationCorrectionUtilityTest {
    public static testMethod void start(){
Test.setMock(HttpCalloutMock.class,new CCC_HttpRegCorrUtilityTest());
    CCC_RegistrationCorrectionUtility.getModelFromSerialSearch('1008X29181');
        CCC_RegistrationCorrectionUtility.DiscreteModelNumbersWrapper testWrp = new CCC_RegistrationCorrectionUtility.DiscreteModelNumbersWrapper();
        testWrp.dataQualityIndicator = 0;
        testWrp.discreetNo = '';
        testWrp.serial = '';
        testWrp.toscode = '';
        testWrp.brand = '';
        testWrp.mfgDate = '';
        testWrp.mfgWeek = 2;
        testWrp.mfgYear = 2;
        testWrp.msg = '';
        testWrp.serialVerified = false;
        testWrp.shippedDate = '';
        testWrp.derivedMfgDate = '';
        testWrp.suGuid = '';
        testWrp.shipTo = '';
        testWrp.selected = false;
        
   }     
}