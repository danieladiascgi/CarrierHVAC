//
// Custom controller for lookup example popup page
//
public with sharing class LookupPopupController 
{
	public String query {get; set;}
	public List<Account> accounts {get; set;}
    public String searchValue{get; set;}
    
    public LookupPopupController(){
        query = ApexPages.currentPage().getParameters().get('nameValue');
        if(query!=null && query.length()>0){
            runQuery();
        }
        
    }
	public PageReference runQuery()
	{
		/*List<List<Account>> searchResults=[FIND :query IN ALL FIELDS RETURNING Account (id, name, billingstreet, billingcity, billingpostalcode)];
		accounts=searchResults[0];*/
        String queryStr = '%'+query+'%';
        accounts = [Select Id, Name, BillingStreet, BillingCity, BillingState, Site, Type from Account where Type='Dealer' and CCC_Account_Display_Name__c like :queryStr];
  		return null;
	}
}