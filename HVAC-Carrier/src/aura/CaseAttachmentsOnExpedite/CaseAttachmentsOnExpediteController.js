({
	doInit : function(component, event, helper) {
		var action1 = component.get("c.getAttachments"); 
            action1.setParams({
                
                "recId": component.get("v.recordId")
                
            });
            action1.setCallback(this, function(a) {
                var state = a.getState();
                if(state === "SUCCESS"){       
                    var attachmentsList = a.getReturnValue(); 
                    //alert('attachmentsList..'+JSON.stringify(attachmentsList));
                    component.set("v.attachmentsList", a.getReturnValue());               
                }
                else{
                    alert('ERROR..');  
                }
            });
            $A.enqueueAction(action1);
	}
})