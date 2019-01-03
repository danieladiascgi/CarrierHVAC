({
    Input: function (component, event) {
        component.set('v.displayInput',true);
        component.set('v.displayHeader',false);
        component.set('v.displayHeaderWithParam',false);
        var action = component.get("c.testInput");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var salesDetails = response.getReturnValue();
                debugger;
                component.set('v.salesDetail',salesDetails);
                component.set('v.materialDetails',salesDetails.Material_Details);
                component.set('v.dealerDetail',salesDetails.Dealer_Details);
                
                debugger;
            }
        });
        $A.enqueueAction(action);
    }, 
    
    Header : function (component, event) {
        component.set('v.displayHeader',true);
        component.set('v.displayInput',false);
        var action = component.get("c.testHeader");
        // action.setParams({
        //});
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var salesDetails = response.getReturnValue();
                component.set('v.salesDetail2',salesDetails);
            }
        });
        $A.enqueueAction(action);
    }, 
    
    HeaderWithParams : function (component, event) {
        component.set('v.displayHeaderWithParam',true);
        component.set('v.displayHeader',false);
        component.set('v.displayInput',false);
        var action = component.get("c.testHeaderWithParams");
        action.setParams({  Dealer : 'HVP131431'  });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set('v.salesDetail2','');
            if (state === "SUCCESS") {
                var salesDetails = response.getReturnValue();
                //console.log('salesDetails::');
                //console.log(salesDetails);
                debugger;
                component.set('v.salesDetail2',salesDetails);
                console.log('salesDetails::');
                console.log(salesDetails.length);
                // debugger;
            }
        });
        $A.enqueueAction(action);
    },
    
})