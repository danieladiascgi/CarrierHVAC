({
	onLoad: function(component, event, sortField) {
      //call apex class method
      var action = component.get('c.fetchOpenSortedCases');
 
      // pass the apex method parameters to action 
      action.setParams({
         'EmailAddress':"poulomi.chatterjee@lntinfotech.com",
         'sortField': sortField,
         'isAsc': component.get("v.isAsc")
      });
      action.setCallback(this, function(response) {
         //store state of response
         var state = response.getState();
         if (state === "SUCCESS") {
         //   alert('hi'+JSON.stringify(response.getReturnValue()));
            //set response value in ListOfContact attribute on component.
            component.set('v.lstCases', response.getReturnValue());
             
            //component.set('v.isAsc',false);
         }
      });
      $A.enqueueAction(action);
   },
 
   sortHelper: function(component, event, sortFieldName) {
      var currentDir = component.get("v.arrowDirection");
   //   alert('currentDir'+currentDir);
      if (currentDir == 'arrowdown') {
         // set the arrowDirection attribute for conditionally rendred arrow sign  
         component.set("v.arrowDirection", 'arrowup');
         // set the isAsc flag to true for sort in Assending order.  
         component.set("v.isAsc", false);
      } else {
         component.set("v.arrowDirection", 'arrowdown');
         component.set("v.isAsc", true);
      }
      // call the onLoad function for call server side method with pass sortFieldName 
      this.onLoad(component, event, sortFieldName);
   }
})