@isTest
public class EquipmentPurposeCtrlTest {
    public static User u1;
    public static Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Replacement Component (RC)').getRecordTypeId();
    public static Id recordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Equipment').getRecordTypeId();
    //public static List<wrapClass> lstVal;
    public static Map<String, Purpose__c> countMap;
    public static List<Purpose__c> countList;
    public static List<String> setPGs;
   
    public static testmethod void StartTest()
     {
         test.startTest();
         
         Profile testprof1=[SELECT Id FROM Profile WHERE Name='CCC Base Profile' limit 1];
        // User u1 = [SELECT Id FROM User WHERE Alias='mr' limit 1];
            u1=new User( email='testdealer.user2712172@gmail.com',
            profileid = testprof1.id,  
            UserName='test2712172.user@gmail.com', 
            Alias = 'GDS',
            TimeZoneSidKey='America/New_York',
            EmailEncodingKey='ISO-8859-1',
            LocaleSidKey='en_US', 
            LanguageLocaleKey='en_US',
            //ContactId = testCon1.id,
            PortalRole = 'Manager',
            FirstName = 'test2712172',
            LastName = 'user2712172');
 
            insert u1;
         
         System.runAs(u1){
         Case rcCase = new Case();
         rcCase.RecordTypeId = recordTypeId;
         insert rcCase;
         Case rcCase1 = new Case();
         rcCase1.RecordTypeId = recordTypeId1;
         
         String lstOfPurpStr = '[{"test":"123","test1":"12454"}]';
         insert rcCase1;
             
		 Picklists_Control__c pklc = new Picklists_Control__c(Name='123',Picklist_Field_Value__c='Pricing',Record_Type__c='Equipment',Picklist_Field_Name__c='Multiple Purpose',Controlling_Field_Value__c='test', Order__c='0'); 
         insert pklc;
        // Picklists_Control__c pickTemp = [SELECT Id,Order__c,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= :recordTypeId1 and Picklist_Field_Name__c='Multiple Purpose' and Controlling_Field_Value__c= 'test' order by Order__c asc];    
           // System.debug('#pickTemp:'+pickTemp);
         Purpose__c purp = new Purpose__c(Name='313', Count__c=34345, case__c=rcCase.Id); 
         insert purp;
             
         Purpose__c purpeq = new Purpose__c(Name='313', Count__c=34345, case__c=rcCase1.Id); 
         insert purpeq;
           
         EquipmentPurposeCtrl.wrapClass wrp = new EquipmentPurposeCtrl.wrapClass();
    	 wrp.count = 123;
         wrp.purpose = 'test';
         List<EquipmentPurposeCtrl.wrapClass> listwrp = new List<EquipmentPurposeCtrl.wrapClass>();
         listwrp.add(wrp);
         EquipmentPurposeCtrl.lstVal=listwrp;
             
         EquipmentPurposeCtrl.getPGs(rcCase1.Id);  
         pklc.Record_Type__c='Equipment';
         update pklc;
         EquipmentPurposeCtrl.getPurposes(rcCase.Id, 'test');
         EquipmentPurposeCtrl.getPurposes(rcCase1.Id, 'test');
         pklc.Picklist_Field_Name__c='Multiple Purpose';
         update pklc;
         EquipmentPurposeCtrl.getPurposes(rcCase.Id, 'test');
         EquipmentPurposeCtrl.getPurposes(rcCase1.Id, 'test');
         EquipmentPurposeCtrl.getPurposes(rcCase.Id, '');
         EquipmentPurposeCtrl.getPurposes(rcCase1.Id, '');
         EquipmentPurposeCtrl.updateClaim(rcCase.Id);
         EquipmentPurposeCtrl.updateClaim(rcCase1.Id);
         EquipmentPurposeCtrl.savePurpose(lstOfPurpStr,rcCase.Id);
         purp.count__c= null;
         update purp;
     //    EquipmentPurposeCtrl.savePurpose(lstOfPurpStr,rcCase.Id);
       
         test.stopTest();
     }

}
}