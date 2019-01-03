({
 init :function(cmp, event, helper){
        //receives from apex the related accounts of the user logged in
        var action = cmp.get("c.GetUserAccounts");
        action.setCallback(this, function(response) {
            var t=response.getReturnValue()[0].Account.Id;
            cmp.set("v.AccountNameList",response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})