({
    doInit : function(component, event, helper) {
        //alert('EmaildetailPageInit');
        component.set("v.spinnerShow",true); 
        var action = component.get("c.getEmailMessageRecToBePassed");
        // var clickedEmailRecId ='02s0m000000GKSHAA4';
        var clickedEmailRecIdVal = component.get("v.clickedEmailRecId");
        //alert('clickedEmailRecIdValinit'+clickedEmailRecIdVal);
        action.setParams({
            "clickedEmailRecId" : clickedEmailRecIdVal
            
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.spinnerShow",false); 
                component.set("v.emsg", a.getReturnValue());
                helper.getEmailAttachments(component,event,clickedEmailRecIdVal);
            }
            else{
                component.set("v.spinnerShow",false); 
                //alert('error');    
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
    sectionOne : function(component, event, helper) {
        helper.helperFun(component,event,'articleOne');
    },
    NavgToSendEmailReply: function(component, event, helper){
        component.set("v.spinnerShow",true); 
        //  component.find('overlayLib').notifyClose();
        //alert('navToSendEmailReply');             
        var clickedEmailRecId = component.get("v.clickedEmailRecId");
        // alert('clickedEmailRecId'+clickedEmailRecId);
        component.set("v.spinnerShow",false); 
        var navReplyEvnt = $A.get("e.c:NavgToSendEmailReply"); 
        navReplyEvnt.setParams({
            "emailMessageId" : clickedEmailRecId,
            "source" : component.get("v.source")
        });
        navReplyEvnt.fire();
        
        component.find('overlayLib').notifyClose();
        
        //  component.destroy();
    },
    
    NavgToSendEmailReplyAll:function(component, event, helper){
        component.set("v.spinnerShow",true); 
        var clickedEmailRecId = component.get("v.clickedEmailRecId");
        // alert('clickedEmailRecId'+clickedEmailRecId);
        component.set("v.spinnerShow",false); 
        var navReplyAllEvnt = $A.get("e.c:NavgToSendEmailReplyAll"); 
        navReplyAllEvnt.setParams({
            "EmailMessageId" : clickedEmailRecId,
            "source" : component.get("v.source")
        });
        navReplyAllEvnt.fire();
        
        component.find('overlayLib').notifyClose();
        //  component.destroy();
    },
    
    NavgToSendEmailForward: function(component,event,helper) {
        component.set("v.spinnerShow",true); 
        var clickedEmailRecId = component.get("v.clickedEmailRecId");
        //alert('clickedEmailRecId'+clickedEmailRecId);
        component.set("v.spinnerShow",false); 
        var navReplyForwardEvnt = $A.get("e.c:NavgToSendEmailForward"); 
        navReplyForwardEvnt.setParams({
            "MessageID" : clickedEmailRecId,
            "source" : component.get("v.source")
        });
        navReplyForwardEvnt.fire();
        
        component.find('overlayLib').notifyClose();
        
        //  component.destroy();
    },
    
    NavigateToSendEmail : function(component,event,helper) {
        alert('NavigateToSendEmail');
        var expRec = component.get("v.clickedEmailRecId");
        var emailMsg = component.get("v.v.emsg");
        var destination = "c:ExpediteSendEmail";
        //alert(this.type);
        //alert(destination);
        $A.createComponent(destination, {recordId:expRec,passedFromOtherCmp:"true",emailMsg:emailMsg}, 
                           function(view) {
                               var content = component.find("content");
                               alert('#content:'+content);
                               content.set("v.body", view);
                           });
    }
    
})