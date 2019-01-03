/**
* @ Developer : Bhupendra Singh Chauhan
* @date_created : 1/14/2016
* @functions : This controller fetches the list of suggested documents from the webservice based on the document title that is fetched generally from case subject.
*               Also it saves selected documents into suggested documents object and display it back on screen.
* Referenced in Pages - CCC_DMISSearch and CCC_CommunityDMISSearch
*@Date Modified : 3/15/2016 Reason: Endpoint values should be stored in custom setting and retrive from it. Developer :Diksha Batra
* @Date Modified : 3/14/2016 Reason: Remove unwanted commented code and debug statements Developer :Diksha Batra
*
***/

Public Class CCC_DMISSearchController{
    // Document Information service variable
    
    public String docInfo_DocumentType {get;set;}
    public Integer docInfo_resultCount {get;set;}
    public Boolean showDocumentResult {get;set;}
    public Boolean showSuggDoc {get;set;}
    public List<DocumentDetails> lstDocs {get;set;}
    public list<DocumentDetails> suggDocs{get;set;}
    public String responseStr{get;set;}
    Public Case objCase{get;set;}
    Public Id CaseId{get;set;}
    public  CCC_IntegrationEndPoint__c  CustomSettingEndPoint;
    CCC_ErrorLog errlog=new CCC_ErrorLog();
    
    /**
* This method is used to fetch records from Suggested Documents and is referenced in Visualforce component and is referenced in VF template.
* @Developer : Ishita Sharma
**/
    
    public Case getExitingRecords()
    {
        if(CaseId!=null ){
            objCase = new Case();
            lstDocs = new list<DocumentDetails>();
            suggDocs = new list<DocumentDetails>();
            objCase =[select subject,CCC_Brand__c,CCC_Model_Number__c from case where id=:CaseId]; 
            docInfo_resultCount  = 20;        
            docInfo_DocumentType = 'Brochures';
            showDocumentResult = false; 
            //Ishita : 8th MArch
            addSuggetedDocumentCommunity();
        }
        system.debug('objCase'+objCase);
        return objCase;
    }
    /**
* This method is used to show more documents on UI during web service call. Record count is increased by 20 as the method is called each time.
* @Developer :  Bhupendra Singh Chauhan
**/
    public pageReference showMoreDocuments(){
        docInfo_resultCount = docInfo_resultCount  + 20;
        getDocumentDetail();
        return null;
    }
    
    //Parametrized Constructor
    public CCC_DMISSearchController(ApexPages.StandardController controller) {
        objCase = new Case();
        system.debug('inside constructor1');
        lstDocs = new list<DocumentDetails>();
        suggDocs = new list<DocumentDetails>();
        system.debug('suggDocs....'+suggDocs);
        system.debug('inside constructor2');
        objCase =[select subject,CCC_Brand__c,CCC_Model_Number__c from case where id=:controller.getRecord().Id]; 
        //docInfo_client =objCase.subject; 
        system.debug('inside constructor3');
        showSuggDoc = false;
        system.debug('sugg doc0:'+ showSuggDoc );
        docInfo_resultCount  = 20;        
        docInfo_DocumentType = 'Brochures';
        showDocumentResult = false;
    }
    
    //Default Constructor
    public CCC_DMISSearchController(){
        showDocumentResult  = false;
    }
    /**
* This method is used to show  documents on UI during web service call.
* @Developer :  Bhupendra Singh Chauhan
**/
    public void getDocumentDetail(){
        if(CaseId!=null ){
            objCase=getExitingRecords();  
        }
        getDocumentInformation(objCase,docInfo_resultCount,docInfo_DocumentType);
        addSuggetedDocument();
    }
    
    /**
* This method is the webservice call that is used to show  both public and private documents.
* @Developer :  Bhupendra Singh Chauhan
**/
    
    private void getDocumentInformation(Case objTempCase, Integer resultCount, String documentType){       
        HttpRequest req = new HttpRequest();
        CustomSettingEndPoint = CCC_IntegrationEndPoint__c.getValues('DMIS_Search');
        String username = CustomSettingEndPoint.UserName__c;           
        String password = CustomSettingEndPoint.Password__c;           
        String securityToken = CustomSettingEndPoint.Token__c;    
        String baseURL = CustomSettingEndPoint.URL__c ; 
        String endpoint = baseURL + 'clientkey=1ED5E7FA-E8F3-4D5F-A9FC-371D37F0A115&format=json&ResultCount='+resultCount;
        
        if(objTempCase.Subject!= null)
            endpoint = endpoint + '&DocumentTitle=' +  EncodingUtil.URLEncode(objTempCase.Subject,'UTF-8');
        if(objTempCase.CCC_Brand__c!= null)
            endpoint = endpoint + '&brands=' + objTempCase.CCC_Brand__c;
        if(objTempCase.CCC_Model_Number__c !=null)
            endpoint = endpoint + '&ModelNumbers='+objTempCase.CCC_Model_Number__c;
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Bearer ' + securityToken  ;
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept', 'application/json');
        Http http = new Http();
        
        HTTPResponse res;
        try{
            res = http.send(req);
            responseStr = '';
            if(res.getBody().contains('<html>')){
                responseStr = 'No Document Information Found. Please enter valid Keyword.';  
                showDocumentResult = false;
                lstDocs.clear();
            }
            else{
                Map<String,Object> resultMapList = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                String documentStr = JSON.serialize(resultMapList.get('Documents'));
                lstDocs = (List<DocumentDetails>)JSON.deserialize(documentStr , List<DocumentDetails>.Class);
                responseStr = '';
                if(lstDocs.size()>0)
                {
                    showDocumentResult = true;
                } else{
                    showDocumentResult = false;
                }
            }
        }catch(System.CalloutException e) {
            errlog.ErrorLogCalloutException(e,'DMIS WebService','CCC_DMISSearchController');
        }
        //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
        Catch(Exception e){
            errlog.ErrorLogException(e,'DMIS WebService','CCC_DMISSearchController');
            responseStr = 'Exception occured while retriving document information';
            addSuggetedDocument();
        }
        
    }
    /**
* This method is used to add records to suggested document object, linking it with the case associated.
* @Developer : Bhupendra Singh Chauhan
**/
    public void addSuggetedDocument(){
        
        suggDocs = new list<DocumentDetails>();
        list<CCC_Suggested_Documents__c> lstSuggDoc = [Select CCC_Document_Name__c, CCC_Document_Title__c,CCC_Size__c,
                                                       CCC_Document_URL__c,
                                                       CCC_Access_Level__c
                                                       from CCC_Suggested_Documents__c
                                                       where
                                                       CCC_Case__c =:objCase.Id];
        set<String> setExisting = new Set<String>();
        for (CCC_Suggested_Documents__c objSuggDoc :lstSuggDoc){
            showSuggDoc = true;           
            DocumentDetails  objDocumentDetails = new DocumentDetails();
            objDocumentDetails.DocumentTitle = objSuggDoc.CCC_Document_Title__c ;
            objDocumentDetails.DocumentSize = objSuggDoc.CCC_Size__c ;
            objDocumentDetails.DocumentBaseURL = objSuggDoc.CCC_Document_URL__c;
            objDocumentDetails.AccessLevel = objSuggDoc.CCC_Access_Level__c;
            suggDocs.add(objDocumentDetails);
            system.debug('suggDocs.2...'+suggDocs);
            setExisting.add(objSuggDoc.CCC_Document_Title__c);
        }
        
        List<DocumentDetails> lstTemp = new list<DocumentDetails>();
        for(DocumentDetails objDoc:lstDocs ){
            //Code For Add Access level
            String str = objDoc.DocumentPath;
            if(str.contains('Public')){
                objDoc.AccessLevel = 'Public';
            }else{
                objDoc.AccessLevel = 'Private';
            }
            //End code for Access Level
            if(!setExisting.Contains(objDoc.DocumentTitle)){
                lstTemp.add(objDoc);
            }
            
        }
        lstDocs = new list<DocumentDetails>();
        lstDocs  = lstTemp;
    }
    
    /**
* This method will save the selected documents records into the suggested document object and link it to the case.
* Also It will make the visualforce page to close as user clicks on suggested document button.
* @Developer : Bhupendra Singh Chauhan
**/
    public PageReference SuggestedDocument(){
        
        for(DocumentDetails obj:lstDocs ){
            list<CCC_Suggested_Documents__c> SuggDocList = new list<CCC_Suggested_Documents__c>();
            if(obj.isSelected){
                CCC_Suggested_Documents__c objSuggesteddoc = new  CCC_Suggested_Documents__c();
                objSuggesteddoc.CCC_Document_Name__c=obj.DocumentTitle;
                objSuggesteddoc.CCC_Document_Title__c = obj.DocumentTitle;
                objSuggesteddoc.CCC_Size__c = obj.DocumentSize;
                objSuggesteddoc.CCC_Document_URL__c = obj.DocumentBaseURL + obj.DocumentPath;
                objSuggesteddoc.CCC_Case__c = objCase.Id ; 
                objSuggesteddoc.CCC_Access_Level__c = obj.AccessLevel;
                SuggDocList.add(objSuggesteddoc);
            } 
            
            insert SuggDocList;
            addSuggetedDocument();
        }
        PageReference pf = new PageReference('/'+objCase.Id );
        pf.setRedirect(true);
        return null;
    }
    
    
    
    
    /* ------------------------------Community Methods ----Community users will access only Public Documents-----------------------------------------------------------------------------------------------  */
    
    /**
* This method is used for community and will cancel the page, will redirect to case standard detail page.
* @Developer : Ishita Sharma
**/
    public PageReference doCancelCommunity(){
        PageReference pf = new PageReference('/'+objCase.Id );
        pf.setRedirect(true);
        return pf;
    }
    /**
* This method is used for community and will save the selected documents records into the suggested document object and link it to the case.
* Also It will make the visualforce page to close as user clicks on suggested document button .
* @Developer : Ishita Sharma
**/
    public PageReference SuggestedDocumentCommunity(){
        
        for(DocumentDetails obj:lstDocs ){
            list<CCC_Suggested_Documents__c> SuggDocList = new list<CCC_Suggested_Documents__c>(); 
            if(obj.isSelected){
                CCC_Suggested_Documents__c objSuggesteddoc = new  CCC_Suggested_Documents__c();
                objSuggesteddoc.CCC_Document_Name__c=obj.DocumentTitle;
                objSuggesteddoc.CCC_Document_Title__c = obj.DocumentTitle;
                objSuggesteddoc.CCC_Size__c = obj.DocumentSize;
                objSuggesteddoc.CCC_Document_URL__c = obj.DocumentBaseURL + obj.DocumentPath;
                objSuggesteddoc.CCC_Case__c = objCase.Id ; 
                objSuggesteddoc.CCC_Access_Level__c = obj.AccessLevel;     
                SuggDocList.add(objSuggesteddoc);
            } 
            
            insert SuggDocList;
            addSuggetedDocumentCommunity();
        }
        PageReference pf = new PageReference('/'+objCase.Id );
        pf.setRedirect(true);
        return pf;
    }
    /**
* This method is used for community page to add records to suggested document object, linking it with the case associated.
* @Developer :  Ishita Sharma
**/
    
    public void addSuggetedDocumentCommunity(){
        
        suggDocs = new list<DocumentDetails>();
        list<CCC_Suggested_Documents__c> lstSuggDoc = [Select CCC_Document_Name__c, CCC_Document_Title__c,CCC_Size__c,
                                                       CCC_Document_URL__c,
                                                       CCC_Access_Level__c
                                                       from CCC_Suggested_Documents__c
                                                       where
                                                       CCC_Case__c =:objCase.Id];
        set<String> setExisting = new Set<String>();
        for (CCC_Suggested_Documents__c objSuggDoc :lstSuggDoc){
            showSuggDoc = true;           
            DocumentDetails  objDocumentDetails = new DocumentDetails();
            objDocumentDetails.DocumentTitle = objSuggDoc.CCC_Document_Title__c ;
            objDocumentDetails.DocumentSize = objSuggDoc.CCC_Size__c ;
            objDocumentDetails.DocumentBaseURL = objSuggDoc.CCC_Document_URL__c;
            objDocumentDetails.AccessLevel = objSuggDoc.CCC_Access_Level__c;
            //added by ishita : defect id : 6 
            if(objDocumentDetails.AccessLevel == 'Public'){
                suggDocs.add(objDocumentDetails);
                 system.debug('suggDocs.3...'+suggDocs);
            }
            setExisting.add(objSuggDoc.CCC_Document_Title__c);
        }
        
        List<DocumentDetails> lstTemp = new list<DocumentDetails>();
        for(DocumentDetails objDoc:lstDocs ){
            //Community users will access only Public Documents
            String str = objDoc.DocumentPath;
            if(str.contains('Public')){
                objDoc.AccessLevel = 'Public';
                //End code for Access Level
                if(!setExisting.Contains(objDoc.DocumentTitle)){
                    lstTemp.add(objDoc);
                }
                
            }      
        }
        lstDocs = new list<DocumentDetails>();
        lstDocs  = lstTemp;
    }
    
    public void getDocumentDetailCommunity(){
        if(CaseId!=null ){
            objCase=getExitingRecords();  
        }
        getDocumentInformation(objCase,docInfo_resultCount,docInfo_DocumentType);
        //for Initialy show all exsting Records
        addSuggetedDocumentCommunity();
        showMoreDocumentsCommunity();
    } 
    
    public pageReference showMoreDocumentsCommunity(){
        docInfo_resultCount = docInfo_resultCount  + 10;
        return null;
    }
    
    /**
* This class contains parameters of the documents class.
* @Developer :Diksha Batra
**/
    public class DocumentDetails{
        public String id {get;set;}
        public String DocumentTitle{get;set;}
        public String[] Type{get;set;}
        public String[] Subtype{get;set;}
        public String BrandFamily{get;set;}
        public String[] Brands{get;set;}
        public String DMSCategory{get;set;}
        public String DMSType{get;set;}
        public String CatalogueNumber{get;set;}
        public String Status{get;set;}
        public String[] ModelNumbers{get;set;}
        public String DocumentMIMEType{get;set;}
        public String DocumentBaseURL{get;set;}
        public String DocumentPath{get;set;}
        public String[] Verticals{get;set;}
        public String Language{get;set;}
        public String Country{get;set;}
        public String PublishedDate{get;set;}
        public String DocumentSize{get;set;}
        public String Region{get;set;}
        public String PrintDate{get;set;}
        public String Author{get;set;}
        public String ModelCategory{get;set;}
        public String PartNumber{get;set;}
        public String Category{get;set;}
        public String SubCategory{get;set;} 
        public boolean isSelected{get;set;} 
        public String AccessLevel{get;set;}  
    }
    
    
}