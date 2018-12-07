({
	doInit : function(component, event, helper) {
        //alert('hello');
        var recordId = component.get("v.recordId");
		var action = component.get("c.getAllAssets");
        action.setParams({"idOfCase":recordId});
        //alert('hello2');
      action.setCallback(this, function(a) {
        if (a.getState() === "SUCCESS") {
            component.set("v.lstAsset", a.getReturnValue());
             
            //alert('rawResponse'+JSON.stringify(a.getReturnValue()));
            //alert('wowww'+JSON.stringify(component.get("v.lstOfDiscreteModelNums")));
        }
        else{
           alert('error');    
        }
      });

    $A.enqueueAction(action);
	},
    
    cancelFindAssets : function(component, event, helper) {
        component.set("v.showFindSection",false);
    },
    
    cancelAssets : function(component, event, helper) {
        component.set("v.showSection",false);
    },
    
    showToolTip : function(component, event, helper) {
        component.set("v.dispayToolTip",true);
    },
    
    hideToolTip : function(component, event, helper) {
        component.set("v.dispayToolTip",false);
    },
    
    showToolTipRes : function(component, event, helper) {
        component.set("v.dispayToolTipRes",true);
    },
    
    hideToolTipRes : function(component, event, helper) {
        component.set("v.dispayToolTipRes",false);
    },
    
    search : function(component, event, helper) {
        //alert('hello');
        component.set("v.displayNoSerialNo",false);
        component.set("v.delSuccess",false);
        component.set("v.selOneAsset",false);
        component.set("v.showException",false);
        var recordId = component.get("v.recordId");
		var action = component.get("c.getEquipmentInfo");
        action.setParams({
         "lstName": component.find("lstname").get("v.value"),
         "ConfNo" : component.find("confnum").get("v.value"),
         "Zipcode" : component.find("zipnum").get("v.value"),
         "instalAddress" : component.find("instaddrs").get("v.value"),
         "PhNo" : component.find("phnum").get("v.value"),
         "RegisNo" : component.find("regnum").get("v.value")
       });
       // alert('hello2');
      action.setCallback(this, function(a) {
        if (a.getState() === "SUCCESS") {
            var listReturned = [];
            listReturned = a.getReturnValue();
            if(listReturned.length == 1){
              component.set("v.showSection",false);
              //$A.get('e.force:refreshView').fire();
              //var recordId = component.get("v.recordId");
		      var action2 = component.get("c.getAllAssets");
              action2.setParams({"idOfCase":recordId});
              //alert('hello2');
              action2.setCallback(this, function(b) {
                if (b.getState() === "SUCCESS") {
                  component.set("v.lstAsset", b.getReturnValue());
             
                  //alert('rawResponse2'+JSON.stringify(b.getReturnValue()));
                 //alert('wowww'+JSON.stringify(component.get("v.lstOfDiscreteModelNums")));
                }
                else{
                   alert('error');    
                }
            });

            $A.enqueueAction(action2);
              
           }
            else{
              component.set("v.showFindSection",true); 
              component.set("v.lstRegEq", a.getReturnValue());
            }
        } 
        else if (a.getState() === "ERROR") {
                var errors = a.getError();
              component.set("v.exception",JSON.stringify(errors[0].message));
              //component.set("v.displayNoSerialNo",false);
              component.set("v.showException",true);
              //alert('errors'+JSON.stringify(errors[0].message));
        }
       
      });

    $A.enqueueAction(action);
	},
    
    validate : function(component,event,helper){
       //alert('hi'+component.find("srlNo").get("v.value"));
       var recordId = component.get("v.recordId");
     if(component.find("srlNo").get("v.value") == '' || component.find("srlNo").get("v.value") == null || component.find("srlNo").get("v.value") == undefined){
         //alert('bye');
        component.set("v.showSection",false);
        component.set("v.displayNoSerialNo",true); 
        component.set("v.showException",false);
        component.set("v.delSuccess",false);
        component.set("v.selOneAsset",false);
     }
     else{    
         component.set("v.displayNoSerialNo",false);
         component.set("v.delSuccess",false);
         component.set("v.selOneAsset",false);
         component.set("v.showException",false);
         
         var action = component.get("c.getDiscreteModelNumbers");
       action.setParams({
         "idOfCase":recordId,
         "dModelNo_ModelNo" : component.find("matNo").get("v.value"),
         "dModelNo_SerialNo" : component.find("srlNo").get("v.value"),
         "dModelNo_DiscModelNo" : component.find("descMatNo").get("v.value"),
         "dModelNo_Brand" : component.find("Brand").get("v.value")
       });

      action.setCallback(this, function(a) {
        if (a.getState() === "SUCCESS") {
            var listReturned = [];
            listReturned = a.getReturnValue();
            if(listReturned.length == 1){
              component.set("v.showSection",false);
              //$A.get('e.force:refreshView').fire();
              //var recordId = component.get("v.recordId");
		      var action1 = component.get("c.getAllAssets");
              action1.setParams({"idOfCase":recordId});
              //alert('hello2');
              action1.setCallback(this, function(b) {
                if (b.getState() === "SUCCESS") {
                  component.set("v.lstAsset", b.getReturnValue());
             
                 // alert('rawResponse2'+JSON.stringify(b.getReturnValue()));
                 //alert('wowww'+JSON.stringify(component.get("v.lstOfDiscreteModelNums")));
                }
                else{
                   alert('error');    
                }
            });

            $A.enqueueAction(action1);
              
           }
            else{
              component.set("v.showSection",true); 
              component.set("v.lstOfDiscreteModelNums", a.getReturnValue());
            }
            
            
            //alert('rawResp'+JSON.stringify(a.getReturnValue()));
            //alert('wowww'+JSON.stringify(component.get("v.lstOfDiscreteModelNums")));
        }
          
          else if (a.getState() === "ERROR") {
                var errors = a.getError();
              component.set("v.exception",JSON.stringify(errors[0].message));
              //component.set("v.displayNoSerialNo",false);
              component.set("v.showException",true);
              //alert('errors'+JSON.stringify(errors[0].message));
          }
          
      });

      $A.enqueueAction(action);
     }
     
   },
    
   getSelectedRadio: function(component, evt){
       var recordId = component.get("v.recordId");
       var action = component.get("c.getSelected");
       var selected = evt.getSource().get("v.value");
       action.setParams({
         "caseId":recordId,
         "selectedPrimaryAssetId" : selected,
         "lstAsset" : component.get("v.lstAsset")
       });

      action.setCallback(this, function(a) {
        if (a.getState() === "SUCCESS") { 
            //alert('rawResp'+JSON.stringify(a.getReturnValue()));
        }
        else{
          alert('ERROR');    
        }
      });

    $A.enqueueAction(action); 
   },

   navToDelete : function(component, event, helper) {
       
       var selectedItem = event.currentTarget;
       var recId = selectedItem.dataset.record;
       var recordId = component.get("v.recordId");
       var action = component.get("c.delRecord");
            action.setParams({
                  "recordToDelete": recId,
                  "caseId":recordId
            });
            action.setCallback(this, function(a) {               
                var state = a.getState();           
		        if(state == "SUCCESS"){
                   component.set("v.lstAsset", a.getReturnValue());
                   component.set("v.delSuccess",true);
                   component.set("v.selOneAsset",false);
                   component.set("v.showException",false);
                   component.set("v.displayNoSerialNo",false);
                } else {
                     alert('Error'); 
                }    
            });
        $A.enqueueAction(action);
    },
    
   onSelect: function(component, evt) { 
         var selected = evt.getSource().get("v.text");
        //component.get("v.selectedRecords").push(selected);
        //alert('sssud'+evt.getSource().get("v.value"));
        if (evt.getSource().get("v.value")) {
           // Checkbox is checked - add id to selectedRecords
           if (component.get("v.selectedRecords").indexOf(selected) < 0) {
              component.get("v.selectedRecords").push(selected);
           }
        } else {
           // Checkbox is unchecked - remove id from selectedRecords
           var index = component.get("v.selectedRecords").indexOf(selected);
           if (index > -1) {
             component.get("v.selectedRecords").splice(index, 1);
           }
        }      
  }, 
    
  onFindSelect: function(component, evt) { 
         var selected = evt.getSource().get("v.text");
        //component.get("v.selectedRecords").push(selected);
        //alert('sssud'+evt.getSource().get("v.value"));
        if (evt.getSource().get("v.value")) {
           // Checkbox is checked - add id to selectedRecords
           if (component.get("v.selectedFindRecords").indexOf(selected) < 0) {
              component.get("v.selectedFindRecords").push(selected);
           }
        } else {
           // Checkbox is unchecked - remove id from selectedRecords
           var index = component.get("v.selectedFindRecords").indexOf(selected);
           if (index > -1) {
             component.get("v.selectedFindRecords").splice(index, 1);
           }
        }      
  }, 
    
   createNewAsset : function(component, event, helper) {
        //alert('hello66'+component.get("v.selectedRecords"));
        var recordId = component.get("v.recordId");
     if(component.get("v.selectedRecords") == '' || component.get("v.selectedRecords") == null){
        // alert('yes');
         component.set("v.delSuccess",false);
        component.set("v.selOneAsset",true);
        component.set("v.showException",false);
        component.set("v.displayNoSerialNo",false);
     }
     else{
        component.set("v.delSuccess",false);
        component.set("v.selOneAsset",false);
        component.set("v.showException",false);
        component.set("v.displayNoSerialNo",false);
		var action = component.get("c.CreateAsset");
       //alert('Stringify Val:'+JSON.stringify(component.get("v.selectedRecords")));
        action.setParams({
         "idOfCase":recordId,
         "selRecs" : component.get("v.selectedRecords"),
         "selRecsStr": JSON.stringify(component.get("v.selectedRecords"))
       });
        //alert('hello2');
      action.setCallback(this, function(a) {
        if (a.getState() == "SUCCESS") {
            var action1 = component.get("c.getAllAssets");
              action1.setParams({"idOfCase":recordId});
              //alert('hello2');
              action1.setCallback(this, function(b) {
                if (b.getState() === "SUCCESS") {
                  component.set("v.lstAsset", b.getReturnValue());
             
                 // alert('rawResponse2'+JSON.stringify(b.getReturnValue()));
                 //alert('wowww'+JSON.stringify(component.get("v.lstOfDiscreteModelNums")));
                }
                else{
                   alert('error');    
                }
            });

            $A.enqueueAction(action1);
        }
        else{
            //component.set("v.assetAdded",true);
            var errors = a.getError();
            component.set("v.exception",JSON.stringify(errors[0].message));
            component.set("v.displayNoSerialNo",false);
            component.set("v.showException",true);
            //alert('The asset with Model no# and Serial no# is already added to this case');    
        }
      });

     $A.enqueueAction(action);
    }
  },
    
    createNewAssetForSS : function(component, event, helper) {
       // alert('hello7');
      var recordId = component.get("v.recordId");
      //alert(component.get("v.selectedFindRecords"));
      if(component.get("v.selectedFindRecords") == '' || component.get("v.selectedFindRecords") == null){
           // alert('yes');
        component.set("v.delSuccess",false);
        component.set("v.selOneAsset",true);
        component.set("v.showException",false);
        component.set("v.displayNoSerialNo",false);
      }
      else{
        component.set("v.delSuccess",false);
        component.set("v.selOneAsset",false);
        component.set("v.showException",false);
        component.set("v.displayNoSerialNo",false);
		var action = component.get("c.CreateAssetForSS");
        action.setParams({"idOfCase":recordId,"selRecsString": JSON.stringify(component.get("v.selectedFindRecords"))});
       // alert('hello8');
       action.setCallback(this, function(a) {
        if (a.getState() === "SUCCESS") {
            var action1 = component.get("c.getAllAssets");
              action1.setParams({"idOfCase":recordId});
              //alert('hello2');
              action1.setCallback(this, function(b) {
                if (b.getState() === "SUCCESS") {
                  component.set("v.lstAsset", b.getReturnValue());
             
                 // alert('rawResponse2'+JSON.stringify(b.getReturnValue()));
                 //alert('wowww'+JSON.stringify(component.get("v.lstOfDiscreteModelNums")));
                }
                else{
                   alert('error');    
                }
            });

            $A.enqueueAction(action1);
        }
        else{
           alert('error');    
        }
      });

    $A.enqueueAction(action);
	}
  } 
})