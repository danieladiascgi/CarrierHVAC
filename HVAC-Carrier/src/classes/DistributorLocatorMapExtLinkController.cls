public class DistributorLocatorMapExtLinkController {
    
    public String myString{get;set;}
    public String dealerPhone{get; set;}
    public String dealerName{get; set;}
    public  String accountName{get; set;}
    public String firstName{get; set;}
    public String lastName{get; set;}
    public String dealerEmail{get; set;}
    public Id caseId{get; set;}
    public String brand{get;set;}
    public String source{get; set;}
    public String email{get; set;}
    public boolean displayPopup {get; set;}   
    public boolean displayDealerInfo {get; set;}
    public boolean displayDealerInfoForDistLoctBtn {get;set;}
    public boolean CreateContact {get;set;}
    public String selectedDealerId{get; set;}
    public String selectedContactId{get; set;}
    public String selectedDealerName{get; set;}
    public String selectedContactName{get; set;}
    public String selectedAccountName{get; set;}
    public String selectedAccountId{get; set;}
    public String dealerIdToPass{get; set;}
    public String contactIdToPass{get; set;}
    public String accountIdToPass{get; set;}
    public Account createAccountIfNotPresent{get; set;}
    public Id AccountId{get;set;}
    public list<SelectOption> BrandOption {get; set;} 
    public String brandSelected{get; set;}
    public String brandname{get; set;}
    public String contactName{get; set;}
    public Contact con{get;set;}
    public String dealerPhoneDistLoctBtn{get;set;}
    public  string accName;
    public DistributorLocatorMapExtLinkController() {
        
        //  this.brand = ApexPages.currentPage().getParameters().get('brandfromURL');
        this.dealerPhone = ApexPages.currentPage().getParameters().get('phoneFromURL');
        this.dealerName = ApexPages.currentPage().getParameters().get('id');
        this.caseId = ApexPages.currentPage().getParameters().get('id');
        this.source = ApexPages.currentPage().getParameters().get('source');
        this.email = ApexPages.currentPage().getParameters().get('email');
        this.dealerPhoneDistLoctBtn =ApexPages.currentPage().getParameters().get('dealerPhone');
        this.firstName = ApexPages.currentPage().getParameters().get('firstName');
        this.lastName = ApexPages.currentPage().getParameters().get('lastName');
        this.selectedContactId = ApexPages.currentPage().getParameters().get('selectedContactId'); 
        this.selectedContactName = ApexPages.currentPage().getParameters().get('selectedContactName'); 
        this.selectedAccountId = ApexPages.currentPage().getParameters().get('selectedAccountId'); 
        this.selectedAccountName = ApexPages.currentPage().getParameters().get('selectedAccountName');
        if(selectedAccountName==null || selectedAccountName.length()>0){
            selectedAccountName = ApexPages.currentPage().getParameters().get('targetAccountName');
        }
        this.selectedDealerId = ApexPages.currentPage().getParameters().get('selectedDealerId'); 
        this.selectedDealerName = ApexPages.currentPage().getParameters().get('selectedDealerName');
        System.debug('######selectedAccountId:'+selectedAccountId);
        System.debug('#######selectedAccountName:'+selectedAccountName);
        System.debug(selectedAccountName = ApexPages.currentPage().getParameters().get('targetAccountName'));
       
        /* this.selectedDealerId= '';
this.selectedContactId='';
this.selectedDealerName='';
this.selectedAccountId='';
this.selectedAccountName='';*/
        dealerIdToPass = '';
        contactIdToPass = '';
        accountIdToPass ='';
       
        BrandOption = new list<SelectOption>();
        BrandOption.add(new SelectOption('',''));
        BrandOption.add(new SelectOption('Carrier','Carrier'));
        BrandOption.add(new SelectOption('Bryant','Bryant'));
        BrandOption.add(new SelectOption('Payne','Payne'));
       
        if(source!=null && source.length()>0 && source=='SmartSearch'){
            displayDealerInfo = true;
        }
        
        else if(source!=null && source.length()>0 && source == 'DistLoctBtn')
        {
            // displayDealerInfo = false;
            CreateContact = true;
            // displayDealerInfoForDistLoctBtn = true;
        }
        else if(source!=null && source.length()>0 && source == 'DistLoctBtnContVerified')
        {
            displayDealerInfo = false; 
        }
        else
        {
           displayDealerInfo = false;  
        }
    }
    public PageReference showStateResults(){
        system.debug('accountName****'+accName);
        System.debug('#Selected Dealer id:'+this.dealerIdToPass);
        System.debug('#Selected Account id:'+this.accountIdToPass);
        System.debug('#selectedContactId:'+selectedContactId);
        system.debug('accountName'+accountName);
        system.debug('selectedAccountName'+selectedAccountName);
        PageReference newPage = null;
        if(source!=null && source.length()>0 && source.equalsIgnoreCase('ExternalLink')){
            newPage = new PageReference('/apex/NonCaseDSMSearchPageTier2?valPassed='+myString+'&brandselected='+brandname+'&dealerPhone='+dealerPhone+'&dealerName='+dealerName+'&selectedDealerId='+dealerIdToPass+'&source='+source);   
        }
        else if(source!=null && source.length()>0 && source.equalsIgnoreCase('DistLoctBtn'))
        {
            newPage = new PageReference('/apex/NonCaseDSMSearchPageExtLink?valPassed='+myString+'&brandselected='+brandname+'&dealerPhone='+dealerPhone+'&selectedAccountId='+accountIdToPass+'&source='+source+'&caseId='+caseId+'&email='+email+'&firstName='+firstName+'&lastName='+lastname+'&selectedContactName='+selectedContactName+'&accountName='+selectedAccountName+'&selectedContactId='+contactIdToPass+'&accountNameDistLoctBtn='+accName);   
            
        }
        else{
            newPage = new PageReference('/apex/NonCaseDSMSearchPageExtLink?valPassed='+myString+'&brandselected='+brandname+'&dealerPhone='+dealerPhone+'&dealerName='+dealerName+'&selectedDealerId='+dealerIdToPass+'&source='+source);   
        }
        
        String searchQuery = 'FIND \'' + email + '\' IN ALL FIELDS RETURNING Contact(id),Account(id) ';
        
        system.debug('searchQuery'+searchQuery);
        if(searchQuery.length()>=1)
        {
            system.debug('searchQuery'+searchQuery);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Contacts Present for associated email..Please search contact using lookup!!!')); 
        }
        
        newPage.setRedirect(true); 
        return newPage;
       
    }
    
    public PageReference closePopup() {        
      
        system.debug('#selectedAccountId:'+selectedAccountId);
        system.debug('#selectedAccountName:'+selectedAccountName);
        system.debug('#selectedDealerName:'+selectedDealerName);
        system.debug('#selectedContactId:'+selectedContactId);
        system.debug('#dealerName:'+dealerName);
        system.debug('#dealerName:'+dealerPhone);
        if(source!=null && source.length()>0 && (source=='SmartSearch') && (selectedDealerName==null || selectedDealerName =='')){
            displayPopup = true;
        }else{
            if(selectedDealerId!=null && selectedDealerId !='')
            {  
                this.dealerIdToPass = selectedDealerId;
            }
            dealerName = selectedDealerName;
            displayPopup = false;
        }
        //Account association to case
        if(source!=null && source.length()>0 && source=='DistLoctBtn' && (selectedAccountName==null && selectedAccountName=='')){
            displayPopup = true;
        }else{
            system.debug('#selectedAccountId:'+selectedAccountId);
            if(selectedAccountId!=null && selectedAccountId !='')
            {  
                this.accountIdToPass = selectedAccountId;
                
            }
            this.accName = selectedAccountName;
            system.debug('accountName'+accName);
            displayPopup = false;
        }
        //Contact Association to case
        if(source!=null && source.length()>0 && (source=='DistLoctBtn') && (lastName==null || lastName =='')){
            displayPopup = true;
        }else{
            
            if(selectedContactId!=null && selectedContactId !='')
            {  
                this.contactIdToPass = selectedContactId;
            }
            
            contactName = selectedContactName;
            system.debug('contactName'+contactName);
            displayPopup = false;
        }
        return null;
    }
    
    public void showPopup() {        
        displayPopup = true;    
    }
}