({
    setup: function(component) {
        component.addValueProvider(
            's',
            {
                get: function(key, comp) { return sessionStorage.getItem(key); },
                set: function(key, value, comp) { sessionStorage.setItem(key, value); }
            }
        );
    },
    checkIfChatButtonIsOnline: function(component, event, helper) {
        var email = component.get("v.value");
        if(email!=null && email!='undefined' && email.length>0){
            var buttonId = '';
            if(email.match(/carrierenterprise/i)){
                buttonId = component.get("v.CEChatButtonId");
            }else{
                buttonId = component.get("v.NONCEChatButtonId");
            }
            var action = component.get("c.checkBtnOnline");
            action.setParams({'email': component.get("v.value"),"chatButtonId": buttonId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()==false){
                        this.showChatOfflineButton(component, event);
                        this.hideChatOnlineButton(component, event);
                        this.checkIfOtherChatButtonIsOnline(component, event, helper,buttonId);
                    }else{
                        this.hideChatOfflineButton(component, event);
                        this.showChatOnlineButton(component, event);
                        component.set("v.OnlineButton", buttonId);
                        //this.checkIfOtherChatButtonIsOnline(component, event, helper,buttonId);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    intervalForChatButtonIsOnline: function(component, event, helper) {
        setInterval(function(){ 
			this.checkIfChatButtonIsOnline(component, event, helper);
		}, 5000);
    },
    hideChatOfflineButton: function(component, event) {
        var offlineButton = component.find("offlineBtn");
        $A.util.removeClass(offlineButton, 'slds-button');
        $A.util.removeClass(offlineButton, 'slds-button_destructive');
        $A.util.removeClass(offlineButton, 'chatBttonStyles');
        $A.util.addClass(offlineButton, 'slds-hide');
    },
    showChatOfflineButton: function(component, event) {
        var offlineButton = component.find("offlineBtn");        
        $A.util.addClass(offlineButton, 'slds-button');
        $A.util.addClass(offlineButton, 'slds-button_destructive');
        $A.util.addClass(offlineButton, 'chatBttonStyles');
        $A.util.removeClass(offlineButton, 'slds-hide');
    },
    hideChatOnlineButton: function(component, event) {
        var offlineButton = component.find("onlineBtn");
        $A.util.removeClass(offlineButton, 'slds-button');
        $A.util.removeClass(offlineButton, 'slds-button_destructive');
        $A.util.removeClass(offlineButton, 'chatBttonStyles');
        $A.util.addClass(offlineButton, 'slds-hide');
    },
    showChatOnlineButton: function(component, event) {
        var offlineButton = component.find("onlineBtn");        
        $A.util.addClass(offlineButton, 'slds-button');
        $A.util.addClass(offlineButton, 'slds-button_destructive');
        $A.util.addClass(offlineButton, 'chatBttonStyles');
        $A.util.removeClass(offlineButton, 'slds-hide');
    },
    checkIfOtherChatButtonIsOnline: function(component, event, helper, currentButtonId) {
        var email = component.get("v.value");
        var ceButtonId = component.get("v.CEChatButtonId");
        var nonCeButtonId = component.get("v.NONCEChatButtonId");
        var buttonId = '';
        if(currentButtonId == ceButtonId){
            buttonId = nonCeButtonId;
        }else{
            buttonId = ceButtonId;
        }
        
        if(email!=null && email!='undefined' && email.length>0){
            
            var action = component.get("c.checkBtnOnline");
            action.setParams({'email': component.get("v.value"),"chatButtonId": buttonId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()==false){
                        this.showChatOfflineButton(component, event);
                        this.hideChatOnlineButton(component, event);
                    }else{
                        this.hideChatOfflineButton(component, event);
                        this.showChatOnlineButton(component, event);
                        component.set("v.OnlineButton", buttonId);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    }
})