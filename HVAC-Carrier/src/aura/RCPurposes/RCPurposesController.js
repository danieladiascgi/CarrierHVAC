({
    doInit : function(component, event, helper) {
        var cseId = component.get("v.recordId");
        component.set("v.CaseId", cseId);
        var action = component.get("c.getCase");
        action.setParams({
            "id" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.case", a.getReturnValue());            
            }
        });
        
        $A.enqueueAction(action);
    },
    successSave : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": "Record Updated Successfully!."
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire(); 
    }
})