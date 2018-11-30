({
    doInit: function(component, event, helper){
        var quotes = '{"quote":[{"quoteNumber":"20202929029029", "quoteRefNumber":"12987398127","quoteDescription":"Description description DeScRiPtIoN","effDate":"16/05/2002","expDate":"16/02/1998"}, {"quoteNumber":"202029290290", "quoteRefNumber":"129873981","quoteDescription":"Description description DeScRiPtIoN","effDate":"16/05/2002","expDate":"16/02/1998"},{"quoteNumber":"202029229029", "quoteRefNumber":"129878127","quoteDescription":"Description description DeScRiPtIoN","effDate":"16/05/2002","expDate":"16/02/1998"} ]}';
        
        var obj = JSON.parse(quotes);
        //console.log(obj.quote[0].quoteNumber);
        console.log(obj.quote[0].quoteNumber);
        
        if(obj != undefined && obj != null){
            component.set("v.quotes_List", obj.quote);
        }
        else {
            component.set("v.quotes_List", []);
        }    
        
    },
    
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