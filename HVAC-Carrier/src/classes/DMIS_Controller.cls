public with sharing class DMIS_Controller {
    
    @AuraEnabled public static Id CaseId{get;set;}
    @AuraEnabled public static Id CaseId1{get;set;}
    @AuraEnabled public static Id CaseId2{get;set;}
    @AuraEnabled public static Case objCase{get;set;}
    @AuraEnabled public static Case objCase1{get;set;}
    @AuraEnabled public static Boolean flag {get;set;}
    @AuraEnabled public static Boolean showMoreResultsflag {get;set;}
    @AuraEnabled public static String docInfo_DocumentType {get;set;}
    @AuraEnabled public static Integer docInfo_resultCount {get;set;}
    @AuraEnabled public static Boolean showDocumentResult {get;set;}
    @AuraEnabled public static List<DocumentDetails> lstDocs {get;set;}
    @AuraEnabled public static list<DocumentDetails> suggDocs{get;set;}
 /* @AuraEnabled public static List<DocumentDetails> lst1{get;set;}
    @AuraEnabled public static List<DocumentDetails> lst2{get;set;}
    @AuraEnabled public static List<DocumentDetails> lst3{get;set;}
    @AuraEnabled public static List<DocumentDetails> lst4{get;set;}
    @AuraEnabled public static list<DocumentDetails> lstaddSuggetedDocument{get;set;}
    @AuraEnabled public static List<DocumentDetails> a{get;set;} */
    @AuraEnabled public static Boolean showSuggDoc {get;set;}
    @AuraEnabled public static String responseStr{get;set;}
    @AuraEnabled public static CCC_IntegrationEndPoint__c  CustomSettingEndPoint{get;set;}
    @AuraEnabled public static CCC_ErrorLog errlog{get;set;}

    public class DocumentDetails{
       @AuraEnabled public String id {get;set;}
       @AuraEnabled public String DocumentTitle{get;set;}
       @AuraEnabled public String[] Type{get;set;}
       //@AuraEnabled public String[] Subtype{get;set;}
       @AuraEnabled public String BrandFamily{get;set;}
       //@AuraEnabled public String[] Brands{get;set;}
       @AuraEnabled public String DMSCategory{get;set;}
       @AuraEnabled public String DMSType{get;set;}
       @AuraEnabled public String CatalogueNumber{get;set;}
       @AuraEnabled public String Status{get;set;}
       @AuraEnabled public String[] ModelNumbers{get;set;}
       @AuraEnabled public String DocumentMIMEType{get;set;}
       @AuraEnabled public String DocumentBaseURL{get;set;}
       @AuraEnabled public String DocumentPath{get;set;}
       //@AuraEnabled public String[] Verticals{get;set;}
       @AuraEnabled public String Language{get;set;}
       @AuraEnabled public String Country{get;set;}
       @AuraEnabled public String PublishedDate{get;set;}
       @AuraEnabled public String DocumentSize{get;set;}
       @AuraEnabled public String Region{get;set;}
       @AuraEnabled public String PrintDate{get;set;}
       @AuraEnabled public String Author{get;set;}
       @AuraEnabled public String ModelCategory{get;set;}
       @AuraEnabled public String PartNumber{get;set;}
       @AuraEnabled public String Category{get;set;}
       @AuraEnabled public String SubCategory{get;set;} 
       @AuraEnabled public boolean isSelected{get;set;} 
       @AuraEnabled public String AccessLevel{get;set;}  
    }
    
    @AuraEnabled
    public static Case getCaseSubject(Id recrdId){
        Case cse = [select Subject,CCC_Brand__c,CCC_Model_Number__c from case where Id =: recrdId];
        //System.debug('dddd'+cse.CCC_Model_Number__c);
        return cse;
    } 
        
   @AuraEnabled
    public static List<DocumentDetails> getListDocs(Id CaseId,Boolean showMoreResultsflag,String srchKeyword,String srchByBrand,String srchByModelNo) {
         //system.debug('srchByBrand'+srchByBrand);
         //system.debug('srchByModelNo'+srchByModelNo);
         //system.debug('srchKeyword'+srchKeyword);
        
        objCase = new Case();
        if(CaseId!=null){
            objCase=getExitingRecords(CaseId,showMoreResultsflag);  
            system.debug('objCase'+objCase);
        }
        List<DocumentDetails> lstgetDocumentInformation = getDocumentInformation(CaseId,objCase,docInfo_resultCount,docInfo_DocumentType,srchKeyword,srchByBrand,srchByModelNo);
        //System.debug('lstgetDocumentInformation'+lstgetDocumentInformation);
        List<DocumentDetails> lst1 = newMethod2(lstgetDocumentInformation);
     //   showMoreDocumentsCommunity();
        //System.debug('List of Docss'+lst1);
        return lst1;
    } 
    
   /*public static List<DocumentDetails> newMethod(List<DocumentDetails> lstgetDocumentInformation1){
       List<DocumentDetails> lstTemp = new list<DocumentDetails>();
       set<String> setExisting = new Set<String>();
        for(DocumentDetails objDoc:lstgetDocumentInformation1 ){
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
        system.debug('lstTemp'+lstTemp); 
        lstDocs = new list<DocumentDetails>();
        lstDocs  = lstTemp;
        system.debug('lstDocs'+lstDocs);
        return lstDocs;
        
    }
    */
 @AuraEnabled
    public static Case getExitingRecords(Id CaseId,Boolean showMoreResultsflag) {
         system.debug('Id'+CaseId);
        if(CaseId!=null ){
            
            objCase1 = new Case();
            lstDocs = new list<DocumentDetails>();
            suggDocs = new list<DocumentDetails>();
            objCase1 = [select id,subject,CCC_Brand__c,CCC_Model_Number__c from case where id=:CaseId]; 
            CaseId1 = objCase1.id;
            system.debug('objCase.....'+objCase1);
            if(showMoreResultsflag == false){
               docInfo_resultCount  = 20;
            }
            docInfo_DocumentType = 'Brochures';
            showDocumentResult = false;     
        
       }
       system.debug('objCase'+objCase1);
       return objCase1;
    }
    
 /* @AuraEnabled  
    public static list<DocumentDetails> addSuggetedDocumentCommunity(Id CaseId1){
        system.debug('CaseId1'+CaseId1);
      //  List<string> lstSetExisting = new List<string>();
        suggDocs = new list<DocumentDetails>();
        list<CCC_Suggested_Documents__c> lstSuggDoc = [Select CCC_Document_Name__c, CCC_Document_Title__c,CCC_Size__c,
                                                       CCC_Document_URL__c,
                                                       CCC_Access_Level__c
                                                       from CCC_Suggested_Documents__c
                                                       where
                                                       CCC_Case__c =:CaseId1];
        set<String> setExisting = new Set<String>();
        system.debug('lstSuggDoc'+lstSuggDoc);
        for (CCC_Suggested_Documents__c objSuggDoc :lstSuggDoc){
            showSuggDoc = true;           
            DocumentDetails  objDocumentDetails = new DocumentDetails();
            objDocumentDetails.DocumentTitle = objSuggDoc.CCC_Document_Title__c ;
            system.debug('objDocumentDetails.DocumentTitle'+objDocumentDetails.DocumentTitle);
            objDocumentDetails.DocumentSize = objSuggDoc.CCC_Size__c ;
            system.debug('objDocumentDetails.DocumentSize'+objDocumentDetails.DocumentSize);
            objDocumentDetails.DocumentBaseURL = objSuggDoc.CCC_Document_URL__c;
            system.debug('objDocumentDetails.DocumentBaseURL'+objDocumentDetails.DocumentBaseURL);
            objDocumentDetails.AccessLevel = objSuggDoc.CCC_Access_Level__c;
            system.debug('objDocumentDetails.AccessLevel'+objDocumentDetails.AccessLevel);
        
            if(objDocumentDetails.AccessLevel == 'Public'){
                suggDocs.add(objDocumentDetails);
                 system.debug('suggDocs.3...'+suggDocs);
            }
            setExisting.add(objSuggDoc.CCC_Document_Title__c);
          
        }
    
         return suggDocs;
  
        
    }
    */
    @AuraEnabled 
    public static List<DocumentDetails> showMoreDocs(Id caseId3,String srchKeyword,String srchByBrand,String srchByModelNo){
        docInfo_resultCount  = 20;
        //System.debug('srchKeyword'+srchKeyword);
        //System.debug('#docInfo_resultCount'+docInfo_resultCount);
        docInfo_resultCount = docInfo_resultCount  + 20;
        //System.debug('#caseId3:'+caseId3);
        showMoreResultsflag = true;
        List<DocumentDetails> list2 = getListDocs(caseId3,showMoreResultsflag,srchKeyword,srchByBrand,srchByModelNo);
        //System.debug('list2'+list2);
        return list2;
       
    }
    
   @AuraEnabled
    public static List<DocumentDetails> getDocumentInformation(Id CaseId,case objTempCase,Integer resultCount,String documentType,String srchKeyword,String srchByBrand,String srchByModelNo){   
        //system.debug('CaseId...'+CaseId);
        List<DocumentDetails> lstaddSuggetedDocument1 = new List<DocumentDetails>();
        HttpRequest req = new HttpRequest();
        errlog=new CCC_ErrorLog();
        CustomSettingEndPoint = CCC_IntegrationEndPoint__c.getValues('DMIS_Search');
        String username = CustomSettingEndPoint.UserName__c;           
        String password = CustomSettingEndPoint.Password__c;           
        String securityToken = CustomSettingEndPoint.Token__c;    
        String baseURL = CustomSettingEndPoint.URL__c ; 
        String endpoint = baseURL + 'clientkey=1ED5E7FA-E8F3-4D5F-A9FC-371D37F0A115&format=json&ResultCount='+resultCount;
        system.debug(baseURL);
        if(srchKeyword!= null)
            //endpoint = endpoint + '&DocumentTitle=' +  EncodingUtil.URLEncode(objTempCase.Subject,'UTF-8');
              endpoint = endpoint + '&DocumentTitle=' +  EncodingUtil.URLEncode(srchKeyword,'UTF-8');
        if(srchByBrand!= null)
            //endpoint = endpoint + '&brands=' + objTempCase.CCC_Brand__c;
              endpoint = endpoint + '&brands=' +srchByBrand;
        if(srchByModelNo!=null)
            //endpoint = endpoint + '&ModelNumbers='+objTempCase.CCC_Model_Number__c;
              endpoint = endpoint + '&ModelNumbers='+srchByModelNo;
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
            System.debug('#ResBody:'+res.getBody());
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
                system.debug('lstSize'+lstDocs.size());
                if(lstDocs.size()>0)
                {
                    showDocumentResult = true;
                    flag = true;
                } else{
                    showDocumentResult = false;
                }
                system.debug('lstDocs'+lstDocs);
              
            }
          //  return lstDocs;
        }catch(System.CalloutException e) {
            errlog.ErrorLogCalloutException(e,'DMIS WebService','CCC_DMISSearchController');
        }
        //Error Hadling part. It will store the information in CCC_Error_log__c  Object.
        Catch(Exception e){
            errlog.ErrorLogException(e,'DMIS WebService','CCC_DMISSearchController');
            responseStr = 'Exception occured while retriving document information';
            list<DocumentDetails> lstaddSuggetedDocument = addSuggetedDocument(CaseId);
            
            system.debug('lstaddSuggetedDocument'+lstaddSuggetedDocument);
            return lstaddSuggetedDocument;
            lstaddSuggetedDocument1 = newMethod2(lstaddSuggetedDocument);
         //   return lstaddSuggetedDocument1;
        }
        if(flag == true){
          list<DocumentDetails> lstExcludingSuggDocs = addSuggetedDocument(CaseId);
            system.debug('lstExcludingSuggDocs'+lstExcludingSuggDocs);
            system.debug('aaa'+lstDocs);
            for (Integer i = 0; i < lstExcludingSuggDocs.size(); i++) 
            {
               for (Integer j = 0; j < lstDocs.size(); j++) 
               {
                  if (lstExcludingSuggDocs[i].DocumentTitle == lstDocs[j].DocumentTitle)
                  {
                     lstDocs.remove(j);
                  }
               }
            }
         system.debug('bbb'+lstDocs);
         return lstDocs;
        }else{
            system.debug('lstaddSuggetedDocument1'+lstaddSuggetedDocument1);
            return lstaddSuggetedDocument1;
        }
        
          
    }   
    
    public static List<DocumentDetails> newMethod2(List<DocumentDetails> lstaddSuggetedDocument){
        
        List<DocumentDetails> lstTemp = new list<DocumentDetails>();
        set<String> setExisting = new Set<String>();
        for(DocumentDetails objDoc:lstaddSuggetedDocument ){
            //Code For Add Access level
            String str = objDoc.DocumentPath;
            if(str!=null && str.contains('Public')){
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
        system.debug('lstDocs'+lstDocs);
        return lstDocs;                
    }    
    
    @AuraEnabled
    public static list<DocumentDetails> addSuggetedDocument(Id CaseId2){
        system.debug('CaseId2'+CaseId2);
        suggDocs = new list<DocumentDetails>();
        //suggDocs = new list<DocumentDetails>();
        list<CCC_Suggested_Documents__c> lstSuggDoc = new list<CCC_Suggested_Documents__c>();
        lstSuggDoc = [Select CCC_Document_Name__c, CCC_Document_Title__c,CCC_Size__c,
                                                       CCC_Document_URL__c,
                                                       CCC_Access_Level__c
                                                       from CCC_Suggested_Documents__c
                                                       where
                                                       CCC_Case__c =:CaseId2];
        
        system.debug('lstSuggDoc.2...'+lstSuggDoc);
        set<String> setExisting = new Set<String>();
        for (CCC_Suggested_Documents__c objSuggDoc :lstSuggDoc){
            showSuggDoc = true;           
            DocumentDetails  objDocumentDetails = new DocumentDetails();
            objDocumentDetails.DocumentTitle = objSuggDoc.CCC_Document_Title__c ;
            objDocumentDetails.DocumentSize = objSuggDoc.CCC_Size__c ;
            objDocumentDetails.DocumentBaseURL = objSuggDoc.CCC_Document_URL__c;
            objDocumentDetails.AccessLevel = objSuggDoc.CCC_Access_Level__c;
            suggDocs.add(objDocumentDetails);
            setExisting.add(objSuggDoc.CCC_Document_Title__c);
            updateCaseFieldWithSuggestedDocs(CaseId2);
        }
        //system.debug('suggDocs.2...'+suggDocs);
        return suggDocs;
  
    }
    
    @AuraEnabled
    public static List<DocumentDetails> SuggestedDocument(string documentLst, ID CaseId){
        //system.debug('documentLst'+documentLst);
        //system.debug('CaseId'+CaseId);
        
        List<DocumentDetails> lstAllDocs = (List<DocumentDetails>)System.JSON.deserialize(documentLst, List<DocumentDetails>.class);
        //system.debug('lstAllDocs'+lstAllDocs);
        list<CCC_Suggested_Documents__c> SuggDocList = new list<CCC_Suggested_Documents__c>(); 
        list<DocumentDetails> lstSelDocs = new list<DocumentDetails>(); 
        for(DocumentDetails obj1 :lstAllDocs){

            if(obj1.isSelected == true){
                string url = '';
                string url1 = '';
                string s = '';
               system.debug('selected '+obj1);                
                CCC_Suggested_Documents__c objSuggesteddoc = new  CCC_Suggested_Documents__c();
                objSuggesteddoc.CCC_Document_Name__c=obj1.DocumentTitle;
                objSuggesteddoc.CCC_Document_Title__c = obj1.DocumentTitle;
                objSuggesteddoc.CCC_Size__c = obj1.DocumentSize;
                url = obj1.DocumentBaseURL;
                url1 = obj1.DocumentPath;
                s = url.removeEnd('/');
                objSuggesteddoc.CCC_Document_URL__c = s  + obj1.DocumentPath;
                objSuggesteddoc.CCC_Case__c = CaseId ; 
                objSuggesteddoc.CCC_Access_Level__c = obj1.AccessLevel;     
                SuggDocList.add(objSuggesteddoc);
                lstSelDocs.add(obj1);
                system.debug(s);
                system.debug(url);
                system.debug(url1);
                system.debug(objSuggesteddoc.CCC_Document_URL__c);
            }  
        }
        
         //system.debug('SuggDocList'+SuggDocList);
         insert SuggDocList;
        
        //list<DocumentDetails> lstExcludingSuggDocs = addSuggetedDocument(CaseId);
            //system.debug('aaa'+lstDocs);
            
            for (Integer i = 0; i < lstSelDocs.size(); i++) 
            {
               for (Integer j = 0; j < lstAllDocs.size(); j++) 
               {
                  if (lstSelDocs[i].DocumentTitle == lstAllDocs[j].DocumentTitle)
                  {
                     lstAllDocs.remove(j);
                  }
               }
            }
         //system.debug('lstAllDocs..'+lstAllDocs);
         return lstAllDocs;
        	
            

         /* List<DocumentDetails> lst3 = addSuggetedDocument(CaseId);
            system.debug('lst3'+lst3);
            return lst3; */
        
       
    }
    public static void updateCaseFieldWithSuggestedDocs(Id caseId){
        Case toUpdateCase = [SElect id, Suggested_Doc_Links__c from Case where id=:caseId]; 
        List<CCC_Suggested_Documents__c> suggesteDocLst = [Select Id, CCC_Document_Title__c, CCC_Document_URL__c from CCC_Suggested_Documents__c where CCC_Case__c =:CaseId order by createddate asc] ;
        String holdSuggestedDocOnCase = '';
        String holdSuggestedDocOnCaseTemp;
        if(suggesteDocLst!=null && suggesteDocLst.size()>0){
            Integer count = 1;
            for(CCC_Suggested_Documents__c eachSuggested:suggesteDocLst){
                //holdSuggestedDocOnCase = holdSuggestedDocOnCase+'<br/>';
                holdSuggestedDocOnCaseTemp = holdSuggestedDocOnCaseTemp+count+') ';
                holdSuggestedDocOnCaseTemp = eachSuggested.CCC_Document_Title__c+' - '+eachSuggested.CCC_Document_URL__c;
                holdSuggestedDocOnCase =  holdSuggestedDocOnCase + holdSuggestedDocOnCaseTemp+'<br/><br/>';
                count++;
            }
            holdSuggestedDocOnCase = holdSuggestedDocOnCase.trim();
            System.debug('#holdSuggestedDocOnCase:'+holdSuggestedDocOnCase);
            toUpdateCase.Suggested_Doc_Links__c = holdSuggestedDocOnCase;
            update toUpdateCase;
        }
    }
}