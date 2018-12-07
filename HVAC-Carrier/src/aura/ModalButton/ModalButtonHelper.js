({
	doInit : function(component, event) {
		var self = this;
		this.checkIfTypeIsSpecifiedOnLoad(component, event);
		this.setButtonText(component, event);

	},
	checkIfTypeIsSpecifiedOnLoad: function(component, event){
		var self=this;
		var requestType = component.get("v.requestType");
		var isTypeSpecifiedOnLoad = !requestType ? false : true;

		component.set("v.isTypeSpecifiedOnLoad", isTypeSpecifiedOnLoad);
	},
	setButtonText : function(component, event){
		var self = this;
		var isTypeSpecifiedOnLoad = component.get("v.isTypeSpecifiedOnLoad");
		var buttonText;

		if(component.get('v.buttonText')) {
			buttonText = component.get('v.buttonText');
		} else {
			if(isTypeSpecifiedOnLoad){
				var requestType = component.get("v.requestType");
				if(requestType ==="case"){
					buttonText='Submit Service Request';
				} else if(requestType==="quote"){
					buttonText = 'Submit Proposal Request';
				} else if(requestType==="renewal"){
					buttonText = 'Renew Now';
				}
			} else {
				buttonText = 'Submit a request';
			}
		}

		component.set("v.buttonText", buttonText);
	},
	setFormHeaderText : function(component, event){
		var self=this;
		var requestType = component.get("v.requestType");
		console.log('RT'+requestType);
		var headerText;

		if(requestType === "case"){
			headerText = 'Request Service';
		} else if (requestType === "quote"){
			headerText = 'Request a proposal';
		} else if (requestType === "renew"){
			headerText = 'Renew your service agreement';
		} else {
			headerText= 'Make a request';
		}
		component.set("v.formHeaderText", headerText);
	},
	setModalForm : function(component, event){
		var self = this;
		var requestType = component.get("v.requestType");
		var formComponent = this.getFormComponent(requestType);
		// this.destroyForm(component);
		this.setFormHeaderText(component, event);
		this.makeForm(formComponent, component, event);
	},
	setRequestType : function(component, event){
		var selected = event.getSource().get("v.text");
		component.set("v.requestType", selected);
	},
	switchModalForm : function(component, event){
		var self=this;

		this.setRequestType(component,event);
		this.setModalForm(component, event);
	},
	getFormComponent : function(requestType){
		var self = this;
		var formToUse;
		console.log('form to use'+requestType);
		if(requestType === "case"){
			formToUse = 'c:BoltLogACase';
		} else if (requestType === "quote"){
			formToUse = 'c:BoltRequestProposal';
		} else if (requestType === "serviceagreement"){
			formToUse = 'c:BoltRequestServiceAgreement';
		} else {
			formToUse = 'c:BoltLogACase';
		}
		return formToUse;
	},
	makeModal : function(component, event){
		component.set('v.isOpen', true);
		var self = this;

		if(component.get("v.isTypeSpecifiedOnLoad")){
			this.setModalForm(component, event);
		}
	},
	closeModal : function(component, event){
		var self = this;

		component.set('v.isOpen', false);
		this.destroyForm(component);
	},

	makeForm : function(formComponent, component, event){
       
		var self = this;
		var action = $A.createComponent(formComponent,
         {"aura:id":"modalForm","AccIdSelected":component.get("v.AccIdval")},
		 function(newComponent, status, errorMessage){
		 	if(status === "SUCCESS"){
		 		self.setForm(newComponent,component);
		 	} else if(status === "INCOMPLETE"){
                console.log("No response from server or client is offline.");
		 	} else if(status === "ERROR"){
		 		console.log("Error: "+errorMessage);
		 	}
		 });
	},
	setForm : function(returnValue, component){

		component.set("v.body", [returnValue]);
	},
    destroyForm : function(component){
    	component.set("v.body", []);
    	var option1 = component.find('option1');
    	var option2 = component.find('option2');
    	var option3 = component.find('option3');
    	if(option1) {
    		option1.set('v.value', null);
    	}
    	if(option2) {
    		option2.set('v.value', null);
    	}
    	if(option3) {
    		option3.set('v.value', null);
    	}
    }
})