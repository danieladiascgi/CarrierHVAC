({
    doInit : function(component, event, helper) {
        //alert(component.get("v.recordId"));
        var action = component.get("c.getEmailMessageRec");
        
        action.setParams({
            "expId" : component.get("v.recordId")
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
    },
    
    redirectToEmailMessageDetail: function(component, event, helper){
        //alert('hi');
        var clickedEmailRecId = event.getSource().get("v.title");
        
        //var recIdCreated = component.get("v.recIdCreated");             
        var event = $A.get( 'e.force:navigateToSObject' );
        event.setParams({
            "recordId" : clickedEmailRecId
        }).fire();
        
    },
    
    navToSendEmailReplyAll: function(component, event, helper){
        var clickedEmailRecId = event.getSource().get("v.title");
        var action = component.get("c.getEmailMessageRecToBePassed");
        var expRecId = component.get("v.recordId");
        action.setParams({
            "clickedEmailRecId" : clickedEmailRecId,
            "type" : "ReplyAll",
            "expediteId" : expRecId
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                /*component.set("v.emailMsg", a.getReturnValue());
                 var event = $A.get("e.c:NavigateToSendEmail");
                 event.setParams({ "view": "This is Testing"});
                 event.fire();*/
                var expRec = component.get("v.recordId");
                var destination = "c:ExpediteSendEmail";
                $A.createComponent(destination, {recordId:expRec,passedFromOtherCmp:"true",passedFromVendorEmail:"true",emailMsg:a.getReturnValue()}, 
                                   function(view) {
                                       var content = component.find("content");
                                       //alert('#content:'+content);
                                       content.set("v.body", view);
                                   });
            }
            else{
                alert('error');    
            }
        });
        $A.enqueueAction(action);        
        
    },
    navToSendEmailReply: function(component, event, helper){
        var clickedEmailRecId = event.getSource().get("v.title");
        var action = component.get("c.getEmailMessageRecToBePassed");
        var expRecId = component.get("v.recordId");
        action.setParams({
            "clickedEmailRecId" : clickedEmailRecId,
            "type" : "Reply",
            "expediteId" : expRecId
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                /*component.set("v.emailMsg", a.getReturnValue());
                 var event = $A.get("e.c:NavigateToSendEmail");
                 event.setParams({ "view": "This is Testing"});
                 event.fire();*/
                var expRec = component.get("v.recordId");
                var destination = "c:ExpediteSendEmail";
                $A.createComponent(destination, {recordId:expRec,passedFromOtherCmp:"true",passedFromVendorEmail:"true",emailMsg:a.getReturnValue()}, 
                                   function(view) {
                                       var content = component.find("content");
                                       //alert('#content:'+content);
                                       content.set("v.body", view);
                                   });
            }
            else{
                alert('error');    
            }
        });
        $A.enqueueAction(action);        
        
    },
    navToSendEmailForward: function(component, event, helper){
        var clickedEmailRecId = event.getSource().get("v.title");
        var action = component.get("c.getEmailMessageRecToBePassed");
        var expRecId = component.get("v.recordId");
        action.setParams({
            "clickedEmailRecId" : clickedEmailRecId,
            "type" : "Forward",
            "expediteId" : expRecId
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                /*component.set("v.emailMsg", a.getReturnValue());
                 var event = $A.get("e.c:NavigateToSendEmail");
                 event.setParams({ "view": "This is Testing"});
                 event.fire();*/
                var expRec = component.get("v.recordId");
                var destination = "c:ExpediteSendEmail";
                $A.createComponent(destination, {recordId:expRec,passedFromOtherCmp:"true",passedFromVendorEmail:"true",emailMsg:a.getReturnValue()}, 
                                   function(view) {
                                       var content = component.find("content");
                                       //alert('#content:'+content);
                                       content.set("v.body", view);
                                   });
            }
            else{
                alert('error');    
            }
        });
        $A.enqueueAction(action);        
        
    },
    NavigateToSendEmail : function(component,event,helper) {
        //alert('Navigate to SAP');
        var expRec = component.get("v.recordId");
        var emailMsg = component.get("v.emailMsg");
        var destination = "c:ExpediteSendEmail";
        //alert(this.type);
        //alert(destination);
        $A.createComponent(destination, {recordId:expRec,passedFromOtherCmp:"true",emailMsg:emailMsg}, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });
    },
    handleShowModal: function(component, event, helper) {
        
        var modalBody;
        //  alert('inside handleshowmodal');
        
        var clickedEmailRecId = event.getSource().get("v.title");
        
        $A.createComponent("c:EmailDetailPage", {"clickedEmailRecId":clickedEmailRecId, "source":"VendorEmail"},
                           
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "Email Detail Page",
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "slds-modal_large",
                                       closeCallback: function() {
                                           // alert('You closed the alert!');
                                       }
                                   })
                                   
                               }
                               
                           });
        
        
    },
    updatenewmsg: function(component, event, helper) {
        // alert('updatenewmsg'+component.get("v.recordId"));
        var action = component.get("c.getNewmsg");
        action.setParams({
            "expId" : component.get("v.recordId")
        });  
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                // alert('success');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams
                ({
                    title: "Success!",
                    message: "Marked all emails as read!..!",
                    type: "success"
                    
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            else{
                //  alert('error');    
            }
        });
        $A.enqueueAction(action);
    },
    NavgToSendEmailReply: function(component, event, helper){
        component.set("v.spinnerShow",true); 
        
        var clickedEmailRecId = event.getParam("emailMessageId");
        var source = event.getParam("source");
        //alert('Handling Event Here:'+clickedEmailRecId);
        if(source!=null && source!='undefined' && source.length>0 && source=='VendorEmail'){
        //if(true){
            var action = component.get("c.getEmailMessageRecToBePassed");
            var expRecId = component.get("v.recordId");
            action.setParams({
                "clickedEmailRecId" : clickedEmailRecId,
                "type" : "Reply",
                "expediteId" : expRecId
            });
            action.setCallback(this, function(a) {
                if (a.getState() === "SUCCESS") {
                    /*component.set("v.emailMsg", a.getReturnValue());
                     var event = $A.get("e.c:NavigateToSendEmail");
                     event.setParams({ "view": "This is Testing"});
                     event.fire();*/
                    var expRec = component.get("v.recordId");
                    var destination = "c:ExpediteSendEmail";
                    component.set("v.spinnerShow",false); 
                    
                    $A.createComponent(destination, {recordId:expRec,passedFromOtherCmp:"true",passedFromVendorEmail:"true",emailMsg:a.getReturnValue()}, 
                                       function(view) {
                                           var content = component.find("content");
                                           //alert('#content:'+content);
                                           content.set("v.body", view);
                                       });
                }
                else{
                    alert('error');    
                }
            });
               $A.enqueueAction(action); 
       }else{
            component.set("v.spinnerShow",false);
        }    
       },
    NavgToSendEmailReplyAll: function(component, event, helper){
        component.set("v.spinnerShow",true); 
        
        var clickedEmailRecId = event.getParam("EmailMessageId");
        var source = event.getParam("source");
        // alert('Handling Event Here:'+clickedEmailRecId);
        if(source!=null && source!='undefined' && source.length>0 && source=='VendorEmail'){
        //if(true){
            var action = component.get("c.getEmailMessageRecToBePassed");
            var expRecId = component.get("v.recordId");
            action.setParams({
                "clickedEmailRecId" : clickedEmailRecId,
                "type" : "ReplyAll",
                "expediteId" : expRecId
            });
            action.setCallback(this, function(a) {
                if (a.getState() === "SUCCESS") {
                    /*component.set("v.emailMsg", a.getReturnValue());
                     var event = $A.get("e.c:NavigateToSendEmail");
                     event.setParams({ "view": "This is Testing"});
                     event.fire();*/
                    var expRec = component.get("v.recordId");
                    var destination = "c:ExpediteSendEmail";
                    component.set("v.spinnerShow",false); 
                    
                    $A.createComponent(destination, {recordId:expRec,passedFromOtherCmp:"true",passedFromVendorEmail:"true",emailMsg:a.getReturnValue()}, 
                                       function(view) {
                                           var content = component.find("content");
                                           //alert('#content:'+content);
                                           content.set("v.body", view);
                                       });
                }
                else{
                    alert('error');    
                }
            });
              $A.enqueueAction(action);        
         }else{
            component.set("v.spinnerShow",false);
        } 
      },
    
    NavgToSendEmailForward: function(component, event, helper){
        component.set("v.spinnerShow",true); 
        
        var clickedEmailRecId = event.getParam("MessageID");
        var source = event.getParam("source");
        //  alert('Handling Event Here:'+clickedEmailRecId);
        if(source!=null && source!='undefined' && source.length>0 && source=='VendorEmail'){

            var action = component.get("c.getEmailMessageRecToBePassed");
            var expRecId = component.get("v.recordId");
            action.setParams({
                "clickedEmailRecId" : clickedEmailRecId,
                "type" : "Forward",
                "expediteId" : expRecId
            });
            action.setCallback(this, function(a) {
                if (a.getState() === "SUCCESS") {
                    /*component.set("v.emailMsg", a.getReturnValue());
                     var event = $A.get("e.c:NavigateToSendEmail");
                     event.setParams({ "view": "This is Testing"});
                     event.fire();*/
                    var expRec = component.get("v.recordId");
                    var destination = "c:ExpediteSendEmail";
                    component.set("v.spinnerShow",false); 
                    
                    $A.createComponent(destination, {recordId:expRec,passedFromOtherCmp:"true",passedFromVendorEmail:"true",emailMsg:a.getReturnValue()}, 
                                       function(view) {
                                           var content = component.find("content");
                                           //alert('#content:'+content);
                                           content.set("v.body", view);
                                       });
                }
                else{
                    alert('error');    
                }
            });
            $A.enqueueAction(action);        
        }else{
            component.set("v.spinnerShow",false);
        }
    },
    getAllVendorEmails: function(component, event, helper){
        helper.getEmails(component, event);
    }
})