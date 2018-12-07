({
   
  doInit: function(component, event, helper){
      //alert('yes');
      var action= component.get("c.getValOfSapShipTo");  
      action.setParams({"recId": component.get("v.recordId")});
      //alert('no');
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state == "SUCCESS") {
            component.set("v.sapShipToVal", response.getReturnValue());           
        }
        else {
            console.log("Failed with state: " + state);
        }
      });   
    $A.enqueueAction(action);
  }, 
    
 showToolTip: function(component, event, helper){
    //component.set("v.displayEnterCustNo",false);
    //component.set("v.displayEnterMatNo",false);
    var matList = component.get("v.materialsList");
   if(matList != null){
      component.set("v.dispayToolTip",true);  
      var action= component.get("c.onHoverCall");  
       var matNo = component.get("v.MaterialNo");
       var custNo = component.get("v.sapShipToVal");
       var isCannada = component.get("v.checkboxVal");
       //alert('custnmbr...'+custNo);
       action.setParams({"materialNumber":matNo,"custNumber":custNo, "isCannada":isCannada});
      action.setCallback(this, function(response) {
       // alert('wow'+JSON.stringify(response.getReturnValue()));
        component.set("v.materialsPriceList", response.getReturnValue());
       // alert('okkkk'+JSON.stringify(component.get("v.materialsList")));
        var state = response.getState();
        if (component.isValid() && state == "SUCCESS") {
            component.set("v.materialsPriceList", response.getReturnValue());           
        }
        else {
            console.log("Failed with state: " + state);
        }
      });   
    // Send action off to be executed
    $A.enqueueAction(action);	
   }
 },
    
  hideToolTip:function(component, event, helper){
    component.set("v.dispayToolTip",false);  
    //component.set("v.displayEnterCustNo",false);
    //component.set("v.displayEnterMatNo",false);
  },
    
  handleClick2: function(component, event, helper) {
      //alert('okzzzz'); 
      //var materialNo = component.find("mno").get("v.value");
     
      component.set("v.displayOnInvalidPartNo",false);
      component.set("v.displayOnNoPriceData",false);
      component.set("v.displayEnterCustNo",false);
      component.set("v.displayEnterMatNo",false);
      if(component.find("sapShipTo").get("v.value") == null || component.find("sapShipTo").get("v.value") == '' || component.find("mno").get("v.value") == null || component.find("mno").get("v.value") == ''){
        //alert('Please enter Customer Number'); 
        if(component.find("sapShipTo").get("v.value") == null || component.find("sapShipTo").get("v.value") == ''){
          component.set("v.displayEnterCustNo",true);
        }
        if(component.find("mno").get("v.value") == null || component.find("mno").get("v.value") == ''){
          component.set("v.displayEnterMatNo",true);
        }
      }
      else{
        component.set("v.showSection",true);
        var action= component.get("c.getMaterialAvailability");
        var matNo = component.get("v.MaterialNo"); 
        var isCannada = component.get("v.checkboxVal");
        action.setParams({"materialNumber":matNo});
        action.setCallback(this, function(response) {
       // alert('wow'+JSON.stringify(response.getReturnValue()));
        component.set("v.materialsList", response.getReturnValue());
       // alert('okkkk'+JSON.stringify(component.get("v.materialsList")));
        var state = response.getState();
        if (component.isValid() && state == "SUCCESS") {
            component.set("v.materialsList", response.getReturnValue());           
        }
        else {
            console.log("Failed with state: " + state);
        }
      });   
      // Send action off to be executed
      $A.enqueueAction(action);	
    }
  },
    
  onSelect: function(component, evt) { 
         var selected = evt.getSource().get("v.text");
        //component.get("v.selectedRecords").push(selected);
        //alert('sssud'+evt.getSource().get("v.value"));
        if (evt.getSource().get("v.value")) {
           // Checkbox is checked - add id to selectedRecords
           if (component.get("v.selectedRecords").indexOf(selected) < 0) {
              component.get("v.selectedRecords").push(selected);
           }
        } else {
           // Checkbox is unchecked - remove id from selectedRecords
           var index = component.get("v.selectedRecords").indexOf(selected);
           if (index > -1) {
             component.get("v.selectedRecords").splice(index, 1);
           }
        }      
  }, 
    
  clickSave: function(component, event, helper){
      /*var checkboxes = document.getElementsByClassName("checkboxLeads");
      var checkboxesChecked = [];
      for (var i=0; i<checkboxes.length; i++) {
        // And stick the checked ones onto an array...
        if (checkboxes[i].checked) {
            checkboxesChecked.push(checkboxes[i]);
        }
      }
      alert('checkboxesChecked..'+checkboxesChecked);*/
    if(component.get("v.displayEnterCustNo") == false && component.get("v.displayEnterMatNo") == false)
    {
       var action= component.get("c.SaveMaterial");
       //alert('action'+JSON.stringify(action));
       //alert('wowss'+JSON.stringify(component.get("v.materialsList")));
       var recMaterial = component.get("v.materialsList");
       var MatrlNo = component.get("v.MaterialNo");
       var matNo = component.get("v.MaterialNo");
       var custNo = component.get("v.sapShipToVal");
       var isCannada = component.get("v.checkboxVal");
       //alert('recMaterial'+recMaterial.Date__c);
      action.setParams({"materialNumber":matNo,"custNumber":custNo, "isCannada":isCannada,"recId": component.get("v.recordId")});
      //action.setParams({"recMatQty":recMaterial.Qty__c,"recMatDt":recMaterial.Date__c,"recMatStatus":recMaterial.Status__c});
        action.setCallback(this, function(response) {
        //component.set("v.MaterialResult", response.getReturnValue());
        var state = response.getState();
        if (state == "SUCCESS") {
            //component.set("v.MaterialResult", response.getReturnValue()); 
            //alert('SUCCESS');
            console.log("Success");    
             $A.get('e.force:refreshView').fire();
        }
        else {
            component.set("v.displayOnInvalidPartNo",false);
            component.set("v.displayOnNoPriceData",false);
            if(component.get("v.materialsList") == null){
                component.set("v.displayOnInvalidPartNo",true);
                //alert('ERROR');
            }
            if(component.get("v.materialsList") != null && component.get("v.materialsPriceList") == null){
                component.set("v.displayOnNoPriceData",true);
                //alert('ERROR');
            }
            console.log("Failed with state: " + state);
        }
    });   
      $A.enqueueAction(action);
   }
 }
    
});