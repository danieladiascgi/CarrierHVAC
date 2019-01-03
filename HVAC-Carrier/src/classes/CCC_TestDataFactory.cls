/**
* @ Developer : 
* @date_created : 13/01/2016
* @functions : Detail description
* @Date Modified : <3/14/2016> Reason:Remove unwanted commented code and debug statements and Add Class, method and statement level comments, verify all methods Developer :Ankita Rambole

*
*
***/

@isTest
Public class CCC_TestDataFactory  {

	private static testMethod void test() {

	}

 public static sObject sObj;
 
     /**
                * @returns: Standard object inserted as parameter
                * @parameters: Standard Object
                * @description : it will create and insert respective Standard Object
                *
                *
                ***/
 public  sObject createTestRecord(sObject sObjLocal){       
    insert sObjLocal;
    return sObjLocal;
}


  /**
                * @returns: list of Standard object inserted as parameter
                * @parameters: Standard Object, total no. of standard object to be created & inserted
                * @description : it will create respective Standard Object list
                *
                *
                ***/

    /* Prepare list of records */
    public  List<sObject> setupMultiRecords(sObject sObjLocal, Integer noOfRecords){
               
        List<sObject> sObjList = new List<sObject>();  
        for(integer i=0; i < noOfRecords; i++){
             sObjList.add(setUpData(sObjLocal) );   
        }   
                
     return sObjList; 
   }  
  /**
                * @returns: List of Standard Objects
                * @parameters: List of Standard Object
                * @description : insert respective Standard Object
                *
                *
                ***/

    /* Insert list of sObjects */
    public List<sObject> insertMultiRecords(List<sObject> sObjList) {
            if(sObjList != null)
            {
                insert sObjList;
            }
            return sObjList;
    }  

    /**
                * @returns: User
                * @parameters: profileName
                * @description : Get a User of profile inserted as parameter,if not present create new user of given profile
                *                and then insert .
                *
                *
                ***/

/* Get User from Salesforce or Create a User */
    public User getUser(String profileName){ 
                 
                User user1 =  new User(); 
                if(profileName == 'System Administrator'){//for System Administrator profile
                    user1 = [SELECT Id,Name,Email,username,profileId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1]; 
                } else if (profileName.contains('') || profileName.contains('')){
                    User sysUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
                     
                     List<Profile> p = [SELECT Id, name FROM Profile WHERE Name=: profileName limit 1];  
                    
                     if(p != null && p.size()>0){
                         user1 = new User(Alias = 'newUser', Email='newuser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p[0].Id, 
                            TimeZoneSidKey='America/Los_Angeles',IsActive= true, UserName='newuser_UTC'+System.now().millisecond()+(Integer)Math.random()*100+'@testorg.com');
                             
                             system.runAs(sysUser) { 
                                insert user1;
                                
                               user1 =  [SELECT Id,Name,userName,Email,ProfileId,Alias FROM User where id=: user1.Id];
                            } 
                     }
                     else{
                          user1=  null;
                     }
                }
                
                
                
                return user1;
      } 
      
    /**
                * @returns: recordtype
                * @parameters: RecordType and Standard Object
                * @description : Fetch the Standard Object with the record type given in parameter
                *
                *
                ***/
    
      /*GetrecordtypeId : Method Fetching Record type id based on Recordtype Name and Sobject*/
    public recordtype GetrecordtypeId(String Recordtypename,String SobjectType){
        RecordType rt;
        if(Recordtypename!='' && SobjectType !=''){
            rt = [select Id from RecordType where Name =:Recordtypename AND IsActive = TRUE AND SobjectType =: SobjectType]; 
        }
        return rt;
    } 
       /**
                * @returns: Standard Object
                * @parameters: Standard Object
                * @description : Create Standard object in parameter and then insert it
                *
                *
                ***/
     public sObject setUpData(sObject tempSObj){
                String sObjName = tempSObj.getSObjectType().getDescribe().getName();
                If(sObjName.contains('__c')){//if object is custom object 
                    string[] divName = sObjName.split('__');
                    if(divName.size() >= 2)
                    {
                        sObjName = divName[divName.size()-2] + '__' + divName[divName.size()-1];
                    }  
                }
                if(sObjName.equalsIgnoreCase('Account')){// if given parameter is of Account Type,create new Account
                        Account accountObj = new Account();
                        accountObj.Name ='TestAccount';
                        accountObj.BillingCountry ='USA';
                        accountObj.RecordTypeID=GetrecordtypeId('Partner','Account').id;
                        accountObj.Type='Distributor';
                        sObj = accountObj;  
                }
               
               if(sObjName.equalsIgnoreCase('Contact')){// if given parameter is of Contact Type, create new contact
                        Contact contactobj = new Contact();
                        contactobj.AccountId=( (Account)createTestRecord(setUpData(new Account())) ).Id;
                        contactobj.RecordTypeID=GetrecordtypeId('Residential Contact','Contact').id;
                        contactobj.LastName='TestLastName';
                        sObj = contactobj;  
               }    
               
               if(sObjName.equalsIgnoreCase('Case')){// if given parameter is of Case Type,create new Case
                        Case caseobj = new Case();
                        caseobj.AccountId=( (Account)createTestRecord(setUpData(new Account())) ).Id;
                        caseobj.ContactId=( (Contact)createTestRecord(setUpData(new Contact())) ).Id;
                        caseobj.Origin='Phone';
                        caseobj.Status='In Progress';
                        caseobj.RecordTypeID=GetrecordtypeId('Consumer Relations','Case').id;
                        sObj = caseobj;  
               }    
               
               if(sObjName.equalsIgnoreCase('Product2')){// if given parameter is of Product2 Type,create new Product2
                        Product2 prodObj= new Product2();
                        prodObj.ProductCode='3333';
                        prodObj.Description='ProductDescription';
                        prodObj.Name='ProductTest';
                        prodObj.CCC_Vendor_Code__c='VendorTestcode';
                        sObj = prodObj;  
               }    
               
               else if('CCC_Suggested_Dealers__c'.equalsIgnoreCase(sObjName)){   // if given parameter is of CCC_Suggested_Dealers__c Type,create new CCC_Suggested_Dealers__c
                    CCC_Suggested_Dealers__c sugg = new CCC_Suggested_Dealers__c();
                        sugg.Name = 'TestDealer';
                        sugg.CCC_Case__c=setUpData(new Case()).id;
                        sObj = sugg;
                        
               }

                return sObj;
            } 

}