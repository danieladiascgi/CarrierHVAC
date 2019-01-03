/**
* @ Developer : Diksha Batra
* @date_created : 1/14/2016
* @functions : This controller is used to fetch the records from suggested dealer related list from case and is used in a visualforce page template to send it to the customer through email.
*              It fetches the list of dealers from the webservice based on the zipcode that is fetched generally from contact MailingPostalCode and additional
*              filters like brand(CA and BR) , radius and Searchfilters. Also it saves selected dealers into suggested dealer object and display it back on screen.
*
*
***/

Public Class CCC_ResidentialEmailTemplateController  {
    
    
    ApexPages.standardController Standard_Controller = null;
    public String responseStr{get;set;}
    public string zip{get;set;} 
    public String rdl_SiteType{get;set;}
    public String rdl_Brand {get;set;}
    public String rdl_SearchType {get;set;}
    public Id caseid;
    public Id caseObjid {get;set;}
    Public case c;
    public boolean showEWrrormsg{get;set;}
    public String rdl_Zip{get;set;}
    public String rdl_Country{get;set;}
    public Integer rdl_iSearchRadius {get;set;}
    public Integer rdl_DealerCount {get;set;}
    public String rdl_SearchFilter {get;set;}
    public List<DealerDetails> lstDealers{get;set;}
    public string error_message{get;set;}
    public List<DealerWrapper> DealerList {get;set;}
    public List<DealerDetails> selectedDealer = new List<DealerDetails>();    
    public List <CCC_Suggested_Dealers__c> SuggDealList ;
    public List <CCC_Suggested_Dealers__c> SelectedDealerList;
    public list<DealerWrapper> existingRecords {get;set;}
    public List <CCC_Suggested_Dealers__c> dealersExistinglist;
    public Id caseobj{get;set;}
    public Id caseobjectid {get;set;}
    CCC_ErrorLog errlog=new CCC_ErrorLog();
    public  CCC_IntegrationEndPoint__c  CustomSettingEndPoint;    
    
    /**
* This method is used to get the details of existing records that are linked to the case.
* @Developer : Ishita Sharma
**/
    public string getExitDealerRecords()
    {
        if(caseobjectid!=null ){
            c=[select id, casenumber,Accountid,ContactId from case where id =:caseobjectid]; 
            caseobj=c.id;
            If(c.ContactId!=null){
                zip=[select MailingPostalCode from contact where id=:c.ContactId].MailingPostalCode;
            }
        }
        dealersExistinglist  = new list<CCC_Suggested_Dealers__c>();
        existingRecords = new list<DealerWrapper>();
        findExisitingRecords();
        return zip;
    }
    
    //Constructor Call
    
    public CCC_ResidentialEmailTemplateController () { 
        
        responseStr = 'Request is yet to be raised';
        rdl_SiteType = 'Consumer';       
        rdl_Brand  = 'CA';
        rdl_SearchType  = 'territory';
        rdl_Zip = '';
        rdl_Country = 'USA'; //USA
        rdl_iSearchRadius  = 30;
        rdl_DealerCount  = 20;
        rdl_SearchFilter  = '';
        lstDealers = new List<DealerDetails>();
        system.debug('Constructor call'+rdl_SiteType+rdl_Brand+rdl_SearchType+rdl_Zip+rdl_Country+rdl_iSearchRadius+rdl_DealerCount+rdl_SearchFilter);
        dealersExistinglist  = new list<CCC_Suggested_Dealers__c>();
        existingRecords = new list<DealerWrapper>();
        
    }
    /**
* This method will call the dealer locator webservice which fetches the dealer details.
* @Developer :Diksha Batra
**/
    public void getDealerDetails(){       
        zip= getExitDealerRecords();
        getDealersDetail(rdl_SiteType, rdl_Brand, rdl_SearchType, zip, rdl_DealerCount,  rdl_Country, rdl_iSearchRadius, rdl_SearchFilter);
        
    }
    /**
* This method will call the dealer locator webservice which fetches the dealer details.
* @Parameters - String siteType, String brand - BR or CA, String searchType , String zip-  Valid US Zipcode, integer dealerCount-  Count of dealers to be shown,
* String country- USA, Integer radius- Radius under which search is to be done , String filters - used as a pichlist to filter.
* @Developer :Diksha Batra
**/
    private void getDealersDetail (String siteType, String brand, String searchType , String zip, integer dealerCount, String country, Integer radius , String filters){       
        CustomSettingEndPoint = CCC_IntegrationEndPoint__c.getValues('Dealer_Locator');
        String username = CustomSettingEndPoint.UserName__c;           
        String password = CustomSettingEndPoint.Password__c;           
        String securityToken = CustomSettingEndPoint.Token__c;    
        String baseURL = CustomSettingEndPoint.URL__c ;    
        
        
        String clientKey = '6B8A7EE7-9046-4F2D-A511-8BCE992AB2FB';
        baseURL += '?strClientKey='+clientKey;     
        HttpRequest req = new HttpRequest();
        String endPoint = baseURL+'&strSiteType='+siteType+'&strBrand='+brand+'&strSearchType='+searchType+'&strZip='+zip+'&idealerCount='+dealerCount+'&strCountry='+country+'&iSearchRadius='+radius+'&strFilter='+filters;        
        req.setEndpoint(endpoint);
        system.debug('------------------endpoint------------------' + endpoint);
        req.setMethod('GET');
        
        String authorizationHeader = 'Bearer ' + securityToken  ;
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/xml');
        req.setHeader('Accept', 'application/xml');
        Http http = new Http();
        HTTPResponse res;
        
        
        try{
            res = http.send(req);
            System.debug(res.getBody());
            responseStr = res.getBody();
            system.debug('-------------responseStr-----'+responseStr );
            lstDealers=New List<DealerDetails> ();
            
            //The code is for Parsing the XML response and checks the tags and its values based on the brand selected.
            
            Dom.Document docx = new Dom.Document();
            docx.load(responseStr);
            dom.XmlNode xroot = docx.getrootelement() ;
            
            for(Dom.XMLNode child : xroot.getChildren()) {
                if(child.getName()=='Dealers'){
                    for(Dom.XMLNode child1 : child.getChildElements())
                    {
                        DealerDetails details = new DealerDetails();
                        for(Dom.XMLNode child2 : child1.getChildElements()){
                            
                            if(child2.getName() != 'Icons'){
                                
                                if(child2.getName()=='DealerName'){
                                    details.dealerName = child2.getText();
                                    system.debug('-------DealerName-----'+child2.getText());
                                }
                                if(child2.getName()=='PostalAddress'){
                                    details.postalAddress = child2.getText();
                                    system.debug('-------PostalAddress-----'+child2.getText());
                                }
                                if(child2.getName()=='City'){
                                    details.City = child2.getText();
                                    system.debug('-------PostalAddress-----'+child2.getText());
                                }
                                if(child2.getName()=='State'){
                                    details.State = child2.getText();
                                    system.debug('-------PostalAddress-----'+child2.getText());
                                }
                                if(child2.getName()=='Phone'){
                                    details.Phone = child2.getText();
                                    system.debug('-------PostalAddress-----'+child2.getText());
                                }
                            }
                            
                        }
                        lstDealers.add(details);
                        SuggestedDealer();
                        
                    }
                }
                
            }
            //Checks if list is empty then displays message as 'No dealers found'.
            if(lstDealers.size()==0)
            {
                ApexPages.AddMessage(New ApexPages.message(ApexPages.severity.ERROR,'No dealers found'));
                error_message = 'No Dealers Found';
            } else{
                error_message = '';
            }
            
            
        }
        catch(System.CalloutException e) {
            errlog.ErrorLogCalloutException(e,'DealerLocator WebService','CCC_ResidentialDealerLocatorController');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Dealer Records Found '));
            
        }
        
        Catch(Exception e){
            //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
            errlog.ErrorLogException(e,'DealerLocator WebService','CCC_ResidentialDealerLocatorController');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Matching Dealer Records Found '));
            //responseStr = 'Exception occured while retriving document information';
            
        }
    }
    
    /**
* This class contains arguments of the dealers
* @Developer :Diksha Batra
**/
    public class DealerDetails{
        public String dealerId {get;set;}
        public String dealerName {get;set;}
        public String postalAddress {get;set;}
        public String City {get;set;}
        public String State{get;set;}
        public String ZipCode{get;set;}
        public String Country{get;set;}
        public String Phone{get;set;}
        public String TollFree{get;set;}
        public String Fax{get;set;}
        public String Email{get;set;}
        public String Website{get;set;}
        public String MarketingMessage{get;set;}
        public String RetailStore{get;set;}
        public String HoursOfOperation{get;set;}
        public String YearsInBusiness{get;set;}
        public String LeadEligible{get;set;}
        public String DistanceInMiles{get;set;}
        public String DistanceInKM{get;set;}
        public String Latitude{get;set;}
        public String Longitude{get;set;}
        public string MapURL{get;set;}
        public string ContactFormURL{get;set;}  
        
    }
    /**
* This method will find the existing records that are added to the suggested dealer object
* @Developer : Diksha Batra
**/
    public void findExisitingRecords(){
        list<CCC_Suggested_Dealers__c> regList = new list<CCC_Suggested_Dealers__c>();
        //getopptys();
        
        if(c != null && c.id != null){
            regList = [Select id,Name,CCC_DealerPostal_Address__c,CCC_Dealer_City__c,CCC_Dealer_Phone__c
                       from CCC_Suggested_Dealers__c where CCC_Case__c =: c.id];
            
        }
        
        for(CCC_Suggested_Dealers__c reg: regList ){
            existingRecords.add(new DealerWrapper(reg,false));
        }
    }
    
    /**
* This method will display the selected records that are added to the suggested dealer object and display it on vf page.
* @Developer : Diksha Batra
**/
    public void populateSelected(){
        for(DealerWrapper reg: existingRecords){
            if(reg.selected && dealersExistinglist.size() > 0){
                dealersExistinglist[0] = reg.DealerLoc ;  
                
            }
        }
    }
    /**
* This is the wrapper class to bind suggested dealer object and boolean checkbox.
* @Developer : Diksha Batra
**/  
    public class DealerWrapper{
        public Boolean selected {get; set;}
        public CCC_Suggested_Dealers__c DealerLoc{get; set;}
        public CCC_Suggested_Dealers__c DealerLoc(){            
            return DealerLoc;
        }
        public DealerWrapper(CCC_Suggested_Dealers__c deal,Boolean check) {
            this.selected = check;
            this.DealerLoc= deal;
        }
    }
    /**
* This method will display list of dealers from wrapper class and will not display duplicate dealer recordes that are already added to the case.
* @Developer : Diksha Batra
**/
    public void SuggestedDealer(){
        SuggDealList =new list<CCC_Suggested_Dealers__c>();
        for(DealerDetails deal : lstDealers){
            CCC_Suggested_Dealers__c sugg = new  CCC_Suggested_Dealers__c();
            sugg.Name = deal.dealerName;
            sugg.CCC_Dealer_City__c = deal.City;
            sugg.CCC_Dealer_Phone__c = deal.Phone;
            sugg.CCC_DealerPostal_Address__c = deal.postalAddress;                          
            SuggDealList.add(sugg);
        }                        
        DealerList =new list <DealerWrapper>();   
        for( CCC_Suggested_Dealers__c sugstdeal : SuggDealList){
            DealerList.add(new DealerWrapper(sugstdeal,false) );
        }
    }
}