({
	loadData: function(cmp){
        var action = cmp.get("c.generateDealerAddData");
    	action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
            
            cmp.set("v.input_K_Quotes_List", response.getReturnValue());
         }
      });
       $A.enqueueAction(action);
    },
})