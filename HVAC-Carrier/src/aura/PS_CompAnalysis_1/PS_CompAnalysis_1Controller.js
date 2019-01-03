({
    handleApplicationEvent : function(component, event, helper) {
        component.set("v.Adding", "false");
        
        var message = event.getParam("Competitor");
        var list= component.get("v.CompetitorList");
        list.push(message);
        component.set("v.CompetitorList", list);
        component.set("v.Adding", "false");
    },
    
    add : function(component, event, helper) {
        component.set("v.Adding", "true");
    },
})