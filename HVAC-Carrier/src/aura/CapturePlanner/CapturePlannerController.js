({
    successSave : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated with Planner successfully."
        });
        toastEvent.fire();
        //component.find("overlayLib").notifyClose();

    }
})