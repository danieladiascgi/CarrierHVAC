({
    checkNumber : function(component, event, helper) {
        var value = document.getElementById(event.target.id).value;
        if(parseInt(value)>100){
            document.getElementById(event.target.id).value = 0;
        }
        else if(parseInt(value)<0){
            document.getElementById(event.target.id).value = 0;
        }
        var input1 =document.getElementById("text-input-id-1").value;
        var input2 =document.getElementById("text-input-id-2").value;
        var input3 =document.getElementById("text-input-id-3").value;
        var input4 =document.getElementById("text-input-id-4").value;
        var input5 =document.getElementById("text-input-id-5").value;
        var input6 =document.getElementById("text-input-id-6").value;
        var input7 =document.getElementById("text-input-id-7").value;
        var NotReady =component.get("v.NotReady");
        if(parseInt(input1) + parseInt(input2) + parseInt(input3)+ 
           parseInt(input4) +parseInt(input5)+parseInt(input6)+parseInt(input7) == 100){
            component.set("v.NotReady","false");
        }
        else if(NotReady=="false") {
            component.set("v.NotReady","true");
        }
    },
    
    init : function(component, event, helper) {
        var today = new Date();
        
        component.set('v.year', today.getFullYear());
         var action = component.get("c.getBrand");
        action.setCallback(this , function(a){
            			var returnValue = a.getReturnValue();
                           component.set("v.BrandList",returnValue)
                           });
         $A.enqueueAction(action);
    },
    
    
    showBrands : function(cmp){
        cmp.set("v.ShowBrands",true)
        
    },
    
    addBrands : function(cmp){
        cmp.set("v.ShowBrands",false)
        var selectCmp = cmp.find("InputSelectMultiple");
        var data =selectCmp.get("v.value");
        cmp.set("v.SelectedBrandList" , data);
        
    },
    
        onMultiSelectChange: function(cmp) {
        var selectCmp = cmp.find("InputSelectMultiple");
        var resultCmp = cmp.find("multiResult");
        resultCmp.set("v.value", selectCmp.get("v.value"));
    },
    
})