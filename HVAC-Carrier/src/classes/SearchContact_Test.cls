@isTest 
public class SearchContact_Test {
    public static testmethod void startTest(){
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
            
            Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';
            insert c; 
            Account acc = new Account();
            acc.Name='Test';
            acc.BillingCity='Milwaukee';
            acc.BillingState='WI';
            acc.BillingCountry='United States';
            insert acc;
            list <Contact> cntlst= new list<Contact> ();
            contact cnt = new contact();
            cnt.LastName='test';
            cnt.FirstName='test1';
            cnt.Email=c.SuppliedEmail;            
            cnt.Phone='9980608820';
            cnt.Fax='1256';
            // cnt.RecordTypeId=rd.Id;
            cnt.MailingStreet='test';
            cnt.MailingCity='test';
            cnt.MailingState='test';
            cnt.MailingCountry='India'; 
            // cnt.id=c.ContactId;
            cntlst.add(cnt);
            insert cntlst;
            c.ContactId=cnt.Id;
            update c;
            contact cnt1 = new contact();
            cnt1.LastName='test';
            cnt1.FirstName='test1';
            cnt1.Email=c.SuppliedEmail;            
            cnt1.Phone='9980608820';
            cnt1.Fax='1256';
            // cnt.RecordTypeId=rd.Id;
            cnt1.MailingStreet='test';
            cnt1.MailingCity='test';
            cnt1.MailingState='test';
            cnt1.MailingCountry='India';
            insert cnt1;
            Defect_Tracker__c dft = new Defect_Tracker__c();
            dft.Category__c='Maintenance';
            dft.Functionality__c='Duplicate Contact';
            dft.Type__c='Duplicate';
            dft.Status__c='Assigned';
            //  dft.Affected_User__c=UserInfo.getUserId();
            insert dft; 
            Duplicate_Contact_Records__c d = new Duplicate_Contact_Records__c();
            d.Observation__c=dft.id;
            d.Email_del__c='ian.brown@carrier.utc.com';
            d.Name__c='test';
            d.Name='test';
            d.Account_Name__c='Nafo  Warranty Admin account';
            d.Account_Address__c='India';
            d.Partner_Account__c=true;
            insert d;            
            test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
            apexpages.currentPage().getparameters().put('id',c.Id);
            SearchContact ssc = new SearchContact(sc);
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            SearchContact.wrapcontact wrap = new  SearchContact.wrapcontact(cnt); 
            wrap.isSelected=true;
            ssc.contactid=cnt.Id;
            ssc.wrapcontactList.add(wrap);
            ssc.isInternalUser=true;
            ssc.display1=false;
            ssc.isSuccess=true;
            ssc.contactList=cntlst;
            
            list<contact> selectedcontacts= new LIST<contact>();
            selectedcontacts=ssc.selectedcontacts;   
            ssc.ProcessSelected();
            RecordType rd = new RecordType();
            rd.Name='Residential Address';          
            ssc.CreateTicket();
            ssc.searchstring='Acme';
            ssc.SearchResult();
            ssc.ConEmail=cnt.Email;
            c.Id=ssc.caseid;
            for(contact c1: cntlst){
                c1.MailingStreet=ssc.MailingStreet;
                c1.MailingCity=ssc.MailingCity;
                c1.MailingState=ssc.MailingState;
                c1.MailingCountry= ssc.MailingCountry;
                c1.Phone=ssc.Phone;
                c1.Fax=ssc.Fax;
                c1.FirstName=ssc.FirstName;
                c1.Email=ssc.Email;
                c1.Id=c.ContactId;
                c1.RecordTypeId=rd.Id;
                
            }
            ssc.Type='Dealer';       
            ssc.getRecordType();
            ssc.selected='Residential Contact';
            ssc.LastName='test1';
            ssc.SaveContact();
            
            ssc.Cancel();
            ssc.isSingleContact=true;           
            ssc.Save(); 
            ssc.queryStr='Testing';
            ssc.runQuery();
            c.AccountId=ssc.accountId;
            ssc.onClick();
            // ssc.SaveAcct();
            ssc.displayAccount=true;
            ssc.display=false;
            ssc.display1=false;
            ssc.display2=true;
            ssc.valueChanged(); 
            // string conid= apexpages.currentPage().getparameters().get('id');
            ssc.conid=cnt1.id;
            ssc.edit();
            ssc.SaveEdit();
            ssc.SelectLink();
            //ssc.SavePHDBContact();
            // ssc.SaveandAccount();
            // ssc.editnew();
            ssc.SaveEditAndAccount();
            ssc.CancelAccount();
            // ssc.UpdateContact();
            // ssc.SaveandCreateAccount();
            Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorEquipDetailTest());
            ssc.getPHDBContactInfo('test','test','8799876875', '600089', 'test', 'test', '344444445', 'test@gmail.com');
            ssc.getPHDBContactInfo1('test','test','8799876875', '600089', 'test', 'test', '344444445', 'test@gmail.com');
            // ssc.getPHDBInfo('test','test','8799876875', '60008956', '567567', 'test', 'test','345435','test@gmail.com');
            
        }
        
    }
    
    public static testmethod void startTest1(){
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
            Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';
            //c.ContactId='0036300000HKxYRAA1';            
            insert c; 
            Account acc = new Account();
            acc.Name='Test';
            acc.BillingCity='Milwaukee';
            acc.BillingState='WI';
            acc.BillingCountry='United States';
            insert acc;
            list <Contact> cntlst= new list<Contact> ();
            contact cnt = new contact();
            cnt.LastName='test';
            cnt.FirstName='test1';
            cnt.Email=c.SuppliedEmail;            
            cnt.Phone='9980608820';
            cnt.Fax='1256';
            // cnt.RecordTypeId=rd.Id;
            cnt.MailingStreet='test';
            cnt.MailingCity='test';
            cnt.MailingState='test';
            cnt.MailingCountry='India'; 
            // cnt.id=c.ContactId;            
            cntlst.add(cnt);
            insert cntlst; 
            System.debug('contactid'+cnt.id);
            contact cnt1 = new contact();
            cnt1.LastName='test';
            cnt1.FirstName='test1';
            cnt1.Email=c.SuppliedEmail;            
            cnt1.Phone='9980608820';
            cnt1.Fax='1256';
            // cnt.RecordTypeId=rd.Id;
            cnt1.MailingStreet='test';
            cnt1.MailingCity='test';
            cnt1.MailingState='test';
            cnt1.MailingCountry='India';
            insert cnt1;
            Defect_Tracker__c dft = new Defect_Tracker__c();
            dft.Category__c='Maintenance';
            dft.Functionality__c='Duplicate Contact';
            dft.Type__c='Duplicate';
            dft.Status__c='Assigned';
            //  dft.Affected_User__c=UserInfo.getUserId();
            insert dft; 
            Duplicate_Contact_Records__c d = new Duplicate_Contact_Records__c();
            d.Observation__c=dft.id;
            d.Email_del__c='ian.brown@carrier.utc.com';
            d.Name__c='test';
            d.Name='test';
            d.Account_Name__c='Nafo  Warranty Admin account';
            d.Account_Address__c='India';
            d.Partner_Account__c=true;
            insert d;            
            test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
            apexpages.currentPage().getparameters().put('id',c.Id);
            SearchContact ssc = new SearchContact(sc);
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            SearchContact.wrapcontact wrap = new  SearchContact.wrapcontact(cnt);  
            wrap.isSelected=true;      
            ssc.searchId = 'test';
            ssc.PHDBRecord=true;
            ssc.strUrl='test';
            ssc.responseStr='test';
            ssc.PHDBRecordid='test';
            ssc.ResidentialFromURL1='test';
            ssc.wrapcontactList.add(wrap);
            ssc.isInternalUser=true;          
            ssc.isSuccess=true;
            ssc.contactList=cntlst;
            list<contact> selectedcontacts= new LIST<contact>();
            selectedcontacts=ssc.selectedcontacts;   
            ssc.ProcessSelected();
            RecordType rd = new RecordType();
            rd.Name='Residential Address';          
            ssc.CreateTicket();
            ssc.searchstring='Acme';
            ssc.SearchResult();
            ssc.ConEmail=cnt.Email;
            c.Id=ssc.caseid;
            for(contact c1: cntlst){
                c1.MailingStreet=ssc.MailingStreet;
                c1.MailingCity=ssc.MailingCity;
                c1.MailingState=ssc.MailingState;
                c1.MailingCountry= ssc.MailingCountry;
                c1.Phone=ssc.Phone;
                c1.Fax=ssc.Fax;
                c1.FirstName=ssc.FirstName;
                c1.Email=ssc.Email;
                c1.Id=c.ContactId;
                c1.RecordTypeId=rd.Id;
                
            }
            ssc.Type='Dealer';       
            ssc.getRecordType();
            ssc.selected='Non-Residential Contact';
            ssc.LastName='test1';
            ssc.SaveContact();        
            ssc.Cancel();
            ssc.isSingleContact=true;            
            ssc.Save(); 
            ssc.queryStr='Testing';
            ssc.runQuery();
            c.AccountId=ssc.accountId;
            ssc.onClick();
            // ssc.SaveAcct();
            ssc.displayAccount=true;
            ssc.display=false;
            ssc.display1=false;
            ssc.display2=true;
            ssc.valueChanged();
            ssc.conid=cnt1.id;
            ssc.edit();  
            ssc.SaveEdit();
            ssc.SelectLink();
            
        }
        
    }
    
    public static testmethod void startTest3(){
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
            
            Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';
            insert c; 
            Account acctest = new Account();
            acctest.Name='Nafo  Warranty Admin account';
            acctest.BillingCity='TestCity';
            acctest.BillingState='TestState';
            acctest.BillingCountry='TestCountry';
            acctest.BillingStreet='TestStreet';
            acctest.BillingPostalCode='63215';
            acctest.Site='test'; 
            acctest.Type='Partner';
            acctest.Phone ='45647654674';
            insert acctest;
            list <Contact> cntlst= new list<Contact> ();
            contact cnt = new contact();
            cnt.LastName='test';
            cnt.FirstName='test1';
            cnt.Email=c.SuppliedEmail;            
            cnt.Phone='9980608820';
            cnt.Fax='1256';
            // cnt.RecordTypeId=rd.Id;
            cnt.MailingStreet='test';
            cnt.MailingCity='test';
            cnt.MailingState='test';
            cnt.MailingCountry='India';
            
            // cnt.id=c.ContactId;
            cntlst.add(cnt);
            
            insert cntlst;
            cnt.AccountId=acctest.Id;
            cntlst.add(cnt);
            update cnt;
            c.ContactId=cnt.Id;
            c.AccountId=acctest.Id;
            update c;
            
            
            test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
            apexpages.currentPage().getparameters().put('id',c.Id);
            SearchContact ssc = new SearchContact(sc);
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            SearchContact.wrapcontact wrap = new  SearchContact.wrapcontact(cnt); 
            wrap.isSelected=true;
            ssc.contactid=cnt.Id;
            ssc.wrapcontactList.add(wrap);
            ssc.isInternalUser=true;
            ssc.display1=false;
            ssc.isSuccess=true;
            ssc.contactList=cntlst;
            
            list<contact> selectedcontacts= new LIST<contact>();
            selectedcontacts=ssc.selectedcontacts;   
            ssc.ProcessSelected();
            RecordType rd = new RecordType();
            rd.Name='Residential Address';          
            ssc.CreateTicket();
            ssc.searchstring='Acme';
            ssc.SearchResult();
            ssc.ConEmail=cnt.Email;
            c.Id=ssc.caseid;
            for(contact c1: cntlst){
                c1.MailingStreet=ssc.MailingStreet;
                c1.MailingCity=ssc.MailingCity;
                c1.MailingState=ssc.MailingState;
                c1.MailingCountry= ssc.MailingCountry;
                c1.Phone=ssc.Phone;
                c1.Fax=ssc.Fax;
                c1.FirstName=ssc.FirstName;
                c1.Email=ssc.Email;
                c1.Id=c.ContactId;
                c1.RecordTypeId=rd.Id;
                
            }
            ssc.Type='Dealer';       
            ssc.getRecordType();
            ssc.selected='Residential Contact';
            ssc.LastName='test1';
            ssc.Name='Testing';
            
            ssc.SavePHDBContact();
            ssc.SaveAcct();
            
            // ssc.SaveAcct();
            //  ssc.SaveandAccount();
        }
        
    }
    
    public static testmethod void startTest4(){
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
            
            Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';
            insert c; 
            Account acctest = new Account();
            acctest.Name='Nafo  Warranty Admin account';
            acctest.BillingCity='TestCity';
            acctest.BillingState='TestState';
            acctest.BillingCountry='TestCountry';
            acctest.BillingStreet='TestStreet';
            acctest.BillingPostalCode='63215';
            acctest.Site='test'; 
            acctest.Type='Partner';
            acctest.Phone ='45647654674';
            insert acctest;
            list <Contact> cntlst= new list<Contact> ();
            contact cnt = new contact();
            cnt.LastName='test';
            cnt.FirstName='test1';
            cnt.Email=c.SuppliedEmail;            
            cnt.Phone='9980608820';
            cnt.Fax='1256';
            cnt.MailingStreet='test';
            cnt.MailingCity='test';
            cnt.MailingState='test';
            cnt.MailingCountry='India';
            cnt.AccountId=acctest.Id;
            cntlst.add(cnt);
            insert cntlst;
            c.ContactId=cnt.Id;
            c.AccountId=acctest.Id;
            update c;
            test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
            apexpages.currentPage().getparameters().put('id',c.Id);
            SearchContact ssc = new SearchContact(sc);
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            SearchContact.wrapcontact wrap = new  SearchContact.wrapcontact(cnt); 
            wrap.isSelected=true;
            ssc.contactid=cnt.Id;
            ssc.wrapcontactList.add(wrap);
            ssc.isInternalUser=true;
            ssc.display1=false;
            ssc.isSuccess=true;
            ssc.contactList=cntlst;
            list<contact> selectedcontacts= new LIST<contact>();
            selectedcontacts=ssc.selectedcontacts;   
            ssc.ProcessSelected();
            RecordType rd = new RecordType();
            rd.Name='Residential Address';          
            ssc.CreateTicket();
            ssc.searchstring='Acme';
            ssc.SearchResult();
            ssc.ConEmail=cnt.Email;
            c.Id=ssc.caseid;
            for(contact c1: cntlst){
                c1.MailingStreet=ssc.MailingStreet;
                c1.MailingCity=ssc.MailingCity;
                c1.MailingState=ssc.MailingState;
                c1.MailingCountry= ssc.MailingCountry;
                c1.Phone=ssc.Phone;
                c1.Fax=ssc.Fax;
                c1.FirstName=ssc.FirstName;
                c1.Email=ssc.Email;
                c1.Id=c.ContactId;
                c1.RecordTypeId=rd.Id;
                
            }
            ssc.Type='Dealer';       
            ssc.getRecordType();
            ssc.selected='Residential Contact';
            ssc.LastName='test1';
            ssc.SaveandAccount();
            
            ssc.SaveandCreateAccount();
            contact cnt2 = new contact();
            cnt2.LastName='test12';
            cnt2.FirstName='test112';
            cnt2.Email=c.SuppliedEmail;            
            cnt2.Phone='9980608820';
            cnt2.Fax='1256';
            cnt2.MailingStreet='test';
            cnt2.MailingCity='test';
            cnt2.MailingState='test';
            cnt2.MailingCountry='India';
            insert cnt2;
            ssc.selected1 = cnt.id;
            try{
                ssc.UpdateContact();
            }catch(exception e){}
            SearchContact.ContactWrapper conWrap = new SearchContact.ContactWrapper(cnt, true);
            conWrap.contactRec = cnt;
            conWrap.isSelected = true;         
            List<SearchContact.ContactWrapper> conWrapList = new List<SearchContact.ContactWrapper>();
            conWrapList.add(conWrap);
            
            ssc.contactResults = cntlst;
            ssc.getAllResults();
            SearchContact.PHDBInfoWrapper PHDBwrap = new SearchContact.PHDBInfoWrapper(cnt, true);
            PHDBwrap.comments = 'test';
            PHDBwrap.confirmationNumber='1233';
            PHDBwrap.consumer_Address1='testaddress';
            PHDBwrap.consumer_Address2='testaddress2';
            PHDBwrap.consumer_BusinessName ='test';
            PHDBwrap.consumer_City='syracuse';
            PHDBwrap.consumer_Country ='USA';
            PHDBwrap.consumer_Email='test@gmail.com';
            PHDBwrap.consumer_Name='manju,ravi';
            PHDBwrap.consumer_Phone1='547657566';
            PHDBwrap.consumer_Phone2='548974957';
            PHDBwrap.consumer_State='NY';
            PHDBwrap.consumer_Zip='13067';
            PHDBwrap.contactRec = cnt;
            PHDBwrap.dealerName = 'testdealer';
            PHDBwrap.dealerPhone ='465456645';
            PHDBwrap.equip_Address1='testaddr';
            PHDBwrap.equip_Address2='testaddr2';
            PHDBwrap.equip_City = 'chennai';
            PHDBwrap.equip_Country='India';
            PHDBwrap.equip_Description='testdesc';
            PHDBwrap.equip_State = 'TN';
            PHDBwrap.equip_Zip='95687';
            PHDBwrap.hvacpId = '1441';
            PHDBwrap.mfgAcctNum = '43545';
            PHDBwrap.model = 'test';
            PHDBwrap.selected = true;
            PHDBwrap.registrationNumber= '45645';
            PHDBwrap.serial ='344444444';
            PHDBwrap.serviceBenchID = '56456';
            PHDBwrap.source='test';
            PHDBwrap.wrapperid='456';
            
            List<SearchContact.PHDBInfoWrapper> PHDBWrapList = new List<SearchContact.PHDBInfoWrapper>();
            PHDBWrapList.add(PHDBwrap);
            
            
            // ssc.editnew();
            ssc.contactSearch();
            Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorEquipDetailTest());
            ssc.getPHDBInfo('test','test','8799876875', '60008956', '567567', 'test', 'test','345435','test@gmail.com');
            
            ssc.MailingCity='cituy';
            ssc.MailingCountry='county';
            ssc.MailingPostalCode='34545';
            ssc.MailingState='statre';
            ssc.MailingStreet='street';
            ssc.MobilePhone='324345';
            
            ssc.PHDBContactsInfo = PHDBWrapList;
            ssc.editnew();
            ssc.SaveEdit();
            ssc.selected='Residential Contact';
            
            try{
                ssc.UpdateContact();
                ssc.SaveContact();
            }catch(exception e){}
            RecordType rd2 = new RecordType();
            rd2.Name='Partner';
            contact cnt23 = new contact();
            cnt23.LastName='test12';
            cnt23.FirstName='test121';
            cnt23.Email=c.SuppliedEmail;            
            cnt23.Phone='9980608820';
            cnt23.Fax='1256';
            cnt23.MailingStreet='test';
            cnt23.MailingCity='test';
            cnt23.MailingState='test';
            cnt23.MailingCountry='India';
            cnt23.AccountId=acctest.Id;
            //cnt23.RecordTypeId=rd2.id;
            insert cnt23;
            ssc.SaveEditAndAccount();
        }
        
    }
    
    public static testmethod void startTest5(){
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
            
            Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';
            insert c; 
            Account acctest = new Account();
            acctest.Name='Nafo  Warranty Admin account';
            acctest.BillingCity='TestCity';
            acctest.BillingState='TestState';
            acctest.BillingCountry='TestCountry';
            acctest.BillingStreet='TestStreet';
            acctest.BillingPostalCode='63215';
            acctest.Site='test'; 
            acctest.Type='Partner';
            acctest.Phone ='45647654674';
            insert acctest;
            list <Contact> cntlst= new list<Contact> ();
            contact cnt = new contact();
            cnt.LastName='test';
            cnt.FirstName='test1';
            cnt.Email=c.SuppliedEmail;            
            cnt.Phone='9980608820';
            cnt.Fax='1256';
            cnt.MailingStreet='test';
            cnt.MailingCity='test';
            cnt.MailingState='test';
            cnt.MailingCountry='India';
            cnt.AccountId=acctest.Id;
            cntlst.add(cnt);
            insert cntlst;
            c.ContactId=cnt.Id;
            c.AccountId=acctest.Id;
            update c;
            test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
            apexpages.currentPage().getparameters().put('id',c.Id);
            SearchContact ssc = new SearchContact(sc);
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            SearchContact.wrapcontact wrap = new  SearchContact.wrapcontact(cnt); 
            wrap.isSelected=true;
            ssc.contactid=cnt.Id;
            ssc.wrapcontactList.add(wrap);
            ssc.isInternalUser=true;
            ssc.display1=false;
            ssc.isSuccess=true;
            ssc.contactList=cntlst;
            list<contact> selectedcontacts= new LIST<contact>();
            selectedcontacts=ssc.selectedcontacts;   
            ssc.ProcessSelected();
            RecordType rd = new RecordType();
            rd.Name='Residential Address';          
            ssc.CreateTicket();
            ssc.searchstring='Acme';
            ssc.SearchResult();
            ssc.ConEmail=cnt.Email;
            c.Id=ssc.caseid;
            for(contact c1: cntlst){
                c1.MailingStreet=ssc.MailingStreet;
                c1.MailingCity=ssc.MailingCity;
                c1.MailingState=ssc.MailingState;
                c1.MailingCountry= ssc.MailingCountry;
                c1.Phone=ssc.Phone;
                c1.Fax=ssc.Fax;
                c1.FirstName=ssc.FirstName;
                c1.Email=ssc.Email;
                c1.Id=c.ContactId;
                c1.RecordTypeId=rd.Id;
                
            }
            ssc.Type='Dealer';       
            ssc.getRecordType();
            ssc.selected='Residential Contact';
            ssc.LastName='test1';
            ssc.SaveandAccount();
            ssc.UpdateContact();
            
            
            SearchContact.ContactWrapper conWrap = new SearchContact.ContactWrapper(cnt, true);
            conWrap.contactRec = cnt;
            conWrap.isSelected = true;         
            List<SearchContact.ContactWrapper> conWrapList = new List<SearchContact.ContactWrapper>();
            conWrapList.add(conWrap);
            
            ssc.contactResults = cntlst;
            ssc.getAllResults();
            
            /*SearchContact.PHDBContactsInfo PHDBCntwrap = new SearchContact.PHDBContactsInfo();
List<SearchContact.PHDBContactsInfo> PHDBWrapconList = new List<SearchContact.PHDBContactsInfo>();
PHDBWrapconList.add(PHDBwrap);*/
            try{
                ssc.editnew();
            }catch(exception e){}
            ssc.SaveandCreateAccount();
            
        }
        
    }
    public static testmethod void startTest6(){
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
            
            Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';
            insert c; 
            Account acctest = new Account();
            acctest.Name='Nafo  Warranty Admin account';
            acctest.BillingCity='TestCity';
            acctest.BillingState='TestState';
            acctest.BillingCountry='TestCountry';
            acctest.BillingStreet='TestStreet';
            acctest.BillingPostalCode='63215';
            acctest.Site='test'; 
            acctest.Type='Partner';
            acctest.Phone ='45647654674';
            insert acctest;
            list <Contact> cntlst= new list<Contact> ();
            contact cnt = new contact();
            cnt.LastName='test';
            cnt.FirstName='test1';
            cnt.Email=c.SuppliedEmail;            
            cnt.Phone='9980608820';
            cnt.Fax='1256';
            cnt.MailingStreet='test';
            cnt.MailingCity='test';
            cnt.MailingState='test';
            cnt.MailingCountry='India';
            //cnt.AccountId=acctest.Id;
            cntlst.add(cnt);
            insert cntlst;
            c.ContactId=cnt.Id;
            c.AccountId=acctest.Id;
            update c;
            test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
            apexpages.currentPage().getparameters().put('id',c.Id);
            SearchContact ssc = new SearchContact(sc);
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            SearchContact.wrapcontact wrap = new  SearchContact.wrapcontact(cnt); 
            wrap.isSelected=true;
            ssc.contactid=cnt.Id;
            ssc.wrapcontactList.add(wrap);
            ssc.isInternalUser=true;
            ssc.display1=false;
            ssc.isSuccess=true;
            ssc.contactList=cntlst;
            list<contact> selectedcontacts= new LIST<contact>();
            selectedcontacts=ssc.selectedcontacts;   
            ssc.ProcessSelected();
            RecordType rd = new RecordType();
            rd.Name='Residential Address';          
            ssc.CreateTicket();
            ssc.searchstring='Acme';
            ssc.SearchResult();
            ssc.ConEmail=cnt.Email;
            c.Id=ssc.caseid;
            for(contact c1: cntlst){
                c1.MailingStreet=ssc.MailingStreet;
                c1.MailingCity=ssc.MailingCity;
                c1.MailingState=ssc.MailingState;
                c1.MailingCountry= ssc.MailingCountry;
                c1.Phone=ssc.Phone;
                c1.Fax=ssc.Fax;
                c1.FirstName=ssc.FirstName;
                c1.Email=ssc.Email;
                c1.Id=c.ContactId;
                c1.RecordTypeId=rd.Id;
                
            }
            ssc.Type='Dealer';       
            ssc.getRecordType();
            ssc.selected='Residential Contact';
            ssc.LastName='test1';
            ssc.SaveandAccount();
            
            ssc.SaveandCreateAccount();
            contact cnt2 = new contact();
            cnt2.LastName='test12';
            cnt2.FirstName='test112';
            cnt2.Email=c.SuppliedEmail;            
            cnt2.Phone='9980608820';
            cnt2.Fax='1256';
            cnt2.MailingStreet='test';
            cnt2.MailingCity='test';
            cnt2.MailingState='test';
            cnt2.MailingCountry='India';
            insert cnt2;
            ssc.selected1 = cnt.id;
            try{
                ssc.UpdateContact();
            }catch(exception e){}
            SearchContact.ContactWrapper conWrap = new SearchContact.ContactWrapper(cnt, true);
            conWrap.contactRec = cnt;
            conWrap.isSelected = true;         
            List<SearchContact.ContactWrapper> conWrapList = new List<SearchContact.ContactWrapper>();
            conWrapList.add(conWrap);
            
            ssc.contactResults = cntlst;
            ssc.getAllResults();
            SearchContact.PHDBInfoWrapper PHDBwrap = new SearchContact.PHDBInfoWrapper(cnt, true);
            PHDBwrap.comments = 'test';
            PHDBwrap.confirmationNumber='1233';
            PHDBwrap.consumer_Address1='testaddress';
            PHDBwrap.consumer_Address2='testaddress2';
            PHDBwrap.consumer_BusinessName ='test';
            PHDBwrap.consumer_City='syracuse';
            PHDBwrap.consumer_Country ='USA';
            PHDBwrap.consumer_Email='test@gmail.com';
            PHDBwrap.consumer_Name='manju,ravi';
            PHDBwrap.consumer_Phone1='547657566';
            PHDBwrap.consumer_Phone2='548974957';
            PHDBwrap.consumer_State='NY';
            PHDBwrap.consumer_Zip='13067';
            PHDBwrap.contactRec = cnt;
            PHDBwrap.dealerName = 'testdealer';
            PHDBwrap.dealerPhone ='465456645';
            PHDBwrap.equip_Address1='testaddr';
            PHDBwrap.equip_Address2='testaddr2';
            PHDBwrap.equip_City = 'chennai';
            PHDBwrap.equip_Country='India';
            PHDBwrap.equip_Description='testdesc';
            PHDBwrap.equip_State = 'TN';
            PHDBwrap.equip_Zip='95687';
            PHDBwrap.hvacpId = '1441';
            PHDBwrap.mfgAcctNum = '43545';
            PHDBwrap.model = 'test';
            PHDBwrap.selected = true;
            PHDBwrap.registrationNumber= '45645';
            PHDBwrap.serial ='344444444';
            PHDBwrap.serviceBenchID = '56456';
            PHDBwrap.source='test';
            PHDBwrap.wrapperid='456';
            
            List<SearchContact.PHDBInfoWrapper> PHDBWrapList = new List<SearchContact.PHDBInfoWrapper>();
            PHDBWrapList.add(PHDBwrap);
            
            
            // ssc.editnew();
            ssc.contactSearch();
            Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorEquipDetailTest());
            ssc.getPHDBInfo('test','test','8799876875', '60008956', '567567', 'test', 'test','345435','test@gmail.com');
            
            ssc.MailingCity='cituy';
            ssc.MailingCountry='county';
            ssc.MailingPostalCode='34545';
            ssc.MailingState='statre';
            ssc.MailingStreet='street';
            ssc.MobilePhone='324345';
            
            ssc.PHDBContactsInfo = PHDBWrapList;
            ssc.editnew();
            ssc.SaveEdit();
            ssc.selected='Residential Contact';
            
            try{
                ssc.UpdateContact();
                ssc.SaveContact();
            }catch(exception e){}
            RecordType rd2 = new RecordType();
            rd2.Name='Partner';
            contact cnt23 = new contact();
            cnt23.LastName='test12';
            cnt23.FirstName='test121';
            cnt23.Email=c.SuppliedEmail;            
            cnt23.Phone='9980608820';
            cnt23.Fax='1256';
            cnt23.MailingStreet='test';
            cnt23.MailingCity='test';
            cnt23.MailingState='test';
            cnt23.MailingCountry='India';
            cnt23.AccountId=acctest.Id;
            //cnt23.RecordTypeId=rd2.id;
            insert cnt23;
            ssc.SaveEditAndAccount();
        }
        
    }
    public static testmethod void startTest7(){
        
        Profile testprof1=[SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u1=new User( email='test.user1812171@gmail.com',
                         profileid = testprof1.id,  
                         UserName='test18121711.user@gmail.com', 
                         Alias = 'GDS',
                         TimeZoneSidKey='America/New_York',
                         EmailEncodingKey='ISO-8859-1',
                         LocaleSidKey='en_US', 
                         LanguageLocaleKey='en_US',
                         //ContactId = testCon1.id,
                         //PortalRole = 'Manager',
                         FirstName = 'test2181217144',
                         LastName = 'user2181217144');
        
        insert u1;
        System.runAs(u1){
            
            Case c= new Case();
            c.Subject='test';
            c.Description='testDesc';
            c.Priority='Medium';
            c.New_Comment__c=true;
            c.CCC_Turn_Back_Code__c ='Not Applicable';
            c.CCC_Part_Number__c='56756';
            c.SuppliedEmail='ian.sfdc@gmail.com';
            insert c; 
            Account acctest = new Account();
            acctest.Name='Nafo  Warranty Admin account';
            acctest.BillingCity='TestCity';
            acctest.BillingState='TestState';
            acctest.BillingCountry='TestCountry';
            acctest.BillingStreet='TestStreet';
            acctest.BillingPostalCode='63215';
            acctest.Site='test'; 
            acctest.Type='Partner';
            acctest.Phone ='45647654674';
            insert acctest;
            list <Contact> cntlst= new list<Contact> ();
            contact cnt = new contact();
            cnt.LastName='test';
            cnt.FirstName='test1';
            cnt.Email=c.SuppliedEmail;            
            cnt.Phone='9980608820';
            cnt.Fax='1256';
            cnt.MailingStreet='test';
            cnt.MailingCity='test';
            cnt.MailingState='test';
            cnt.MailingCountry='India';
            cnt.RecordTypeId = [Select Id, Name from RecordType where sobjecttype='Contact' and name='Non-Residential Contact'].Id;
            //cnt.AccountId=acctest.Id;
            cntlst.add(cnt);
            insert cntlst;
            c.ContactId=cnt.Id;
            c.AccountId=acctest.Id;
            update c;
            test.startTest();
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(c);
            apexpages.currentPage().getparameters().put('id',c.Id);
            SearchContact ssc = new SearchContact(sc);
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            SearchContact.wrapcontact wrap = new  SearchContact.wrapcontact(cnt); 
            wrap.isSelected=true;
            ssc.contactid=cnt.Id;
            ssc.wrapcontactList.add(wrap);
            ssc.isInternalUser=true;
            ssc.display1=false;
            ssc.isSuccess=true;
            ssc.contactList=cntlst;
            list<contact> selectedcontacts= new LIST<contact>();
            selectedcontacts=ssc.selectedcontacts;   
            ssc.ProcessSelected();
            RecordType rd = new RecordType();
            rd.Name='Residential Address';          
            ssc.CreateTicket();
            ssc.searchstring='Acme';
            ssc.SearchResult();
            ssc.ConEmail=cnt.Email;
            c.Id=ssc.caseid;
            for(contact c1: cntlst){
                c1.MailingStreet=ssc.MailingStreet;
                c1.MailingCity=ssc.MailingCity;
                c1.MailingState=ssc.MailingState;
                c1.MailingCountry= ssc.MailingCountry;
                c1.Phone=ssc.Phone;
                c1.Fax=ssc.Fax;
                c1.FirstName=ssc.FirstName;
                c1.Email=ssc.Email;
                c1.Id=c.ContactId;
                c1.RecordTypeId=rd.Id;
                c1.RecordTypeId = [Select Id, Name from RecordType where sobjecttype='Contact' and name='Non-Residential Contact'].Id;
                
            }
            ssc.Type='Dealer';       
            ssc.getRecordType();
            ssc.selected='Residential Contact';
            ssc.LastName='test1';
            ssc.SaveandAccount();
            
            ssc.SaveandCreateAccount();
            contact cnt2 = new contact();
            cnt2.LastName='test12';
            cnt2.FirstName='test112';
            cnt2.Email=c.SuppliedEmail;            
            cnt2.Phone='9980608820';
            cnt2.Fax='1256';
            cnt2.MailingStreet='test';
            cnt2.MailingCity='test';
            cnt2.MailingState='test';
            cnt2.MailingCountry='India';
            insert cnt2;
            ssc.selected1 = cnt.id;
            try{
                ssc.UpdateContact();
            }catch(exception e){}
            SearchContact.ContactWrapper conWrap = new SearchContact.ContactWrapper(cnt, true);
            conWrap.contactRec = cnt;
            conWrap.isSelected = true;         
            List<SearchContact.ContactWrapper> conWrapList = new List<SearchContact.ContactWrapper>();
            conWrapList.add(conWrap);
            
            ssc.contactResults = cntlst;
            ssc.getAllResults();
            SearchContact.PHDBInfoWrapper PHDBwrap = new SearchContact.PHDBInfoWrapper(cnt, true);
            PHDBwrap.comments = 'test';
            PHDBwrap.confirmationNumber='1233';
            PHDBwrap.consumer_Address1='testaddress';
            PHDBwrap.consumer_Address2='testaddress2';
            PHDBwrap.consumer_BusinessName ='test';
            PHDBwrap.consumer_City='syracuse';
            PHDBwrap.consumer_Country ='USA';
            PHDBwrap.consumer_Email='test@gmail.com';
            PHDBwrap.consumer_Name='manju,ravi';
            PHDBwrap.consumer_Phone1='547657566';
            PHDBwrap.consumer_Phone2='548974957';
            PHDBwrap.consumer_State='NY';
            PHDBwrap.consumer_Zip='13067';
            PHDBwrap.contactRec = cnt;
            PHDBwrap.dealerName = 'testdealer';
            PHDBwrap.dealerPhone ='465456645';
            PHDBwrap.equip_Address1='testaddr';
            PHDBwrap.equip_Address2='testaddr2';
            PHDBwrap.equip_City = 'chennai';
            PHDBwrap.equip_Country='India';
            PHDBwrap.equip_Description='testdesc';
            PHDBwrap.equip_State = 'TN';
            PHDBwrap.equip_Zip='95687';
            PHDBwrap.hvacpId = '1441';
            PHDBwrap.mfgAcctNum = '43545';
            PHDBwrap.model = 'test';
            PHDBwrap.selected = true;
            PHDBwrap.registrationNumber= '45645';
            PHDBwrap.serial ='344444444';
            PHDBwrap.serviceBenchID = '56456';
            PHDBwrap.source='test';
            PHDBwrap.wrapperid='456';
            
            List<SearchContact.PHDBInfoWrapper> PHDBWrapList = new List<SearchContact.PHDBInfoWrapper>();
            PHDBWrapList.add(PHDBwrap);
            
            
            // ssc.editnew();
            ssc.contactSearch();
            Test.setMock(HttpCalloutMock.class, new  CCC_HttpRespGeneratorEquipDetailTest());
            ssc.getPHDBInfo('test','test','8799876875', '60008956', '567567', 'test', 'test','345435','test@gmail.com');
            
            ssc.MailingCity='cituy';
            ssc.MailingCountry='county';
            ssc.MailingPostalCode='34545';
            ssc.MailingState='statre';
            ssc.MailingStreet='street';
            ssc.MobilePhone='324345';
            
            ssc.PHDBContactsInfo = PHDBWrapList;
            ssc.editnew();
            ssc.SaveEdit();
            ssc.selected='Residential Contact';
            
            try{
                ssc.UpdateContact();
                ssc.SaveContact();
            }catch(exception e){}
            RecordType rd2 = new RecordType();
            rd2.Name='Partner';
            contact cnt23 = new contact();
            cnt23.LastName='test12';
            cnt23.FirstName='test121';
            cnt23.Email=c.SuppliedEmail;            
            cnt23.Phone='9980608820';
            cnt23.Fax='1256';
            cnt23.MailingStreet='test';
            cnt23.MailingCity='test';
            cnt23.MailingState='test';
            cnt23.MailingCountry='India';
            cnt23.AccountId=acctest.Id;
            //cnt23.RecordTypeId=rd2.id;
            insert cnt23;
            ssc.SaveEditAndAccount();
        }
        
    }
}