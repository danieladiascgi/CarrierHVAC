/**
 * @ Developer : Amitkumar Joshi
 * @date_created : 13/01/2016
 *  @Date Modified : <3/14/2016> Reason:Remove unwanted commented code and debug statements Developer :Ankita Rambole
 @Date Modified : <3/15/2016> Reason: <Add Class, method and statement level comments, verify all methods > Developer :<Ankita Rambole> 
 ***/ 
public  class CCC_ViewCaseController{

//--------------------------------------------------------------
    //List to store all the cases according to requirement
    public List<Case> AllCases = new list<Case>();
    public List<Case> AllCasesSubmittedByMe = new list<Case>();
    public List<Case> AllCompanyCases = new list<Case>();
    public List<Case> AllSharedCases = new list<Case>();
    
    //List to show the limited records on the page
    public List<Case> casesToShow{get;set;}
    public List<Case> submittedByMeCasesToShow{get;set;}
    public List<Case> allCompanyCasesToShow{get;set;}
    public List<Case> allSharedCasesToShow{get;set;}
    //Navigation variables
    Integer counter = 0;//TO track the number of records parsed
    Integer counter1=0;
    Integer counter2=0;
    Integer counter3=0;
    Integer limitSize = 10;
    Integer limitSize1 = 10;
    Integer limitSize2 = 10; //Number of records to be displayed
    Integer limitSize3 = 10;
    Integer totalSize =0;
    Integer totalSize1=0;
    Integer totalSize2=0; //To Store the total number of records available
    Integer totalSize3=0;
  //--------------------------------------------------------------  
    public list<case> myOpenCaseList{get;set;} // my open cases
    public boolean isShowMySupportCasesTab{get;set;} // show / hide My support cases tab on visualforce page
    public boolean isShowMyCompanyCasesTab{get;set;} // show / hide My Company cases tab on visualforce page
    public boolean isShowCreateCaseButton{get;set;} // show / hide Create Case Button on visualforce page
    public boolean isShowMySharedCasesTab{get;set;}
    Public String UserId = UserInfo.getUserId();
    Public Set<Id> setRecordTypeIds = new Set<Id>();
    public String orderByField{get;set;} 
    public String orderByField_MSR{get;set;}
    public Profile currentUserProfile;
   // public String Status='Closed';
    public String Status;
    public String size='LIMIT 250';
    public String orderType_MSR{
       get{return orderType_MSR;}
      set{orderType_MSR= (orderType_MSR== 'DESC')? 'ASC' : 'DESC';
      }
    }
    public String orderByField_ACL{get;set;}
    public String orderType_ACL{
       get{return orderType_ACL;}
      set{orderType_ACL= (orderType_ACL== 'DESC')? 'ASC' : 'DESC';
      }
    }
    public String orderByField_AAL{get;set;}
    public String orderType_AAL{
       get{return orderType_AAL;}
      set{orderType_AAL= (orderType_AAL== 'DESC')? 'ASC' : 'DESC';
      }
    }
    
    public String orderType{
       get{return orderType;}
      set{orderType= (orderType== 'DESC')? 'ASC' : 'DESC';
      }
   }
   public String orderByField_SC{get;set;}
    public String orderType_SC{
       get{return orderType_SC;}
      set{orderType_SC= (orderType_SC== 'DESC')? 'ASC' : 'DESC';
      }
    }
   /**   
        * @description: Constructor of class, it fetchs the profile of user. If profile is Wipro Community or Ecobee Community
                        then Create Case Button is not visible, also it call for methods which displays Open Cases,Support Request List,
                         Account Case List of the user as well as, displays All Account Case List in user Interface.  
                *
                ***/
    
