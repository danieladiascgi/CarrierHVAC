({
     updateNewMsgFieldOnRead: function(component, event, helper){
      var recordId = component.get("v.recordId");
        var action = component.get("c.updateNewMsgFieldOnRead");
        action.setParam("csId", recordId);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var toBeRefreshed = response.getReturnValue();
                //alert('SUCCESS');
                if(toBeRefreshed==true){
                   // alert('Refreshing');
                      $A.get('e.force:refreshView').fire();
                 }
                //alert('Error:');
          //component.set("v.case", response.getReturnValue());

            } else{
            }
        });
        $A.enqueueAction(action);
   },
	    
    addDivider : function() {
    var x = document.getElementsByClassName("hasDiv");
    	for(var i=0; i<x.length; i++){
    		x[i].classList.add("slds-has-divider--bottom");
    	}
	},

    removeDivider : function() {
    var x = document.getElementsByClassName("hasDiv");
        for(var i=0; i<x.length; i++){
            x[i].classList.remove("slds-has-divider--bottom");
        } 
	},
    
    addEditIcon : function() {
    var x = document.getElementsByClassName("editIcon");
    	for(var i=0; i<x.length; i++){
    		x[i].classList.remove("slds-hide");
    	}
	},

    removeEditIcon : function() {
    var x = document.getElementsByClassName("editIcon");
        for(var i=0; i<x.length; i++){
            x[i].classList.add("slds-hide");
        } 
	}
    
})