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
                alert('Error description1:');
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
        
      
        var action2 = component.get("c.getCase");
        action2.setParams({
            "id" : component.get("v.recordId") 
        });
        action2.setCallback(this,function(response){
            var state = response.getState();             
            if(state === 'SUCCESS'){                
                var result = response.getReturnValue();
               // alert('Expedite_Record_Count__c'+result.Expedite_Record_Count__c);
                if(result.Expedite_Record_Is_present__c == true)
                {
                   // alert('inside if');
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Expedite__c",
                    "defaultFieldValues": {
                        'Subject__c' : result.Subject,
                        'Description__c' : result.Description,
                        'Priority__c': 'High',
                        'Account_Name__c': result.AccountId,
                       // 'Brand__c':result.CCC_Brand__c,
                        'C10_Order__c' :null,
                        'Status__c':result.Status,
                        'Source__c':result.Origin,
                       // 'Purpose__c':result.CCC_Purpose__c,
                       // 'Part_Description__c':result.CCC_Part_Description__c,
                       // 'Part_Number__c':result.CCC_Part_Number__c,
                        'Customer_Type__c':result.CCC_Customer_Type__c,
                       // 'Quantity__c':result.CCC_Part_Quantity__c,
                       // 'Planner__c':result.CCC_Planner__c,
                        'Contact_Name__c':result.ContactId,
                        'Customer_PO__c':result.CCC_Customer_PO__c,
                        'Expedite_Status__c':result.CCC_Expedite_Status__c,
                      //  'Invoice__c':result.CCC_Invoice__c,
                        'Material__c':result.Material__c,
                        'Model__c':result.CCC_Model_Number__c,
                        'Phone_Number__c':result.Phone_Number__c,
                       // 'Buyer__c':result.CCC_Product_Buyer__c,
                        'Sender_s_Email__c':result.SuppliedEmail,
                        'Serial__c':result.CCC_Serial_Number__c,
                       // 'Solution__c':result.CCC_Solution__c,
                        'Vendor_Ship_Date__c':result.CCC_Vendor_Ship_Date__c,
                        'Vendor_Tracking__c':result.CCC_Vendor_Tracking__c,
                        'Vendor_Code__c':null,
                        'Vendor_Name__c':null,
                        'Commit_Time__c':result.CCC_Commit_Time__c,
                        'RCD_PO__c':null,
                        'Quote__c':result.CCC_Quote__c,
                        'Stocking_Type__c':result.CCC_Stocking_Type__c,
                        'Case_Number__c':result.Id,
                        'ZSM__c':result.ZSM__c,
                       // 'RMA__c':result.CCC_RMA__c,
                        'Part_Description__c':null,
                        'Part_Number__c':'',
                        'Quantity__c':null,
                        'Part__c':null,
                        'Planner__c':null,
                        'Buyer__c':null
                       // 'New_Comments__c':result.New_Comment__c,
                       // 'New_Msg__c':result.New_Msg__c
                       
                        
                        
                       // 'recordTypeId' : '01215000001JLpG'
             	} 
                
                   
       
         	});
                 createRecordEvent.fire();
            }
                else
                {
                    
                     var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Expedite__c",
                    "defaultFieldValues": {
                        'Subject__c' : result.Subject,
                        'Description__c' : result.Description,
                        'Priority__c': 'High',
                        'Account_Name__c': result.AccountId,
                        'Brand__c':result.CCC_Brand__c,
                        'C10_Order__c' :result.CCC_C10Order__c,
                        'Status__c':result.Status,
                        'Source__c':result.Origin,
                        //'Purpose__c':result.CCC_Purpose__c,
                       // 'Part_Description__c':result.CCC_Part_Description__c,
                       // 'Part_Number__c':result.CCC_Part_Number__c,
                        'Customer_Type__c':result.CCC_Customer_Type__c,
                       // 'Quantity__c':result.CCC_Part_Quantity__c,
                        'Planner__c':result.CCC_Planner__c,
                        'Contact_Name__c':result.ContactId,
                        'Customer_PO__c':result.CCC_Customer_PO__c,
                         'Expedite_Status__c':result.CCC_Expedite_Status__c,
                       // 'Invoice__c':result.CCC_Invoice__c,
                        'Material__c':result.Material__c,
                        'Model__c':result.CCC_Model_Number__c,
                        'Phone_Number__c':result.Phone_Number__c,
                        'Buyer__c':result.CCC_Product_Buyer__c,
                        'Sender_s_Email__c':result.SuppliedEmail,
                        'Serial__c':result.CCC_Serial_Number__c,
                        'Solution__c':result.CCC_Solution__c,
                        'Vendor_Ship_Date__c':result.CCC_Vendor_Ship_Date__c,
                        'Vendor_Tracking__c':result.CCC_Vendor_Tracking__c,
                        'Vendor_Code__c':result.CCC_Vendor_Code__c,
                        'Vendor_Name__c':result.CCC_Vendor_Name__c,
                        'Commit_Time__c':result.CCC_Commit_Time__c,
                        'RCD_PO__c':result.CCC_RCD_PO__c,
                        'Quote__c':result.CCC_Quote__c,
                        'Stocking_Type__c':result.CCC_Stocking_Type__c,
                        'Case_Number__c':result.Id,
                      //  'ZSM__c':result.ZSM__c,
                      //  'RMA__c':result.CCC_RMA__c,
                        'Part_Description__c':result.CCC_Part_Description__c,
                        'Part_Number__c':result.CCC_Part_Number__c,
                        'Quantity__c':result.CCC_Part_Quantity__c,
                        'Part__c':result.CCC_Part__c
                       // 'New_Comments__c':result.New_Comment__c,
                       // 'New_Msg__c':result.New_Msg__c
                       
                        
                        
                       // 'recordTypeId' : '01215000001JLpG'
             	} 
                    
                
                   
       
         	});
                 createRecordEvent.fire();
               
                }
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
     //  var action = component.get("c.getCase");
        action.setParam("id", recordId);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.case", response.getReturnValue());
                $A.get('e.force:refreshView').fire();

            } else{
                alert('Error description2:');
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