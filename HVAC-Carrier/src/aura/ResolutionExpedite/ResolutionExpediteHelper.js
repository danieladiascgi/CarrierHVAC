({
    fetchPicklistValues: function(component, controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentOptionsImpl");
        // pass paramerters [object name , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objApiName': component.get("v.objInfo"),
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                //alert('#StoreResponse:'+StoreResponse);
                //alert(JSON.stringify(response.getReturnValue()));
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap", StoreResponse);
                //alert('bye');
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on ui field. 
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                //set the controller field value for ui:inputSelect  
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: "--- None ---"
                    });
                }
                
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push({
                        class: "optionClass",
                        label: listOfkeys[i],
                        value: listOfkeys[i]
                    });
                }
                // set the ControllerField variable values to country(controller picklist field)
                component.find('defectCode').set("v.options", ControllerField);
                var cs = component.get("v.case");
                if(cs.CCC_Defect_Code__c!=null && cs.CCC_Defect_Code__c!='undefined' && typeof(cs.CCC_Defect_Code__c)!='undefined' && cs.CCC_Defect_Code__c.length>0){
                    var Map = component.get("v.depnedentFieldMap");
                    var ListOfDependentFields = Map[cs.CCC_Defect_Code__c];                 
                    this.fetchDepValues(component, ListOfDependentFields);
                }
                
            }
            else{
                alert('Error');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field)  
        var dependentFields = [];
        
        if (ListOfDependentFields != undefined && ListOfDependentFields.length > 0) {
            dependentFields.push({
                class: "optionClass",
                label: "--- None ---",
                value: "--- None ---"
            });
            
        }
        
        else{
            dependentFields.push({
                class: "optionClass",
                label: "--- None ---",
                value: "--- None ---"
            });
        }
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push({
                class: "optionClass",
                label: ListOfDependentFields[i],
                value: ListOfDependentFields[i]
            });
        }
        // set the dependentFields variable values to State(dependent picklist field) on ui:inputselect    
        component.find('defectSubCode').set("v.options", dependentFields);
        // make disable false for ui:inputselect field 
        component.set("v.isDependentDisable", false);
    },
    
    saveClose: function(component) {
        var action = component.get("c.saveCaseClose");
        //alert(component.find('Turnback').get("v.value"));
        var tbValue = component.get("v.selValTB");
        if(tbValue==null || typeof(tbValue)==undefined || tbValue.length==0){
            tbValue = component.find('Turnback').get("v.value");
        }
        action.setParams({"caseObject": component.get("v.Expedite"),
                          "selValue": component.get("v.selVal"),
                          "selValTB": tbValue,
                          "vendortracking":component.find("vendortracking").get("v.value"),
                          "committime":component.find("committime").get("v.value"),
                          "shipdate":component.find("shipdate").get("v.value")
                         });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                
                
                component.set("v.PickStatus", "Closed");
                component.set("v.spinnerShow",false);
                component.set("v.displayTurnback",false);
                component.set("v.displayResolution",false);
                component.set("v.displayPurpose",false);
                component.set("v.displayContact",false);
                $A.get('e.force:refreshView').fire(); 
                
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert('error2');
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
    fetchExpListVal: function(component, fieldName, elementId) {
        
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.Expedite"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                // alert('Val'+allValues);
                
                if (allValues != undefined && allValues.length > 0) {
                    // alert('Inside if...');
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                // alert('Id'+opts);	
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    getPlannerInformation: function(component, event) {
        
        var action = component.get("c.checkIfPlannerIsEmpty");
        action.setParams({
            "ExpediteId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                if(response.getReturnValue()==true){
                    var modalBody;
                    $A.createComponent("c:CapturePlanner", {ExpediteId:component.get("v.recordId")},
                                       
                                       function(content, status) {
                                           if (status === "SUCCESS") {
                                               modalBody = content;
                                               component.find('overlayLib').showCustomModal({
                                                   header: "Expedite Planner Information",
                                                   body: modalBody, 
                                                   showCloseButton: true,
                                                   cssClass: "slds-modal_small",
                                                   closeCallback: function() {
                                                       //alert('Click Ok to close popup!!');
                                                        $A.get('e.force:refreshView').fire();
                                                   }
                                               })
                                               
                                           }
                                           
                                       });
                }else{
                    
                }
            }
        });
        $A.enqueueAction(action);
    }
    
    
})