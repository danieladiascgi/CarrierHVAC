@isTest(SeeAllData=true)
public class TestDistLocMapExtLnkCntrl {
public static testMethod void testDistributorLocatorNoDealerFromSmartSearch(){
        Case c = new Case();
        c.subject='testing';
        c.Description='test';
        insert c;
    	System.currentPageReference().getParameters().put('phoneFromURL', '3159288246');
    	System.currentPageReference().getParameters().put('id', c.Id);
        //System.currentPageReference().getParameters().put('id', '');
    	System.currentPageReference().getParameters().put('source', 'SmartSearch');
        
        DistributorLocatorMapExtLinkController cont = new DistributorLocatorMapExtLinkController();
    	cont.showPopup();
    	cont.selectedDealerName = '';
    	cont.selectedDealerId = '';
    	cont.brandname = 'Carrier';
    	cont.closePopup();
    	cont.myString = 'NY';
    	cont.showStateResults();
    }
    public static testMethod void testDistributorLocatorNoDealerFromExternalLink(){
        Case c = new Case();
        c.subject='testing';
        c.Description='test';
        insert c;
    	System.currentPageReference().getParameters().put('phoneFromURL', '3159288246');
    	System.currentPageReference().getParameters().put('id', c.Id);
    	System.currentPageReference().getParameters().put('source', 'ExternalLink');
        DistributorLocatorMapExtLinkController cont = new DistributorLocatorMapExtLinkController();
    	cont.showPopup();
    	cont.selectedDealerName = 'Testing';
    	cont.selectedDealerId = '12345';
    	cont.brandname = 'Carrier';
    	cont.closePopup();
    	cont.myString = 'NY';
    	cont.showStateResults();
    }
    public static testMethod void testDistributorLocatorNoDealerFromDistLoctBtn(){
        Case c = new Case();
        c.subject='testing';
        c.Description='test';
        insert c;
    	System.currentPageReference().getParameters().put('phoneFromURL', '3159288246');
    	System.currentPageReference().getParameters().put('id', c.Id);
    	System.currentPageReference().getParameters().put('source', 'DistLoctBtn');
        DistributorLocatorMapExtLinkController cont = new DistributorLocatorMapExtLinkController();
    	cont.showPopup();
    	cont.selectedDealerName = 'Testing';
    	cont.selectedDealerId = '';
    	cont.brandname = 'Carrier';
    	cont.closePopup();
    	cont.myString = 'NY';
    	cont.showStateResults();
    }
    
}