({
    
    doInit : function(component, event, helper) {
        helper.fetchExpListVal(component, 'Expedite_Status__c', 'expstatus');
        component.set("v.isError", false);
        component.set("v.showEditView", false);
        component.set("v.errorMsg", "");
        
        var action = component.get("c.getExpedite");
        action.setParams({
            "id" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.Expedite", a.getReturnValue());
                //  alert('exp'+JSON.Stringify(a.getReturnValue()));
                var cs = a.getReturnValue();
                // alert('cssss'+JSON.Stringify(cs));
                component.set("v.PickReason",cs.Resolution_Code__c);
                component.set("v.PickTB",cs.Turnback__c);
                component.set("v.PickStatus",cs.Expedite_Status__c);
                //alert(cs.Expedite_Status__c);
                // component.set("v.defCode",cs.CCC_Defect_Code__c);
                // component.set("v.defSubCode",cs.CCC_Defect_Sub_Code__c);
            }
        });
        
        $A.enqueueAction(action);
        
        var action1 = component.get("c.getTurnback");
        action1.setParams({
            "id" : component.get("v.recordId")
        });
        
        action1.setCallback(this, function(a) {
            if (a.getState() == "SUCCESS") {
                //  alert('#a.getReturnValue():of turnback'+JSON.stringify(a.getReturnValue()));
                component.set("v.Turnback", a.getReturnValue());
            }
        });
        
        $A.enqueueAction(action1);
        
        var action2 = component.get("c.getResolutionCode");
        action2.setParams({
            "id" : component.get("v.recordId")
        });
        
        action2.setCallback(this, function(a) {
            if (a.getState() == "SUCCESS") {
                //  alert('#a.getReturnValue(): of resolution'+JSON.stringify(a.getReturnValue()));
                component.set("v.Reasons", a.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
        
      /*  var action3 = component.get("c.getselectOptions");
        action3.setParams({
            "id" : component.get("v.recordId")
          //  "objObject": component.get("v.Expedite"),
           // "fld": Expedite_Status__c
        });
        
        action3.setCallback(this, function(a) {
            if (a.getState() == "SUCCESS") {
                // alert('#a.getReturnValue():of status'+JSON.stringify(a.getReturnValue()));
                component.set("v.PickStatus", a.getReturnValue());
            }
        });
        
        $A.enqueueAction(action3);*/
        
        //helper.getPlannerInformation(component, event);
        
    },
    
    handleOnLoad : function(component, event, helper) {
        
    },
    
    onSelectChange : function(component, event, helper) {
        // component.set("v.checkedRC",true);
        var selected = component.find("rcode").get("v.value");
        component.set("v.selVal",selected);
    },
    
    onTBChange : function(component, event, helper) {
        component.set("v.turnbackDefault",true);
        var selectedTB = component.find("Turnback").get("v.value");
        component.set("v.selValTB",selectedTB);
    },
    
    onStatusChange : function(component, event, helper) {
        // alert('status change');
        //  alert(event.getSource().get("v.value"));
        //component.set("v.checkedstatus",true);
        var selectedStatus = component.find("expstatus").get("v.value");
        component.set("v.selValStatus",selectedStatus);
    },
    
    saveCaseAndClose : function(component, event, helper) {
        component.set("v.displayTurnback",false);
        component.set("v.displaySolution",false);
        //  component.set("v.displayResolution",false);
        //  component.set("v.displayDefectCode",false);
        //  component.set("v.displayDefectSubCode",false);
        //  component.set("v.displayPurpose",false);
        component.set("v.displayContact",false);
        
        var action6 = component.get("c.getContactVal");
        action6.setParams({
            "id" : component.get("v.recordId")
        });
        action6.setCallback(this, function(a) {
            if (a.getState() == "SUCCESS") {
                component.set("v.ContactVal", a.getReturnValue());
                if( component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined || component.get("v.ContactVal") == false )
                {
                    /* if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined){
                           component.set("v.displayResolution",true);  
                       }*/
                       if(component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined ){
                           component.set("v.displayTurnback",true);
                       }
                       /* if(component.get("v.PurposeCount") == false){
                           component.set("v.displayPurpose",true);
                       }*/
                       if(component.get("v.ContactVal") == false){
                           component.set("v.displayContact",true);
                       }
                       
                   }
                   else{
                       helper.saveClose(component);
                   }
                   
               }
               else{
                   alert('Error6');
               }
           });
        
        $A.enqueueAction(action6);
    },
    
    saveOnlyCase : function(component, event, helper) {
        
        //alert('clicked1');
        //  component.set("v.recordId","Closed");
        component.set("v.spinnerShow",true);
        var action = component.get("c.saveCase");        
        
        action.setParams({"caseObject": component.get("v.Expedite"),
                          "selValue": component.get("v.selVal"),
                          "selValTB": component.get("v.selValTB"),
                          "selValStatus": component.get("v.selValStatus"),
                          "vendortracking":component.find("vendortracking").get("v.value"),
                          "committime":component.find("committime").get("v.value"),
                          "shipdate":component.find("shipdate").get("v.value")
                         });
        
        //alert('clicked3');
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                //alert('clicked4');
                //alert('updated successfully');
                // window.location.reload();
                component.set("v.spinnerShow",false);
                component.set("v.displayTurnback",false);
                component.set("v.displaySolution",false);
                component.set("v.displayResolution",false);
                component.set("v.displayPurpose",false);
                component.set("v.displayContact",false);
                
                $A.get('e.force:refreshView').fire();
                
            } else if (state === "ERROR") {
                //alert('clicked5');
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert('error4');
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    refreshViewHandler : function(component, event, helper) {
        helper.fetchExpListVal(component, 'Expedite_Status__c', 'expstatus');
        component.set("v.isError", false);
        component.set("v.showEditView", false);
        component.set("v.errorMsg", "");
        
        var action = component.get("c.getExpedite");
        action.setParams({
            "id" : component.get("v.recordId")
          
        });
        
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.Expedite", a.getReturnValue());
                //  alert('exp'+JSON.Stringify(a.getReturnValue()));
                var cs = a.getReturnValue();
                // alert('cssss'+JSON.Stringify(cs));
                component.set("v.PickReason",cs.Resolution_Code__c);
                component.set("v.PickTB",cs.Turnback__c);
                component.set("v.PickStatus",cs.Expedite_Status__c);
                //alert(cs.Expedite_Status__c);
                // component.set("v.defCode",cs.CCC_Defect_Code__c);
                // component.set("v.defSubCode",cs.CCC_Defect_Sub_Code__c);
            }
        });
        
        $A.enqueueAction(action);
        
        var action1 = component.get("c.getTurnback");
        action1.setParams({
            "id" : component.get("v.recordId")
        });
        
        action1.setCallback(this, function(a) {
            if (a.getState() == "SUCCESS") {
                //  alert('#a.getReturnValue():of turnback'+JSON.stringify(a.getReturnValue()));
                component.set("v.Turnback", a.getReturnValue());
            }
        });
        
        $A.enqueueAction(action1);
        
        var action2 = component.get("c.getResolutionCode");
        action2.setParams({
            "id" : component.get("v.recordId")
        });
        
        action2.setCallback(this, function(a) {
            if (a.getState() == "SUCCESS") {
                //  alert('#a.getReturnValue(): of resolution'+JSON.stringify(a.getReturnValue()));
                component.set("v.Reasons", a.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
        
      /*  var action3 = component.get("c.getselectOptions");
        action3.setParams({
            "id" : component.get("v.recordId")
           // "objObject": component.get("v.Expedite"),
           // "fld": Expedite_Status__c
        });
        
        action3.setCallback(this, function(a) {
            if (a.getState() == "SUCCESS") {
                // alert('#a.getReturnValue():of status'+JSON.stringify(a.getReturnValue()));
                component.set("v.PickStatus", a.getReturnValue());
            }
        });
        
        $A.enqueueAction(action3);*/
        
        
        
    },
})