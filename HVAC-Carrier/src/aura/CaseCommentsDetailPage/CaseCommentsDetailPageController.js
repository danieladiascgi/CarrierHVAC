({
	doInit : function(component, event, helper) {
      
       var action = component.get("c.getCaseCommentRecToBePassed");
      var clickedCaseCmtRecId2 = component.get("v.clickedCaseCmtRecId");
       
        action.setParams({
            "CaseCmtRecId":clickedCaseCmtRecId2 
        });
        action.setCallback(this, function(a) {
          if (a.getState() === "SUCCESS") {
            component.set("v.eachcmt", a.getReturnValue());
	      }
          else{
            alert('error');    
          }
        });
        $A.enqueueAction(action);
    }
})