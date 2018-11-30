({
    handleClick :function(component, event, helper){
        var btn = event.currentTarget.name;
        
        if(btn=='back'){
            var appEvent = $A.get("e.c:FirePageEvent");
            
            appEvent.setParams({
                "message" : "Previous Page" });
            appEvent.fire();    
        }else{
            var appEvent = $A.get("e.c:FirePageEvent");
            
            appEvent.setParams({
                "message" : "Next Page" });
            appEvent.fire();    
            
        }
    }
})