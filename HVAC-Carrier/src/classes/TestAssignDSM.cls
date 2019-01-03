@isTest(SeeAllData=true)
public class TestAssignDSM {
    
    public static testMethod void testUSACase(){
        Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(usaCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaONCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaONPHONESixOneThreeCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
        canadaContactOntario.Phone = '613.987.3234';
        update canadaContactOntario;
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaONPHONEFourOneSixCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
        canadaContactOntario.Phone = '416.987.3234';
        update canadaContactOntario;
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaNSCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='NS' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaNSNineOOFiveCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='NS' and MailingCountry = 'Canada' order by createddate desc limit 1];
		canadaContact.Phone = '905.987.3234';
        update canadaContact;
        System.debug('#canadaContact:'+canadaContact);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContact, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
	public static testMethod void testCanadaNSFiveOneNineCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='NS' and MailingCountry = 'Canada' order by createddate desc limit 1];
		canadaContact.Phone = '519.987.3234';
        update canadaContact;
        System.debug('#canadaContact:'+canadaContact);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContact, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaONSixOneThreeCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
		canadaContact.Phone = '613.987.3234';
        update canadaContact;
        System.debug('#canadaContact:'+canadaContact);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContact, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
	public static testMethod void testCanadaONNineOOFiveCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
		canadaContact.Phone = '905.987.3234';
        update canadaContact;
        System.debug('#canadaContact:'+canadaContact);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContact, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
	public static testMethod void testCanadaNSEightOOSevenCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='NS' and MailingCountry = 'Canada' order by createddate desc limit 1];
		canadaContact.Phone = '807.987.3234';
        update canadaContact;
        System.debug('#canadaContact:'+canadaContact);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContact, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
	public static testMethod void testCanadaNSTwoFourSevenCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='NS' and MailingCountry = 'Canada' order by createddate desc limit 1];
		canadaContact.Phone = '247.987.3234';
        update canadaContact;
        System.debug('#canadaContact:'+canadaContact);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContact, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
	public static testMethod void testCanadaSixOneThreeCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='NS' and MailingCountry = 'Canada' order by createddate desc limit 1];
		canadaContact.Phone = '613.987.3234';
        update canadaContact;
        System.debug('#canadaContact:'+canadaContact);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContact, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaFourOneSixCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='NS' and MailingCountry = 'Canada' order by createddate desc limit 1];
		canadaContact.Phone = '416.987.3234';
        update canadaContact;
        System.debug('#canadaContact:'+canadaContact);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContact, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaQCCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='QC' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaSKCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='SK' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testCanadaBCCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='BC' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
	public static testMethod void testCanadaABCase(){
       Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='AB' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
        ApexPages.StandardController controller = new ApexPages.standardController(canCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  
        assigndsm.init();
        assigndsm.proceedWithAssignment();
    }
    public static testMethod void testUSACaseAsset(){
        Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
		Asset ast = new Asset();
         
          ast.Name='765435uyrertyjhtrhj';
          ast.Brand__c='Payne';
          ast.CCC_Disc_Model_Number__c='1234';
          ast.CCC_Model_Number__c='1234';
          ast.SerialNumber='1234';
          ast.CCC_Validation_status__c=true;
          ast.AccountId=resAcct.id;
      //  ast.ContactId=testCon1.id;
          insert ast;
          
          //create new CCC_junctionCaseAsset__c
          CCC_junctionCaseAsset__c junAsset2= new CCC_junctionCaseAsset__c();
          junAsset2.Asset__c= ast.id;
          junAsset2.Case__c=usaCse.id;
          insert junAsset2;
        ApexPages.StandardController controller = new ApexPages.standardController(usaCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  		
        assigndsm.init();
		assigndsm.getAllAssets();
        System.currentPageReference().getParameters().put('primaryAssetId', ast.id);
        assigndsm.getSelected();
		assigndsm.searchDSM();
        //assigndsm.proceedWithAssignment();
    }
    public static testMethod void testSelectedDSM(){
        Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
		DSM_Distributor_Directory__c directory = [Select Id from DSM_Distributor_Directory__c where State__c='NY' and Country__c='USA' and County_Name__c='Onondaga County' and Brand__c='Carrier' limit 1];
		
        ApexPages.StandardController controller = new ApexPages.standardController(usaCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  		
        assigndsm.init();
		assigndsm.getAllAssets();
        System.currentPageReference().getParameters().put('selectedDSMId', directory.id);
        assigndsm.getSelectedDSM();
        assigndsm.getSelectedDist();
		
    }
    public static testMethod void testDSMSearch(){
        Account resAcct = getResidentialAccount();
        System.debug('#resAcct:'+resAcct);
        Contact usContact = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where Is_Address_Verified__c=true and MailingCountry = 'United States' order by createddate desc limit 1];
        System.debug('#usContact:'+usContact);
        Account canadaAcct = getCanadaResAccount();
        System.debug('#canadaAcct:'+canadaAcct);
        Contact canadaContactOntario = [Select Id,RecordTypeId,AccountId,FirstName, LastName,Email,Phone,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Enrichment_Payload__c from Contact where MailingState='ON' and MailingCountry = 'Canada' order by createddate desc limit 1];
        System.debug('#canadaContactOntario:'+canadaContactOntario);
        Case usaCse = getUSACase('USA Case 1', resAcct, usContact, 'Carrier');
        System.debug('#usaCse:'+usaCse);
        Case canCse = getUSACase('Canada Case 1', canadaAcct, canadaContactOntario, 'Carrier');
        System.debug('#canCse:'+canCse);
		DSM_Distributor_Directory__c directory = [Select Id from DSM_Distributor_Directory__c where State__c='NY' and Country__c='USA' and County_Name__c='Onondaga County' and Brand__c='Carrier' limit 1];
		List<DSM_Distributor_Directory__c> nyDsmsLst = [Select Id from DSM_Distributor_Directory__c where State__c='NY' ];
		Id [] fixedSearchResults= new Id[nyDsmsLst.size()];
        integer count = 0;
		for(DSM_Distributor_Directory__c eachDirectory : nyDsmsLst){
			fixedSearchResults[count] = eachDirectory.Id;  
			count = count+1;
		}
		Test.setFixedSearchResults(fixedSearchResults);
		
        ApexPages.StandardController controller = new ApexPages.standardController(usaCse);
        AssignDSMController assigndsm =new AssignDSMController(controller);  		
        assigndsm.init();
		assigndsm.searchDSMText = 'NY';
		assigndsm.searchDSM();
		
    }
    public static Account getResidentialAccount(){
        Account acctToRet =new Account();
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Residential Address' Limit 1];
        acctToRet.recordTypeId=rt.id;
        acctToRet.Name='Residential - 300 Deerfield Rd,East Syracuse,NY,United States 13057';
        acctToRet.BillingStreet = '300 Deerfield Rd';
        acctToRet.BillingCity = 'East Syracuse';
        acctToRet.BillingState = 'NY';
        acctToRet.BillingCountry = 'United States';
        acctToRet.BillingPostalCode='13057';
        insert acctToRet;
        return acctToRet;
    }
    public static Account getCanadaResAccount(){
        Account acctToRet =new Account();
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Residential Address' Limit 1];
        acctToRet.recordTypeId=rt.id;
        acctToRet.Name='Residential - 234 Wellington Street,Ottawa,Ontario,Canada K1A 0G9';
        acctToRet.BillingStreet = '234 Wellington Street';
        acctToRet.BillingCity = 'Ottawa';
        acctToRet.BillingState = 'ON';
        acctToRet.BillingCountry = 'Canada';
        acctToRet.BillingPostalCode='K1A 0G9';
        insert acctToRet;
        return acctToRet;
    }
    public static Contact getUSAContact(Account acct){
        Contact cont = new Contact();
        RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Residential Contact' Limit 1];
        cont.RecordTypeId = rt.Id;
        cont.AccountId = acct.Id;
        cont.FirstName = 'Tommy';
        cont.LastName = 'Hills';
        cont.Email = 'tommy.hills@usa.com';
        cont.Phone = '3158765432';
        cont.MobilePhone = '3158765432';
        cont.MailingStreet = '300 Deerfield Rd';
        cont.MailingCity = 'East Syracuse';
        cont.MailingState = 'NY';
        cont.MailingPostalCode = '13057';
        //cont.MailingCountry = 'USA';
        
        cont.Enrichment_Payload__c = '<SUPPLEMENTARY_US><Status>EUS1</Status><COUNTY_FIPS_CODE>067</COUNTY_FIPS_CODE><STATE_FIPS_CODE>36</STATE_FIPS_CODE><MSA_ID></MSA_ID><CBSA_ID>45060</CBSA_ID><FINANCE_NUMBER>352530</FINANCE_NUMBER><RECORD_TYPE>H</RECORD_TYPE><CMSA_ID></CMSA_ID><CENSUS_TRACT_NO>014500</CENSUS_TRACT_NO><CENSUS_BLOCK_NO>1058</CENSUS_BLOCK_NO><CENSUS_BLOCK_GROUP>1</CENSUS_BLOCK_GROUP><PMSA_ID></PMSA_ID><MCD_ID>20478</MCD_ID><PLACE_FIPS_CODE></PLACE_FIPS_CODE><TIME_ZONE_CODE>-5</TIME_ZONE_CODE><TIME_ZONE_NAME>EST</TIME_ZONE_NAME></SUPPLEMENTARY_US>';
        insert cont;
        return cont;
    }
    public static Contact getCanadaContact(Account acct){
        Contact cont = new Contact();
        cont.AccountId = acct.Id;
        cont.FirstName = 'Britney';
        cont.LastName = 'Spears';
        cont.Email = 'britney.spears@canada.com';
        cont.Phone = '6137828111';
        cont.MobilePhone = '6137828111';
        cont.MailingStreet = '234 Wellington Street';
        cont.MailingCity = 'Ottawa';
        cont.MailingState = 'Ontario';
        cont.MailingPostalCode = 'K1A 0G9';
        //cont.MailingCountry = 'Canada';
        insert cont;
        return cont;
    }
    public static Case getUSACase(String subject, Account acct, Contact cont, String brand){
        Case cseToret = new Case();
        cseToret.AccountId = acct.Id;
        cseToRet.ContactId = cont.Id;        
        cseToRet.Subject=subject;
        cseToRet.Origin='Email';
        cseToRet.Status='Open'; 
        cseToRet.CCC_Brand__c = brand;
        RecordType rt3= [select id,Name from RecordType where SobjectType='Case' and Name='Consumer Relations' Limit 1];
        cseToRet.recordTypeId=rt3.id;
        cseToRet.CCC_Brand__c='BRY';
        insert cseToRet;
        return cseToRet;
        
    }
    
}