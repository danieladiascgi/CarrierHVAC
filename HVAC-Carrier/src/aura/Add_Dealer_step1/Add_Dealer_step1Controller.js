({
    init :function(component, event, helper){
        var action = component.get("c.GetUserAccounts");
        action.setCallback(this, function(response) {
            component.set("v.AccountNameList",response.getReturnValue());
        });
        $A.enqueueAction(action);
        
    }
    
    ,
    
    StoreValue : function(cmp, event){
        var value = document.getElementById("select-01");
        var t=value.options[value.selectedIndex].value;
        cmp.set("v.distributorId",t);
    }
})