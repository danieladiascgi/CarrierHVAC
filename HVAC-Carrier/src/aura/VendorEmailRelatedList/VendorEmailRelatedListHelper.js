({
	getEmails : function(component, event) {
        var action = component.get("c.getAllEmails");
        action.setParams({
            "expId" : component.get("v.recordId"),
            //"hasAttach":component.get("v.hasAttachment")
            
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.emails", a.getReturnValue());
            }
            else{
                alert('error');    
            }
        });
        $A.enqueueAction(action);
    }
})