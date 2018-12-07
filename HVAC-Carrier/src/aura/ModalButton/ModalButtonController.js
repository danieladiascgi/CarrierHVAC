({
	doInit : function(component, event, helper){
		helper.doInit(component, event);
	},
	makeModal : function(component, event, helper){
		helper.makeModal(component, event);
	},
	switchModalForm : function(component, event, helper){
		var selected = event.getSource().get("v.text");
		helper.switchModalForm(component, event);
	},
	closeModal : function(component, event, helper){
		helper.closeModal(component, event);
	},
	makeModalForm : function(component, event, helper){
		helper.makeModalForm(component, event);
	},
    searchkeyModalchangectrl : function(component, event, helper){
        
		var searchKey = event.getParam("SearchKey");
        console.log('Modal button search key:'+searchKey);
        component.set('v.AccIdval', searchKey);
        
	}
})