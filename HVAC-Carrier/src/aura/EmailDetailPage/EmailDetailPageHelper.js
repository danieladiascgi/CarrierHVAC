({
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    getEmailAttachments : function(component,event,emailMessageId) {
        var action1 = component.get("c.getAttachments"); 
        action1.setParams({
            
            "recId": emailMessageId
            //"recId": 'a1W63000000QUO5'
        });
        // alert('success');
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