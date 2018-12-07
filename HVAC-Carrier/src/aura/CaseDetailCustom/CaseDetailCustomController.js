({
    doInit : function(component, event, helper) {
        //alert('bye'+component.get("v.clickedCaseRecId"));
        var action = component.get("c.fetchCase");
        var CaseId= component.get("v.clickedCaseRecId");
        
        var actiondisplay = component.get("c.DisplayComments");
        actiondisplay.setParams({
            "CaseId": CaseId
            
        });          
        actiondisplay.setCallback(this,function(response)
                                  {
                                      component.set("v.CmdList",response.getReturnValue());
                                      var state=response.getState();
                                      var result=response.getReturnValue();
                                      if(state=="SUCCESS"){component.set("v.CmdList",result);}
                                  }); 
        $A.enqueueAction(actiondisplay);
        
        
        var actiondisplayattach = component.get("c.DisplayAttachments");
        //  alert('actiondisplayattach'+actiondisplayattach);
        actiondisplayattach.setParams({
            "CaseId": CaseId
            
        });          
        actiondisplayattach.setCallback(this,function(response)
                                        {
                                            component.set("v.AttachList",response.getReturnValue());
                                            var state=response.getState();
                                            var result=response.getReturnValue();
                                            //alert('result'+JSON.stringify(result));
                                            if(state=="SUCCESS"){component.set("v.AttachList",result);}
                                        }); 
        $A.enqueueAction(actiondisplayattach);
        
        
        /*  var actiondisplay2 = component.get("c.DisplayFeed");
        actiondisplay2.setParams({
           "CaseId": CaseId
          
           });          
        actiondisplay2.setCallback(this,function(response)
        {
            //component.set("v.FeedList",response.getReturnValue());
            var state=response.getState();
            var result=response.getReturnValue();
            if(state=="SUCCESS"){
                component.set("v.feedList",result);
                alert('result..'+JSON.stringify(result));
            }
                       
        }); 
        $A.enqueueAction(actiondisplay2);*/
        //Display Existing Comments – End        
        
        action.setParams({
            "caseRecordId" : component.get("v.clickedCaseRecId")
        });
        //alert('jj');
        action.setCallback(this, function(a) {
            //alert('kk');
            if (a.getState() === "SUCCESS") {
                component.set("v.caseWrp", a.getReturnValue());
                //alert(JSON.stringify(component.get("v.caseWrp")));
            }
            else{
                alert('error');    
            }
        });
        $A.enqueueAction(action);
        
        var actionemail = component.get("c.getEmailMessageRec");
        actionemail.setParams({
            "CaseId": CaseId
        });
        actionemail.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.emails", a.getReturnValue());
            }
            else{
                alert('error');    
            }
        });
        $A.enqueueAction(actionemail);
        
        var actionexpedite = component.get("c.getExpediteRec");
        actionexpedite.setParams({
            "CaseId": CaseId
        });
        actionexpedite.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.expedites", a.getReturnValue());
            }
            else{
                alert('error');    
            }
        });
        $A.enqueueAction(actionexpedite); 
        var status = component.get("c.checkStatus");
        status.setParams({
            "CaseId": CaseId
            
        });
        status.setCallback(this,function(response)
                           {
                               component.set("v.status",response.getReturnValue());
                               
                               var state=response.getState();
                               var result=response.getReturnValue();
                               // alert(result);
                               if(state=="SUCCESS"){
                                   component.set("v.status",result);
                                   if(result=='Closed')
                                       component.set("v.showComments", false); 
                               }
                           }); 
        $A.enqueueAction(status);
    },
    
    sectionOne : function(component, event, helper) {
        helper.helperFun(component,event,'articleOne');
    },
    
    sectionTwo : function(component, event, helper) {
        helper.helperFun(component,event,'articleTwo');
    },
    
    sectionThree : function(component, event, helper) {
        helper.helperFun(component,event,'articleThree');
    },
    
    sectionFour : function(component, event, helper) {
        helper.helperFun(component,event,'articleFour');
    },
    
    sectionFive : function(component, event, helper) {
        helper.helperFun(component,event,'articleFive');
    },
    sectionSix : function(component, event, helper) {
        helper.helperFun(component,event,'articleSix');
    },
    detailTab: function(component, event, helper) {
        var tab1 = component.find('detailId');
        var TabOnedata = component.find('detailTabDataId');
        
        var tab2 = component.find('commentId');
        var TabTwoData = component.find('commentTabDataId');
        
       /* var tab3 = component.find('feedId');
        var TabThreeData = component.find('feedActualDataId');*/
        
        var tab4 = component.find('emailId');
        var TabFourData = component.find('emailTabDataId');
        
        var tab5 = component.find('expediteId');
        var TabFiveData = component.find('expediteTabDataId');
        
        //show and Active fruits tab
        $A.util.addClass(tab1, 'slds-active');
        $A.util.addClass(TabOnedata, 'slds-show');
        $A.util.removeClass(TabOnedata, 'slds-hide');
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');
        
        
    },
    
    commentTab: function(component, event, helper) {
        
        var tab1 = component.find('detailId');
        var TabOnedata = component.find('detailTabDataId');
        
        var tab2 = component.find('commentId');
        var TabTwoData = component.find('commentTabDataId');
        
        var tab3 = component.find('feedId');
        var TabThreeData = component.find('feedActualDataId');
        
        var tab4 = component.find('emailId');
        var TabFourData = component.find('emailTabDataId');
        
        var tab5 = component.find('expediteId');
        var TabFiveData = component.find('expediteTabDataId');
        
        //show and Active vegetables Tab
        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-hide');
        $A.util.addClass(TabTwoData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');
        
        
        
    },
    
    feedTab: function(component, event, helper) {
        var tab1 = component.find('detailId');
        var TabOnedata = component.find('detailTabDataId');
        
        var tab2 = component.find('commentId');
        var TabTwoData = component.find('commentTabDataId');
        
        var tab3 = component.find('feedId');
        var TabThreeData = component.find('feedActualDataId');
        
        var tab4 = component.find('emailId');
        var TabFourData = component.find('emailTabDataId');
        
        var tab5 = component.find('expediteId');
        var TabFiveData = component.find('expediteTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-hide');
        $A.util.addClass(TabThreeData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');
        
    },
    emailTab: function(component, event, helper) {
        // alert('email');
        var tab1 = component.find('detailId');
        var TabOnedata = component.find('detailTabDataId');
        
        var tab2 = component.find('commentId');
        var TabTwoData = component.find('commentTabDataId');
        
        var tab3 = component.find('feedId');
        var TabThreeData = component.find('feedActualDataId');
        
        var tab4 = component.find('emailId');
        var TabFourData = component.find('emailTabDataId');
        
        var tab5 = component.find('expediteId');
        var TabFiveData = component.find('expediteTabDataId');
        
        //show and Active color Tab
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.addClass(TabThreeData, 'slds-hide');
        $A.util.removeClass(TabThreeData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.addClass(tab4, 'slds-active');
        $A.util.addClass(TabFourData, 'slds-show');
        $A.util.removeClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');
        
    },
    
    expediteTab: function(component, event, helper) {
        var tab1 = component.find('detailId');
        var TabOnedata = component.find('detailTabDataId');
        
        var tab2 = component.find('commentId');
        var TabTwoData = component.find('commentTabDataId');
        
        var tab3 = component.find('feedId');
        var TabThreeData = component.find('feedActualDataId');
        
        var tab4 = component.find('emailId');
        var TabFourData = component.find('emailTabDataId');
        
        var tab5 = component.find('expediteId');
        var TabFiveData = component.find('expediteTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-hide');
        $A.util.addClass(TabFiveData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
         
    },
    
    saveComment: function(component, event, helper) {
        
        var commentbody=component.get("v.CommentBody");
        // alert('commentbody'+commentbody);
        //  alert(commentbody.length);
        if(commentbody.length>4000)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams
            ({
                title: "Error!",
                message: "Limit Exceeded..! You can't use more than 4000 characters..!! ",
                type: "error"
                
            });
            toastEvent.fire();
            // $A.get('e.force:refreshView').fire();
            
        }
        var ispublished=component.get("v.IsPublished");
        
        if(ispublished=='' || ispublished == null){
            //  alert('Bool');
            ispublished=false;
        }
        
        var CaseId= component.get("v.clickedCaseRecId");
        
        
        
        var action = component.get("c.SaveComments");
        action.setParams
        ({
            "commentbody": commentbody,
            "ispublished": ispublished,
            "CaseId": CaseId
            
        });
        action.setCallback(this, function(response)
                           {
                               
                               
                               var state =  response.getState();
                               
                               
                           });
        
        
        
        
        
        
        $A.enqueueAction(action);
        var actiondisplay = component.get("c.DisplayComments"); 
        var CaseId= component.get("v.clickedCaseRecId");
        actiondisplay.setParams({
            "CaseId": CaseId
            
        }); 
        actiondisplay.setCallback(this,function(response)
                                  {
                                      component.set("v.CmdList",response.getReturnValue());
                                      var state=response.getState();
                                      var result=response.getReturnValue();
                                      if(state=="SUCCESS"){component.set("v.CmdList",result);}
                                  }); 
        $A.enqueueAction(actiondisplay);
        
        
        
    },
    
    saveFeed: function(component, event, helper) {      
        
        var body=component.get("v.feedBody");
        alert(body);
        var CaseId= component.get("v.clickedCaseRecId");
        //  alert('commentbody'+commentbody);
        //  alert('ispublished'+ispublished);
        var action = component.get("c.SaveFeed");
        action.setParams
        ({
            "body": body,
            
            "CaseId": CaseId
            
        });
        action.setCallback(this, function(response)
                           {
                               var state =  response.getState();
                               
                           });
        
        $A.enqueueAction(action);
        
        var actiondisplay2 = component.get("c.DisplayFeed"); 
        var CaseId= component.get("v.clickedCaseRecId");
        actiondisplay2.setParams({
            "CaseId": CaseId
            
        }); 
        actiondisplay2.setCallback(this,function(response)
                                   {
                                       //component.set("v.feedList",response.getReturnValue());
                                       var state=response.getState();
                                       var result=response.getReturnValue();
                                       if(state=="SUCCESS"){
                                           component.set("v.feedList",result);
                                       }
                                       
                                   }); 
        $A.enqueueAction(actiondisplay2);
    },
    
    handleShowModal: function(component, event, helper) {
        var modalBody;
        //alert('inside handleshowmodal');
        
        var clickedEmailRecId = event.getSource().get("v.title");
        //alert('clickedEmailRecId'+clickedEmailRecId); 
        //  component.set("v.mailbodyStatus", true);
        $A.createComponent("c:EmailDetailPage", {"clickedEmailRecId":clickedEmailRecId},
                           
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "Email Detail Page",
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "mymodal",
                                       closeCallback: function() {
                                           // alert('You closed the alert!');
                                       }
                                   })
                                   
                               }
                               
                           });
    },
    
    
    NavigateToChat : function(component, event, helper) {
        //alert('#url:');
        var caseNum = '';
        var purpose = '';
        var subPurpose = '';
        var caseRec = component.get("v.caseWrp");
        caseNum = caseRec.caseNumber;
        purpose = caseRec.caseNumber;
        var nameVal = event.getSource().get("v.name");
        if(nameVal.indexOf(';')!=-1){
            var nameArr = nameVal.split(';');
            caseNum = nameArr[0];
            purpose = nameArr[1];
            subPurpose = nameArr[2];
            
        }
        
        var urlVal = 'https://partuat-utc-ccs-customersgateway.cs65.force.com/LiveChatButton?value='+sessionStorage.getItem('payload')+'&CaseNumber='+caseNum+'&purpose='+purpose+'&subPurpose='+subPurpose;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urlVal 
        });
        urlEvent.fire();
    }
    
    
    
})