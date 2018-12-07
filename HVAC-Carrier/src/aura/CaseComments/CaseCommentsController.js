({
     doInit : function(component, event, helper) {
        // var recordId = component.get("v.recordId");
   // var CaseId = '5000m0000037QHK';
	    var actiondisplay = component.get("c.DisplayComments");
        actiondisplay.setParams({
           "ExpId":  component.get("v.recordId")

          
           });          
        actiondisplay.setCallback(this,function(response)
        {
            component.set("v.CmdList",response.getReturnValue());
            
            var state=response.getState();
            var result=response.getReturnValue();
            if(state=="SUCCESS")
            {
                //alert('success'+JSON.stringify(response.getReturnValue()));
                component.set("v.CmdList",result);
            }
         }); 
        $A.enqueueAction(actiondisplay);
         helper.getPlannerInformation(component, event);
     },
    openModal : function(component, event, helper) {
        
       // alert('Clicked');
        
       // var clickedCaseCmtRecId= component.getSource().get("v.Id");
       // var clickedCaseCmtRecId = event.target.id;
        var clickedCaseCmtRecId = event.currentTarget.id;
      // var clickedCaseCmtRecId=' 00a0m000000ETVtAAO';
       //alert('clickedCaseCmtRecId'+clickedCaseCmtRecId);
       var modalBody;
       $A.createComponent("c:CaseCommentsDetailPage", {clickedCaseCmtRecId:clickedCaseCmtRecId},
                          
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "CASE COMMENTS DETAIL PAGE",
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "slds-modal_small",
                                       closeCallback: function() {
                                           //alert('Click Ok to close popup!!');
                                           
                                       }
                                   })
                                   
                               }
                               
                           });
    }
    
})