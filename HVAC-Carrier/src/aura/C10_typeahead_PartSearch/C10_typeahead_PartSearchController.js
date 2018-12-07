({
	 selectPart : function(component, event, helper){      
    // get the selected Account from list  
      var getSelectCase = component.get("v.oAccount");
     
    // call the event   
      var compEvent = component.getEvent("oSelectedAccountEvent");
     
    // set the Selected Account to the event attribute.  
         compEvent.setParams({"partnoByEvent" : getSelectCase });  
    // fire the event  
         compEvent.fire();
    },
})