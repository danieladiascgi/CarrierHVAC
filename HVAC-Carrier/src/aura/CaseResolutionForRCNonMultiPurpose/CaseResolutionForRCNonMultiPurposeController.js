({
    
doInit : function(component, event, helper) {
    
    component.set("v.isError", false);
    component.set("v.showEditView", false);
    component.set("v.errorMsg", "");
  
    var action = component.get("c.getCase");
    action.setParams({
        "id" : component.get("v.recordId")
    });

    action.setCallback(this, function(a) {
        if (a.getState() === "SUCCESS") {
            component.set("v.case", a.getReturnValue());
            var cs = a.getReturnValue();
            component.set("v.PickReason",cs.Reason);
            component.set("v.PickTB",cs.CCC_Turn_Back_Code__c);
            component.set("v.PickStatus",cs.Status);
            component.set("v.defCode",cs.CCC_Defect_Code__c);
            component.set("v.defSubCode",cs.CCC_Defect_Sub_Code__c);
          }
    });

    $A.enqueueAction(action);
    
    var action1 = component.get("c.getTurnback");
    action1.setParams({
        "id" : component.get("v.recordId")
    });

    action1.setCallback(this, function(a) {
        if (a.getState() == "SUCCESS") {
          //  alert('#a.getReturnValue():'+JSON.stringify(a.getReturnValue()));
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
        //    alert('#a.getReturnValue():'+JSON.stringify(a.getReturnValue()));
            component.set("v.Reasons", a.getReturnValue());
         }
    });
     $A.enqueueAction(action2);
    
     var action3 = component.get("c.getStatus");
    action3.setParams({
        "id" : component.get("v.recordId")
    });

    action3.setCallback(this, function(a) {
        if (a.getState() == "SUCCESS") {
         //   alert('#a.getReturnValue():'+JSON.stringify(a.getReturnValue()));
            component.set("v.Status", a.getReturnValue());
        }
    });

    $A.enqueueAction(action3);
    
     var action4= component.get("c.getRecordType");  
     action4.setParams({
        "id" : component.get("v.recordId")
    });
    action4.setCallback(this, function(response) {
        var state = response.getState();
        
        if (state == "SUCCESS") {
            component.set("v.displayPSS",false);
            component.set("v.displayNoPSS",false);
       
            var recordType = response.getReturnValue();
            component.set("v.RecordType", recordType);
            if(response.getReturnValue() == 'Post Sale Support')	{
                component.set("v.displayPSS",true);
                helper.fetchPicklistValues(component, 'CCC_Defect_Code__c', 'CCC_Defect_Sub_Code__c');
            }		
            else {
                component.set("v.displayNoPSS",true);
            }
        }
        
    });   
    $A.enqueueAction(action4); 
    
    var action5 = component.get("c.getCaseOwner");
    action5.setParams({
        "id" : component.get("v.recordId")
    });

    action5.setCallback(this, function(a) {
        if (a.getState() == "SUCCESS") {
         //   alert('#a.getReturnValue():'+JSON.stringify(a.getReturnValue()));
            component.set("v.CaseOwner", a.getReturnValue());
        }
    });

    $A.enqueueAction(action5);
    
    
   },
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
                component.set("v.DefectCode", controllerValueKey);
                
            } else {
                var defaultVal = [{
                    class: "optionClass",
                    label: '--- None ---',
                    value: '--- None ---'
                }];
                component.find('defectCode').set("v.options", defaultVal);
                component.set("v.isDependentDisable", true);
                component.set("v.DefectCode", controllerValueKey);
                
            }
            
        },
    
    onDependentFieldChange: function(component, event, helper) {
                //  alert(event.getSource().get("v.value"));
                var dependentValueKey = event.getSource().get("v.value");
                component.set("v.DefectSubCode", dependentValueKey);
                //alert(dependentValueKey);
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
       //component.set("v.checkedstatus",true);
       var selectedStatus = component.find("scode").get("v.value");
       component.set("v.selValStatus",selectedStatus);
   },
    
   saveCaseAndClose : function(component, event, helper) {
    component.set("v.displayTurnback",false);
    component.set("v.displaySolution",false);
    component.set("v.displayResolution",false);
    component.set("v.displayDefectCode",false);
    component.set("v.displayDefectSubCode",false);
    component.set("v.displayPurpose",false);
    component.set("v.displayContact",false);
   
       if(component.get("v.RecordType") == 'Post Sale Support'){
      
           if(component.find("defectCode").get("v.value") == '--- None ---' || component.find("defectCode").get("v.value") == undefined || component.find("defectSubCode").get("v.value") == '--- None ---' || component.find("defectSubCode").get("v.value") == undefined || component.find("Solution").get("v.value") == ''|| component.find("Solution").get("v.value") == undefined || component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined){
               if(component.find("defectCode").get("v.value") == '--- None ---' || component.find("defectCode").get("v.value") == undefined ){
                   component.set("v.displayDefectCode",true);
               }
               if(component.find("defectSubCode").get("v.value") == '--- None ---' || component.find("defectSubCode").get("v.value") == undefined ){
                   component.set("v.displayDefectSubCode",true);
               }
               if(component.find("Solution").get("v.value") == ''|| component.find("Solution").get("v.value") == undefined){
                   component.set("v.displaySolution",true);
               }
               if(component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined ){
                   component.set("v.displayTurnback",true);
               }
           }else{
                helper.saveClose(component);
           }
       }
       if(component.get("v.CaseOwner") == '00G1C000003oCVwUAM' && component.get("v.RecordType") == 'Equipment' )
       {
          // alert('orderentrycase');
         
           var action5 = component.get("c.getPurposeCount");
           action5.setParams({
               "id" : component.get("v.recordId")
           });
           action5.setCallback(this, function(a) {
               if (a.getState() == "SUCCESS") {
                   
                   component.set("v.PurposeCount", a.getReturnValue());
                   component.set("v.displayContact",false);
              
                   if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined || component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined || component.get("v.PurposeCount") == false )
                   {
                       if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined){
                           component.set("v.displayResolution",true);  
                       }
                       if(component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined ){
                           component.set("v.displayTurnback",true);
                       }
                       if(component.get("v.PurposeCount") == false){
                       		component.set("v.displayPurpose",true);
                   	   }
                       if(component.get("v.ContactVal") == false){
                       		component.set("v.displayContact",false);
                   	   }
                       
                   }else{
                      // alert('elseorder');
                       component.set("v.displayContact",false);
                       helper.saveClose2(component);
                   }
               }
               else{
                   alert('Error5');
               }
           });
           
           $A.enqueueAction(action5); 
       }
      // if(component.get("v.RecordType") == 'Replacement Component (RC)' || component.get("v.RecordType") == 'Equipment')
       if(component.get("v.RecordType") == 'Equipment' && component.get("v.CaseOwner") != '00G1C000003oCVwUAM')
       {
          // alert('equipment');
           var action5 = component.get("c.getPurposeCount");
           action5.setParams({
               "id" : component.get("v.recordId")
           });
           action5.setCallback(this, function(a) {
               if (a.getState() == "SUCCESS") {
                    component.set("v.PurposeCount", a.getReturnValue());
                    }
               else{
                   alert('Error5');
               }
           });
           
           $A.enqueueAction(action5); 
           
           var action6 = component.get("c.getContactVal");
           action6.setParams({
               "id" : component.get("v.recordId")
           });
           action6.setCallback(this, function(a) {
               if (a.getState() == "SUCCESS") {
                   
                  
                   component.set("v.ContactVal", a.getReturnValue());
                   
                   
                   if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined || component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined || component.get("v.PurposeCount") == false || component.get("v.ContactVal") == false )
                   {
                       if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined){
                           component.set("v.displayResolution",true);  
                       }
                       if(component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined ){
                           component.set("v.displayTurnback",true);
                       }
                       if(component.get("v.PurposeCount") == false){
                           component.set("v.displayPurpose",true);
                       }
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
       }
       
       
           if(component.get("v.RecordType") == 'Replacement Component (RC)')
           {
           var action5 = component.get("c.getCase");
           action5.setParams({
               "id" : component.get("v.recordId")
           });
           action5.setCallback(this, function(a) {
               if (a.getState() == "SUCCESS") {
                   
                   var cse = a.getReturnValue();
              
                   if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined || component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined || cse.CCC_Purpose__c==null || cse.CCC_Purpose__c=='undefined' || cse.CCC_Purpose__c=='' || cse.CCC_Sub_Purpose__c==null || cse.CCC_Sub_Purpose__c=='undefined' ||cse.CCC_Sub_Purpose__c=='' )
                   {
                       if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined){
                           component.set("v.displayResolution",true);  
                       }
                       if(component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined ){
                           component.set("v.displayTurnback",true);
                       }
                       if(cse.CCC_Purpose__c=='undefined' || cse.CCC_Purpose__c=='' || cse.CCC_Sub_Purpose__c==null || cse.CCC_Sub_Purpose__c=='undefined' ||cse.CCC_Sub_Purpose__c==''){
                       		component.set("v.displayPurpose",true);
                   	   }
                     /*  if(component.get("v.ContactVal") == false){
                       		component.set("v.displayContact",true);
                   	   }*/
                       
                   }else{
                       helper.saveClose(component);
                   }
               }
               else{
                   alert('Error5');
               }
           });
           
           $A.enqueueAction(action5); 
              
       }
    
        if(component.get("v.RecordType") == 'Channel')
        {
            
            if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined || component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined)
            {
                if(component.find("rcode").get("v.value") == '---None---' || component.find("rcode").get("v.value") == undefined){
                    component.set("v.displayResolution",true);  
                }
                if(component.find("Turnback").get("v.value") == '---None---' || component.find("Turnback").get("v.value") == undefined ){
                    component.set("v.displayTurnback",true);
                }
            }
            else{
                helper.saveClose(component);
            }
        }
       
       
    },
    saveOnlyCase : function(component, event, helper) {
        
        //alert('clicked1');
        //  component.set("v.recordId","Closed");
        component.set("v.spinnerShow",true);
        var action = component.get("c.saveCase");        
        
        action.setParams({"caseObject": component.get("v.case"),"selValue": component.get("v.selVal"),"selValTB": component.get("v.selValTB"),"selValStatus": component.get("v.selValStatus"),"selValDefectCode": component.get("v.DefectCode"),"selValDefectSubCode": component.get("v.DefectSubCode")});
     
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
    } 
})