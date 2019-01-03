@isTest(SeeAllData=true)
public class TestLookupPopupController {
    public static testMethod void testLookupPopupSearch(){
        ApexPages.currentPage().getParameters().put('nameValue', 'Testing');        
        LookupPopupController cont = new LookupPopupController();
        cont.searchValue = 'Test';
    }
}