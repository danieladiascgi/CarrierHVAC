({
    doInit : function(component, event, helper) {
        var emsgRec = component.get("v.emsg");
        helper.getEmailAttachments(component,event,emsgRec.Id);
        helper.getSubSetOfTextBody(component,event);
        helper.checkIfCurrentLoggedInUserIsExpedite(component, event);
        
    },
    showDescription : function(component, event, helper) {
        var showBodyBoolean = component.get("v.showBody"); 
        if(showBodyBoolean){
            component.set("v.showBody", false);
        }else{
            component.set("v.showBody", true);
        }
        helper.updateReadStatus(component, event);
    },
    NavgToSendEmail: function(component, event, helper){
        component.set("v.spinnerShow",true); 
        var selectedMenuItemValue = event.getParam("value");
        var emsgRec = component.get("v.emsg");             
        var clickedEmailRecId = emsgRec.Id;
        component.set("v.spinnerShow",false); 
        if(selectedMenuItemValue=='Reply'){
            var navReplyEvnt = $A.get("e.c:NavgToSendEmailReply"); 
            navReplyEvnt.setParams({
                "emailMessageId" : clickedEmailRecId,
                "source" : component.get("v.source")
            });
            navReplyEvnt.fire();
        }else if(selectedMenuItemValue=='ReplyAll'){
            var navReplyAllEvnt = $A.get("e.c:NavgToSendEmailReplyAll"); 
            navReplyAllEvnt.setParams({
                "EmailMessageId" : clickedEmailRecId,
                "source" : component.get("v.source")
            });
            navReplyAllEvnt.fire();
        }else{
            var navReplyForwardEvnt = $A.get("e.c:NavgToSendEmailForward"); 
            navReplyForwardEvnt.setParams({
                "MessageID" : clickedEmailRecId,
                "source" : component.get("v.source")
            });
            navReplyForwardEvnt.fire();
        }
        
        
        
        
        //  component.destroy();
    },
    
    
})