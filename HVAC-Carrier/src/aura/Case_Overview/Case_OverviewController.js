({
    doInit : function(component, event, helper) {
         helper.updateNewMsgFieldOnRead(component, event, helper);
        //alert('#Inside DoInit');
       /* helper.fetchBrandValues(component, 'CCC_Brand__c', '');
        helper.fetchCustomerTypeValues(component, 'CCC_Customer_Type__c', '');
        helper.fetchSourceValues(component, 'Origin', '');
        helper.fetchPicklistValues(component, 'CCC_Purpose__c', 'CCC_Sub_Purpose__c');*/
        
        
        //alert(component.get("v.recordId"));
        var recordId = component.get("v.recordId");
        var action = component.get("c.getCase");
        action.setParam("id", recordId);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.case", response.getReturnValue());
                //$A.get('e.force:refreshView').fire();

            } else{
                //alert('Error:');
            }
        });
        $A.enqueueAction(action);
      /*  var toggleText = component.find("editable");        
        $A.util.toggleClass(toggleText, "slds-hide");*/
    },
     handleOnLoad : function(component, event, helper) {
        
      //  var toggleText = component.find("editable");
        //var toggleText = document.getElementById('editable');
        //$(toggleText).hide();
     //   $A.util.toggleClass(toggleText, "slds-hide");
    },
    
    checkIfFired : function(component, event, helper) {
        //alert(component.get("v.recordId"));
        //alert('Refreshed:'+event.getSource().getLocalId());
        //$A.get('e.force:refreshView').fire();
    },
      toggleEditMode: function(component, event, helper) {
       
      /* var toggleText = component.find("editable");
        	
		$A.util.toggleClass(toggleText, "slds-hide");*/
        var toggleText = component.find("readonly");
        	
		$A.util.toggleClass(toggleText, "slds-hide");
    },
        saveCase1 : function(component,helper) {
           // alert('Save Clicked');
          //  console.log('Before Upsert:'+component.get("v.case"));
             var action = component.get("c.saveCase");
            var caseVar = component.get("v.case");
            caseVar.CCC_Purpose__c = component.get("v.Purpose");
            //alert('#Purp:'+component.get("v.Purpose"));
            //alert('#Sub Purp:'+component.get("v.SubPurpose"));
            caseVar.CCC_Sub_Purpose__c = component.get("v.SubPurpose");
            caseVar.CCC_Brand__c = component.get("v.Brand");
            caseVar.CCC_Customer_Type__c = component.get("v.CustomerType");
            caseVar.Origin = component.get("v.Source");
        //action.setParams({"caseObject": component.get("v.case")});
            action.setParams({"caseObject": caseVar});
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if(state == "SUCCESS"){
             //   console.log( 'Success Response:'+response.getReturnValue()); 
            /*    var toggleText = component.find("editable");        	
                $A.util.toggleClass(toggleText, "slds-hide");
                var toggleText = component.find("readonly");                    
                $A.util.toggleClass(toggleText, "slds-hide");*/
               // alert('successfully saved');
                window.location.reload();
             //   alert('refresh');
              //  $A.get('e.force:refreshView').fire();
            }else{
               // alert('Error:');
            }
             
        } );
        $A.enqueueAction(action);
        },
    
 
 
   // function call on change tha controller field  
   onControllerFieldChange: function(component, event, helper) {
   //   alert(event.getSource().get("v.value"));
      // get the selected value
      var controllerValueKey = event.getSource().get("v.value");
 
      // get the map values   
      var Map = component.get("v.depnedentFieldMap");
 
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != '--- None ---') {
 
         // get dependent values for controller field by using map[key].  
         // for i.e "India" is controllerValueKey so in the map give key Name for get map values like 
         // map['India'] = its return all dependent picklist values.
         var ListOfDependentFields = Map[controllerValueKey];
         helper.fetchDepValues(component, ListOfDependentFields);
          component.set("v.Purpose", controllerValueKey);
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
         component.find('conState').set("v.options", defaultVal);
         component.set("v.isDependentDisable", true);
          component.set("v.Purpose", controllerValueKey);
          //alert(component.get("v.Purpose"));
      }
       //alert(component.get("v.Purpose"));
   },
 
   // function call on change tha Dependent field    
   onDependentFieldChange: function(component, event, helper) {
    //  alert(event.getSource().get("v.value"));
    var dependentValueKey = event.getSource().get("v.value");
    component.set("v.SubPurpose", dependentValueKey);
       //alert(dependentValueKey);
   },
   onBrandChange: function(component, event, helper) {
    //  alert(event.getSource().get("v.value"));
    var brandKey = event.getSource().get("v.value");
    component.set("v.Brand", brandKey);
       //alert(dependentValueKey);
   },
   onCustomerTypeChange: function(component, event, helper) {
    //  alert(event.getSource().get("v.value"));
    var brandKey = event.getSource().get("v.value");
    component.set("v.CustomerType", brandKey);
       //alert(dependentValueKey);
   },
   onSourceChange: function(component, event, helper) {
    //  alert(event.getSource().get("v.value"));
    var brandKey = event.getSource().get("v.value");
    component.set("v.Source", brandKey);
       //alert(dependentValueKey);
   }
    
})