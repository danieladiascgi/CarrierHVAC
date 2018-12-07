({
    doInit : function(component, event, helper) {
        
        /* if(component.get("v.passedFromOtherCmp") == true){
             alert(component.get("v.passedFromOtherCmp"));
          var getFromAddr = component.find("from").get("v.value");
            alert(component.find("from").get("v.value"));
         var getCcAddr = component.find("cc").get("v.value");
        alert(component.find("cc").get("v.value"));
        var getEmail = component.find("to").get("v.value");
         // var replyall =getEmail+getCcAddr;
         // component.set("v.emailMsg.ToAddress",replyall);
        }*/
        var actiondisplay = component.get("c.fetchUser");
        actiondisplay.setParams({
            // "ExpId":  component.get("v.recordId")
        });         
        actiondisplay.setCallback(this,function(response)
        {
           component.set("v.LoggedInEmail",response.getReturnValue());
           var state=response.getState();
           var result=response.getReturnValue();
           if(state=="SUCCESS")
           {
              component.set("v.LoggedInEmail",result);
           }
         }); 
        $A.enqueueAction(actiondisplay);
        if(component.get("v.passedFromOtherCmp") == false){
            
            var action = component.get("c.populateTemplate");
            action.setParams({
                "expId" : component.get("v.recordId")
            });
            action.setCallback(this, function(a) {
                if (a.getState() === "SUCCESS") {
                    component.set("v.emailMsg", a.getReturnValue()); 
                    var action1 = component.get("c.getAttachments"); 
                    action1.setParams({
                        
                        "recId": component.get("v.recordId")
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
                    //alert(component.get("v.emailMsg"));
                }
                else{
                    alert('error');
                    //component.set("v.emailMsg", '');
                }
            });
            
            $A.enqueueAction(action);
        }else{
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
        helper.helperFun(component,event,'articleOne');
    },
    
    NavToSendEmail : function(component, event, helper){
        //alert('navigatinggg...'); 
    },
    
    cancel : function(component, event, helper){
        /*var event = $A.get("e.c:NavigateToEmailsRelatedList");
        event.setParams({ "view": "This is Testing"});
        //alert('Firing Evt:'+event);
        event.fire();*/
        var expRec = component.get("v.recordId");
        var destination = "c:EmailsRelatedList";
        //alert(this.type);
        //alert(destination);
        $A.createComponent(destination, {recordId:expRec}, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });
    },
    
    NavigateToEmailsRelatedList : function(component,event,helper) {
        //alert('Navigate to SAP');
        var expRec = component.get("v.recordId");
        var destination = "c:EmailsRelatedList";
        //alert(this.type);
        //alert(destination);
        $A.createComponent(destination, {recordId:expRec}, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });
    },
     cancelvendoremail : function(component, event, helper){
        // alert('cancelvendoremail');
        /*var event = $A.get("e.c:NavigateToVendorEmailRelatedList");
        event.setParams({ "view": "This is Testing"});
        //alert('Firing Evt:'+event);
        event.fire();*/
          var expRec = component.get("v.recordId");
        var destination = "c:VendorEmailRelatedList";
        //alert(this.type);
        //alert(destination);
        $A.createComponent(destination, {recordId:expRec}, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });
    },
    
    NavigateToVendorEmailRelatedList : function(component,event,helper) {
       // alert('Navigate to NavigateToVendorEmailRelatedList');
        var expRec = component.get("v.recordId");
        var destination = "c:VendorEmailRelatedList";
        //alert(this.type);
        //alert(destination);
        $A.createComponent(destination, {recordId:expRec}, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });
    },
    
    populateBodyWithTmplt : function(component, event, helper){
        var selected = event.getSource().get("v.text");       
        // alert('selected..'+selected);
        var action = component.get("c.populateBodyWithTemplate");
        action.setParams({
            "expId" : component.get("v.recordId"),
            "paramRec" : selected,
            "emailMsg" : component.get("v.emailMsg")
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.emailMsg", a.getReturnValue());            
                //alert(JSON.stringify(component.get("v.emailMsg")));
                var cmpTarget = component.find('Modalbox');
                var cmpBack = component.find('Modalbackdrop');
                $A.util.removeClass(cmpBack,'slds-backdrop--open');
                $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
            }
            else{
                alert('error');
                //component.set("v.emailMsg", '');
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    sendMail: function(component, event, helper) {
        //alert('hi1');
        var getFromAddr = component.find("from").get("v.value");
        var getCcAddr = component.find("cc").get("v.value");
        // alert(component.find("cc").get("v.value"));
        var getEmail = component.find("to").get("v.value");
        var getSubject = component.find("subject").get("v.value");
        var getbody = component.find("body").get("v.value");
        var recordId = component.get("v.recordId");
        var selectedfile = component.get("v.selectedRecords");
        var selectedAttachments = component.get("v.attachmentsList");
        //alert('hi2');
        // check if Email field is Empty or not contains @ so display a alert message 
        // otherwise call call and pass the fields value to helper method    
        if ($A.util.isEmpty(getEmail) || !getEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        } else {
            // alert('helper');
            //alert('hi3');
            helper.sendHelper(component, getFromAddr,getCcAddr, getEmail, getSubject, getbody,selectedfile, selectedAttachments);           
        }               
    },
    
    
    onSelectChange : function(component, event, helper) {
        var selected = component.find("levels").get("v.value");
    },
    
    
    onSelect: function(cmp, evt) { 
        var selected = evt.getSource().get("v.text");
        var selRecs = cmp.get("v.selectedRecords");
        var selectedAttachments = [];
        if(selRecs!=null && typeof(selRecs)!=undefined && typeof(selRecs)!='undefined'){
            selectedAttachments = cmp.get("v.selectedRecords");
        }
        selectedAttachments.push({
            value: selected
        });
        //alert('Selected:'+selected);
        cmp.set("v.selectedRecords", selectedAttachments);
    }, 
    
    
    printEmailMsg : function(component, event, helper){
        var emlMsg = component.get("v.emailMsg");
        //alert('Subject:'+emlMsg.Subject);
        //alert('HTML Body:'+emlMsg.HtmlBody);
        
    },
    closeModal:function(component,event,helper){ 
        //component.set("v.dispayModal",false);
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    
    selTemplate : function(component, event, helper){
        //alert('Hiii');
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        //component.set("v.displayModal",true);
        var action = component.get("c.selectTemplatePopup");
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.listTemplates", a.getReturnValue()); 
                //alert(JSON.stringify(component.get("v.listTemplates")));
            }
            else{
                alert('error');
                //component.set("v.emailMsg", '');
            }
        });
        
        $A.enqueueAction(action);
    },
    
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        $A.get('e.force:refreshView').fire();
        
    },
    refreshAttachments: function(component, event, helper) {
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
    },
    sectionOne : function(component, event, helper) {
       helper.helperFun(component,event,'articleOne');
    }
})