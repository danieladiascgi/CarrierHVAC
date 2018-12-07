({
    doInit : function(component, event, helper) {
        helper.fetchPicklistValues(component, 'CCC_Purpose__c', 'CCC_Sub_Purpose__c');
        helper.preparePartData(component, event);
        helper.prepareCustomerPOData(component, event);
    },
    
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    addNewRow1: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData1(component, event);
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        
        var AllRowsList = component.get("v.WrapPartList");
        AllRowsList.splice(index, 1);
        
        component.set("v.WrapPartList", AllRowsList);
    },
    
    removeDeletedRow1: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        
        var AllRowsList = component.get("v.custPO");
        AllRowsList.splice(index, 1);
        
        component.set("v.custPO", AllRowsList);
    },
    selectDate: function(component,event,helper){
        var getWhichBtn = event.getSource().get("v.localId");
        component.set("v.storeRadioValue" , getWhichBtn);    
        alert(getWhichBtn);   
    },
    saveCase1 : function(component,event,helper) {
        
        var jobValue;
        var jobname;
        var builddate;
        var sub;
        // List<WrapperCls__c> part = component.get("v.WrapPartList");
        var purpose = component.find("conPurpose").get("v.value");
        var subPurpose = component.find("conSubPurpose").get("v.value");
        var isEmpty = false;
        var wrapList = component.get("v.WrapPartList");
        for(var i =0; i<wrapList.length;i++){
            if(wrapList[i].prtNo__c == '' || wrapList[i].prtNo__c == undefined){
                isEmpty = true;
            }    
        }
        
        if(purpose=='Technical/Part Info - 42 Series Fan Coil')
        {
            var sapValue = component.find("sap").get("v.value");
            var odsValue = component.find("ods").get("v.value");
            jobValue = component.find("jobsite").get("v.value");
            var buildDateValue = component.get("v.storeRadioValue");
            
            
        }
        // Render subject field based on purpose value
        if(purpose!='Technical/Part Info - 42 Series Fan Coil')
        {
            sub = component.find("subject").get("v.value"); 
        }
        
        
        var getUrlParameter = function getUrlParameter(sParam) {
            
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;
            
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');
                // alert('Params**'+sParameterName);
                
                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
        };
        var payload = getUrlParameter('value');
        if(payload==null && sessionStorage.getItem('payload')!='undefined' && sessionStorage.getItem('payload')!=null && sessionStorage.getItem('payload')!=undefined && sessionStorage.getItem('payload').length>0){
            
            payload = sessionStorage.getItem('payload');
        }
        //alert('payload'+payload);
        var action2  = component.get("c.getparsePayloadAndGetValues");
        action2.setParams({"payloadStr" : payload});
        action2.setCallback(this,function(response)
                            {
                                //  component.set("v.value",response.getReturnValue());
                                component.set("v.contlst",response.getReturnValue());
                                var state=response.getState();
                                var result=response.getReturnValue();
                                
                                // alert('*******'+response.getReturnValue());
                                if(state=="SUCCESS"){
                                    component.set("v.contlst",result);
                                    //  alert('after success'+ component.get("v.value")); 
                                    
                                    
                                    
                                    //  alert('partlength'+component.get("v.partlength"));
                                    //  var partlength = component.get("v.WrapInstance");
                                    //  alert('size'+partlength);
                                    if((component.find("conPurpose").get("v.value")==null || component.find("conPurpose").get("v.value")=='undefined' || component.find("conPurpose").get("v.value") == '--- None ---')){
                                        alert('Please select Purpose');
                                    }
                                    else if((component.find("conSubPurpose").get("v.value")==null || component.find("conSubPurpose").get("v.value")=='undefined' || component.find("conSubPurpose").get("v.value") == '--- None ---')){
                                        alert('Please select Sub-Purpose');   
                                    }
                                        else if(((sub == '') || (sub == null))&& (component.find("conPurpose").get("v.value") != 'Technical/Part Info - 42 Series Fan Coil')) {
                                            alert('Please enter Subject');   
                                        }
                                            else if((component.find("conPurpose").get("v.value") == 'Technical/Part Info' || component.find("conPurpose").get("v.value") == 'Pricing/Quoting') && (component.find("serial").get("v.value")==null || component.find("serial").get("v.value") =='' || component.find("model").get("v.value")==null || component.find("model").get("v.value") =='')){            
                                                alert('Please enter Model # and Serial #');            
                                            }
                                                else if((component.find("conPurpose").get("v.value") == 'Technical/Part Info - 42 Series Fan Coil')&& (jobValue==null || jobValue =='' )){            
                                                    alert('Please enter Jobsite');            
                                                }
                                    
                                                    else if((component.find("conPurpose").get("v.value") == 'Technical/Part Info - 42 Series Fan Coil')&& (component.find("serial").get("v.value")==null || component.find("serial").get("v.value") =='' || component.find("model").get("v.value")==null || component.find("model").get("v.value") =='')){            
                                                        alert('Please enter Model # and Serial #');            
                                                    }
                                                        else if((component.find("conPurpose").get("v.value") == 'Order Status and Maintenance') && (component.find("custPO").get("v.value")==null || component.find("custPO").get("v.value") =='')){
                                                            alert('Please enter Customer PO #');
                                                        }
                                                           else if((component.find("conPurpose").get("v.value") == 'Price & Availability') && isEmpty == true){  
                                                                alert('Please enter Part #');
                                                                
                                                            }
                                    
                                                                else{
                                                                    // alert('spinner'+builddate);
                                                                    component.set("v.Spinner", true);
                                                                    //  alert('after validation'+ component.find("custPO").get("v.value"));
                                                                    var action = component.get("c.saveCase");                 
                                                                    action.setParams({
                                                                        "description" : component.find("description").get("v.value"),
                                                                        "distributor_customer" : component.find("distributor_customer").get("v.value"),
                                                                        "subject" : sub, 
                                                                        "conPurpose" : component.find("conPurpose").get("v.value"),
                                                                        "conSubPurpose" : component.find("conSubPurpose").get("v.value"),
                                                                        "serial" : component.find("serial").get("v.value"),
                                                                        "model" : component.find("model").get("v.value"),
                                                                        "ListPart": component.get("v.WrapPartList"),
                                                                        // "CustomerPO":	 component.get("v.custPO"),
                                                                        "CustomerPO": component.find("custPO").get("v.value"),
                                                                        "contlst":	 component.get("v.contlst"),
                                                                        "sap" : sapValue,
                                                                        "ods" : odsValue,
                                                                        "buildDate": buildDateValue,
                                                                        "jobName": jobValue,
                                                                        "filename":component.get("v.fileName")
                                                                        
                                                                        
                                                                    });	
                                                                    
                                                                    
                                                                    //action.setParams({"caseObject": caseVar});
                                                                    action.setCallback(this, function(response) {
                                                                        var state = response.getState();
                                                                        if(state == "SUCCESS"){ 
                                                                           
                                                                            var recId = response.getReturnValue();
                                                                            //alert("CaseRecId"+recId.CaseNumber);
                                                                            component.set("v.Spinner",false);
                                                                            component.set("v.recIdCreated",recId);
                                                                            helper.uploadHelper(component, event);
                                                                            // alert("RecordId"+recId.CaseNumber);
                                                                            component.set("v.mailStatus", true);
                                                                            
                                                                        }else{
                                                                            // alert('Error:');
                                                                        }
                                                                        
                                                                        
                                                                    } );
                                                                    $A.enqueueAction(action);
                                                                }
                                }
                            }); 
        $A.enqueueAction(action2);
        
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // alert('showspinner');
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        //   alert('hidespinner');
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
    redirectToCaseDetail: function(component, event, helper){
        //alert('redirectToCaseDetail');
        //  var email = component.get("v.value");
        //  alert(email);
        component.set("v.mailStatus", false);
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse!=null && storeResponse!='undefined' && storeResponse!=undefined && storeResponse.alias!='undefined' && (storeResponse.Alias=='guest' || storeResponse.Alias=='tjamb')){
                    /*alert('inside if');
                   var destination = "c:MyOpenCases";
        
                   alert(destination);
                    $A.createComponent(destination, { "email":email}, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });*/
                    helper.redirectToMyOpenCasesCustom(component);
                }else{
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": '00B0m0000017njL',
                        "listViewName": null,
                        "scope": "Case"
                    });
                    navEvent.fire();        
                }
            }
        });
        $A.enqueueAction(action);
        
        
        
        
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
        if (controllerValueKey == "Technical/Part Info - 42 Series Fan Coil") {     
            component.set("v.displayseriesfields", true);
            component.set("v.displaysubjectfield", false);
        }
        else
        {
            component.set("v.displayseriesfields", false);
            component.set("v.displaysubjectfield", true);
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
    
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            //helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            // alert('filesize'+event.getSource().get("v.files").length);
            fileName = event.getSource().get("v.files")[0]['name'];
            //alert('fileName'+fileName);
        }
        component.set("v.fileName", fileName);
        
    }
      
    
    
})