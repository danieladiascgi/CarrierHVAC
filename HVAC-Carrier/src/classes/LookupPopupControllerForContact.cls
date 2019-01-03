public class LookupPopupControllerForContact {
    public String query {get; set;}
	public List<Contact> contacts {get; set;}
    public List<Contact> contacts1 {get; set;}
    public String searchValue{get; set;}
    
    public LookupPopupControllerForContact(){
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
        if(query.length() > 1)
        {
            String query = '*'+query+'*'; 
            String searchQuery = 'FIND \'' + query + '\' IN ALL FIELDS RETURNING Contact(id),Account(id) ';
            List<List <sObject>> searchList = search.query(searchQuery);
            contacts1  = ((List<contact>)searchList[0]);
            contacts =[select FirstName,LastName,Name,email,id,RecordTypeId,CCC_Account_Address__c,Account.name,Account.RecordTypeId,Account.IsPartner,Phone from contact where id=:contacts1];
         } 
     return null;
	}
}