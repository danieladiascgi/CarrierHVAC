Public Class AssignDSMController {
    
    Public Case objCase{get;set;}
    public Contact objContact{get; set;}
    public Contact ph{get;set;}
    public String brandSelected{get; set;}
    public string searchDSMText{get;set;}
    public list<SelectOption> BrandOption {get; set;} 
    List<DSM_Distributor_Directory__c>  lstdist{get; set;}
    public List<AllDistributors> lstAllDist{get; set;}
    public List<AllDistributors> searchLstAllDist{get; set;}
    public List<AllDistributors> searchLstDist{get; set;}
    public Map<String, DSM_Distributor_Directory__c> mapDistIdKeyDistVal{get; set;}
    //List<DSM_Distributor_Directory__c> c = new List<DSM_Distributor_Directory__c>();
    public list <AllAsset> lstAsset {get ; set;}
    public Map<String, Asset> mapAstIdKeyAstVal{get; set;}
    public Map<Id, CCC_junctionCaseAsset__c> junctionIdKeyObjMap{get; set;}
    public Map<Id, Id> assetIdKeyJuncIdValue{get; set;}
    public String selectedPrimaryAssetId{get; set;}
    public String selectedDistId{get; set;}
    public Boolean isPrimaryEquipSelEnabled{get; set;}
    public Boolean isDistSelEnabled{get; set;}
    public Boolean showEquipmentSelTable{get; set;}
    //public List<DSM_Distributor_Directory__c> listOfDistributors{get; set;}
    public boolean showDesc{get; set;}
    
    public AssignDSMController(ApexPages.StandardController controller) {
        objCase = (Case)controller.getRecord();
        lstdist = new List<DSM_Distributor_Directory__c>();
        junctionIdKeyObjMap = new Map<Id, CCC_junctionCaseAsset__c>();
        assetIdKeyJuncIdValue = new Map<Id, Id>();
        isPrimaryEquipSelEnabled = false;
        showEquipmentSelTable = false;
        lstAllDist = new List<AllDistributors>();
        searchLstAllDist = new List<AllDistributors>();
        searchLstDist = new List<AllDistributors>();
        mapDistIdKeyDistVal = new Map<String, DSM_Distributor_Directory__c>();
        mapAstIdKeyAstVal = new Map<String, Asset>();
        BrandOption = new list<SelectOption>();
        BrandOption.add(new SelectOption('',''));
        BrandOption.add(new SelectOption('Carrier','Carrier'));
        BrandOption.add(new SelectOption('Bryant','Bryant'));
        BrandOption.add(new SelectOption('Payne','Payne'));
        brandSelected = '';
        searchDSMText = '';
        isDistSelEnabled = false;
        showDesc = false;
        
        
    }
    
    public PageReference init(){
        
        objCase = [SELECT contactId, contact.MailingStreet,contact.MailingState,contact.MailingCity,contact.MailingPostalCode,Contact.Phone,CCC_Brand__c,CCC_Distributor_s_Name__c FROM Case where Id=:objCase.Id];
        System.debug('#objCase Contact:'+objCase.ContactId);
        System.debug('#objCase Brand:'+objCase.CCC_Brand__c);
        if(objCase.contactId==null || (objCase.contact.MailingPostalCode==null)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Case should have contact/zip associated!!!'));
            return null;
        }
        if(objCase.CCC_Brand__c==null || objCase.CCC_Brand__c.length()==0){
            System.debug('#inside brand');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Case should have brand associated, Please select Brand or Primary equipment!!!'));
            isPrimaryEquipSelEnabled = true;
            return null;
        }
        lstAsset = getAllAssets();
        /*PageReference redirectPage = new PageReference('/'+objCase.Id);
redirectPage.setRedirect(true);
return redirectPage;*/
        proceedWithAssignment();
        // searchDSM();
        //return proceedWithAssignment();
        return null;
    }
    public list<AllAsset> getAllAssets(){
        list<AllAsset> lstAssetTemp = new list<AllAsset>();
        set<Id> AssetIds = new set<Id>();
        //insert junction asset in list
        for(CCC_junctionCaseAsset__c objJunction:[select Id,Asset__c, primary__c from CCC_junctionCaseAsset__c where Case__c =:objCase.Id]){
            AssetIds.add(objJunction.Asset__c);
            System.debug('#junctionIdKeyObjMap:'+junctionIdKeyObjMap);
            System.debug('#objJunction:'+objJunction);
            System.debug('#objJunction.Id:'+objJunction.Id);
            
            junctionIdKeyObjMap.put(objJunction.Id, objJunction);
            assetIdKeyJuncIdValue.put(objJunction.Asset__c, objJunction.Id);
        }
        
        //maps to Asset object and redirects to CCC_EquipmentDetail page with parameters Serial Number, Model Number, Brand and Discrete Model Number
        for(Asset objAsset:[Select Id,Brand__c,Toss_Code__c,Product_Hierarchy__c,CCC_Disc_Model_Number__c,CCC_Model_Number__c,SerialNumber,CCC_Validation_status__c,CCC_Installing_Dealer__c,Ship_Date__c  from Asset where Id = :AssetIds]){
            System.debug('#Asset:'+objAsset);
            System.debug('#lstAssetTemp:'+lstAssetTemp);
            //String strUrl = '/apex/CCC_EquipmentDetail?sn='+objAsset.SerialNumber+'&mn='+objAsset.CCC_Model_Number__c+'&br='+objAsset.Brand__c+'decmn='+objAsset.CCC_Disc_Model_Number__c;
            lstAssetTemp.add(new AllAsset(objAsset,'', assetIdKeyJuncIdValue.get(objAsset.Id)));
            mapAstIdKeyAstVal.put(objAsset.Id, objAsset);
            //IsAssetShow = true;
        }
        return lstAssetTemp;
    }
    public PageReference getSelected()
    {
        selectedPrimaryAssetId = ApexPages.currentPage().getParameters().get('primaryAssetId');
        System.debug('#selectedPrimaryAssetId:'+selectedPrimaryAssetId);
        List<CCC_junctionCaseAsset__c> updateJuncAssetWithPrimary = new List<CCC_junctionCaseAsset__c>();
        if(lstAsset!=null && lstAsset.size()>0){
            for(AllAsset eachAst : lstAsset){
                CCC_junctionCaseAsset__c juncAst = junctionIdKeyObjMap.get(eachAst.junctionAssetId);
                if(selectedPrimaryAssetId.equals(eachAst.objAsset.Id)){
                    //eachAst.objAsset.Primary__c=true;
                    //updateAssetsWithPrimary.add(eachAst.objAsset);
                    
                    juncAst.Primary__c = true;
                    updateJuncAssetWithPrimary.add(juncAst);
                    //cse.TOS_Code__c = eachAst.objAsset.TOSS_Code__c;
                    //cse.CCC_Serial_Number__c = eachAst.objAsset.SerialNumber;
                    //cse.CCC_Model_Number__c = eachAst.objAsset.CCC_Model_Number__c;
                    //cse.Ship_Date__c = eachAst.objAsset.Ship_Date__c;
                    //System.debug('#assetDate:'+eachAst.objAsset.Ship_Date__c);
                }else{
                    //eachAst.objAsset.Primary__c=false;
                    //updateAssetsWithPrimary.add(eachAst.objAsset);
                    juncAst.Primary__c = false;
                    updateJuncAssetWithPrimary.add(juncAst);
                }
            }
        }
        System.debug('#updateJuncAssetWithPrimary:'+updateJuncAssetWithPrimary);
        if(mapAstIdKeyAstVal!=null && mapAstIdKeyAstVal.size()>0 && mapAstIdKeyAstVal.containsKey(selectedPrimaryAssetId)){
            Asset ast = mapAstIdKeyAstVal.get(selectedPrimaryAssetId);
            objCase.CCC_Brand__c = ast.Brand__c;
            update objCase;
        }
        if(updateJuncAssetWithPrimary!=null){
            update updateJuncAssetWithPrimary;
            System.debug('updated');
            isPrimaryEquipSelEnabled = false;
            System.debug('#returning ');
            proceedWithAssignment();
            
            //return proceedWithAssignment();
        }
        return null;
    }
    public void proceedWithAssignment(){
        System.debug('#proceed method');
        objContact = [Select Id,MailingState,Enrichment_Payload__c,Phone from Contact where Id=:objCase.ContactId];
        System.debug('#objContact:'+objContact);
        //objCase = [Select Id,contact.MailingState from case where Id=:objCase.ContactId];
        //System.debug('#objCase :'+objCase);
        if(objContact.Enrichment_Payload__c==null || objContact.Enrichment_Payload__c.length()==0){
            System.debug('#Inside Enrichment_Payload__c null');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Address is not verified!!!'));
        }else{
            System.debug('contact.MailingPostalCode:'+objCase.contact.MailingPostalCode);
            String zip = String.valueOf(objCase.contact.MailingPostalCode);
            System.debug('contact.MailingState :'+objCase.contact.MailingState);
            String State = String.valueOf(objCase.contact.MailingState);
            System.debug('#State:'+State);
            System.debug('contact.Phone:'+objCase.contact.Phone);
            String Ph= String.valueOf(objCase.contact.Phone);
            //ph = [Select Phone from contact where Phone LIKE '905%'];
            String stateCode = '';
            String countryCode = '';
            System.debug('#zip:'+zip);
            if(!zip.isAlphanumericSpace() && (objContact.Enrichment_Payload__c.contains('STATE_FIPS_CODE') || objContact.Enrichment_Payload__c.contains('COUNTY_FIPS_CODE'))){
                Dom.Document doc = new Dom.Document();
                String enrichmentPayload = objContact.Enrichment_Payload__c;
                if(enrichmentPayload!=null && enrichmentPayload.length()>0 && enrichmentPayload.contains('&lt;')){
                    enrichmentPayload = enrichmentPayload.replaceAll('&lt;', '<');
                    enrichmentPayload = enrichmentPayload.replaceAll('&gt;', '>');
                }
                System.debug('#Enrichment Payload after correction:'+enrichmentPayload);
                doc.load(enrichmentPayload);
                Dom.XMLNode root = doc.getRootElement(); 
                stateCode =  root.getChildElement('STATE_FIPS_CODE',root.getNamespace()).gettext();
                countryCode =  root.getChildElement('COUNTY_FIPS_CODE',root.getNamespace()).gettext();
            }      
            System.debug('State_Fips_Code :'+stateCode);
            System.debug('County_Fips_Code :'+countryCode);
            System.debug('##Brand:'+objCase.CCC_Brand__c);
            String brand = '';
            brand = objCase.CCC_Brand__c;
            if((brand==null || brand.length()==0) && brandSelected!=null && brandSelected.length()>0){
                brand  = brandSelected;
            }
            if(objCase.CCC_Brand__c!=null && objCase.CCC_Brand__c.equals('CAR')){
                brand = 'Carrier';
            }else if(objCase.CCC_Brand__c!=null && objCase.CCC_Brand__c.equals('BRY')){
                brand = 'Bryant';
            }else if(objCase.CCC_Brand__c!=null && objCase.CCC_Brand__c.equals('PAY')){
                brand = 'Payne';
            }
            objCase.CCC_Brand__c = brand;
            String fipsCode = stateCode + countryCode;
            System.debug('#FIPS Code:'+fipsCode);
            //lstdist = [select id, Distributor_Name__c, Contact_Name__c,Distributor_ID__c,Contact_Id__c from DSM_Distributor_Directory__c where FIPS_Code__c =: fipsCode AND Brand__c =:brand];      
            //String zip = String.valueOf(contact.MailingPostalCode);
            boolean isCanadaAssociationSuccessful = false;
            boolean isCanadianAddress = false;
            User u = new user();
            
            Pattern NonAlphanumeric = Pattern.compile('.*[a-zA-Z].*');
            Matcher matcher = NonAlphanumeric.matcher(zip);
            System.debug('Matcher Matches:'+matcher.matches());  
            if(matcher.matches()){
                isCanadianAddress = true;
                if(ph!=null && ph.contains('(')){
                    ph = ph.replaceAll('\\(', '');
                }
                if(ph!=null && ph.contains(')')){
                    ph = ph.replaceAll('\\)', '');
                }
            }else{
                isCanadianAddress = false;
            }
            if(isCanadianAddress && (State!=null) && (State.equals('AB'))){
                system.debug('Inside if');
                u = [SELECT Name, Id FROM User where Name ='Dominic Poulin' limit 1];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //  objCase.OwnerId='00515000006Up6G';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
                //lstdist = [select id, Distributor_Name__c, Contact_Name__c,Distributor_ID__c,Contact_Id__c,County_Name__c from DSM_Distributor_Directory__c where Distributor_Name__c Like 'CARRIER CANADA%' AND Brand__c =:brand];         
            }
            
            else if(isCanadianAddress && (State!=null) && (State.equals('BC'))){
                u = [SELECT Name, Id FROM User where Name ='Joey Kosowan' limit 1];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //     objCase.OwnerId='00515000006Up3s';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            }
            
            else if(isCanadianAddress && (State!=null) && (State.equals('NS') || State.equals('NL') || State.equals('NB') || State.equals('PE')) && ((ph.startsWith('905')) || (ph.startsWith('289')))){
                u = [SELECT Name, Id FROM User where Name ='Graham Hogarth'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //   objCase.OwnerId='00515000006Up3L';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            } 
            else if(isCanadianAddress && (State!=null) && (State.equals('NS') || State.equals('NL') || State.equals('NB') || State.equals('PE')) && ((ph.startsWith('519')) || (ph.startsWith('226')) || (ph.startsWith('548')))){
                u = [SELECT Name, Id FROM User where Name ='Bradley Nakamura'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //   objCase.OwnerId='00515000006Up3L';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            }
            else if(isCanadianAddress && (State!=null) && (State.equals('NS') || State.equals('NL') || State.equals('NB') || State.equals('PE')) && ((ph.startsWith('807')) || (ph.startsWith('437')) || (ph.startsWith('365')))){
                u = [SELECT Name, Id FROM User where Name ='Curtis Schierholtz'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //   objCase.OwnerId='00515000006Up3L';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            }
            else if(isCanadianAddress && (State!=null) && (State.equals('NS') || State.equals('NL') || State.equals('NB') || State.equals('PE')) && ((ph.startsWith('247')) || (ph.startsWith('705')) || (ph.startsWith('819'))|| (ph.startsWith('873'))|| (ph.startsWith('343'))|| (ph.startsWith('613')))){
                u = [SELECT Name, Id FROM User where Name ='Curtis Schierholtz'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //   objCase.OwnerId='00515000006Up3L';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            }
            else if(isCanadianAddress && (State!=null) && (State.equals('NS') || State.equals('NL') || State.equals('NB') || State.equals('PE')) && ((ph.startsWith('613')) || (ph.startsWith('506')) || (ph.startsWith('902'))|| (ph.startsWith('709'))|| (ph.startsWith('343'))|| (ph.startsWith('807')))){
                u = [SELECT Name, Id FROM User where Name ='Alein Bertrand'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //   objCase.OwnerId='00515000006Up3L';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            }
            else if(isCanadianAddress && (State!=null) && (State.equals('NS') || State.equals('NL') || State.equals('NB') || State.equals('PE')) && ((ph.startsWith('416')) || (ph.startsWith('647')))){
                u = [SELECT Name, Id FROM User where Name ='Omar Gulban'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //   objCase.OwnerId='00515000006Up3L';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            }
            else if(isCanadianAddress && (State!=null) && (State.equals('ON')) && ((ph.startsWith('905')) || (ph.startsWith('289')) /*|| (ph.startsWith('365'))*/)){
                u = [SELECT Name, Id FROM User where Name ='Graham Hogarth'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //   objCase.OwnerId='00515000006Up3L';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            } 
            else if(isCanadianAddress && (State!=null) && (State.equals('ON')) && ((ph.startsWith('519')) || (ph.startsWith('226')) || (ph.startsWith('548')))){
                u = [SELECT Name, Id FROM User where Name ='Bradley Nakamura'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //  objCase.OwnerId='00515000006Up5b';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            } 
            else if(isCanadianAddress && (State!=null) && (State.equals('ON')) && ((ph.startsWith('807')) || (ph.startsWith('365')) || (ph.startsWith('437')))){
                u = [SELECT Name, Id FROM User where Name ='Curtis Schierholtz'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //    objCase.OwnerId='00515000006Up6d';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            } 
            else if(isCanadianAddress && (State!=null) && (State.equals('ON')) && ((ph.startsWith('247')) || (ph.startsWith('705')) || (ph.startsWith('819')) || (ph.startsWith('873')) || (ph.startsWith('343')) || (ph.startsWith('613')))){
                u = [SELECT Name, Id FROM User where Name ='Curtis Schierholtz'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //    objCase.OwnerId='00515000006Up6d';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            } 
            else if(isCanadianAddress && (State!=null) && (State.equals('ON')) && ((ph.startsWith('613')) || (ph.startsWith('506')) || (ph.startsWith('902')) || (ph.startsWith('709')) || (ph.startsWith('343')) || (ph.startsWith('807')))){
                u = [SELECT Name, Id FROM User where Name ='Alein Bertrand'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //  objCase.OwnerId='005g0000004Bcv4';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            } 
            else if(isCanadianAddress && (State!=null) && (State.equals('ON')) && ((ph.startsWith('416')) || (ph.startsWith('647')))){
                u = [SELECT Name, Id FROM User where Name ='Omar Gulban'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //  objCase.OwnerId='005g0000004Bcv4';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            } 
            else if(isCanadianAddress && (State!=null) && (State.equals('QC'))){
                u = [SELECT Name, Id FROM User where Name ='Alein Bertrand'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //  objCase.OwnerId='005g0000004BiB7';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            }
            else if(isCanadianAddress && (State!=null) && (State.equals('SK'))){
                u = [SELECT Name, Id FROM User where Name ='Dominic Poulin'];
                system.debug('userid'+u.id);
                objCase.OwnerId= u.id;  
                system.debug('objCase.OwnerId'+objCase.OwnerId);
                //  objCase.OwnerId='005g0000004BiB7';
                update objCase;
                isCanadaAssociationSuccessful = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            }
            else if(zip!=null && isCanadianAddress){
                System.debug('#Zip does not match show all Canada distributors!');
                System.debug('#zip.isAlphanumericSpace():'+zip.isAlphanumericSpace());
                System.debug('#State ON:'+State.equals('ON'));                
                System.debug('#Phone Starts with:'+ph.startsWith('613'));
                showDesc = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'There are no distributors in this area.Please search manually!'));
                lstdist = [select id, Distributor_Name__c, Contact_Name__c,Distributor_ID__c,Contact_Id__c,County_Name__c,Description__c from DSM_Distributor_Directory__c where Distributor_Name__c Like 'CARRIER CANADA%' AND Brand__c =:brand];        
            }
            else{
                system.debug('Inside else');
                if(fipsCode!=null && fipsCode.length()>0 && fipsCode.trim().length()>0){
                    System.debug('#Fips Code To Query:'+fipsCode);
                    System.debug('#Brand Code To Query:'+brand);
                    lstdist = [select id, Distributor_Name__c, Contact_Name__c,Distributor_ID__c,Contact_Id__c,County_Name__c,Description__c from DSM_Distributor_Directory__c where FIPS_Code__c =: fipsCode AND Brand__c =:brand];   
                }
                
            }   
            system.debug('#lstdist:'+lstdist);
            if(lstdist!=null && lstdist.size()>1){
                for(DSM_Distributor_Directory__c eachDist : lstdist){
                    AllDistributors dist = new AllDistributors(false, eachDist);
                    lstAllDist.add(dist);
                    mapDistIdKeyDistVal.put(eachDist.Id, eachDist);
                }
                isDistSelEnabled = true;
            }else if(lstdist!=null && lstdist.size()==1){
                selectedDistId = lstdist.get(0).Id;
                mapDistIdKeyDistVal.put(lstdist.get(0).Id, lstdist.get(0));
                proceedWithSelectedDist();
                //return proceedWithSelectedDist();
            }else if(!isCanadaAssociationSuccessful){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'There are no distributors in this area.Please search manually!'));
            }
        }
        //return null;
    } 
    public Class AllAsset{
        public Asset objAsset{get;set;}
        public String strURL{get;set;}
        public String junctionAssetId{get;set;}
        public AllAsset(Asset objAsset, String strURL, String junctionAssetId){
            this.objAsset = objAsset;
            this.strURL = strURL;
            this.junctionAssetId = junctionAssetId;
        }
    }
    public PageReference proceedWithSelectedDist(){
        System.debug('#selected dist:'+selectedDistId);
        if(!mapDistIdKeyDistVal.containsKey(selectedDistId)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'There are no distributors in this area.Please search manually!'));
            return null;
        }
        DSM_Distributor_Directory__c distToAssign = mapDistIdKeyDistVal.get(selectedDistId);
        System.debug('#distToAssign:'+distToAssign);
        objCase.CCC_Distributor_s_Name__c = distToAssign.Distributor_ID__c;
        System.debug('#contact Id:'+distToAssign.Contact_ID__c);
        List<User> lstDistributorUser = [Select Id from User where isActive=true and ContactId=:distToAssign.Contact_ID__c];
        System.debug('#lstDistributorUser:'+lstDistributorUser);
        System.debug('#lstDistributorUser:'+lstDistributorUser.size());
        System.debug('#brandSelected:'+brandSelected);
        if(brandSelected!=null && brandSelected.length()>0){
            objCase.CCC_Brand__c = brandSelected;
        }
        
        if(lstDistributorUser!=null && lstDistributorUser.size()>0){
            objCase.ownerid=lstDistributorUser.get(0).Id;
            System.debug('#ownerid:'+objCase.ownerid);
            update objCase;     
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully associated distributor!!!'));
            
        }else{           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'There\'s no DSM User for Contact ['+distToAssign.Contact_Name__c+']. Please search and associate manually!'));
            return null;
            
        }
        
        PageReference pr = new PageReference('/'+objCase.Id);
        system.debug('pr'+pr);
        pr.setRedirect(true);
        return pr;
    }
    public PageReference getSelectedDist()
    {
        return null;
    }
    public Class AllDistributors{
        public boolean selected{get; set;}
        public DSM_Distributor_Directory__c eachDist{get; set;}
        public AllDistributors(Boolean selected, DSM_Distributor_Directory__c eachDist){
            this.selected = selected;
            this.eachDist = eachDist;
        }
    }
    public void getSelectedDSM()
    {
        selectedDistId = ApexPages.currentPage().getParameters().get('selectedDSMId');
        System.debug('#selectedDistId:'+selectedDistId);
        proceedWithSelectedDist();
        
        // return null;
    }
    
    public void searchDSM(){
        
        if(searchDSMText == null || searchDSMText == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value');
            ApexPages.addMessage(myMsg); 
        }
        else{
            string dsm = searchDSMText;
            string dsmRes = 'Find\'' + dsm + '\'IN ALL FIELDS RETURNING DSM_Distributor_Directory__c(id, Distributor_Name__c, Contact_Name__c,Distributor_ID__c,Contact_Id__c,County_Name__c)';
            System.debug('#dsmRes:'+dsmRes);
            List<List<SObject>> lstdist= search.query(dsmRes);
            system.debug('result'+lstdist.size()); 
            system.debug('result'+lstdist);
            
            if(lstdist!=null && lstdist.size()>0)
            {
                List<SObject> lstOfSerchdDist = lstdist.get(0);
                system.debug('final result'+lstOfSerchdDist);
                system.debug('final result size'+lstOfSerchdDist.size());
                lstAllDist.clear();
                if(lstOfSerchdDist!=null && lstOfSerchdDist.size()>0){
                    
                    for(SObject obj : lstOfSerchdDist){
                        DSM_Distributor_Directory__c eachDist = (DSM_Distributor_Directory__c)obj;
                        AllDistributors dist = new AllDistributors(false, eachDist);
                        lstAllDist.add(dist);
                        system.debug('for loop'+lstAllDist);
                        mapDistIdKeyDistVal.put(eachDist.Id, eachDist);
                        
                    }
                }else{
                    system.debug('else loop');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No records found'));
                }
                isDistSelEnabled = true;
            }else{
                system.debug('else loop');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No records found'));
            }
        }
    }
}