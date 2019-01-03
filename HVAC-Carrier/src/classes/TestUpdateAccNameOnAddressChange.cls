@isTest
public class TestUpdateAccNameOnAddressChange {

    public static testmethod void testContactAddrChange(){
        //Contact resCont = [Select Id from Contact where RecordType.Name='Residential Contact' order by createddate desc limit 1];
         Account acctToRet =new Account();
        RecordType rtAcc = [select id,Name from RecordType where SobjectType='Account' and Name='Residential Address' Limit 1];
        acctToRet.recordTypeId=rtAcc.id;
        acctToRet.Name='Residential - 300 Deerfield Rd,East Syracuse,NY,United States 13057';
        acctToRet.BillingStreet = '300 Deerfield Rd';
        acctToRet.BillingCity = 'East Syracuse';
        acctToRet.BillingState = 'NY';
        acctToRet.BillingCountry = 'United States';
        acctToRet.BillingPostalCode='13057';
        insert acctToRet;
        Contact cont = new Contact();
        RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Residential Contact' Limit 1];
        cont.RecordTypeId = rt.Id;
        cont.AccountId = acctToRet.Id;
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
        List<Id> ids = new List<Id>();
        ids.add(cont.id);
        UpdateAccNameOnAddressChange.getAccountName(ids);
        
    }
    public static testmethod void testContactNoAddr(){
        //Contact resCont = [Select Id from Contact where RecordType.Name='Residential Contact' order by createddate desc limit 1];
         Account acctToRet =new Account();
        RecordType rtAcc = [select id,Name from RecordType where SobjectType='Account' and Name='Residential Address' Limit 1];
        acctToRet.recordTypeId=rtAcc.id;
        acctToRet.Name='Residential - 300 Deerfield Rd,East Syracuse,NY,United States 13057';
        acctToRet.BillingStreet = '300 Deerfield Rd';
        acctToRet.BillingCity = 'East Syracuse';
        acctToRet.BillingState = 'NY';
        acctToRet.BillingCountry = 'United States';
        acctToRet.BillingPostalCode='13057';
        insert acctToRet;
        Contact cont = new Contact();
        RecordType rt = [select id,Name from RecordType where SobjectType='Contact' and Name='Residential Contact' Limit 1];
        cont.RecordTypeId = rt.Id;
        cont.AccountId = acctToRet.Id;
        cont.FirstName = 'Tommy';
        cont.LastName = 'Hills';
        cont.Email = 'tommy.hills@usa.com';
        cont.Phone = '3158765432';
        cont.MobilePhone = '3158765432';
        /*cont.MailingStreet = '300 Deerfield Rd';
        cont.MailingCity = 'East Syracuse';
        cont.MailingState = 'NY';
        cont.MailingPostalCode = '13057';*/
        //cont.MailingCountry = 'USA';
        
        cont.Enrichment_Payload__c = '<SUPPLEMENTARY_US><Status>EUS1</Status><COUNTY_FIPS_CODE>067</COUNTY_FIPS_CODE><STATE_FIPS_CODE>36</STATE_FIPS_CODE><MSA_ID></MSA_ID><CBSA_ID>45060</CBSA_ID><FINANCE_NUMBER>352530</FINANCE_NUMBER><RECORD_TYPE>H</RECORD_TYPE><CMSA_ID></CMSA_ID><CENSUS_TRACT_NO>014500</CENSUS_TRACT_NO><CENSUS_BLOCK_NO>1058</CENSUS_BLOCK_NO><CENSUS_BLOCK_GROUP>1</CENSUS_BLOCK_GROUP><PMSA_ID></PMSA_ID><MCD_ID>20478</MCD_ID><PLACE_FIPS_CODE></PLACE_FIPS_CODE><TIME_ZONE_CODE>-5</TIME_ZONE_CODE><TIME_ZONE_NAME>EST</TIME_ZONE_NAME></SUPPLEMENTARY_US>';
        insert cont;
        List<Id> ids = new List<Id>();
        ids.add(cont.id);
        UpdateAccNameOnAddressChange.getAccountName(ids);
        
    }
}