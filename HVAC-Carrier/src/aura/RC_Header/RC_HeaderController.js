({ 
    doInit : function(component, event, helper) {
        var getUrlParameter = function getUrlParameter(sParam) {
            
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;
            
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');
                // alert('Params**'+sParameterName);
                
                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
        };
        var payload = getUrlParameter('value');
        if(payload==null && sessionStorage.getItem('payload')!='undefined' && sessionStorage.getItem('payload')!=null && sessionStorage.getItem('payload')!=undefined && sessionStorage.getItem('payload').length>0){
            payload = sessionStorage.getItem('payload');
        }
        if(payload!=null){
            var action2  = component.get("c.getparsePayloadAndGetName");
            action2.setParams({"payloadStr" : payload});
            action2.setCallback(this,function(response)
                                {
                                    
                                    var state=response.getState();
                                    var result=response.getReturnValue();
                                    // alert(response);
                                    if(state=="SUCCESS"){
                                        component.set("v.FullName",result);
                                        
                                    }else{
                                        component.set("v.TilesStatus", false);
                                        component.set("v.TilesErrorStatus", true);
                                    }
                                }); 
            $A.enqueueAction(action2);
        }
    }
    
})