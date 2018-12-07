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
        
    },
    
    showPercentage : function(cmp, event,helper){
        
        
        try{
            var totalPrevious = document.getElementById("text-input-id-current-1").value;
            var totalCurrent = document.getElementById("text-input-id-current").value;
            var totalFuture = document.getElementById("text-input-id-current+1").value;
            
            var totalId = event.target.id;
            var id = event.target.id.split("-")[0]; 
            var inputPrevious = document.getElementById(id + "-inputPreviousYear").value;
            var inputCurrent = document.getElementById(id + "-inputCurrentYear").value;
            var inputFuture = document.getElementById(id + "-inputfutureYear").value;
            
            if(totalPrevious!=0 && totalPrevious!=null){
                document.getElementById(id+"-previousYear").value =  inputPrevious/totalPrevious;
            }
            if(totalCurrent!=0 && totalCurrent!=null){
                document.getElementById(id + "-currentYear").value =inputCurrent/totalCurrent;
            }
            if(totalFuture!=0 && totalFuture!=null){
                document.getElementById(id + "-futureYear").value = inputFuture/totalFuture;
            }
        }
        catch(err){
            
        }
        
        
        
    },
    
    validateFields : function(cmp,event,helper){
        var totalPrevious = document.getElementById("text-input-id-current-1").value;
        var totalCurrent = document.getElementById("text-input-id-current").value;
        var totalFuture = document.getElementById("text-input-id-current+1").value;
        var selectList=cmp.get("v.SelectedBrandList");
        var size=selectList.length;
        
        var i;
        for(i=0;i<size;i++){
            totalPrevious -= document.getElementById(i + "-inputPreviousYear").value;
            totalCurrent -= document.getElementById(i + "-inputCurrentYear").value;
            totalFuture -= document.getElementById(i + "-inputfutureYear").value;
            helper.addToSObjectCollection(cmp,event,helper);
        }
        
        if(totalPrevious==0 && totalCurrent==0 && totalFuture==0){
            alert("Nice");
        }
        else {
            if(totalPrevious!=0){
                alert("Total of previous year values is incorrect by " + totalPrevious*-1);
            }
            else if(totalCurrent!=0){
                alert("Total of current year values is incorrect by " + totalCurrent*-1);
            }
                else if(totalFuture!=0){
                    alert("Total of next year values is incorrect by " + totalFuture*-1);
                }
            
        }
        
        
    }
    
    
    
    
    
})