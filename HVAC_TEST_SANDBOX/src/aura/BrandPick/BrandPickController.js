({
	    init : function(component){
        var action = component.get("c.getBrand");
        action.setCallback(this , function(a){
            			var returnValue = a.getReturnValue();
                           component.set("v.BrandList",returnValue)
                           });
         $A.enqueueAction(action);
    }
    ,
    FireEvent : function(cmp, event){
        var appEvent = $A.get("e.c:BrandPickEvent");
        var brands =cmp.get("v.result");
        appEvent.setParams({
            "SelectedBrands" : brands });
        appEvent.fire();
        
    },
    
    onMultiSelectChange: function(cmp) {
        var selectCmp = cmp.find("InputSelectMultiple");
        var resultCmp = cmp.find("multiResult");
        resultCmp.set("v.value", selectCmp.get("v.value"));
    },

})