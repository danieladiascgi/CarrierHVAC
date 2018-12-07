({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.typeAheadforParts");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //alert(JSON.stringify(storeResponse));
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
                //component.set("v.lstWrapperPart", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    
    showPartRecord : function(component,event,partNo,custnum) {
        // call the apex class method 
        var action = component.get("c.showPartRecord");
        // set param to method  
        action.setParams({
            'custnum': custnum,
            'partNo': partNo
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //alert(JSON.stringify(storeResponse));
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "FAIL!",
                        "message": "No Parts Found!."
                        
                        
                    });
                    toastEvent.fire();
                    
                    
                } else {
                    
                    component.set("v.Message", 'Search Result...');
                }
                
                // set searchResult list with return value from server.
                //component.set("v.listOfSearchRecords", storeResponse);
                component.set("v.lstWrapperPart", storeResponse);
                component.set("v.secondTableTrue",true);
                component.set("v.spinnerShow",false);
                
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
        
    },
    
    searchAccHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.typeAheadforCustNum");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //   alert(storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.spinnerShow",false);
                    component.set("v.Message", 'No Result Found...');
                    
                    
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfAccountRecords", storeResponse);
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    }
    
})