public class EquipmentPurposeCtrl {
   
    public class wrapClass{
        @AuraEnabled
        public String purpose{get; set;}
        @AuraEnabled
        public double count{get; set;}
    }
   
    @AuraEnabled
    public static List<wrapClass> lstVal {get;set;}
    public static Map<String, Purpose__c> countMap{get;set;}
    public static List<Purpose__c> countList{get;set;}
    //public static List<String> exstPurposes{get;set;}
    public static List<String> setPGs{get;set;}
    
    @AuraEnabled
    public static List<String> getPGs(Id idOfCase){
       String recordTypeName = [Select Id, RecordType.Name from Case where id=:idOfCase].RecordType.Name;
       List<Picklists_Control__c> PurposeList = [SELECT Id,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= :recordTypeName and Picklist_Field_Name__c='Group' order by Order__c asc];
       setPGs = new List<String>(); 
        setPGs.add('All');
       for(Picklists_Control__c pu : PurposeList){
         setPGs.add(pu.Picklist_Field_Value__c);  
       }
        return setPGs;
    }

    @AuraEnabled
    public static List<wrapClass> getPurposes(Id idOfCase,String selectCmp){
        countList = new List<Purpose__c>();
        List<Picklists_Control__c> PurposeList = new List<Picklists_Control__c>();
        List<wrapClass> lstVal = new List<wrapClass>();
        if(idOfCase!=null){
           countList = [Select Id,Name,Count__c from Purpose__c where Case__c=:idOfCase];
        }
        String recordTypeName = [Select Id, RecordType.Name, RecordType.DeveloperName from Case where id=:idOfCase].RecordType.DeveloperName;
        System.debug('#Record Type Name:'+recordTypeName);
        if(recordTypeName =='Equipment'){
            if(selectCmp != null && selectCmp != '' && selectCmp != 'All'){
              // String s = [SELECT Id,Order__c,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= :recordTypeName and Picklist_Field_Name__c='CCC_Purpose__c' and Picklist_Field_Value__c= :selectCmp].Order__c;
               PurposeList = [SELECT Id,Order__c,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= :recordTypeName and Picklist_Field_Name__c='Multiple Purpose' and Controlling_Field_Value__c= :selectCmp order by Order__c asc];
            }
            else{
               PurposeList = [SELECT Id,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= :recordTypeName and Picklist_Field_Name__c='Multiple Purpose' order by Order__c asc];
            }
        }
       else{
            if(selectCmp != null && selectCmp != '' && selectCmp != 'All'){
              // String s = [SELECT Id,Order__c,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= :recordTypeName and Picklist_Field_Name__c='CCC_Purpose__c' and Picklist_Field_Value__c= :selectCmp].Order__c;
               PurposeList = [SELECT Id,Order__c,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= :recordTypeName and Picklist_Field_Name__c='Multiple Purpose' and Controlling_Field_Value__c= :selectCmp order by Order__c asc];
            }
            else{
               PurposeList = [SELECT Id,Picklist_Field_Value__c FROM Picklists_Control__c where Record_Type__c= :recordTypeName and Picklist_Field_Name__c='Multiple Purpose' order by Order__c asc];
            }
        }  
        System.debug('#PurposeList:'+PurposeList);
        System.debug('#Quey Res:'+[SELECT Id,Order__c,Record_Type__c,Picklist_Field_Value__c FROM Picklists_Control__c]);
        countMap = new Map<String, Purpose__c>();
        for(Purpose__c pu : countList){
          countMap.put(pu.Name,pu);  
        }
        for(Picklists_Control__c pickCntrl : purposeList){
            if(pickCntrl.Picklist_Field_Value__c!=null && pickCntrl.Picklist_Field_Value__c.length()>0){
                if(countMap.containsKey(pickCntrl.Picklist_Field_Value__c)){
                   Purpose__c a = countMap.get(pickCntrl.Picklist_Field_Value__c);
                   wrapClass wrp = new wrapClass();
                   if(a.Count__c == 0){
                     a.Count__c = null;   
                   }
                   wrp.count = a.Count__c;
                   wrp.purpose = pickCntrl.Picklist_Field_Value__c;
                   lstVal.add(wrp);
                }
                else{
                   wrapClass wrp = new wrapClass();
                   wrp.count = null;
                   wrp.purpose = pickCntrl.Picklist_Field_Value__c;
                   lstVal.add(wrp); 
                }
            }
        }      
        return lstVal;
    }    
    
    /*@AuraEnabled
    public static List<wrapClass> savePurpose(List<wrapClass> lstOfPurp,Id idOfCase){
        System.debug('#lstOfPurpStr:'+lstOfPurp);
        System.debug('#idOfCase:'+idOfCase);
        return null;
    }*/
  @AuraEnabled
  public static void savePurpose(String lstOfPurpStr,Id idOfCase){
      System.debug('#lstOfPurpStr:'+lstOfPurpStr);
      System.debug('#idOfCase:'+idOfCase);
     List<wrapClass> lstOfPurp = (List<wrapClass>)JSON.deserialize(lstOfPurpStr, List<wrapClass>.class);
      System.debug('#lstOfPurp:'+lstOfPurp);
    countList = [Select Id,Name,Count__c from Purpose__c where Case__c=:idOfCase];
      System.debug('#countList:'+countList);
    countMap = new Map<String, Purpose__c>();
    System.debug('wow'+lstOfPurp);
      for(Purpose__c pu : countList){
          countMap.put(pu.Name,pu);  
      }
      for(wrapClass wc : lstOfPurp){
             if(countMap.containsKey(wc.purpose)){
                Purpose__c p = countMap.get(wc.purpose);
                if(wc.count == null){
                  wc.count = 0;    
                }
                p.Count__c = wc.count;
                update p;
             }
             else{
                Purpose__c p = new Purpose__c();
                p.Name = wc.purpose;
                if(wc.count == null){
                  wc.count = 0;    
                }
                p.Count__c = wc.count;
                p.Case__c = idOfCase;
                insert p;
            }
      }
          String recordTypeName = [Select Id, RecordType.Name from Case where id=:idOfCase].RecordType.Name;
          system.debug('recordTypeName'+recordTypeName);
          case c = new case();
          Purpose__c p = new Purpose__c();
          if(recordTypeName == 'Replacement Component (RC)')
          {
           system.debug('recordTypeName'+recordTypeName);   
          List<Purpose__c> p1= [SELECT Id,Count__c, Name FROM Purpose__c where Case__c=:idOfCase];
           Case c1 = [Select id from case where id = :idOfCase];   
        //   if(p1.size()>0){
              for(Purpose__c p2 : p1){
                
              
           if(p2.Count__c != 0 && p2.Name == 'Expedite')
           {
               
               c1.CCC_Purpose__c = 'Expedite';
               c1.CCC_Sub_Purpose__c= 'Expedite';
               c1.CCC_Expedite_Status__c ='Expedite';
           }
              else{
                  System.debug('expedite');
              }
              }
             update c1;
                  
         // }
  }
      
      
  }
     @AuraEnabled
    public static void updateClaim(Id idOfCase){
        if(idOfCase!=null){
            Case cse = [Select Id, Is_Claim__c from Case where id=:idOfCase];
            cse.Is_Claim__c = true;
            String recordTypeName = [Select Id, RecordType.Name, RecordType.DeveloperName from Case where id=:idOfCase].RecordType.DeveloperName;
            if(recordTypeName=='Equipment'){
                cse.Claims_Order_Type__c = 'Equipment';
            }else{
                 cse.Claims_Order_Type__c = 'FAST PARTS';
            }
            
            update cse;
        }
    }
}