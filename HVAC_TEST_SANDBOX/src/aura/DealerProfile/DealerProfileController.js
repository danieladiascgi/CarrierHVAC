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
        
        component.set("v.DataList",inputs);
        
        var NotReady =component.get("v.NotReady");
        
        if(count == 100){
            component.set("v.NotReady","false");
            component.set("v.rnc",document.getElementById("text-input-id-1").value);
            component.set("v.rncMF",document.getElementById("text-input-id-2").value);
            component.set("v.aor",document.getElementById("text-input-id-3").value);
            component.set("v.com",document.getElementById("text-input-id-4").value);
            component.set("v.dls",document.getElementById("text-input-id-5").value);
            component.set("v.retail",document.getElementById("text-input-id-6").value);
            component.set("v.ot",document.getElementById("text-input-id-7").value);
            component.set("v.dograph","true");
        }
        else if(NotReady=="false") {
            component.set("v.NotReady","true");
            component.set("v.dograph","false");
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
        
        var AddBrandList = event.getParam("SelectedBrands");
        var BrandList = cmp.get("v.SelectedBrandList");
        var nonseleced= event.getParam("NonSelectedBrands");
        var i;
        if(AddBrandList!=""){
            for(i=0;i<AddBrandList.length;i++){
                var current = AddBrandList[i];
                BrandList.push(current);
            }
        }
        
        cmp.set("v.SelectedBrandList", BrandList);
        cmp.set("v.BrandList", event.getParam("NonSelectedBrands"));
        
        
        if( event.getParam("NonSelectedBrands").length == 0){
            cmp.set("v.NonBrandLeft",true);
            cmp.set("v.ShowBrands", false);
        }
        else{
            cmp.set("v.ShowBrands", false);
        }
        
        
        
    },
    
    RemoveBrand : function(cmp, event){
        var removedBrand = event.getSource().get("v.name"); 
        var selectedList = cmp.get("v.SelectedBrandList"); 
        var BrandList=cmp.get("v.BrandList"); 
        var i;
        var remove;
        for(i=0;i<selectedList.length;i++){
            if(selectedList[i]==removedBrand){
                remove=i;
                break;
            }
            
        }
        selectedList.splice(remove,1);
        cmp.set("v.SelectedBrandList",selectedList);
        BrandList.push(removedBrand);
        cmp.set("v.BrandList",BrandList);
        cmp.set("v.NonBrandLeft",false);
        
    }
    
    
    
    
    
    
    
})