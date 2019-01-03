public with sharing class FeedbackTurnbackSelectionController1 {
    // Turnback and selection set/variables
    //New Or Escape Variables - Start
     //public CaseTurnBackJunction__c junction{get; set;}
    public Turnback__c turnback{get; set;}
    public String caseId{get; set;}
    /*public Boolean renderNonCaseRelatedSection{get; set;}
    public List<CaseTurnBackJunction__c> listOfCaseTurnBackJunction {get;set;}
    public String purpose{get; set;}
    public String subPurpose{get; set;}
    public String casetype{get; set;}*/
    public Boolean renderSearch{get; set;}
    /*public Boolean isSearchClicked{get; set;}*/
    public String selectedTurnbackId{get; set;}
    /*public Boolean isFromCase{get; set;}*/
    public String retURL{get; set;}
    //New Or Escape Variables - End
    //private list<TurnbackSubclass> Turnbacklist {get; set;}
    /*private set<Id> TurnbackSelectedSet;
    public Integer TurnbackSelectedCount {get; set;}
    public String SelectedOneTurnback {get; set;}*/
    // selection and filter
    public list<String> AlphaList {get; set;}
    public String AlphaFilter {get; set;}
    /*//public String SearchType {get; set;}
    //public String SearchSubType {get; set;}
    private String SaveSearchType;
    private String SaveSearchSubType;
    public String SaveSearchDescription;
    private String QueryTurnback;*/
    // display sort and number
    public String RecPerPage {get; set;}
    public list<SelectOption> RecPerPageOption {get; set;} 
    /*public String SortFieldSave;*/
    /***
    * FeedbackTurnbackSelectionController - Constructor initialization
    ***/
   
    public FeedbackTurnbackSelectionController1(ApexPages.StandardController cont){
        caseId = ApexPages.currentPage().getParameters().get('caseid');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        /*isFromCase = false;
        if(caseId!=null && caseId.length()>0){
            isFromCase = true;
        }*/
        //junction = new CaseTurnBackJunction__c();
        turnback = new Turnback__c();
        /*isSearchClicked = false;
        Turnbacklist = new list<TurnbackSubclass>();
        TurnbackSelectedSet = new set<Id>();
        renderNonCaseRelatedSection = false;
        //records for page initialization
        renderSearch = false;
        RecPerPageOption = new list<SelectOption>();
        RecPerPageOption.add(new SelectOption('10','10'));
        RecPerPageOption.add(new SelectOption('25','25'));
        RecPerPageOption.add(new SelectOption('50','50'));
        RecPerPageOption.add(new SelectOption('100','100'));
        RecPerPageOption.add(new SelectOption('200','200'));
        RecPerPage = '10'; //default records per page
        // initialization alpha list
        AlphaList = new list<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Other', 'All'};
            SortFieldSave = SortField;
        // alpha filter, use page parameter or set default to all
        if (apexpages.currentpage().getparameters().get('alpha') == null) {
            AlphaFilter = 'All';
        } else {
            AlphaFilter = apexpages.currentpage().getparameters().get('alpha');
        }
        // list generation
        BuildQuery();*/ 
    }
    /***
    * StdSetControllerTurnback - paging through the Turnback list
    ***/
   
   
    public ApexPages.StandardSetController StdSetControllerTurnback {
        get {
            /*if(StdSetControllerTurnback == null) {
                StdSetControllerTurnback = new ApexPages.StandardSetController(Database.getQueryLocator(QueryTurnback));
                // sets the number of records in each page set
                StdSetControllerTurnback.setPageSize(Integer.valueOf(RecPerPage));
            }*/
            return StdSetControllerTurnback;
        }
        set;
    }
   
   
    /***
    * getCurrentTurnbacklist - return an Turnback list for the table
    ***/


   
    /*public list<TurnbackSubclass> getCurrentTurnbacklist() {
        UpdateTurnbackSelectedSet();
        Turnbacklist = new list<TurnbackSubclass>();
        list<Turnback__c> tempLst = new list<Turnback__c>();
        for (Turnback__c a : (list<Turnback__c>)Database.query(QueryTurnback)) {
            //System.debug('##ID['+a.id+']Desc:'+a.Description__c);
            //System.debug('#Res Stsfy:'+(SaveSearchDescription.length()>0 && a.Description__c.contains(SaveSearchDescription)));
            if(SaveSearchDescription!=null && SaveSearchDescription.length()>0){
                if(a.Description__c!=null && a.Description__c.contains(SaveSearchDescription)){
                    tempLst.add(a);
                    Turnbacklist.add(new TurnbackSubclass(a, TurnbackSelectedSet.contains(a.Id)));
                }
                
            }else{
                Turnbacklist.add(new TurnbackSubclass(a, TurnbackSelectedSet.contains(a.Id)));
                }
        }
        StdSetControllerTurnback = new ApexPages.StandardSetController(tempLst);
        return Turnbacklist;
    }*/
   
   
    /***
    * UpdateTurnbackSelectedSet - add/remove Turnbacks from the selected Turnback id list
    ***/
    /*public void UpdateTurnbackSelectedSet(){
        for(TurnbackSubclass a : Turnbacklist ){
            if(a.aCheckBox == true) {
                TurnbackSelectedSet.add(a.aTurnback.Id);
            } else {
                if(TurnbackSelectedSet.contains(a.aTurnback.Id)) {
                    TurnbackSelectedSet.remove(a.aTurnback.Id);
                }
            }
        } 
        TurnbackSelectedCount = TurnbackSelectedSet.size();
    }*/
    /***
    * ClearTurnbackSelectedSet - remove selected Turnbacks and initialize counter
    ***/
    /*public PageReference ClearAll(){
        Turnbacklist.clear();
        TurnbackSelectedSet.clear();
        TurnbackSelectedCount = 0;
        //SearchType = '';
        //SearchSubType = '';
        SaveSearchType = '';
        SaveSearchSubType = '';
        SaveSearchDescription='';
        AlphaFilter = 'All';
        BuildQuery();
        return null;
    }*/
    /***
    * SearchTurnback - set search criteria fields and refresh Turnback table
    ***/
    /*public PageReference SearchTurnback() {
        if(!renderNonCaseRelatedSection && (junction.Type__c==null || junction.Type__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Type'));
            return null;
        }
        if(!renderNonCaseRelatedSection && (junction.Sub_Type__c==null || junction.Sub_Type__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Sub-Type'));
            return null;
        }
        if(!renderNonCaseRelatedSection && (turnback.Description__c==null || turnback.Description__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Description'));
            return null;
        }
        renderSearch = true;
        //SaveSearchType = SearchType;
        isSearchClicked = true;
        //System.debug('#isSearchClicked:'+isSearchClicked);
    SaveSearchType = junction.Type__c;
        //SaveSearchSubType = SearchSubType;
    SaveSearchSubType = junction.Sub_Type__c;
    SaveSearchDescription = turnback.Description__c;
        BuildQuery();
        return null;
    }*/
    /***
    * BuildQuery - build query command for list selection change
    ***/
    /*public void BuildQuery() {
        StdSetControllerTurnback = null;
        String QueryWhere = '';
        if (AlphaFilter == null || AlphaFilter.trim().length() == 0) {
            AlphaFilter = 'All';
        }
       QueryTurnback = 'SELECT Id,Name,Type__c,Sub_Type__c, Identified_By__c, Description__c, Count__c, Status__c, Identified_On__c  ' +
            ' FROM Turnback__c';
        if (AlphaFilter == 'Other') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' < \'A\' OR ' +
                                    String.escapeSingleQuotes(SortField) + ' > \'Z\') AND (NOT ' +
                                    String.escapeSingleQuotes(SortField) + ' LIKE \'Z%\') ');
        } else if (AlphaFilter != 'All') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' LIKE \'' + String.escapeSingleQuotes(AlphaFilter) + '%\')' );
        }
        if (SaveSearchType != null) {
            QueryWhere = BuildWhere(QueryWhere, ' (Type__c LIKE \'%' + String.escapeSingleQuotes(SaveSearchType) + '%\')');
        }
        if (SaveSearchSubType != null) {
              QueryWhere = BuildWhere(QueryWhere, ' (Sub_Type__c LIKE \'%' + String.escapeSingleQuotes(SaveSearchSubType) + '%\')');
        }
        QueryTurnback += QueryWhere;
        QueryTurnback += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) + ' LIMIT 10000';
        system.debug('QueryTurnback:' + QueryTurnback);
    }*/
    /***
    * BuildWhere - build soql string for where criteria
    ***/
    /*public String BuildWhere(String QW, String Cond) {
        if (QW == '') {
            return ' WHERE ' + Cond;
        } else {
            return QW + ' AND ' + Cond;
        }
    }*/
    /***
    * SortDirection - return sort direction. Default ascending(asc)
    ***/
    /*public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; } return SortDirection;  }
        set;
    }*/
    /***
    * SortField - return sort by field. Default to Name
    ***/
    /*public String SortField {
        get { if (SortField == null) {SortField = 'Name'; } return SortField;  }
        set;
    }*/
    /***
    * SortToggle - toggles the sorting of query from asc<-->desc
    ***/
    /*public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            AlphaFilter = 'All';
            SortFieldSave = SortField;
        }
        // run the query again
        BuildQuery();
    }*/
    /***
    * DoSomethingOne - do something with one selected Turnback
    ***/
    /*public PageReference DoSomethingOne() {
        system.debug('SelectedOneTurnback: ' + SelectedOneTurnback);
        return null;
    }*/
    /***
    * DoSomethingMany - do something with many selected Turnbacks
    ***/
    /*public PageReference DoSomethingMany() {
        for (Id TurnbackId : TurnbackSelectedSet) {
            system.debug('Checked: ' + TurnbackId);
        }
        return null;
    }*/
  
    /*public class TurnbackSubclass {
        public Boolean aCheckBox {get;set;}
        public Turnback__c  aTurnback {get;set;}
        // sub-class initialization
        public TurnbackSubclass(Turnback__c a, Boolean chk){
            aTurnback = a;
            aCheckBox = chk;
        }
    }*/
    //********************************************************
    /*public PageReference nonCaseRelatedCounts(){
        
        renderSearch = false;
        isSearchClicked = true;
        renderNonCaseRelatedSection = !renderNonCaseRelatedSection;
        return null;
    }*/
    /*public List<CaseTurnBackJunction__c> getAllFields()
    {
        return listOfCaseTurnBackJunction;
    }*/
    /*public PageReference populateCaseFields(){
        if(caseId!=null && caseId.length()>0){
            Case cse = [Select Id, CCC_Purpose__c, CCC_Sub_Purpose__c,CCC_RecordTypeName__c from Case where Id=:caseId];
            junction.CaseMaster__c = cse.Id;
            purpose = cse.CCC_Purpose__c;
            subPurpose = cse.CCC_Sub_Purpose__c;
            casetype = cse.CCC_RecordTypeName__c;
            
        }
        return null;
    }*/
    public PageReference saveTurnbackAndJunction(){
        //System.debug('#isSearchClicked:'+isSearchClicked);
        /*if(isSearchClicked){*/
            if((turnback.Type__c==null || turnback.Type__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Type'));
            return null;
        }
        if((turnback.Sub_Type__c==null || turnback.Sub_Type__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Sub-Type'));
            return null;
        }
        if((turnback.Description__c==null || turnback.Description__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Description'));
            return null;
        }
        if((turnback.Title__c==null || turnback.Title__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Title'));
            return null;
        }
        //System.debug('#Juntion Type:'+junction.Type__c);
        //System.debug('#Juntion Sub Type:'+junction.Sub_Type__c);
        //System.debug('#Juntion Description:'+turnback.Description__c);
        //turnback.Type__c = junction.Type__c;
        //turnback.Sub_Type__c = junction.Sub_Type__c;
        turnback.Count__c = 1;
        turnback.Identified_By__c = UserInfo.getUserId();
        turnback.Identified_On__c = Date.today();
        //turnback.Status__c = '--None--';
        //turnback.Source__c = 'Testing';
        insert turnback;
        /*if((renderNonCaseRelatedSection || isSearchClicked) && isFromCase){    
            junction.TurnbackMaster__c = turnback.Id;
            junction.CaseMaster__c = caseId;
            insert junction;
            return redirectToCaseDetail();
        }else if((renderNonCaseRelatedSection || isSearchClicked) && !isFromCase){*/
            return redirectToTurnbackDetail();
        /*}*/        
        /*}else{
            System.debug('#Error Block');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please search for Turnbacks first...'));
        }*/  
        return redirectToTurnbackDetail();
    }
    public PageReference redirectToCaseDetail()
    {
        
        PageReference redirectPage1 = new PageReference('/'+caseId);
        redirectPage1.setRedirect(true);
        return redirectPage1;
        
    }
    public PageReference redirectToTurnbackDetail()
    {
         PageReference redirectPage1 = null;
        if(turnback!=null && turnback.Id!=null){
            redirectPage1 = new PageReference('/'+turnback.Id);
        }else if(selectedTurnbackId!=null && selectedTurnbackId.length()>0){
            redirectPage1 = new PageReference('/'+selectedTurnbackId);
        }else{
            redirectPage1 = new PageReference('/'+retURL);
        }
        //PageReference redirectPage1 = new PageReference('/'+turnback.Id);
        redirectPage1.setRedirect(true);
        return redirectPage1;
        
    }
    /*public PageReference saveTurnbacks(){
        isSearchClicked = true;
        if(!renderNonCaseRelatedSection && (junction.Type__c==null || junction.Type__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Type'));
            return null;
        }
        if(!renderNonCaseRelatedSection && (junction.Sub_Type__c==null || junction.Sub_Type__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Sub-Type'));
            return null;
        }
        if(!renderNonCaseRelatedSection && (turnback.Description__c==null || turnback.Description__c.equals(''))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Description'));
            return null;
        }
       List<CaseTurnBackJunction__c> juncToInsertLst = new List<CaseTurnBackJunction__c>();
         //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'selectedTurnbackId'+selectedTurnbackId));
        if(selectedTurnbackId!=null && selectedTurnbackId.length()>0){
            if(isFromCase){
            CaseTurnBackJunction__c junc = new CaseTurnBackJunction__c();
                 junc.CaseMaster__c = caseid;
                 junc.TurnbackMaster__c = selectedTurnbackId;
                 insert junc;
            }    
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Records Saved successfully...'));
            Turnback__c tbCountUpdate = [Select Id, Count__c from Turnback__c where Id=:selectedTurnbackId];
            tbCountUpdate.Count__c = tbCountUpdate.Count__c!=null?tbCountUpdate.Count__c+1:1;
            update tbCountUpdate;
        }
         
        return null;
    }*/
    /*public PageReference getSelected()
    {
        
        selectedTurnbackId = ApexPages.currentPage().getParameters().get('accid');
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,selectedTurnbackId));
        System.debug('Entered account selection block:'+selectedTurnbackId);
        return null;
    }*/
    public PageReference cancelOrClose(){
        /*if(isFromCase){
            return redirectToCaseDetail();
        }else{*/
            return redirectToTurnbackDetail();
        /*}*/
    }
    //*********************************************************
}