    public CCC_ViewCaseController(){
    

        currentUserProfile = [select id, name from Profile  where Id=: UserInfo.getProfileId()];
        
              
        
        
        
        
        orderType='DESC';
        orderByField ='CaseNumber'; 
        orderType_MSR ='DESC';
        orderByField_MSR='CaseNumber';
        orderType_ACL='DESC';
        orderByField_ACL='CaseNumber';
        orderType_AAL='DESC';
        orderByField_AAL='CaseNumber';
        orderType_SC='DESC';
        orderByField_SC='CaseNumber';
        
         // check if user if Wipro & Ecobee user then hide Create Case Button
        if(currentUserProfile.Name == 'Wipro Community' || currentUserProfile.Name == 'Ecobee Community' ){
               isShowCreateCaseButton = false;
               isShowMySupportCasesTab =false;
               isShowMyCompanyCasesTab=false;
               isShowMySharedCasesTab=false;
               displayMyOpenCases();
               
        }else{
            isShowCreateCaseButton = true;
            isShowMySupportCasesTab =true;
            isShowMyCompanyCasesTab=true;
            isShowMySharedCasesTab=true;
            displayMyOpenCases();
        displayMySupportRequestList();
        //displayMyAccountCaseList();
        displayAllAccountCaseList();
            displaySharedCaseList();
        }
        
        
            }
            
            
            
 //-------------------------------------------------------------------------------------------
 
  public void beginning(){
   
        casesToShow.clear();
        counter=0;
        if((counter + limitSize) <= totalSize){
       
            for(Integer i=0;i<limitSize;i++){
                casesToShow.add(AllCases.get(i));
            }   
           
        } else{
       
            for(Integer i=0;i<totalSize;i++){
                casesToShow.add(AllCases.get(i));
            }       
           
        }
       
    }
    
    public void beginningCSBM(){
   
        submittedByMeCasesToShow.clear();
        counter1=0;
        if((counter1 + limitSize1) <= totalSize1){
       
            for(Integer i=0;i<limitSize1;i++){
                submittedByMeCasesToShow.add(AllCasesSubmittedByMe.get(i));
            }   
           
        } else{
       
            for(Integer i=0;i<totalSize1;i++){
                submittedByMeCasesToShow.add(AllCasesSubmittedByMe.get(i));
            }       
           
        }
       
    }
    
     public void beginningACC(){
   
        allCompanyCasesToShow.clear();
        counter2=0;
        if((counter2 + limitSize2) <= totalSize2){
       
            for(Integer i=0;i<limitSize2;i++){
                allCompanyCasesToShow.add(AllCompanyCases.get(i));
            }   
           
        } else{
       
            for(Integer i=0;i<totalSize2;i++){
                allCompanyCasesToShow.add(AllCompanyCases.get(i));
            }       
           
        }
       
    }
     public void beginningSC(){
   
        allSharedCasesToShow.clear();
        counter3=0;
        if((counter3 + limitSize3) <= totalSize3){
       
            for(Integer i=0;i<limitSize3;i++){
                allSharedCasesToShow.add(AllSharedCases.get(i));
            }   
           
        } else{
       
            for(Integer i=0;i<totalSize3;i++){
                allSharedCasesToShow.add(AllSharedCases.get(i));
            }       
           
        }
       
    }
   
