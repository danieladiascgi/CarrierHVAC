({
    doInit : function(component, event, helper) {
        $A.util.toggleClass(component.find("categoryPicklist"), "toggle");
        component.set("v.accountSelected",sessionStorage.getItem('Acc_Id_Selected'));
        console.log('v.accountSelected ' + sessionStorage.getItem('Acc_Id_Selected'));
        var accounts = component.get('v.accounts');
        var accSelected = component.get('v.accountSelected');
        for(var account of accounts) {
            if(account.Id == accSelected) component.set('v.accName', account.Name);
        }
        //console.log(component.get("v.pageReference").state.defaultacc);
    },
    onFocus: function(component, event, helper) {
        helper.fetchAccounts(component, '');
        component.set('v.dropdownVisible', true);
    },
    onBlur: function(component, event, helper) {
        setTimeout(function() {
            component.set("v.foundAccounts", null);
            component.set("v.searchKey", '');
            component.set('v.dropdownVisible', false);
        }, 200);
    },
    onKeyUp: function(component, event, helper) {
        var searchPhrase = component.get('v.searchKey');
        helper.fetchAccounts(component, searchPhrase);
    },
    changeAccountCustomInput: function(component, event, helper) {
        var selectedValue = event.srcElement.id;
        helper.selectAccount(component, selectedValue);
        var accounts = component.get('v.foundAccounts');
        for(var acc of accounts) {
            if(acc.Id == selectedValue) {
                component.set('v.accName', acc.Name);
            }
        }
    },
    changeAccountDefaultInput : function(component, event, helper) {
        var selectedValue = event.getSource().get("v.value");
        helper.selectAccount(component, selectedValue);
    },
})