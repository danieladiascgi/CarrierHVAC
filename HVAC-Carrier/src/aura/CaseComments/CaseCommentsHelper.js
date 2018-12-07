({
	getPlannerInformation: function(component, event) {
        
        var action = component.get("c.checkIfPlannerIsEmpty");
        action.setParams({
            "ExpediteId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                if(response.getReturnValue()==true){
                    var modalBody;
                    $A.createComponent("c:CapturePlanner", {ExpediteId:component.get("v.recordId")},
                                       
                                       function(content, status) {
                                           if (status === "SUCCESS") {
                                               modalBody = content;
                                               component.find('overlayLib').showCustomModal({
                                                   header: "Expedite Planner Information",
                                                   body: modalBody, 
                                                   showCloseButton: true,
                                                   cssClass: "slds-modal_small",
                                                   closeCallback: function() {
                                                       //alert('Click Ok to close popup!!');
                                                        $A.get('e.force:refreshView').fire();
                                                   }
                                               })
                                               
                                           }
                                           
                                       });
                }else{
                    
                }
            }
        });
        $A.enqueueAction(action);
    }
})