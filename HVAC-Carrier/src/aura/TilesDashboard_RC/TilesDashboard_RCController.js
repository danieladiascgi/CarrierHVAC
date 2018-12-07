({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert('state'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // alert('storeResponse'+JSON.stringify(storeResponse));
                if(storeResponse!=null && storeResponse!='undefined' && 
                   storeResponse!=undefined && storeResponse.alias!='undefined' &&
                   (storeResponse.Alias=='guest' ))
                { 
                    //  alert('inside if');
                    var getUrlParameter = function getUrlParameter(sParam) {
                        
                        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                            sURLVariables = sPageURL.split('&'),
                            sParameterName,
                            i;
                        
                        for (i = 0; i < sURLVariables.length; i++) {
                            sParameterName = sURLVariables[i].split('=');
                            // alert('Params**'+sParameterName);
                            
                            if (sParameterName[0] === sParam) {
                                return sParameterName[1] === undefined ? true : sParameterName[1];
                            }
                        }
                    };
                    var payload = getUrlParameter('value');
                    // alert('payload'+payload);
                    
                    if(payload==null && sessionStorage.getItem('payload')!='undefined' && sessionStorage.getItem('payload')!=null && sessionStorage.getItem('payload')!=undefined && sessionStorage.getItem('payload').length>0){
                        payload = sessionStorage.getItem('payload');
                    }
                    if(payload!=null){
                        var action2  = component.get("c.getparsePayloadAndGetValues");
                        action2.setParams({"payloadStr" : payload});
                        action2.setCallback(this,function(response)
                                            {
                                                component.set("v.value",response.getReturnValue());
                                                var state=response.getState();
                                                var result=response.getReturnValue();
                                                // alert(response);
                                                if(state=="SUCCESS"){
                                                    component.set("v.value",result);
                                                    if((payload!=null && payload!='undefined' && payload!=undefined && payload.length>0) && (sessionStorage.getItem('payload')=='undefined' || sessionStorage.getItem('payload')==undefined || sessionStorage.getItem('payload')==null || sessionStorage.getItem('payload')=='')){
                        								sessionStorage.setItem('payload', payload);
                                                        //helper.checkIfChatButtonIsOnline(component, event, helper);
                                                        
                    								}
                                                    component.set("v.TilesStatus", true);
                                                    helper.checkIfChatButtonIsOnline(component, event, helper);
                                                    /*window.setInterval(function(){ 
															helper.checkIfChatButtonIsOnline(component, event, helper);
														}, 10000);*/
                                                    
                                                }else{
                                                    component.set("v.TilesStatus", false);
                        							component.set("v.TilesErrorStatus", true);
                                                }
                                            }); 
                        $A.enqueueAction(action2);
                    }
                    else
                    {
                        // alert('Unauthenticated User');
                        component.set("v.TilesStatus", false);
                        component.set("v.TilesErrorStatus", true);
                    }
                }
                else
                {
                    //  alert('inside else');
                    component.set("v.TilesStatus", true);
                }
            }
            
        }); 
        $A.enqueueAction(action); 
        
        helper.hideChatOfflineButton(component, event);
        
        
        
    },
    /*searchSAP : function(component, event, helper) {
		alert('Clicked');
		var evt = $A.get("e.c:NavigateToSAP");
      	evt.setParams({ "view": "This is Testing"});
        alert('Firing Evt:'+evt);
      	evt.fire();
        
	},*/
    CloseErrorStatus: function(component, event, helper){
        
        component.set("v.TilesErrorStatus", false);
        
    },
    contactCustService : function(component, event, helper) {
        
        var event = $A.get("e.c:NavigateToCCS");
        event.setParams({ "view": "This is Testing"});
        //alert('Firing Evt:'+event);
        event.fire();
        
        
        
        
        
    },
    openCases : function(component, event, helper) {
        //alert('Clicked');
        var email = component.get("v.value");
        var action = component.get("c.fetchUser");
        var buttonId = component.get("v.OnlineButton");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse!=null && storeResponse!='undefined' && storeResponse!=undefined && storeResponse.alias!='undefined' && (storeResponse.Alias=='guest' || storeResponse.Alias=='tjamb')){
                    var destination = "c:MyOpenCases";
                    $A.createComponent(destination, {"email":email,"OnlineButton":buttonId}, 
                                       function(view) {
                                           var content = component.find("content");
                                           //alert('#content:'+content);
                                           content.set("v.body", view);
                                       });
                }else{
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": '00B0m0000017njL',
                        "listViewName": null,
                        "scope": "Case"
                    });
                    navEvent.fire();        
                }
            }
        });
        $A.enqueueAction(action);
        
        
    },
    openOrders : function(component, event, helper) {
        //alert('Clicked');
    },
    OrderStatus: function(component, event, helper){
        var event = $A.get("e.c:NavigateToOrderStatus");
        event.setParams({ "view": "This is Testing"});
        //alert('Firing Evt:'+event);
        event.fire();
    },
    SearchC10: function(component, event, helper){
        var event = $A.get("e.c:NavigateToSearchC10");
        event.setParams({ "view": "This is Testing"});
        //alert('Firing Evt:'+event);
        event.fire();
    },
    
    NavigateToCCSComp : function(component,event,helper) {
        //    alert('Navigate to CCS');
        var destination = "c:RC_CCS";
        //alert(this.type);
        //var comp = component.find("content");
        //alert(destination+'#'+comp);
        $A.createComponent(destination, { }, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });
    },
    NavigateToOrderStatus : function(component,event,helper) {
        //alert('Navigate to SAP');
        var destination = "c:C10_cloned";
        //alert(this.type);
        //alert(destination);
        $A.createComponent(destination, { }, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });
    },
    NavigateToQuoting : function(component, event, helper) {
        //alert('#url:');
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://rcdquote.hvacpartners.com/quotestatus.htm' 
        });
        urlEvent.fire();
    },
    NavigateToChat : function(component, event, helper) {
        //alert('#url:');
        var urlVal = 'https://utc-ccs-customersgateway.secure.force.com/LiveChatButton?value='+sessionStorage.getItem('payload');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urlVal 
        });
        urlEvent.fire();
    },
    WindowOpenChat : function(component, event, helper) {
        //alert('#url:');
        var buttonId = component.get("v.OnlineButton");
        //var urlVal = 'https://utc-ccs-customersgateway.secure.force.com/LiveChatButton?value='+sessionStorage.getItem('payload');
        var urlVal = 'https://utc-ccs-customersgateway.secure.force.com/LiveChatButton?value='+sessionStorage.getItem('payload')+'&buttonId='+buttonId;
        window.open(urlVal, 'formresult', 'scrollbars=yes,menubar=no,height=450,width=500,resizable=yes,toolbar=no,status=no');
    },
    NavigateToCR : function(component, event, helper) {
        //alert('#url:');
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://rcdchannel.com' 
        });
        urlEvent.fire();
    },
    
    NavigateToSearchC10: function(component,event,helper) {
        //alert('Navigate to SAP');
        var destination = "c:SearchC10Demo";
        //alert(this.type);
        //alert(destination);
        $A.createComponent(destination, { }, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });
    },
    openHelpAndTraining:function(component, event, helper) {
        //alert('openHelpAndTraining');
		 window.open("https://files.hvacpartners.com/docs/1010/ChanPart/05/ccc_trn_rc_comm.pdf");
       
	},
    openFAQ:function(component, event, helper) {
        //alert('openHelpAndTraining');
		 window.open("https://files.hvacpartners.com/docs/1010/ChanPart/0A/ccc_trn_rc_faq.pdf");
       
	}
})