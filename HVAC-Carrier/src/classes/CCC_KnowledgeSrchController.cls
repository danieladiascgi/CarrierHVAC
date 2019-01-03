/**
* @ Developer :Somdev Bhattacharya 
* @date_created : 2/22/2016
* @functions : Detail description
* @Date Modified : 3/14/2016 Reason: Remove unwanted commented code and debug statements Developer :Ankita Rambole
* @Date Modified : 3/16/2016 Reason: Added method and statement level comments Developer :Ankita Rambole

*
*
***/

public with sharing class CCC_KnowledgeSrchController {
    public  List<knowledgeWrapper> knowledgeList = new List<knowledgeWrapper>();
    
    //public  List<CCC_Knowledge__kav> selectedKnowledge = new List<CCC_Knowledge__kav>();
    public String titles {get;set;}
    /**
* @return:PageReference
* @description : This method redirects to new Case Page
**/
    public PageReference createNewCase() {
        return new PageReference('/setup/ui/recordtypeselect.jsp?ent=Case&retURL=%2F500%2Fo&save_new_url=%2F500%2Fe%3FretURL%3D%252F500%252Fo');
        
    }
    public Id selectedCaseType{get;set;}
    public String selectedCategoryType {get;set;}
    public boolean caseTrue {get ; set;}
    
    /**
* @description : Fetches loggedIn User's profile ID'
**/
    public PageReference showField() {
        Profile p = [select name from Profile where id =:UserInfo.getProfileId()];
        
        //throws error if no subject is entered
        if(titles ==null|| titles=='') {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Please enter Subject');
            ApexPages.addMessage(myMsg); 
            return null;
        }   
        else { 
            
            if((/*p.name !='Partner Community Warranty Admin' &&*/ p.name != 'Partner Community DSM')){
                caseTrue=true;
                return null;
            }
           
            //if profile is a Partner Community Warranty Admin, and check box next to title is checked, the case is created with subject as value in titles
            else {
                
                integer i=0;
                for(knowledgeWrapper pp :knowledgeList) {
                    if(pp.selected ==true){
                        i=1;
                    }
                }
                if(i==1) {
                    
                    case c = new case ();
                    c.Subject= titles;
                    insert c;
                    CaseArticle ca;
                    List<CaseArticle> caList= new List<CaseArticle>();
                    
                    for(knowledgeWrapper dd : knowledgeList) {
                        
                        //It attaches the article with the case if the check box is checked
                        if(dd.selected ==true ) {
                            ca= new CaseArticle();
                            ca.CaseId=c.Id;
                            /*ca.KnowledgeArticleId=dd.knwlg.KnowledgeArticleId;
                            ca.ArticleVersionNumber=dd.knwlg.VersionNumber;
                            ca.ArticleLanguage=dd.knwlg.Language;*/
                            caList.add(ca);
                        }
                    }
                    
                    if(caList.size()>0){
                        /*insert caList;  */  
                    }
                    //It redirects to Case Edit Page
                    PageReference redirecturl = new PageReference('/'+c.id+'/e');
                    redirecturl.setRedirect(true);
                    return redirecturl ;
                    
                }
                //It redirects to Case Edit Page and fetches the title with it
                else {
                    PageReference redirecturl = new PageReference('/500/e?ent=Case&cas14='+titles);
                    redirecturl.setRedirect(true);
                    return redirecturl ;
                }
                
            }
            
        }    
    }    
    
    
    // the soql without the order and limit
    private String soql {get;set;}
    
    
    /**
* @description : Fetches the collection of contacts to display
**/
   // public List<CCC_Knowledge__kav> ArticleList{get;set;}
    
    /**
* @description :constructor call
**/
    public CCC_KnowledgeSrchController() {
        
        System.debug('constructor titles : titles :'+ titles );
        
        //when selectedCategoryType is equal to null, the insert the query result in ArticleList 
        if(selectedCategoryType ==null || selectedCategoryType =='- None -') {
            /*soql = 'SELECT title,Summary, UrlName,ArticleType,VersionNumber,Language,KnowledgeArticleId,IsVisibleInPrm FROM CCC_Knowledge__kav where  PublishStatus = \'online\' and Language = \'en_US\' and IsVisibleInPrm=true Limit 1000';
            
            ArticleList=Database.query(soql);*/
            
        }
        else
        {
            soql = 'SELECT title,Summary,UrlName,ArticleType,VersionNumber,Language,KnowledgeArticleId,IsVisibleInPrm FROM CCC_Knowledge__kav where  PublishStatus = \'online\' and Language = \'en_US\' and IsVisibleInPrm=true Limit 1000';
            
            runQuery();
        }
        caseTrue=false;
    }
    
    
    /**
* @description :This method runs the actual query
**/
    public void runQuery() {
        /*ArticleList.clear();
        set<Id> artIdSet= new set<Id>();
        List<CCC_Knowledge__kav> fdList = new List<CCC_Knowledge__kav>();
        if(selectedCategoryType!=null){
            For(CCC_Knowledge__DataCategorySelection c:[Select Id, ParentId,Datacategoryname from CCC_Knowledge__DataCategorySelection] ) {
                if(c.Datacategoryname==selectedCategoryType) {
                    artIdSet.add(c.ParentId);
                }
                
            }
            
            fdList  =Database.query(soql);     
            
            for(CCC_Knowledge__kav c:fdList) {
                for(Id i :artIdSet) {
                    
                    if(string.valueof(i)==c.id && c.IsVisibleInPrm==true){
                        
                        ArticleList.add(c);
                    }
                    
                }
                
            }
        }
        else {
            ArticleList=Database.query(soql);
            
        }*/
        
        
        
        
    }
    /**
* @description :It forms SOQL query that works on OnKeyUp
**/
    public PageReference runSearch() {
        
        titles = Apexpages.currentPage().getParameters().get('title');
        
        /*soql = 'SELECT title,Summary,UrlName,KnowledgeArticleId, ArticleType,VersionNumber,Language, IsVisibleInPrm FROM CCC_Knowledge__kav where PublishStatus = \'online\' and Language = \'en_US\' ';
        
        
        if (titles!=null && !titles.equals('')){
            soql  = soql +'AND  (title like  \'%'+String.escapeSingleQuotes(Titles)+'%\'';
            soql  = soql +' OR Summary like  \'%'+String.escapeSingleQuotes(Titles)+'%\'' + ' )' +' Limit 1000';
            
        }
        runQuery(); */
        
        return null;
    }
    /**
* @returns: PageReference
* @description :It will get the selected articles and add it to accwrapper 
**/
    public PageReference getSelected() {
        
        /*selectedKnowledge.clear();
        for(knowledgeWrapper accwrapper : knowledgeList ){
            if(accwrapper.selected == true){
                selectedKnowledge.add(accwrapper.knwlg);
            }
        }*/
        return null;
        
    }
    
    /**
* @returns: pageReference
* @description :redirects page to Home Page of Community
**/
    
    public pageReference cancelSearch () {
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        PageReference redirecturl1 = new PageReference(baseUrl);
        redirecturl1.setRedirect(true);
        return redirecturl1 ;
    }
    
    /**
* @returns: PageReference
* @description :This method redirects to Create New Case Page
**/
    public PageReference createCase () {
        integer i=0;
        for(knowledgeWrapper pp :knowledgeList) {
            if(pp.selected ==true){
                i=1;
            }
        }
        if(i==1){
            //gives error if the case record type is not selected
            if(selectedCaseType ==null){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please  select the case type');
                ApexPages.addMessage(myMsg1); 
                return null;
            }
            //creates and insert new case of selected case Type
            if(selectedCaseType !=null){
                case c = new case();
                c.RecordTypeId=selectedCaseType;
                if(titles!='' && titles!=null){
                    c.subject=titles;
                    
                    try {
                        insert c;
                    }
                    catch(DMLexception e) {
                        
                        
                        ApexPages.addMessages(e);
                    }
                    
                    CaseArticle ca;
                    List<CaseArticle> caList= new List<CaseArticle>();
                    
                    /*for(knowledgeWrapper dd : knowledgeList) {
                        
                        if(dd.selected ==true ) {
                            ca= new CaseArticle();
                            ca.CaseId=c.Id;
                            ca.KnowledgeArticleId=dd.knwlg.KnowledgeArticleId;
                            ca.ArticleVersionNumber=dd.knwlg.VersionNumber;
                            ca.ArticleLanguage=dd.knwlg.Language;
                            caList.add(ca);
                        }
                    }
                    if(caList.size()>0){
                        insert caList;    
                    }*/
                    system.debug('caseID link' + c.id);
                    PageReference redirecturl = new PageReference('/'+c.id+'/e');
                     system.debug('caseID link' + redirecturl);
                    redirecturl.setRedirect(true);
                    return redirecturl ;
                }
                else {
                    PageReference redirecturl = new PageReference('/500/e?ent=Case&RecordType='+selectedCaseType);
                    redirecturl.setRedirect(true);
                    return redirecturl ;
                }
            } 
            //error when subject is not entered while creating case
            else{
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please  Subject');
                ApexPages.addMessage(myMsg1); 
                return null;
            }
        } else { 
            //error when record type for case is not selected
            if(selectedCaseType ==null){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Please  select the case type');
                ApexPages.addMessage(myMsg1); 
                return null;
            }
            else {
                PageReference redirecturl = new PageReference('/500/e?ent=Case&RecordType='+selectedCaseType+'&cas14='+titles);
                redirecturl.setRedirect(true);
                return redirecturl ;    }  
        }
    }
    
    /**
* @returns: the picklist options
* @description :This method gets all available record types for case object based on the profile
**/
    public static List<String> GetAvailableRecordTypeNamesForSObject(Schema.SObjectType objType) {
        List<String> names = new List<String>();
        List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
        // If there are 2 or more RecordTypes...
        if (infos.size() > 1) {
            for (RecordTypeInfo i : infos) {
                if (i.isAvailable()) 
                    // Ignore the Master Record Type, whose Id always ends with 'AAA'.
                    // We check the Id because Name can change depending on the user's language.
                    // && !String.valueOf(i.getRecordTypeId()).endsWith('AAA'))
                    names.add(i.getName());
            }
        } 
        // Otherwise there's just the Master record type,
        // so add it in, since it MUST always be available
        else names.add(infos[0].getName());
        return names;
    }
    /**
* @returns: the picklist options
* @description :This method gets all available record types for case object available in availableCaseTypes list
**/
    public List<selectOption> getCaseType() {
        List<String> availableCaseTypes =GetAvailableRecordTypeNamesForSObject(Case.SObjectType);
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', '- None -')); 
        for (RecordType recordtype : [SELECT Id, Name FROM RecordType where SobjectType = 'Case' AND IsActive = TRUE AND Name in:availableCaseTypes]) { 
            options.add(new selectOption(recordtype.id, recordtype.Name)); 
            
        }
        return options; //return the picklist options
    }
    /**
* @returns: the picklist options
* @description :This method gets all available Category Type for the selected Article
* Category Type is the custom setting used for differentiating articles based on categories
**/
    
    public List<selectOption> getCategoryType() {
        
        
        List<selectOption> option1s = new List<selectOption>(); 
        option1s.add(new selectOption('', '- None -')); 
        for (CategoryTypes__c recordtype1 :[Select name,Display_Name__c from CategoryTypes__c] ) { 
            option1s.add(new selectOption(recordtype1.Name,recordtype1.Display_Name__c)); 
            
        }
        return option1s; //return the picklist options
    }
    
    /**
* @returns: list
* @description :This method get all Article list and display in User Interface
**/
    public List<knowledgeWrapper> getknowledgeList() {
        /*knowledgeList.clear();
        // add articles to list
        for(CCC_Knowledge__kav ff :ArticleList) {
            knowledgeList.add(new knowledgeWrapper(ff));         
        } */
        
        return knowledgeList;
    }
    public List<knowledgeWrapper> setknowledgeList() {
        
        return knowledgeList;
    }
    public class knowledgeWrapper {
        //public CCC_Knowledge__kav knwlg {get; set;}
        public Boolean selected {get; set;}
        /*public knowledgeWrapper(CCC_Knowledge__kav a) {
            knwlg = a;
            selected = false;
        }*/
    }
    /**
* @returns: list
* @description :This method get all Article list which are selected by the user
**/
   /* public List<CCC_Knowledge__kav> GetselectedKnowledge()    {
        if(selectedKnowledge.size()>0){
            return selectedKnowledge;
        }
        else{
            return null;
        }    
    }   */
}