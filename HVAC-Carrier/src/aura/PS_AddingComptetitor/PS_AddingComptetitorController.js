({
    save : function(component, event, helper) {
        
        var competitor ={ 'sobjectType': 'Competitive_Sell__c',
                         'Name':'',
                         'Annual_Sales__c':'', 
                         'AOR__c':'',
                         'RNC__c':'',
                         'Hard_Copy__c':'',
                         'Attached__c':''
                        };
        competitor.Annual_Sales__c = component.get("v.Annual");
        
        var appEvent = $A.get("e.c:PS_AddingCompetitorEvent");
        appEvent.setParams({
            "Competitor" : competitor });
        appEvent.fire();
    }
})