@isTest
public class ResolutionFetchTest  {
    public static Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
     public static Id recordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
    public static Id recordTypeId2 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
    public static Id recordTypeId3 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Post Sale Support').getRecordTypeId();
    public static String s;
    public static Map<String, Picklists_Control__c> purposePicklistForEquipment;
    public static Map<String, Picklists_Control__c> subPurposePicklistForEquipment;
    public static Map<String, List<String>> contrlKeyLstOfDepend;
    public static List<Case> lstCase;
    public static List<Purpose__c> lstResCount;
    public static String Count;
    public static List<Turnback__c> lstTurnback;
    public static List<Picklists_Control__c> statusList;
    
 //   public static String CCC_Defect_Code__c;
  //  public static String CCC_Defect_Sub_Code__c;
    
    public static testmethod void startTest(){
        //Set up user
       // User u1 = [SELECT Id FROM User WHERE Alias='mr' limit 1];
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
  
  
        User u1=new User( email='test.user1812171@gmail.com',
                profileid = testprof1.id,  
                UserName='test1812171.user@gmail.com', 
                Alias = 'GDS',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                //ContactId = testCon1.id,
                //PortalRole = 'Manager',
                FirstName = 'test1812171',
                LastName = 'user1812171');
         
                insert u1;
        
        System.runAs(u1){
            Case rcCase = new Case();
            rcCase.RecordTypeId = recordTypeId;
            insert rcCase;
            Case rcCase1 = new Case();
            rcCase1.RecordTypeId = recordTypeId1;
            insert rcCase1;
             Case rcCase2 = new Case();
            rcCase2.RecordTypeId = recordTypeId2;
            insert rcCase2;
             Case rcCase3 = new Case();
            rcCase3.CCC_Solution__c ='test';
            rcCase3.RecordTypeId = recordTypeId3;
            insert rcCase3;
            Purpose__c p = new Purpose__c();
            p.Count__c=23;
            p.Case__c=rcCase.Id;
            insert p;
            
             List<Picklists_Control__c> reasonList = new List<Picklists_Control__c>();
         test.startTest();
           
           ResolutionFetch.getPurposeCount(rcCase.id);
           ResolutionFetch.getRecordType(rcCase.id);
           ResolutionFetch.getCase(rcCase.id);
           ResolutionFetch.getStatus(rcCase.id);
           ResolutionFetch.getClaimCases(rcCase.id);
           ResolutionFetch.saveCase(rcCase,'Not Applicable','Dealer Error','Hold','Air Filter','Other' );
           ResolutionFetch.saveCaseClose(rcCase,'Not Applicable','Dealer Error','Air Filter','Other' );
           ResolutionFetch.getDependentOptionsImpl('test','test', 'test');
            createTurnbacks('Replacement Component', true);
            createTurnbacks2('Equipment');
             createTurnbacks3('Channel');
             createTurnbacks4('Post Sale Support','test');
            
           ResolutionFetch.getTurnback(rcCase.id);
            ResolutionFetch.getTurnback(rcCase1.id);
            ResolutionFetch.getTurnback(rcCase2.id);
            ResolutionFetch.getTurnback(rcCase3.id);
            
            createResolution('Replacement Component');
            createResolution1('Equipment');
           
            createResolution2('Channel');
            
            ResolutionFetch.getResolutionCode(rcCase.id);
            ResolutionFetch.getResolutionCode(rcCase1.id);
            ResolutionFetch.getResolutionCode(rcCase2.id);
            // ResolutionFetch.getResolutionCode(rcCase3.id);
            

       test.stopTest();             
            
            
         
        }
        
    }
    
    public static void createTurnbacks(String recordType, Boolean isICP){
        Turnback__c tb = new Turnback__c();
        tb.Title__c = 'Testing Please Ignore';
        tb.Is_ICP__c = isICP;
        tb.Status__c = 'Open';
        if(recordType!=null && recordType.length()>0 && recordType=='Replacement Component'){
            tb.Replacement_Component_RC__c = true;
        }
        insert tb;
    }
         
        public static void createTurnbacks2(String recordType){
        Turnback__c tb = new Turnback__c();
        tb.Title__c = 'Testing Please Ignore';
        tb.Status__c = 'Open';
        if(recordType!=null && recordType.length()>0 && recordType=='Equipment'){
            tb.Equipment__c = true;
        }
        insert tb;
        
       }
     public static void createTurnbacks3(String recordType){
        Turnback__c tb = new Turnback__c();
        tb.Title__c = 'Testing Please Ignore';
        tb.Status__c = 'Open';
        if(recordType!=null && recordType.length()>0 && recordType=='Channel'){
            tb.Channel__c = true;
        }
        insert tb;
        
       }
     public static void createTurnbacks4(String recordType, String Solution){
        Turnback__c tb = new Turnback__c();
        tb.Title__c = 'Testing Please Ignore';
        tb.Status__c = 'Open';
        if(recordType!=null && recordType.length()>0 && recordType=='Post Sale Support'){
            tb.Post_Sale_Support__c = true;
        }
        insert tb;
        
       }
    public static void createResolution(String recordType){
        Picklists_Control__c pc = new Picklists_Control__c();
        pc.Picklist_Field_Value__c= 'Testing Please Ignore';
        pc.Name='1500';
       if(recordType!=null && recordType.length()>0 && recordType=='Equipment'){
            pc.Picklist_Field_Name__c = 'Reason';
            pc.Record_Type__c ='CCC_Replacement_Component';
        }
        insert pc;
    }
    public static void createResolution1(String recordType){
        Picklists_Control__c pc = new Picklists_Control__c();
        pc.Picklist_Field_Value__c= 'Testing Please Ignore';
        pc.Name='1045';
       if(recordType!=null && recordType.length()>0 && recordType=='Post Sale Support'){
            pc.Picklist_Field_Name__c = 'Reason';
           pc.Record_Type__c ='Equipment';
        }
        insert pc;
    }
    public static void createResolution2(String recordType){
        Picklists_Control__c pc = new Picklists_Control__c();
        pc.Picklist_Field_Value__c= 'Testing Please Ignore';
        pc.Name='1067';
       if(recordType!=null && recordType.length()>0 && recordType=='Channel'){
            pc.Picklist_Field_Name__c = 'Reason';
           pc.Record_Type__c ='CCC_Channel';
        }
        insert pc;
    }

}