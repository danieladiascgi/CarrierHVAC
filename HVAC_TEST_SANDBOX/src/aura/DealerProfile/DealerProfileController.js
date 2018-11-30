({
    checkNumber : function(component, event, helper) {
        var value = document.getElementById(event.target.id).value;
        if(parseInt(value)>100){
            document.getElementById(event.target.id).value = 0;
        }
        else if(parseInt(value)<0){
            document.getElementById(event.target.id).value = 0;
        }
        var inputs  = [document.getElementById("text-input-id-1").value,document.getElementById("text-input-id-2").value,document.getElementById("text-input-id-3").value,
                       document.getElementById("text-input-id-4").value,document.getElementById("text-input-id-5").value,document.getElementById("text-input-id-6").value,
                       document.getElementById("text-input-id-7").value];
        
        var i;
        var count = 0;
        for (i = 0; i < inputs.length; i++) { 
            if(inputs[i]==""){
                inputs[i]=0;
            }
            count+=parseInt(inputs[i]);
        }
        
        var NotReady =component.get("v.NotReady");
        
        if(count == 100){
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
    
    handleApplicationEvent : function(cmp, event) {
        cmp.set("v.ShowBrands", false);
        var brand = event.getParam("SelectedBrands");
        var test =event.getParam("NonSelectedBrands");
        var isArray = Array.isArray(brand);
        cmp.set("v.SelectedBrandList", event.getParam("SelectedBrands"));
        var testtegjsdcjcd = cmp.get("v.SelectedBrandList");
        cmp.set("v.BrandList", event.getParam("NonSelectedBrands"));
    }
    
    
    
    
    
    
    
    
    
})