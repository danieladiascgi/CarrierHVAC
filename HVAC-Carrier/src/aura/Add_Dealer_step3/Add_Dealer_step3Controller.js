({
    updateFields :function(component, event, helper){
        var summary = component.get("v.sumRequest");
        var issues = component.get("v.issues");
        
        if(summary=="" || summary == null){
            component.set("v.IsSummaryFilled","false");
        }
        else{
            component.set("v.IsSummaryFilled","true");
        }
        /*if(issues=="" || issues == null){
            issues="no input for issues";
        }*/
        
        component.set("v.sumRequest",summary);
        component.set("v.issues",issues);
        
    }
})