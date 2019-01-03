/**
* @ Developer : Diksha Batra
* @date_created : 1/14/2016
* @functions : This controller fetches the list of dealers from the webservice based on the zipcode that is fetched generally from contact MailingPostalCode and additional
*              filters like brand(CA and BR) , radius and Searchfilters. Also it saves selected dealers into suggested dealer object and display it back on screen.
* Referenced in Pages - CC_ResidentialDealerLocatorSearch
* @Date Modified : <3/14/2016> Reason: Added additional information section on page and parsed values to it of HoursOfOperation and YearsInBusiness Developer :Diksha Batra
*
*
***/


Public Class CCC_ResidentialDealerLocatorController {

     //Residental Dealer Location using CBP
    ApexPages.standardController Standard_Controller = null;
    public String responseStr{get;set;}
    public string zip{get;set;} 
    public String rdl_SiteType{get;set;}
    public String rdl_Brand {get;set;}
    public String rdl_SearchType {get;set;}
    public Id caseid;
    Public case c;
    public String rdl_Zip{get;set;}
    public String rdl_Country{get;set;}
    public Integer rdl_iSearchRadius {get;set;}
    public Integer rdl_DealerCount {get;set;}
    public String rdl_SearchFilter {get;set;}
    public List<DealerDetails> lstDealers{get;set;}
    public Map<String, String> mapDealers{get; set;}
    public string error_message{get;set;}
    public List<DealerWrapper> DealerList {get;set;}
    public List<DealerDetails> selectedDealer = new List<DealerDetails>();    
    public List <CCC_Suggested_Dealers__c> SuggDealList ;
    public List <CCC_Suggested_Dealers__c> SelectedDealerList;
    public list<DealerWrapper> existingRecords {get;set;}
    public List <CCC_Suggested_Dealers__c> dealersExistinglist;
    public List<CCC_Suggested_Dealers__c> regList {get;set;}
    public String SelectedBrands {get;set;}
    public String SelectedSearchFilter {get;set;}
    public boolean Showradius{get;set;}
    public boolean Showfilter{get;set;}
    public string brandselected{get;set;}
    public  CCC_IntegrationEndPoint__c  CustomSettingEndPoint;
    public CCC_ErrorLog errlog=new CCC_ErrorLog();
    
    public List<selectOption> getrdl_Brands(){
        List<selectOption> brands = new List<selectOption>();
        brands.add(new selectOption('BR','BR'));
        brands.add(new selectOption('CA','CA'));
        return brands;
    }
    
    public List<selectOption> getrdl_SearchFilters(){
        List<selectOption> SearchFilter = new List<selectOption>();
        if(SelectedBrands=='CA'){
            SearchFilter.add(new selectOption('Featured Dealers','Featured Dealers'));
            SearchFilter.add(new selectOption('All Dealers','All Dealers'));
            SearchFilter.add(new selectOption('Ductless Split Systems','Ductless Split Systems'));
            SearchFilter.add(new selectOption('Factory Authorized','Factory Authorized'));
            SearchFilter.add(new selectOption('Financing Offered','Financing Offered'));
            SearchFilter.add(new selectOption('NATE Trained','NATE Trained'));
            SearchFilter.add(new selectOption('Geothermal','Geothermal'));
            //Commented below code since we no longer user "fadonly" and "generator" filters.
            /*SearchFilter.add(new selectOption('fadonly','fadonly'));
            SearchFilter.add(new selectOption('generator','generator'));*/
        
        }
        return SearchFilter;
    }
     /**
     * This method will set the radius and filter according to the brand selected.
     * @Developer : Diksha Batra
     **/
      public void radiusValue(){
            if(SelectedBrands=='BR'){
                rdl_iSearchRadius  = 25;
                Showradius=True;
                Showfilter=False;
            }
            else{
                rdl_iSearchRadius  = 30;
                Showradius=False;
                Showfilter=True;
            }
          
        }
    
     /**
     * This method will check the zipcode pattern is of form 12345-1234
     * @Developer : Ishita Sharma
     **/    
    public static Boolean CheckValidZip(String sZip) {
        return Pattern.matches('\\d{5}(-\\d{4})?',sZip);
    }
        public CCC_ResidentialDealerLocatorController(ApexPages.StandardController controller) {
        
        // RDL Dealer REST API initialization  
        Standard_Controller =  controller;
        responseStr = 'Request is yet to be raised';
        rdl_SiteType ='Consumer';       
        /*Commented the below code to change the search type to "Proximity" since it returns many values and Territory value is only used by Featured Deales(Version one request S-01362)*/    
        //rdl_SearchType  = 'territory';
        rdl_SearchType  = 'Proximity';
        rdl_Zip = '';
        rdl_Country = 'USA'; //USA
        rdl_iSearchRadius  = 25;
        rdl_DealerCount  = 0;
        rdl_SearchFilter  = '';
        rdl_Brand = '';
        Showradius=True;
        Showfilter=False;
        lstDealers = new List<DealerDetails>();  
        mapDealers = new Map<String, String>();
        SelectedSearchFilter = 'Featured Dealers';
        system.debug('Constructor call'+rdl_SiteType+SelectedBrands+rdl_SearchType+rdl_Zip+rdl_Country+rdl_iSearchRadius+rdl_DealerCount+SelectedSearchFilter);
               
        caseid=Apexpages.currentpage().getparameters().get('id');
        c=[select id, Accountid,ContactId,CCC_Brand__c from case where id=:caseid];    
             If(c.ContactId!=null){
                  //Fetches the zipcode from contact mailing Postal code.
                   zip = [select MailingPostalCode from contact where id=:c.ContactId].MailingPostalCode ;
                 if(zip !=null) {
                  if(zip.isNumeric()){
                     //Checks zipcode and trim it to 5 digits.
                      if(zip.length()>4){
                        String Zipsubstring = zip.Substring(0,5);
                        zip=Zipsubstring;
                      }
                      else{
                          zip=zip;
                      }
                      rdl_Country ='USA'; 
                  }
                  
                 else{
                      rdl_Country ='CANADA'; 
                  }
                  //Checks zipcode and trim it to 5 digits if its of the form 12345-1234
                  if(CheckValidZip(zip)){
                           String Zipsubstring = zip.Substring(0,5);
                           zip=Zipsubstring;
                           rdl_Country ='USA';  
                          
                 }
            }
        }
        
        // If selected brand on case page is Carrier - On Page it shows CA else BR.
        If(c.CCC_Brand__c!=null){
           If(c.CCC_Brand__c =='Carrier'){
               SelectedBrands='CA';
               If(SelectedBrands=='CA'){
                   Showradius=False;
                   Showfilter=True;
               }
                
            }
        }
        dealersExistinglist  = new list<CCC_Suggested_Dealers__c>();
        existingRecords = new list<DealerWrapper>();
        findExisitingRecords();   
        }
       
     /**
     * This method will call the dealer locator webservice which fetches the dealer details.
     * @Developer :Diksha Batra
     **/ 
     
      public void getDealerDetails(){       
          //Added changes by Tejas - Start
          /*@If a Case contact Country belongs to Canada then dealer search on US regions was not populating and vice-versa, This below piece of code resets the coutry value based on zip code entered by User.*/
          if(zip !=null) {
                  if(zip.isNumeric()){
                     //Checks zipcode and trim it to 5 digits.
                      if(zip.length()>4){
                        String Zipsubstring = zip.Substring(0,5);
                        zip=Zipsubstring;
                      }
                      else{
                          zip=zip;
                      }
                      rdl_Country ='USA'; 
                  }
                  
                 else{
                      rdl_Country ='CANADA'; 
                  }
          }
          //Added changes by Tejas  - End
          
           getDealersDetail(rdl_SiteType, SelectedBrands, rdl_SearchType, zip, rdl_DealerCount,  rdl_Country, rdl_iSearchRadius, SelectedSearchFilter);
         
     }
    
     /**
     * This method will call the dealer locator webservice which fetches the dealer details.
     * @Parameters - String siteType-Consumer, String brand - BR or CA, String searchType-territory , String zip-  Valid US Zipcode, integer dealerCount-  Count of dealers to be shown,
     * String country- USA, Integer radius- Radius under which search is to be done , String filters - used as a picklist to filter.
     * @Developer :Diksha Batra
     **/
   private void getDealersDetail (String siteType, String brand, String searchType , String zip, integer dealerCount, String country, Integer radius , String filters ){       
         CustomSettingEndPoint = CCC_IntegrationEndPoint__c.getValues('Dealer_Locator');
         String username = CustomSettingEndPoint.UserName__c;           
         String password = CustomSettingEndPoint.Password__c;           
         String securityToken = CustomSettingEndPoint.Token__c;    
         String baseURL = CustomSettingEndPoint.URL__c ;    
        
           if(filters!=null && (filters.equals('Featured Dealers') || filters.contains('Featured Dealers'))){
               searchType = 'Territory';
           }
        String tempFilter = '';
       if(filters!=null && searchType=='Proximity' && !filters.contains(',')){
           if(filters.contains('Ductless Split Systems')){
               tempFilter = 'DUCT-FREE%20SPLIT%20SYSTEMS';
           }
           if(filters.contains('Factory Authorized')){
               tempFilter = 'FADONLY';
           }
           if(filters.contains('Geothermal')){
               tempFilter = 'GEOTHERMAL';
           }
       }else if(filters!=null && filters.contains(',')){
           tempFilter = '';
       }else{
           tempFilter = filters;
       }
        
        System.debug('#SelectedSearchFilter:'+SelectedSearchFilter);
        List<String> fltrLst = new List<String>();
       Set<String> fltrSet = new Set<String>();
       if(SelectedSearchFilter.contains(',')){
           fltrLst = SelectedSearchFilter.split(',');
           system.debug('#fltrLst:'+fltrLst);
       }
       if(fltrLst!=null && fltrLst.size()>0){
           fltrSet.addAll(fltrLst);
           System.debug('#fltrSet:'+fltrSet);
           System.debug('#FltrSetCondition:'+(fltrSet.contains('Featured Dealers') || fltrSet.contains('All Dealers')));
       }
        String clientKey = '6B8A7EE7-9046-4F2D-A511-8BCE992AB2FB';
         baseURL += '?strClientKey='+clientKey;     
       
        HttpRequest req = new HttpRequest();
        String endPoint = baseURL+'&strSiteType='+siteType+'&strBrand='+brand+'&strSearchType='+searchType+'&strZip='+zip+'&idealerCount='+dealerCount+'&strCountry='+country+'&iSearchRadius='+radius+'&strFilter='+tempFilter;        
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
        responseStr = res.getBody();
        System.debug('#responseStr:'+responseStr);
        /*Added new variables below to capture the nature of dealers returned for Proximity search and soft-filter the results*/
        boolean isDuctless = false;
        boolean isFactoryAuthorized = false;
        boolean isFinancingOffered = false;
        boolean isNATETrained = false;
        boolean isGeothermal = false;
        System.debug('#searchType:'+searchType);
        lstDealers=New List<DealerDetails> ();
        mapDealers = new Map<String, String>();
        
       
        //The code is for Parsing the XML response and checks the tags and its values based on the brand selected.
        
        Dom.Document docx = new Dom.Document();
         docx.load(responseStr);
         dom.XmlNode xroot = docx.getrootelement() ;
        
        for(Dom.XMLNode child : xroot.getChildren()) {
            if(child.getName()=='Dealers'){
                for(Dom.XMLNode child1 : child.getChildElements())
                    {
                        DealerDetails details = new DealerDetails();

                        if(child1.getName()=='Dealer'){
                                    details.dealerId = child1.getAttributeValue('DealerId',null);
                                    }
                                    
                            for(Dom.XMLNode child2 : child1.getChildElements()){
                
                            if(child2.getName() == 'Icons'){
                                
                                for(Dom.XMLNode child3 : child2.getChildElements()){
                                    
                                     if(child3.getName()=='ProductOfferings'){
                                        for(Dom.XMLNode child4 : child3.getChildElements()){
                                            if(child4.getName()=='Generator'){
                                            details.generator = child4.getText();
                                             if(child4.getText()=='1' && SelectedBrands=='CA'){
                                                details.iconSet = '/resource/Badges/Badge/CA/icn-generator.gif';
                                             }
                                             if(child4.getText()=='1' && SelectedBrands=='BR'){
                                                details.iconSet = '/resource/Badges/Badge/BR/badge-cirlcechampions-sm.png';
                                             }
                                            }
                                            if(child4.getName()=='DFS'){
                                            details.dFS = child4.getText();
                                             if(child4.getText()=='1' && SelectedBrands=='CA'){
                                                 /*Added below code to identify Ductless dealers(Version one request S-01362)*/
                                                 isDuctless = true;
                                                details.iconSet3 = '/resource/Badges/Badge/CA/icn-ductfree_lg.png';
                                             }
                                             if(child4.getText()=='1' && SelectedBrands=='BR'){
                                                details.iconSet3 = '/resource/Badges/Badge/BR/badge-ductless-sm.png';
                                             }
                                            }
                                            if(child4.getName()=='Geothermal'){
                                                details.geothermal = child4.getText();
                                            if(child4.getText()=='1' && SelectedBrands=='CA'){
                                                /*Added below code to identify Geothermal dealers(Version one request S-01362)*/
                                                isGeothermal = true;
                                                details.iconSet4 = '/resource/Badges/Badge/CA/icn-geothermal_new.png';
                                             }
                                             if(child4.getText()=='1' && SelectedBrands=='BR'){
                                                details.iconSet4 = '/resource/Badges/Badge/BR/badge-geothermal-sm.png';
                                             }
                                            }
                                            if(child4.getName()=='HealthyAir'){
                                            details.healthyAir = child4.getText();
                                            if(child4.getText()=='1'&& SelectedBrands=='CA'){
                                                details.iconSet5 = '/resource/Badges/Badge/CA/icn-deal-airq-lg.png';
                                             }
                                             if(child4.getText()=='1' && SelectedBrands=='BR'){
                                                details.iconSet5 = '/resource/Badges/Badge/BR/icn-healthyair-bryant-sm.gif';
                                             }
                                            }
                                            if(child4.getName()=='CORHomeAutomation'){
                                            details.corhomeautomation = child4.getText();
                                            if(child4.getText()=='1'&& SelectedBrands=='CA'){
                                                details.iconSet14 = '/resource/Badges/Badge/CA/CorHA.png';
                                             }
                                             if(child4.getText()=='1' && SelectedBrands=='BR'){
                                                details.iconSet14 = '/resource/Badges/Badge/BR/CorHome.png';
                                             }
                                            }
                                        }
                                    }
                                
                                    if(child3.getName()=='SpeaksSpanish'){
                                    details.speaksSpanish = child3.getText();
                                     if(child3.getText()=='1' && SelectedBrands=='CA'){
                                        details.iconSet6 = '/resource/Badges/Badge/CA/spanish.png';
                                     }
                                     if(child3.getText()=='1' && SelectedBrands=='BR'){
                                        details.iconSet6 = '/resource/Badges/Badge/BR/badge-spanish-sm.png';
                                     }
                                    }
                                    if(child3.getName()=='FactoryAuthorizedDealer'){
                                    details.factoryAuthorizedDealer = child3.getText();
                                    if(child3.getText()=='1' && SelectedBrands=='CA'){
                                        /*Added below code to identify Factory Authorized dealers(Version one request S-01362)*/
                                        isFactoryAuthorized = true;
                                        //details.factoryAuthorizedDealer = child3.getText();
                                        details.iconSet1 = '/resource/Badges/Badge/CA/icn-deal-fad.png';
                                    }
                                     if(child3.getText()=='1' && SelectedBrands=='BR'){
                                        details.iconSet1 = '/resource/Badges/Badge/BR/badge-factoryauthorized-sm.png';
                                    }
                                    }
                                    if(child3.getName()=='NATEDealer'){
                                    details.nATEDealer = child3.getText();
                                    if(child3.getText()=='1' && SelectedBrands=='CA'){
                                        /*Added below code to identify NATE dealers(Version one request S-01362)*/
                                        isNATETrained = true;
                                        details.iconSet7 = '/resource/Badges/Badge/CA/icn_nate_logo.png';
                                        
                                    }
                                    if(child3.getText()=='1' && SelectedBrands=='BR'){
                                        details.iconSet7 = '/resource/Badges/Badge/BR/icn_nate_logo.png';
                                        
                                    }
                                    }
                                    if(child3.getName()=='OffersFinancing'){
                                    details.offersFinancing = child3.getText();
                                    if(child3.getText()=='1' && SelectedBrands=='CA'){
                                         /*Added below code to identify Finance offering dealers(Version one request S-01362)*/
                                         isFinancingOffered = true;
                                         details.iconSet8 = '/resource/Badges/Badge/CA/financing.png';
                                    }
                                    if(child3.getText()=='1' && SelectedBrands=='BR'){
                                         details.iconSet8 = '/resource/Badges/Badge/BR/badge-financing-sm.png';
                                    }
                                    }
                                    if(child3.getName()=='PastDealerOfTheYear'){
                                    details.pastDealerOfTheYear = child3.getText();
                                     if(child3.getText()=='1' && SelectedBrands=='BR'){
                                         details.iconSet9 = '/resource/Badges/Badge/BR/icn-deal-medal.gif';
                                    }
                                    }
                                    if(child3.getName()=='DistinguishedDealer'){
                                    details.distinguishedDealer = child3.getText();
                                     if(child3.getText()=='1' && SelectedBrands=='CA'){
                                         details.iconSet10 = '/resource/Badges/Badge/CA/icn-deal-dist.png';
                                    }
                                    }
                                    if(child3.getName()=='PinnacleDealer'){
                                    details.dinnacleDealer = child3.getText();
                                     if(child3.getText()=='1'){
                                         //details.iconSet = '/resource/Badges/Badge/CA/';
                                         //No image/icon provided here
                                    }
                                    }
                                     if(child3.getName()=='EnergyExpert'){
                                    details.energyExpert = child3.getText();
                                    if(child3.getText()=='1' && SelectedBrands=='CA'){
                                         details.iconSet11 = '/resource/Badges/Badge/CA/icn-deal-energy.gif';
                                    }
                                    }
                                     if(child3.getName()=='OffersPromotion1'){
                                    details.offersPromotion1 = child3.getText();
                                    if(child3.getText()=='1' && SelectedBrands=='CA'){
                                         details.iconSet12 = '/resource/Badges/Badge/CA/icn-deal-cool-sm.gif';
                                    }
                                     if(child3.getText()=='1' && SelectedBrands=='BR'){
                                         details.iconSet12 = '/resource/Badges/Badge/BR/badge-bonus-sm.png';
                                    }
                                    }
                                     if(child3.getName()=='OffersPromotion2'){
                                    details.offersPromotion2 = child3.getText();
                                    if(child3.getText()=='1' && SelectedBrands=='CA'){
                                         details.iconSet13 = '/resource/Badges/Badge/CA/icn-president-Award.gif';
                                    }
                                    if(child3.getText()=='1' && SelectedBrands=='BR'){
                                         details.iconSet13 = '/resource/Badges/Badge/BR/icn-deal-year-sm.gif';
                                    }
                                    }
                                     if(child3.getName()=='IndoorAirSpecialistDealer'){
                                    details.indoorAirSpecialistDealer = child3.getText();
                                    if(child3.getText()=='1' && SelectedBrands=='BR')
                                    {
                                         details.iconSet2 = '/resource/Badges/Badge/BR/BryantIAS_LocatorIcon.gif';
                                    }
                                    }
                                }
                            }
                                
                            if(child2.getName()=='DealerName'){
                                    details.dealerName = child2.getText();
                                    }
                            if(child2.getName()=='PostalAddress'){
                                    details.postalAddress = child2.getText();
                                    }
                            if(child2.getName()=='City'){
                                    details.City = child2.getText();
                                    }
                            if(child2.getName()=='State'){
                                     details.State = child2.getText();
                                    }
                            if(child2.getName()=='Phone'){
                                    details.Phone = child2.getText();
                                    }
                            if(child2.getName()=='HoursOfOperation'){
                                    details.HoursOfOperation = child2.getText();
                                    }
                             if(child2.getName()=='YearsInBusiness'){
                                    details.YearsInBusiness = child2.getText();
                                    }
                
                    }
                   /*Commented below code and added conditions for (Version one request S-01362)*/
                   //lstDealers.add(details);
                        /*if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && (SelectedSearchFilter=='Featured Dealers' || SelectedSearchFilter=='All Dealers')){
                            lstDealers.add(details);
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter=='Ductless Split Systems' && isDuctless==true){
                            lstDealers.add(details);
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter=='Factory Authorized' && isFactoryAuthorized==true){
                            lstDealers.add(details);
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter=='Financing Offered' && isFinancingOffered==true){
                            lstDealers.add(details);
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter=='NATE Trained' && isNATETrained==true){
                            lstDealers.add(details);
                        }*/
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && (SelectedSearchFilter.contains('Featured Dealers') || SelectedSearchFilter.contains('All Dealers'))){
                            System.debug('#Yes Featured Dealers');
                            if(!mapDealers.containskey(details.dealerId)){
                                lstDealers.add(details);
                                mapDealers.put(details.dealerId, details.dealerId);
                            }
                            
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter.contains('Ductless Split Systems') && isDuctless==true){
                            if(!mapDealers.containskey(details.dealerId)){
                                lstDealers.add(details);
                                mapDealers.put(details.dealerId, details.dealerId);
                            }
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter.contains('Factory Authorized') && isFactoryAuthorized==true){
                            if(!mapDealers.containskey(details.dealerId)){
                                lstDealers.add(details);
                                mapDealers.put(details.dealerId, details.dealerId);
                            }
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter.contains('Financing Offered') && isFinancingOffered==true){
                            if(!mapDealers.containskey(details.dealerId)){
                                lstDealers.add(details);
                                mapDealers.put(details.dealerId, details.dealerId);
                            }
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter.contains('NATE Trained') && isNATETrained==true){
                            if(!mapDealers.containskey(details.dealerId)){
                                lstDealers.add(details);
                                mapDealers.put(details.dealerId, details.dealerId);
                            }
                        }
                        if(SelectedSearchFilter!=null && SelectedSearchFilter.length()>0 && SelectedSearchFilter.contains('Geothermal') && isGeothermal==true){
                            if(!mapDealers.containskey(details.dealerId)){
                                lstDealers.add(details);
                                mapDealers.put(details.dealerId, details.dealerId);
                            }
                        }
                        isDuctless = false;
                        isFactoryAuthorized = false;
                        isFinancingOffered = false;
                        isNATETrained = false;
                        isGeothermal = false;
                   SuggestedDealer();
                    }
            }

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
             
        }
        
        //Checks if list is empty then displays message as 'No dealers found'.
        if(lstDealers.size()==0)
        {
            ApexPages.AddMessage(New ApexPages.message(ApexPages.severity.ERROR,'No dealers found'));
            error_message = 'No Dealers Found';
            DealerList= new List<DealerWrapper>();
            DealerList.clear();
            
        } else{
            error_message = '';
        }
    }
    
     /**
     * This class contains arguments/parameters of the dealers
     * @Developer :Diksha Batra
     **/
        public class DealerDetails{
        public String dealerId {get;set;}
        public String dealer {get;set;}
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
        public string speaksSpanish{get;set;}
        public string factoryAuthorizedDealer{get;set;}
        public string nATEDealer{get;set;}
        public string offersFinancing{get;set;}
        public string generator{get;set;}
        public string dFS{get;set;}
        public string geothermal{get;set;}
        public string healthyAir{get;set;}
        public string corhomeautomation{get;set;}
        public string pastDealerOfTheYear{get;set;}
        public string distinguishedDealer{get;set;}
        public string dinnacleDealer{get;set;}
        public string energyExpert{get;set;}
        public string offersPromotion1{get;set;}
        public string offersPromotion2{get;set;}
        public string Promotionofffer{get;set;}
        public string indoorAirSpecialistDealer{get;set;}
        //set of Icons available
        public string iconSet{get;set;}
        public string iconSet1{get;set;}
        public string iconSet2{get;set;}
        public string iconSet3{get;set;}
        public string iconSet4{get;set;}
        public string iconSet5{get;set;}
        public string iconSet6{get;set;}
        public string iconSet7{get;set;}
        public string iconSet8{get;set;}
        public string iconSet9{get;set;}
        public string iconSet10{get;set;}
        public string iconSet11{get;set;}
        public string iconSet12{get;set;}
        public string iconSet13{get;set;}
        public string iconSet14{get;set;}
        }
    
     /**
     * This method will find the existing records that are added to the suggested dealer object
     * @Developer : Diksha Batra
     **/
        public void findExisitingRecords(){           
            if(c != null && c.id != null){
                regList = [Select id,Name,CCC_DealerPostal_Address__c,CCC_Dealer_City__c,CCC_Dealer_Phone__c,CCC_Icon1__c,CCC_Icon2__c,CCC_Icon3__c,
                            CCC_Icon4__c,CCC_Icon5__c,CCC_Icon6__c,CCC_Icon7__c,CCC_Icon8__c,CCC_Icon9__c,CCC_Icon10__c,CCC_Icon11__c,CCC_Icon12__c,
                            CCC_Icon13__c,CCC_Icon14__c,Icon15__c,CCC_HVAC_ID__c,CCC_Additional_Information__c,CCC_Years_In_Business__c
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
     * This method will display list of dealers from wrapper class and will not display duplicate dealer recordes that are already added to the case.
     * @Developer : Diksha Batra
     **/
        public void SuggestedDealer(){
                    
                    Set<String> setDealer = new Set<String>();                   
                    for(CCC_Suggested_Dealers__c sgstDealer : regList ){
                        setDealer.add(sgstDealer.Name);
                    }
                     SuggDealList =new list<CCC_Suggested_Dealers__c>();
                     for(DealerDetails deal : lstDealers){
                         if(!setDealer.contains(deal.dealerName)){
                                CCC_Suggested_Dealers__c sugg = new  CCC_Suggested_Dealers__c();
                                sugg.Name = deal.dealerName;
                                sugg.CCC_Dealer_City__c = deal.City;
                                if(rdl_Country!=null && rdl_Country.equals('CANADA'))
                                {
                                if(SelectedBrands!=null && SelectedBrands.equals('BR'))
                                
                                {
                                 deal.Phone = '888 980 1509';
                                }
                                 
                               else
                                {
                                 deal.Phone = '888 980 1507';
                                } 
                                }
                               
                                sugg.CCC_Dealer_Phone__c = deal.Phone;
                                sugg.CCC_DealerPostal_Address__c = deal.postalAddress;
                                sugg.CCC_HVAC_ID__c = deal.dealerId;
                                sugg.CCC_Icon1__c= deal.iconSet1;
                                sugg.CCC_Icon2__c= deal.iconSet2;
                                sugg.CCC_Icon3__c= deal.iconSet3;
                                sugg.CCC_Icon4__c= deal.iconSet4;
                                sugg.CCC_Icon5__c= deal.iconSet5;
                                sugg.CCC_Icon6__c= deal.iconSet6;
                                sugg.CCC_Icon7__c= deal.iconSet7;
                                sugg.CCC_Icon8__c= deal.iconSet8;
                                sugg.CCC_Icon9__c= deal.iconSet9;
                                sugg.CCC_Icon10__c= deal.iconSet10;
                                sugg.CCC_Icon11__c= deal.iconSet11;
                                sugg.CCC_Icon12__c= deal.iconSet12;
                                sugg.CCC_Icon13__c= deal.iconSet13;
                                sugg.CCC_Icon14__c= deal.iconSet;
                                sugg.Icon15__c= deal.iconSet14;
                               
                                sugg.CCC_Additional_Information__c= deal.HoursOfOperation;
                                sugg.CCC_Years_In_Business__c= deal.YearsInBusiness;
                                SuggDealList.add(sugg);
                            }
                        } 
                        DealerList =new list <DealerWrapper>();   
                        for( CCC_Suggested_Dealers__c sugstdeal : SuggDealList){
                              DealerList.add(new DealerWrapper(sugstdeal,false) );
                       }
               }
               
                /**
     * This method will save the selected dealer records into the suggested dealer object and link it to the case.
     * Also It will make the visualforce page to close as user clicks on suggested dealers button.
     * @Developer : Diksha Batra
     **/
              public PageReference save(){  
              String caseId = ApexPages.currentPage().getParameters().get('id'); 
              SelectedDealerList=new list<CCC_Suggested_Dealers__c>();
              case cs=[select id, status from case where id=:caseId];
              if(DealerList!=null && DealerList.size()>0 ){
                    for (DealerWrapper dealwrap : DealerList){
                         if(dealwrap.selected == true){
                            dealwrap.DealerLoc.CCC_Case__c=cs.id;
                            SelectedDealerList.add(dealwrap.DealerLoc);
                        }
                        else{
                            dealwrap.DealerLoc.CCC_Case__c=null;
                        }
                }
            }
                if(SelectedDealerList !=null && SelectedDealerList.size()>0 ){
                  upsert SelectedDealerList;
                  
                }
                PageReference pageRef = new PageReference('/' + caseId);
               pageRef.setRedirect(True);
                //return pageRef;
                return null;
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
        
    }