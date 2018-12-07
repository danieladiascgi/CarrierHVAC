({
    sendHelper: function(component, getFromAddr,getCcAddr, getEmail, getSubject, getbody, selectedfile, selectedAttachments) {
        // call the server side controller method 	
        var action = component.get("c.sendMailMethod");
        //alert('getCcAddr'+getCcAddr);
        var mfile2 = JSON.stringify(selectedfile);
       // alert('test'+JSON.stringify(selectedfile));
        // set the 3 params to sendMailMethod method   
        action.setParams({
            'mMail': getEmail,
            'mFrom': getFromAddr,
            'mCc' : getCcAddr,
            'mSubject': getSubject,
            'mbody': getbody,
            'selectedAttachsStr': mfile2,
            'recId': component.get("v.recordId")
            
        });
       // alert('file'+JSON.Stringfy(file));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var storeResponse = response.getReturnValue();
                 //alert('response'+JSON.stringify(storeResponse));
                // if state of server response is comes "SUCCESS",
                // display the success message box by set mailStatus attribute to true
                component.set("v.mailStatus", true);
                 var emailMsgRec = component.get("v.emailMsg");
                emailMsgRec.ToAddress = getEmail;
                component.set("v.emailMsg", emailMsgRec);
            }
            else{
                 var storeResponse = response.getReturnValue();
                 //alert('response'+JSON.stringify(storeResponse));
                 alert('error');
            }
 
        });
        $A.enqueueAction(action);
    },
    helperFun : function(component,event,secId) {
	  var acc = component.find(secId);
        var sign = component.get("v.expand_collapse_flag");
        if(sign==false){
            component.set("v.expand_collapse_flag", true);
        }else{
            component.set("v.expand_collapse_flag", false);
        }
        $A.util.toggleClass(acc, 'slds-hide');
	}
})