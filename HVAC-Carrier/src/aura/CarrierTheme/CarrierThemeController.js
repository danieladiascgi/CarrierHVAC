({
	afterScriptsLoaded : function(component, event, helper) {
		new WOW().init();
    },
    doInit : function(component, event, helper) {
    //    helper.init(component);
    },
    //AccSelectChange : function(component, event, helper) {
    //    console.log('account select change: '+ component.get("v.AccId_select"));
    //    sessionStorage.setItem('Acc_Id_Selected',event.getParam("SearchKey"));
    //},
    TabLoad : function(component, event, helper) {
        console.log('Tab load');
    },
})