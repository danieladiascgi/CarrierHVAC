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
                //	alert(JSON.stringify(response.getReturnValue()));
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap", StoreResponse);
                //        alert('bye');
                
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
        // alert('tbValue'+tbValue);
        if(tbValue==null || typeof(tbValue)==undefined || tbValue.length==0 ){
            tbValue = component.find('Turnback').get("v.value");
            // alert('tbValue'+tbValue);
        }
        action.setParams({"caseObject": component.get("v.case"),"selValue": component.get("v.selVal"),"selValTB": tbValue,"selValDefectCode": component.get("v.DefectCode"),"selValDefectSubCode": component.get("v.DefectSubCode")});
        
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
    
    saveClose2: function(component) {
        // alert('saveclose2');
        component.set("v.displayContact",false);
        var action = component.get("c.saveCaseClose");
        //alert(component.find('Turnback').get("v.value"));
        var tbValue = component.get("v.selValTB");
        if(tbValue==null || typeof(tbValue)==undefined || tbValue.length==0){
            tbValue = component.find('Turnback').get("v.value");
        }
        action.setParams({"caseObject": component.get("v.case"),"selValue": component.get("v.selVal"),"selValTB": tbValue,"selValDefectCode": component.get("v.DefectCode"),"selValDefectSubCode": component.get("v.DefectSubCode")});
        
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
    }
    
    
})