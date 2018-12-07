({
    doInit: function(component, event, helper){
        var quotes = '{"quote":[{"Quote_number__c":"20202929029029","Name":"A123456789", "Quote_Reference_Number__c":"12987398127","Quote_Description__c":"Description description DeScRiPtIoN","Effective_Date__c":"16/05/2002","Expired_Date__c":"16/02/1998"}, {"Quote_number__c":"202029290290","Name":"B123456789", "Quote_Reference_Number__c":"129873981","Quote_Description__c":"Description description DeScRiPtIoN","Effective_Date__c":"16/05/2002","Expired_Date__c":"16/02/1998"}, {"Quote_number__c":"202029229029","Name":"C123456789", "Quote_Reference_Number__c":"129878127","Quote_Description__c":"Description description DeScRiPtIoN","Effective_Date__c":"16/05/2002","Expired_Date__c":"16/02/1998"} ]}';
        var obj = JSON.parse(quotes);
        //console.log(obj.quote[0].quoteNumber);
        if(obj != undefined && obj != null){
            component.set("v.quotes_List", obj.quote);
        }
        else {
            component.set("v.quotes_List", []);
        }    
        
    },
    onclick: function(cmp, evt, hlpr){
        var list = cmp.get("v.quotes_List");
        var selected = [];
        for(var i = 0; i< list.length ; i++){
            if (list[i].isSelected == true){                
                selected.push(list[i]); 
            }
        }
        var inputVariables=[
            {
                name : "k-quotes",
                type : "SObject",
                value : [selected]
            }];
        cmp.set("v.quotes_selected", inputVariables);
        //console.log( inputVariables);
    }
    
})