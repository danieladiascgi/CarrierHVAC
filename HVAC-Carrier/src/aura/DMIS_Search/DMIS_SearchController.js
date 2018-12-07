({ 
    doInit : function(component, event, helper) {
        
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        setTimeout(function(){ helper.closeModalHere(component); }, 3000);
        var recordId = component.get("v.recordId");
        var action2 = component.get("c.getCaseSubject");
        action2.setParam("recrdId", recordId);
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){     
              var cs = response.getReturnValue();
              //alert('cs..'+JSON.stringify(cs));
              component.set("v.searchKeyword",cs.Subject );
              component.set("v.searchByBrand",cs.CCC_Brand__c ); 
              component.set("v.searchByModelNo",cs.CCC_Model_Number__c );   
              //alert('values..'+cs.Subject+cs.CCC_Brand__c+cs.CCC_Model_Number__c);
        
        var action = component.get("c.getListDocs");
      //action.setParam("CaseId", recordId); 
        var srchKeyword = component.get("v.searchKeyword");
        var srchByBrand = component.get("v.searchByBrand");
        var srchByModelNo = component.get("v.searchByModelNo");
        action.setParams({"CaseId" : recordId , "showMoreResultsflag" : false, "srchKeyword" : srchKeyword, "srchByBrand" : srchByBrand, "srchByModelNo" : srchByModelNo });
        //action.setParams({"CaseId" : recordId , "showMoreResultsflag" : false});
        var listofDocs = component.get("v.lstDocs");
        var listDocs = JSON.stringify(listofDocs);
    //    var recordId = component.get("v.recordId");
        var action1 = component.get("c.addSuggetedDocument");
        action1.setParams({"CaseId2" : recordId});       
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('Success');
                component.set("v.lstDocs", response.getReturnValue());
             //   component.set("v.suggDocs", response.getReturnValue());
               // alert('wowww'+JSON.stringify(component.get("v.lstDocs")));
                //$A.get('e.force:refreshView').fire();

            } else{
                alert('Error:');
            }
        });
        
        $A.enqueueAction(action);
        action1.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                 //  window.location.reload();
              component.set("v.suggDocs", response.getReturnValue());
                //alert('success'+JSON.stringify(component.get("v.lstDocs")));
            } else{
                //alert('Error:');
            }
        });
        
        $A.enqueueAction(action1);
        } else{
                alert('Error:');
            }
        });
        $A.enqueueAction(action2);
    },
    
   
	sectionOne : function(component, event, helper) {
       helper.helperFun(component,event,'articleOne');
    },
    
    sectionTwo : function(component, event, helper) {
      helper.helperFun(component,event,'articleTwo');
    },
   
    
    closeModal:function(component,event,helper){ 
        //component.set("v.dispayModal",false);
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    
    onSelectChange : function(component,event,helper){
        component.set("v.setBrandVal",true);
    },
    
    /*openmodal: function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },*/
    
	findDocument : function(component, event, helper) {
        helper.helperFun(component,event,'articleTwo');
        var recordId = component.get("v.recordId");
        var action = component.get("c.getListDocs");
        var srchKeyword = component.find("Subject").get("v.value");
        if(component.get("v.setBrandVal") == true){
           var srchByBrand = component.find("Brand").get("v.value");
        }
        else{
           var srchByBrand = component.get("v.searchByBrand");
        }
        //alert('eee'+srchByBrand);
        if(srchByBrand == '-None-'){
            srchByBrand =null;
        }
        var srchByModelNo = component.find("modelno").get("v.value");
        action.setParams({"CaseId" : recordId , "showMoreResultsflag" : false, "srchKeyword" : srchKeyword, "srchByBrand" : srchByBrand, "srchByModelNo" : srchByModelNo});
        //action.setParam("CaseId", recordId);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('Success');
                component.set("v.lstDocs", response.getReturnValue());
                //alert('wowww'+JSON.stringify(component.get("v.lstDocs")));
                //$A.get('e.force:refreshView').fire();

            } else{
                alert('Error:');
            }
        });
        $A.enqueueAction(action);
           	
	},
    
    addDocument : function(component, event, helper) {
        
        var listofDocs = component.get("v.lstDocs");
        var listDocs = JSON.stringify(listofDocs);
        var recordId = component.get("v.recordId");
        component.set("v.showRemovedListSection", true);
        component.set("v.showMoreDocumentSection", false);
        component.set("v.showSection", false);
        //alert('gggggg');
        
        var action = component.get("c.SuggestedDocument");
        action.setParams({"documentLst" : listDocs , "CaseId" : recordId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                //window.location.reload();
                component.set("v.lstDocs", response.getReturnValue());
              var action1 = component.get("c.addSuggetedDocument");
              action1.setParams({"CaseId2" : recordId});
              action1.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    //  window.location.reload();
                    component.set("v.suggDocs", response.getReturnValue());
                    //alert('success'+JSON.stringify(component.get("v.lstDocs")));
                } else{
                    //alert('Error:');
                }
            });
        
           $A.enqueueAction(action1);
                //alert('wwwww'+response.getReturnValue());
                $A.get('e.force:refreshView').fire();
                //alert('success'+JSON.stringify(component.get("v.lstDocs")));
            } else{
                alert('Error:');
            }
        });
        $A.enqueueAction(action);
    },
    
    showMoreRecords : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.showMoreDocs");
        component.set("v.showMoreDocumentSection", true);
        component.set("v.showSection", false);     
        component.set("v.showRemovedListSection", false);
     
        var srchKeyword = component.find("Subject").get("v.value");
        var srchByBrand = component.find("Brand").get("v.value");
        var srchByModelNo = component.find("modelno").get("v.value");
         if(srchByBrand == '-None-'){
            srchByBrand =null;
        }
        //alert('recordId..'+recordId);
        action.setParams({"caseId3" : recordId, "srchKeyword" : srchKeyword, "srchByBrand" : srchByBrand, "srchByModelNo" : srchByModelNo});
        //action.setParams({"CaseId" : recordId , "srchKeyword" : srchKeyword});
        //action.setParam("caseId", recordId);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('Success');
                component.set("v.lstDocs", response.getReturnValue());           
   
            } else{
                alert('Error:');
            }
        });
        $A.enqueueAction(action);
    },
    
    Cancel : function(component, event, helper){
         window.location.reload();
    },
    
    keywordChange: function(component, event, helper) {
    //  alert(event.getSource().get("v.value"));
    var newWord = event.getSource().get("v.value");
    component.set("v.Subject", newWord);
       //alert(dependentValueKey);
   },
})