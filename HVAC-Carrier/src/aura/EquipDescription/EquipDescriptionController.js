({
    doInit : function(component, event, helper) {
        //alert(component.get("v.recordId"));
        helper.updateNewMsgFieldOnRead(component, event, helper);
        
        var recordId = component.get("v.recordId");
        //alert('Record Id in Desc:'+recordId);
        var action = component.get("c.getCase");
        action.setParam("id", recordId);
        action.setBackground();
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.case", response.getReturnValue());
                //$A.get('e.force:refreshView').fire();

            } else{
                alert('Error desc:');
            }
        });
        $A.enqueueAction(action);
        var toggleText = component.find("editable");
        $A.util.toggleClass(toggleText, "slds-hide");
    },
    
    changeEditLayout : function(component, event, helper) {
        component.set("v.isEditPage", true);
        helper.removeDivider();
        helper.removeEditIcon();
    },
    
    clickCancel : function(component, event, helper) {
        component.set("v.isEditPage", false);
    	helper.addDivider();
        helper.addEditIcon();
        $A.get('e.force:refreshView').fire();
 },
    
     MoveToJunk : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        //alert('Record Id in Desc:'+recordId);
        var action = component.get("c.ChangeOwner");
        action.setParam("id", recordId);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.saveStatus", true);  
                setTimeout(function(){/*alert('should close now');*/component.set("v.saveStatus", false);}, 4000);
                $A.get('e.force:refreshView').fire();
            } 
            else{
            }
        });
        $A.enqueueAction(action);
 },
    
  Expedite : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        var action = component.get("c.ChangeOwner2");
        action.setParam("id", recordId);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.changeOwner", true);  
                setTimeout(function(){/*alert('should close now');*/component.set("v.changeOwner", false);}, 4000);
                //  alert('success desc:');
                $A.get('e.force:refreshView').fire();
            } else{
                //  alert('Error desc:');
            }
        });
        $A.enqueueAction(action);
        var action2 = component.get("c.getCase");
        action2.setParams({
            "id" : component.get("v.recordId") 
        });
        action2.setCallback(this,function(response){
            var state = response.getState();             
            if(state === 'SUCCESS'){                
                var result = response.getReturnValue();
               // alert("Test:"+result.New_Comment__c);
                var newComment = "true";
                var parentId = '';
                if(result.ParentId!=null && result.ParentId.length>0){
                    parentId = result.ParentId;
                }else{
                    parentId = result.Id;
                }
               // alert("TypeOf:"+typeof(newComment));
               //alert('Creating new record with Ower expedite');
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Case",
                    "defaultFieldValues": {
                        'Subject' : result.Subject,
                        'Description' : result.Description,
                        'LastModifiedDate' : result.LastModifiedDate,
                        'LastModifiedBy.Name' : result.LastModifiedBy.Name,
                        'isClosed' : result.isClosed,
                        'CreatedDate':result.CreatedDate,
                        'CCC_Purpose__c':result.CCC_Purpose__c,
                        'CCC_Sub_Purpose__c':result.CCC_Sub_Purpose__c,
                        'Priority':result.Priority,
                        'Status':'Open',
                        'OwnerId':'00G150000042746',
                        'Owner.Name':'Expedite',
                        'RecordTypeId':result.RecordTypeId,
                        'Origin':result.Origin,
                        'To_Address__c':result.To_Address__c,
                        'SuppliedEmail':result.SuppliedEmail,
                        'CCC_Brand__c':result.CCC_Brand__c,
                        'CCC_Customer_Type__c':result.CCC_Customer_Type__c,
                        'CreatedBy.Name':result.CreatedBy.Name,
                        'ParentId':parentId,
                        'OwnerId':'00G150000042746',
                        'CCC_Date_Time_Assigned__c':result.CCC_Date_Time_Assigned__c,
                        'Flag_Comments__c':result.Flag_Comments__c,
                        'New_Comment__c':result.New_Comment__c,
                        'AccountId':result.AccountId,
                        'ContactId':result.ContactId,
                        'New_Msg__c':result.New_Msg__c,
                        'Phone_Number__c':result.Phone_Number__c,
                        'ZSM__c':result.ZSM__c,
                        'CCC_Part__c':result.CCC_Part__c,
                        'CCC_Part_Number__c':result.CCC_Part_Number__c,
                        'CCC_Part_Quantity__c':result.CCC_Part_Quantity__c,
                        'CCC_Part_Description__c':result.CCC_Part_Description__c,
                        'CCC_Planner__c':result.CCC_Planner__c,
                        'CCC_Product_Buyer__c':result.CCC_Product_Buyer__c,
                        'CCC_Vendor_Code__c':result.CCC_Vendor_Code__c,
                        'CCC_Vendor_Name__c':result.CCC_Vendor_Name__c,
                        'CCC_Stocking_Type__c':result.CCC_Stocking_Type__c,
                        'Material__c':result.Material__c,
                        'CCC_C10Order__c':result.CCC_C10Order__c,
                        'CCC_Customer_PO__c':result.CCC_Customer_PO__c,
                        'CCC_RCD_PO__c':result.CCC_RCD_PO__c,
                        'CCC_Quote__c':result.CCC_Quote__c,
                        'CCC_RMA__c':result.CCC_RMA__c,
                        'CCC_RMA_Sent__c':result.CCC_RMA_Sent__c,
                        'CCC_Invoice__c':result.CCC_Invoice__c,
                        'CCC_Model_Number__c':result.CCC_Model_Number__c,
                        'CCC_Serial_Number__c':result.CCC_Serial_Number__c,
                        'CCC_Expedite_Status__c':result.CCC_Expedite_Status__c,
                        'CCC_Commit_Time__c':result.CCC_Commit_Time__c,
                        'CCC_Vendor_Ship_Date__c':result.CCC_Vendor_Ship_Date__c,
                        'CCC_Vendor_Tracking__c':result.CCC_Vendor_Tracking__c,
                        //'CCC_Days_Open__c':result.CCC_Days_Open__c,
                        'CCC_Solution__c':result.CCC_Solution__c,
                        //'CCC_Time_to_Closure__c':result.CCC_Time_to_Closure__c,
                        //'CCC_Turn_Back_Code__c':result.CCC_Turn_Back_Code__c,
                        'Order__c':result.Order__c,
                        'Claims_Purpose__c':result.Claims_Purpose__c,
                        'Claims_Sub_Purpose__c':result.Claims_Sub_Purpose__c,
                        'Claims_Order_Type__c': result.	Claims_Order_Type__c,
                        'CCC_Sub_Purpose__c':result.CCC_Sub_Purpose__c,
                        'CCC_SAP_Order__c':result.CCC_SAP_Order__c
                        
                        
                       // 'recordTypeId' : '01215000001JLpG'
             	}            
       
         	});
                 createRecordEvent.fire();
           }
        });
         $A.enqueueAction(action2);
    
    },

    handleOnLoad : function(component, event, helper) {
        //$A.get('e.force:refreshView').fire();
        //var toggleText = component.find("editable");
        //$A.util.toggleClass(toggleText, "slds-hide");
        var recordId = component.get("v.recordId");
        //alert('Record Id in Desc:'+recordId);
        var action = component.get("c.getCase");
        action.setParam("id", recordId);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.case", response.getReturnValue());
                $A.get('e.force:refreshView').fire();

            } else{
                alert('Error desc:');
            }
        });
        $A.enqueueAction(action);
        var toggleText = component.find("editable");
        $A.util.toggleClass(toggleText, "slds-hide");
    },
    
    checkIfFired : function(component, event, helper) {
        //alert(component.get("v.recordId"));
        //alert('Refreshed:'+event.getSource().getLocalId());
        //$A.get('e.force:refreshView').fire();
    },
    
    

   
    saveDesc1 : function(component,event,helper) {
        //    alert('Save Clicked');
           component.set("v.isEditPage", false);
           console.log('Before Upsert:'+component.get("v.case"));
           var action = component.get("c.saveCase5");
           action.setParams({"caseObject": component.get("v.case")});
           action.setCallback(this, function(response) {  
           var state = response.getState();
            if(state == "SUCCESS"){
                console.log( 'Success Response:'+response.getReturnValue()); 
                
                $A.get('e.force:refreshView').fire();
            }else{
              //  alert('Error:');
            }
             
        } );
        $A.enqueueAction(action);
        },
      closeMessage: function(component, event, helper) {
        component.set("v.saveStatus", false);    
  
      }
  
	

})