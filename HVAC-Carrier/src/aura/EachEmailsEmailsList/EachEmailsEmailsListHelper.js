({
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
    },
    updateReadStatus : function(component,event) {
        var emsgRec = component.get("v.emsg");
        var action1 = component.get("c.updateEmailMsgCustomStatus"); 
        action1.setBackground();
        action1.setParams({
            
            "emailMsgId": emsgRec.Id
            //"recId": 'a1W63000000QUO5'
        });
        // alert('success');
        action1.setCallback(this, function(a) {
            var state = a.getState();
            if(state === "SUCCESS"){
                if(emsgRec.Incoming==true){
                    emsgRec.Status = 'Read';
                    component.set("v.emsg", emsgRec);
                }
                
            }
            else{
                alert('ERROR..');  
            }
        });
        $A.enqueueAction(action1);
    },
    getSubSetOfTextBody : function(component,event) {
        var emsgRec = component.get("v.emsg");
        if(emsgRec!=null && emsgRec!='undefined' && emsgRec.TextBody!=null && emsgRec.TextBody!='undefined' && emsgRec.TextBody.length>0){
            var body = emsgRec.TextBody;
            if(body.length>75){
                body = body.substring(0,75);
            }else{
                body = body.substring(0,body.length);
            }
            body = body + '...';
            component.set('v.TextBodyPart', body);
            
        }
    },
    checkIfCurrentLoggedInUserIsExpedite : function(component,event) {
        var action = component.get("c.checkIfCurrentLoggedInUserIsExpedite");
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.showReplyAllButton", a.getReturnValue());
            }
            else{
                alert('error');    
            }
        });
        $A.enqueueAction(action);
    }
})