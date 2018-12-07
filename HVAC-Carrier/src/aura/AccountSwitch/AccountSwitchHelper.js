({
	fetchAccounts: function(component, searchPhrase) {
        var accounts = component.get('v.accounts');
        var foundAccounts = [];
        for(var account of accounts) {
            if(account['Name'].toLowerCase().includes(searchPhrase.toLowerCase())) foundAccounts.push(account);
            if(foundAccounts.length == 5) break;
        }
        component.set('v.foundAccounts', foundAccounts);
    },
    selectAccount: function(component, selectedAccount) {
        sessionStorage.setItem('Acc_Id_Selected', selectedAccount);
        var myEvent = $A.get("e.c:AccountChangeEvent");
        if(selectedAccount != "" && selectedAccount != null) myEvent.setParams({"SearchKey": selectedAccount});
        else myEvent.setParams({"SearchKey": null});

        myEvent.fire();
    }
})