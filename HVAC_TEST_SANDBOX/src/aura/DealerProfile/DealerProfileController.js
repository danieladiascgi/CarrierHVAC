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
;        var NotReady =component.get("v.NotReady");
        
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
         
    },
    
    
    showBrands : function(cmp){
        cmp.set("v.ShowBrands",true)
    },
    
    handleApplicationEvent : function(cmp, event) {
        cmp.set("v.ShowBrands", "false");
    }
    
    
    
    
    
    
    
    
    
})