    public void next(){
   
        casesToShow.clear();
        counter=counter+limitSize;
       
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+limitSize);i++){
                casesToShow.add(AllCases.get(i));
            }
        } else{
            for(Integer i=counter;i<totalSize;i++){
                casesToShow.add(AllCases.get(i));
            }
        }
    }
    
    public void nextCSBM(){
   
        submittedByMeCasesToShow.clear();
        counter1=counter1+limitSize1;
       
        if((counter1+limitSize1) <= totalSize1){
            for(Integer i=counter1-1;i<(counter1+limitSize1);i++){
                submittedByMeCasesToShow.add(AllCasesSubmittedByMe.get(i));
            }
        } else{
            for(Integer i=counter1;i<totalSize1;i++){
                submittedByMeCasesToShow.add(AllCasesSubmittedByMe.get(i));
            }
        }
    }
    
        public void nextACC(){
   
        allCompanyCasesToShow.clear();
        counter2=counter2+limitSize2;
       
        if((counter2+limitSize2) <= totalSize2){
            for(Integer i=counter2-1;i<(counter2+limitSize2);i++){
                allCompanyCasesToShow.add(AllCompanyCases.get(i));
            }
        } else{
            for(Integer i=counter2;i<totalSize2;i++){
                allCompanyCasesToShow.add(AllCompanyCases.get(i));
            }
        }
    }
    public void nextSC(){
   
        allSharedCasesToShow.clear();
        counter3=counter3+limitSize3;
       
        if((counter3+limitSize3) <= totalSize3){
            for(Integer i=counter3-1;i<(counter3+limitSize3);i++){
                allSharedCasesToShow.add(AllSharedCases.get(i));
            }
        } else{
            for(Integer i=counter3;i<totalSize3;i++){
                allSharedCasesToShow.add(AllSharedCases.get(i));
            }
        }
    }
      
    public void previous(){
   
        casesToShow.clear();

        counter=counter-limitSize;       
       
        for(Integer i=counter;i<(counter+limitSize); i++){
            casesToShow.add(AllCases.get(i));
        }
    }


    public void previousCSBM(){
   
        submittedByMeCasesToShow.clear();

        counter1=counter1-limitSize1;       
       
        for(Integer i=counter1;i<(counter1+limitSize1); i++){
            submittedByMeCasesToShow.add(AllCasesSubmittedByMe.get(i));
        }
    }
    
     public void previousACC(){
   
        allCompanyCasesToShow.clear();

        counter2=counter2-limitSize2;       
       
        for(Integer i=counter2;i<(counter2+limitSize2); i++){
            allCompanyCasesToShow.add(AllCompanyCases.get(i));
        }
    }
    public void previousSC(){
   
        allSharedCasesToShow.clear();

        counter3=counter3-limitSize3;       
       
        for(Integer i=counter3;i<(counter3+limitSize3); i++){
            allSharedCasesToShow.add(AllSharedCases.get(i));
        }
    }
        
    public void last (){
   
        casesToShow.clear();
       
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        } else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
       
        for(Integer i=counter-1;i<totalSize-1;i++){
                casesToShow.add(AllCases.get(i));
        }
       
    }
    
    public void lastCSBM (){
   
        submittedByMeCasesToShow.clear();
       
        if(math.mod(totalSize1 , limitSize1) == 0){
            counter1 = limitSize1 * ((totalSize1/limitSize1)-1);
        } else if (math.mod(totalSize1 , limitSize1) != 0){
            counter1 = limitSize1 * ((totalSize1/limitSize1));
        }
       
        for(Integer i=counter1-1;i<totalSize1-1;i++){
                submittedByMeCasesToShow.add(AllCasesSubmittedByMe.get(i));
        }
       
    }
    
    public void lastACC (){
   
        allCompanyCasesToShow.clear();
       
        if(math.mod(totalSize2 , limitSize2) == 0){
            counter2 = limitSize2 * ((totalSize2/limitSize2)-1);
        } else if (math.mod(totalSize2 , limitSize2) != 0){
            counter2 = limitSize2 * ((totalSize2/limitSize2));
        }
       
        for(Integer i=counter2-1;i<totalSize2-1;i++){
                allCompanyCasesToShow.add(AllCompanyCases.get(i));
        }
       
    }
   public void lastSC (){
   
        allSharedCasesToShow.clear();
       
        if(math.mod(totalSize3 , limitSize3) == 0){
            counter3 = limitSize3 * ((totalSize3/limitSize3)-1);
        } else if (math.mod(totalSize3 , limitSize3) != 0){
            counter3 = limitSize3 * ((totalSize3/limitSize3));
        }
       
        for(Integer i=counter3-1;i<totalSize3-1;i++){
                allSharedCasesToShow.add(AllSharedCases.get(i));
        }
       
    }
    public Boolean getDisableNext(){
   
        if((counter + limitSize) >= totalSize )
            return true ;
        else
            return false ;
    }
   public Boolean getDisableNextCSBM(){
   
        if((counter1 + limitSize1) >= totalSize1 )
            return true ;
        else
            return false ;
    }
    public Boolean getDisableNextACC(){
   
        if((counter2 + limitSize2) >= totalSize2 )
            return true ;
        else
            return false ;
    }
    public Boolean getDisableNextSC(){
   
        if((counter3 + limitSize3) >= totalSize3 )
            return true ;
        else
            return false ;
    }
    public Boolean getDisablePrevious(){
   
        if(counter == 0)
            return true ;
        else
            return false ;
    } 
    
    public Boolean getDisablePreviousCSBM(){
   
        if(counter1 == 0)
            return true ;
        else
            return false ;
    } 
    
    public Boolean getDisablePreviousACC(){
   
        if(counter2 == 0)
            return true ;
        else
            return false ;
    } 
    public Boolean getDisablePreviousSC(){
   
        if(counter3 == 0)
            return true ;
        else
            return false ;
    } 
    
    
  //  ------------------------------------------------------------------------------------------------------------           
    
    
    /**
                
                * @description: display all Open Cases, Support Request List, Account Case List of user as well as 
                                 All Account Case List in User Interface  according to the Order Selected by the user.
                *              
                *
                ***/
    public void getSortedListToDisplay(){
      orderType= (orderType== 'DESC')? 'ASC' : 'DESC';
      orderType_MSR= (orderType_MSR== 'DESC')? 'ASC' : 'DESC';
      orderType_ACL= (orderType_ACL== 'DESC')? 'ASC' : 'DESC';
      orderType_AAL= (orderType_AAL== 'DESC')? 'ASC' : 'DESC';
      orderType_SC= (orderType_SC== 'DESC')? 'ASC' : 'DESC';
      //beginning();
     displayMyOpenCases();
      displayMySupportRequestList();
     // displayMyAccountCaseList();
      displayAllAccountCaseList();
        displaySharedCaseList();
       
    }
    /**
     * This method will fetch all open cases of currently logged in user
     * @Developer : Amitkumar Joshi
     **/
    public void displayMyOpenCases(){
       //Commented Status='Closed' condition to meet the requirement of DEF0000398 on 06/13/2016 by Sudheer Reddy
       //Removed the condition from DSM, Warranty Admin and DSM/Warranty Admin Query.
       
              
       // Below code is to check the logged in user profile.
       if(currentUserProfile.Name == 'Wipro Community'){
         String query= 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name, IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate,Dealer_Account_Number__c,Completed__c,Distributor_Customer__c FROM Case  where Owner.name='+ '\''+ 'Wipro Queue' + '\'' +' and status!='+ '\''+ Status+ '\''+' ORDER BY'+' '+ orderByField+' ' + orderType +' '+ size ;
            myOpenCaseList =  Database.query(query); 
       }
       else if(currentUserProfile.Name == 'Ecobee Community' ){
       String query= 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name, IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate,Dealer_Account_Number__c,Completed__c,Distributor_Customer__c FROM Case  where Owner.name='+ '\''+ 'Ecobee Queue' + '\'' +' and status!='+ '\''+ Status+ '\''+' ORDER BY'+' '+ orderByField+' ' + orderType +' '+ size  ;
            myOpenCaseList =  Database.query(query); 
       }
        else
        {
            casesToShow = new list<Case>();
        
        //Get all the contacts which are from Public realations lead source
        //AllCases = [select id , name from contact];
         String query= 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name, IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate,Dealer_Account_Number__c,Completed__c,Distributor_Customer__c FROM Case  where ownerId='+ '\''+ UserId + '\'' +' ORDER BY'+' '+ orderByField+' ' + orderType ;
            AllCases=  Database.query(query);
        //Store the total size
        totalSize = AllCases.size();
        
        //Intial adding of contacts to casesToShow
        //check the total records are more than limitSize and assign the records
        if((counter+limitSize) <= totalSize){
            for(Integer i=0;i<limitSize;i++){
                casesToShow.add(AllCases.get(i));
            }
        }else{
            for(Integer i=0;i<totalSize;i++){
                casesToShow.add(AllCases.get(i));
            }
        }      
        }
        
       
    }
    
    /**
     * This method will fetch all support cases logged by current user
     * @Developer : Amitkumar Joshi
     **/
    public void displayMySupportRequestList(){
    //String LIMIT='LIMIT 10';
        
       
              
        
        
                    submittedByMeCasesToShow = new list<Case>();
        
         // Using status filter will fetch only closed status.As per requirement D-01030,status filter is removed. 
       // String query = 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name,IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,createdById,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate FROM Case where createdById ='+'\''+UserId +'\''+' and status !='+ '\''+ Status+ '\''+' ORDER BY'+' '+ orderByField_MSR+' ' + orderType_MSR+' '+size;
         String query = 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name,IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,createdById,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate,Dealer_Account_Number__c,Completed__c,Distributor_Customer__c FROM Case where createdById ='+'\''+UserId +'\''+' ORDER BY'+' '+ orderByField_MSR+' ' + orderType_MSR+' '+size;
            AllCasesSubmittedByMe =  Database.query(query);
           // mySupportRequestList = Database.query(query);
        //Store the total size
        totalSize1 = AllCasesSubmittedByMe.size();
        
        //Intial adding of contacts to casesToShow
        //check the total records are more than limitSize and assign the records
        if((counter1+limitSize1) <= totalSize1){
            for(Integer i=0;i<limitSize1;i++){
                submittedByMeCasesToShow.add(AllCasesSubmittedByMe.get(i));
            }
        }else{
            for(Integer i=0;i<totalSize1;i++){
                submittedByMeCasesToShow.add(AllCasesSubmittedByMe.get(i));
            }
        }
        
    }
    
        
    /**
     * This method will fetch all cases belongs to the parent and child account
     * of currently logged in user.
     * @Developer : Amitkumar Joshi
     **/
    public void displayAllAccountCaseList(){
    
        Set<String> accountList = new Set<String>();
        List<String> accountListQuery = new List<String>();
        List<Case> cases = new List <Case>();
        Set<id> userIdlist = new Set<id>();
        Set<id>accontIds=new Set<Id>();
        //Creating a set of Contact Ids that fetches list of Contact of the account that is fetched in accontIds Set.
        Set<id>contactIds=new Set<Id>();
        Set<id>contactMapIDs=new Set<Id>();
        //Creating a List of Users who has same contact ids as in contactIds set.
        Set<id>userId=new Set<id>();
        List<User> currentUserList = [select contact.AccountId from User where Id=:UserInfo.getUserId()];
        
          
            for(case c:cases){
                 
                 //Adding Case's Account in  accontIds set.
                 accontIds.add(c.accountid);
             }
             
                     //Using Map query saves CPU time

                    //Fetching all contacts in map

                    Map<id,contact> cMap = new Map<id,contact>([select id from contact where accountid in:accontIds]);


            //Creating set of ids

                contactIds= cMap.keySet() ;
             
              //for loop starts.
              // It Fetches map of Users who has same contact ids as in contactIds set.
              
               Map<id,User> cMapUser = new Map<id,User>([select id from user where contactid in:contactIds]);
               
                //Creating set of ids

                userId= cMapUser.keySet() ;
             
            if(currentUserList.size()>0){
                accountListQuery.add(currentUserList[0].contact.AccountId);
            }
            
            
            accountList=new CCC_UserTriggerHelper().CreateHierarchy(accountListQuery);
           if(accountList.size()>0){
           
           Map<id,contact> cMapCont = new Map<id,contact>([select Id from Contact where accountId IN :accountList]);


            //Creating set of ids

             contactMapIDs = cMapCont .keySet() ;
             Map<id,User> cMapUser2 = new Map<id,User>([select Id from User where contactId IN :contactMapIDs]);
             
             userIdlist= cMapUser2.keySet() ;
              userIdlist.addAll(userId);
           } 
           
          List<User> uList = [select Id, contact.AccountId ,contactid from User where Id IN :userIdlist and IsActive=True];
            //creating a list og account that will fetch Account list from the list of users in above user list uList
            List<String> accLst = new List <String>();
            //for loop starts.
            for(User u : uList){
                /* Checks if user has Account , i.e user is a community user that had contact and Account Associated with it.
                 If yes , it Adds corresponding Accounts to accLst*/
                if(u.contact.AccountId!=null){
                accLst.add(u.contact.AccountId);
                }
            }
            
            /* Fetch all accounts in heirarchy from the Account of user passed */
             Set<String> accountIdSet = new Set<String>();
            if(accLst.size()>0){
                accountIdSet = new CCC_UserTriggerHelper().CreateHierarchy(accLst );
            }
           String Status ='Closed';
          
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            setRecordTypeIds.add(rtMapByName.get('Warranty').getRecordTypeId());
            setRecordTypeIds.add(rtMapByName.get('Consumer Relations').getRecordTypeId());
            setRecordTypeIds.add(rtMapByName.get('Post Sale Support').getRecordTypeId());
           
          if(accountList.size()>0){
          
          
          allCompanyCasesToShow = new list<Case>();
        
        //Get all the contacts which are from Public realations lead source
        //AllCases = [select id , name from contact];
              String query = 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c, ClosedDate,Account.Name,IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,RecordTypeId ,CreatedDate,Dealer_Account_Number__c,Completed__c,Distributor_Customer__c FROM Case WHERE RecordTypeId IN :setRecordTypeIds AND Status!='+ '\''+ Status + '\'' +' AND (AccountId IN :accountIdSet OR (Owner.Id IN :userIdlist OR CreatedById IN:userIdlist)) ORDER BY'+' '+ orderByField_AAL+' ' + orderType_AAL; 
              AllCompanyCases = Database.query(query);
        //Store the total size
        totalSize2 = AllCompanyCases.size();
        
        //Intial adding of contacts to casesToShow
        //check the total records are more than limitSize and assign the records
        if((counter2+limitSize2) <= totalSize2){
            for(Integer i=0;i<limitSize2;i++){
                allCompanyCasesToShow.add(AllCompanyCases.get(i));
            }
        }else{
            for(Integer i=0;i<totalSize2;i++){
                allCompanyCasesToShow.add(AllCompanyCases.get(i));
            }
        }     
          
          
          
          
          
             
             


             
                       }
    }
    public void displaySharedCaseList(){
        allSharedCasesToShow = new list<Case>();
        Boolean SharedStatus = true;
         // Using status filter will fetch only closed status.As per requirement D-01030,status filter is removed. 
       // String query = 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name,IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,createdById,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate FROM Case where createdById ='+'\''+UserId +'\''+' and status !='+ '\''+ Status+ '\''+' ORDER BY'+' '+ orderByField_MSR+' ' + orderType_MSR+' '+size;
        //String query = 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name,IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,createdById,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate,Dealer_Account_Number__c,Completed__c,Approved_for_Sharing__c FROM Case where RecordType.Name ='+'\''+ 'Post Sale Support' +'\' '+' and Approved_for_Sharing__c ='+ SharedStatus +' ORDER BY'+' '+ orderByField_SC+' ' + orderType_SC+' '+size;  
        String query = 'SELECT Id,Case.CaseNumber FROM CaseShare where UserOrGroupId=\'00G1500000424rhEAA\' and Case.RecordType.Name=\'Post Sale Support\'';  
		System.debug('#Case Share Query:'+query);
        List<CaseShare> allCaseShareRecords = new List<CaseShare>();
        allCaseShareRecords =  Database.query(query);
        List<String> caseNumbers = new List<String>();
        for(CaseShare eachCaseShare : allCaseShareRecords){
            caseNumbers.add(eachCaseShare.Case.CaseNumber);            
        }
        String recordTypeName = 'Post Sale Support';
        String inClauseStrCaseNumbers = '';
        inClauseStrCaseNumbers = buildInClauseCaseNumbersQueries(caseNumbers);
        String caseQuery = 'SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name,IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,createdById,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate,Dealer_Account_Number__c,Completed__c,Approved_for_Sharing__c FROM Case where CaseNumber IN ('+inClauseStrCaseNumbers+') and RecordType.Name ='+'\''+ 'Post Sale Support'+'\'' +' ORDER BY'+' '+ orderByField_SC+' ' + orderType_SC+' '+size;
        //AllSharedCases = [SELECT CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name,IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,createdById,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate,Dealer_Account_Number__c,Completed__c,Approved_for_Sharing__c FROM Case where RecordType.Name =:recordTypeName and CaseNumber in :caseNumbers];
        System.debug('#Case Query:'+caseQuery);
        AllSharedCases = Database.query(caseQuery);
           // mySupportRequestList = Database.query(query);
        //Store the total size
        totalSize3 = AllSharedCases.size();
        
        //Intial adding of contacts to casesToShow
        //check the total records are more than limitSize and assign the records
        if((counter3+limitSize3) <= totalSize3){
            for(Integer i=0;i<limitSize3;i++){
                allSharedCasesToShow.add(AllSharedCases.get(i));
            }
        }else{
            for(Integer i=0;i<totalSize3;i++){
                allSharedCasesToShow.add(AllSharedCases.get(i));
            }
        }
        
    }
    public String buildInClauseCaseNumbersQueries(List<String> caseNumbers){
        String queryToReturn = '';
        if(caseNumbers!=null && caseNumbers.size()>0){
            for(String eachCaseNumber : caseNumbers){
                queryToReturn = queryToReturn +'\''+ eachCaseNumber+'\',';
            }
        }
        if(queryToReturn.endsWith(',')){
            queryToReturn = queryToReturn.substring(0, queryToReturn.length()-1);
        }
        return queryToReturn;
    }
   
}