({
   doInit : function(component, event, helper) {      
      helper.getPurposes(component);
      helper.getPurposeGroups(component);
      
   },
   onChangeOfVal : function(component, event, helper){
      var selectCmp = component.find("pg").get("v.value");
     // alert('group');
      helper.getDepValues(component,selectCmp);  
   },
   
   handleSave : function(component, event, helper) {
      
      helper.savePurposeVals(component);
      
   },
   closeMessage: function(component, event, helper) {
        component.set("v.saveStatus", false);
        $A.get('e.force:refreshView').fire();
   },
   isClaim: function(component, event, helper) {
        if (confirm("Are you sure!") == true) {
        	helper.updateClaims(component);
    	} else {
        	return false;
    	}
        
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