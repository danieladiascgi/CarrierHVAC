@isTest(SeeAllData=true)
public class TestLookupPopupControllerForContact {
    public static testMethod void testLookupPopupSearchForContact(){
        ApexPages.currentPage().getParameters().put('nameValue', 'Testing');        
        LookupPopupControllerForContact cont = new LookupPopupControllerForContact();
        cont.searchValue = 'Test';
    }

}