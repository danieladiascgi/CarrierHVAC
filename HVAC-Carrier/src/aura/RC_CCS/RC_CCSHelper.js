({
    
    fetchPicklistValues: function(component, controllerField, dependentField) {
        // call the server side function 
     //   var purposenew = component.get("v.purposes");
        // alert('purposenew'+purposenew);
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
                // alert('StoreResponse'+response.getReturnValue());
                //alert('#StoreResponse:'+StoreResponse);
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap", StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on ui field. 
                listOfkeys.push("--- None ---");
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                /* for (var i = 0; i < listOfkeys.length; i++) {
                    if(listOfkeys[i]=='Technical/Part Info')
                    {
                        alert('tech');
                    ControllerField.push({
                        class: "optionClass",
                        label: "Technical/Part Info",
                        value: "Technical/Part Info"
                    });
                      
                }
                  
                }*/
                
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
                
                
                
                
                
                component.set("v.purposes", listOfkeys); 
                component.set("v.Spinner", false);
                // set the ControllerField variable values to country(controller picklist field)
                //component.find('conPurpose').set("v.options", ControllerField);
            }
        });
        $A.enqueueAction(action);
    },
    
    createObjectData: function(component, event) {
        
        var RowItemList = component.get("v.WrapPartList");
        
        RowItemList.push({
            'sobjectType': 'WrapperCls__c',
            'prtNo__c': '',
            'failedPrt__c':false,            
            'Quantity__c':'',
            'Description__c':''
        });
        
        component.set("v.WrapPartList", RowItemList);
        
    },
    preparePartData: function(component, event) {
        
        var RowItemList = component.get("v.WrapPartList");
        if(RowItemList!=null && RowItemList!='undefined' && RowItemList.length==0){
            RowItemList.push({
                'sobjectType': 'WrapperCls__c',
                'prtNo__c': '',
                'failedPrt__c':false,            
                'Quantity__c':'',
                'Description__c':''
            });
            
            component.set("v.WrapPartList", RowItemList);
        }   
    },
    createObjectData1: function(component, event) {
        
        var RowItemList = component.get("v.custPO");
        
        
        RowItemList.push({
            'sobjectType': 'WrapperCls__c',
            'Customer_PO__c': '',
            'Customer_PO_check__c':false           
            
        });
        
        component.set("v.custPO", RowItemList);
        
    },
    prepareCustomerPOData: function(component, event) {
        
        var RowItemList = component.get("v.custPO");
        if(RowItemList!=null && RowItemList!='undefined' && RowItemList.length==0){
            
            RowItemList.push({
                'sobjectType': 'WrapperCls__c',
                'Customer_PO__c': '',
                'Customer_PO_check__c':false           
                
            });
            
            component.set("v.custPO", RowItemList);
        }    
    },
    
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field)  
        var dependentFields = [];
        var subPrps = [];
        subPrps.push("--- None ---");
        if (ListOfDependentFields != undefined && ListOfDependentFields.length > 0) {
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
            subPrps.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to State(dependent picklist field) on ui:inputselect    
        component.set("v.subPurposes", subPrps);
        //component.find('conSubPurpose').set("v.options", dependentFields);
        // make disable false for ui:inputselect field 
        component.set("v.isDependentDisable", false);
    },
    fetchBrandValues: function(component, controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getPicklistOptionsImpl");
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
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap", StoreResponse);
                
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
                component.find('Brand').set("v.options", ControllerField);
            }
        });
        $A.enqueueAction(action); 
    },
    fetchCustomerTypeValues: function(component, controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getPicklistOptionsImpl");
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
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap", StoreResponse);
                
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
                component.find('CustomerType').set("v.options", ControllerField);
            }
        });
        $A.enqueueAction(action); 
    },
    fetchSourceValues: function(component, controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getPicklistOptionsImpl");
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
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap", StoreResponse);
                
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
                component.find('Source').set("v.options", ControllerField);
            }
        });
        $A.enqueueAction(action); 
    },
    redirectToMyOpenCasesCustom: function(component) {
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
        var actionParsePayload  = component.get("c.getparsePayloadAndGetValues");
        
        actionParsePayload.setParams({"payloadStr" : payload});
        actionParsePayload.setCallback(this,function(response){
            var state=response.getState();
            if(state=="SUCCESS"){
                //Console.log('#Response:'+response.getReturnValue());
               // var email = response.getReturnValue();
              
               var contlst = response.getReturnValue();
               
                var destination = "c:MyOpenCases";
                //alert(destination);
                $A.createComponent(destination, { "email":contlst[2]}, 
                                   function(view) {
                                       var content = component.find("content");
                                       //alert('#content:'+content);
                                       content.set("v.body", view);
                                   });
            }
        });
        $A.enqueueAction(actionParsePayload);
    },
    
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]
        // alert('files'+component.find("fileId").get("v.files"));
        var self = this;
        if(fileInput!=null && fileInput!='undefined' && fileInput.length!=0){
            for(var i=0;i<fileInput.length;i++){
                (function(file) {
                //var file = fileInput[i];
               // alert('fileName'+file.name);
                 
                if (file.size > self.MAX_FILE_SIZE) {
                    component.set("v.showLoadingSpinner", false);
                    component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                    return;
                }
                //  alert('beforeuploadProcess1'+file.name); 
                // create a FileReader object 
                var objFileReader = new FileReader();
                //  alert('beforeuploadProcess2'+file.name); 
                // set onload function of FileReader object   
                objFileReader.onload = $A.getCallback(function() {
                   // alert('beforeuploadProcess3'+file.name); 
                    var fileContents = objFileReader.result;
                    var base64 = 'base64,';
                    var dataStart = fileContents.indexOf(base64) + base64.length;
                    fileContents = fileContents.substring(dataStart);
                    // call the uploadProcess method
                    //  alert('beforeuploadProcess'+file.name); 
                    self.uploadProcess(component, file, fileContents);
                });
                
                objFileReader.readAsDataURL(file);
                })(fileInput[i]);    
            }
        }
    },
    
    uploadProcess: function(component, file, fileContents) {
        // alert('uploadProcess'+file.name);
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        //  alert('uploadInChunk'+file.name);
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            recordId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            // alert('arrachId'+response.getReturnValue());
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    //alert('your File is uploaded successfully');
                    component.set("v.showLoadingSpinner", false);
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }
})