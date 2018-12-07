({
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    }
  /*  createFeedDyanmic : function(component) {
        var CaseId= component.get("v.clickedCaseRecId");
        $A.createComponent(
            "forceChatter:publisher", {
                "context": "RECORD",
                "recordId": CaseId
            },
            function(recordFeed) {
                //Add the new button to the body array
                if (component.isValid()) {
                    var body = component.find("content");
                    //body.push(recordFeed);
                    body.set("v.body", body);
                }
            }); 
        
        $A.createComponent(
            "forceChatter:feed", {
                "type": "Record",
                "subjectId": CaseId
            },
            function(recordFeed) {
                //Add the new button to the body array
                if (component.isValid()) {
                    var body = component.find("content");
                    //body.push(recordFeed);
                    body.set("v.body", body);
                }
            });
    }*/
})