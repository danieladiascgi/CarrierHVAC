({
    //Fetch the accounts from the Apex controller
    getPurposes: function(component) {
        var recordId = component.get("v.recordId");
     	var action = component.get("c.getPurposes");
     	//Set up the callback
     	action.setParams({"idOfCase":recordId,"selectCmp":'All'});
     	action.setCallback(this, function(actionResult) {
            component.set("v.listOfPurposes", actionResult.getReturnValue());
        	//component.set("v.accountsLength", actionResult.getReturnValue().length); 
        	//alert('thelist..'+JSON.stringify(component.get("v.listOfPurposes")));
      	});	
        $A.enqueueAction(action);  
    },
    getPurposeGroups: function(component) {
        var recordId = component.get("v.recordId");
     	var action = component.get("c.getPGs");
        action.setParam("idOfCase", recordId);
     	//Set up the callback
     	action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if(state === "SUCCESS"){
                
                //var addAll = new Object({0:'All'});
                //addAll.
                /*addAll.push({
                  class: "optionClass",
                  label: "All",
                  value: "All"
               });*/
                //addAll.push("All");
                //alert('Type of:'+typeof(actionResult.getReturnValue()));
                //var obj = actionResult.getReturnValue();
                //var arr = Object.keys(obj).map(function (key) { return obj[key]; });
               // addAll.push(Object.keys(obj).map(function (key) { return obj[key]; }));
                //alert(JSON.stringify(component.get("v.caseRec")));
                component.set("v.purposeGroups", actionResult.getReturnValue());

            } else{
                //alert('Error:');
            }
            
        	//component.set("v.accountsLength", actionResult.getReturnValue().length); 
      	});	
        $A.enqueueAction(action);  
    },
    getDepValues: function(component,selectCmp){
        var recordId = component.get("v.recordId");
     	var action = component.get("c.getPurposes");
        action.setParams({"idOfCase":recordId,"selectCmp":selectCmp});
     	action.setCallback(this, function(actionResult) {
            component.set("v.listOfPurposes", actionResult.getReturnValue());
        	//component.set("v.accountsLength", actionResult.getReturnValue().length); 
        	//alert('thelist..'+JSON.stringify(component.get("v.listOfPurposes")));
      	});	
        $A.enqueueAction(action);
        
    },
    savePurposeVals: function(component) {
        var recordId = component.get("v.recordId");
      //  alert('test purpose');
        var lstOfPurp = component.get("v.listOfPurposes");
     //   alert('lstOfPurp:'+lstOfPurp);
        //alert('Stringify lstOfPurp:'+JSON.stringify(lstOfPurp));
        var jsonValStr = new String(JSON.stringify(lstOfPurp));
        if(jsonValStr.indexOf('"count":""')){
            jsonValStr = jsonValStr.replace(/"count":""/g , '"count":"0"');
        }
        //alert('jsonValStr:'+jsonValStr);
     
     var action = component.get("c.savePurpose");
        action.setParams({"lstOfPurpStr": jsonValStr,"idOfCase":recordId});
     	//Set up the callback
     	action.setCallback(this, function(actionResult) {
           var state = actionResult.getState();
           if(state === "SUCCESS"){
            component.set("v.saveStatus", true);  
            setTimeout(function(){/*alert('should close now');*/component.set("v.saveStatus", false);}, 1000);
            $A.get('e.force:refreshView').fire();
           }
           else{
              //alert('Error:');
           }
      	});	
        $A.enqueueAction(action);     
       
    },
    updateClaims: function(component) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateClaim");
        action.setParams({"idOfCase":recordId});
        action.setCallback(this, function(actionResult) {
           var state = actionResult.getState();
           if(state === "SUCCESS"){
            	$A.get('e.force:refreshView').fire();
           }
           else{
              //alert('Error:');
           }
      	});	
        $A.enqueueAction(action);      
    }
})