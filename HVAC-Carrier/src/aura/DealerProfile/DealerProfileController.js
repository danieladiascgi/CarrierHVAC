({
    checkNumber : function(cmp, event, helper) {
        cmp.set("v.Comment",cmp.find("text-input-id-8").get("v.value"));
        var inputs  = [cmp.find("text-input-id-1").get("v.value"),cmp.find("text-input-id-2").get("v.value"),cmp.find("text-input-id-3").get("v.value"),
                       cmp.find("text-input-id-4").get("v.value"),cmp.find("text-input-id-5").get("v.value"),cmp.find("text-input-id-6").get("v.value"),
                       cmp.find("text-input-id-7").get("v.value")];
        
        var i;
        var count = 0;
        for (i = 0; i < inputs.length; i++) { 
            if(inputs[i]==""){
                inputs[i]=0;
            }
            count+=parseInt(inputs[i]);
        }
        cmp.set("v.DataList",inputs);
        var NotReady = cmp.get("v.NotReady");
        
        if(count == 100){
            cmp.set("v.NotReady","false");
            cmp.set("v.rnc",cmp.find("text-input-id-1").get("v.value"));
            cmp.set("v.rncMF",cmp.find("text-input-id-2").get("v.value"));
            cmp.set("v.aor",cmp.find("text-input-id-3").get("v.value"));
            cmp.set("v.com",cmp.find("text-input-id-4").get("v.value"));
            cmp.set("v.dls",cmp.find("text-input-id-5").get("v.value"));
            cmp.set("v.retail",cmp.find("text-input-id-6").get("v.value"));
            cmp.set("v.ot",cmp.find("text-input-id-7").get("v.value"));
            cmp.set("v.dograph","true"); 
        }
        else if(NotReady=="false") {
            cmp.set("v.NotReady","true");
            cmp.set("v.dograph","false");
        }
    },
    
    init : function(cmp, event, helper) {
        var device = $A.get("$Browser.formFactor");
        if(device=="PHONE"){
            cmp.set("v.isMobile","true");
        }
        
        var today = new Date();
        cmp.set('v.year', today.getFullYear());
        
        
        var action = cmp.get("c.getBrand");
        action.setCallback(this , function(a){
            var returnValue = a.getReturnValue();
            cmp.set("v.BrandList",returnValue)
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
        
        var size = cmp.get("v.SelectedBrandList").length;
        var id = event.target.id.split("-")[0];
        var totalPrevious = 0;
        var totalCurrent = 0;
        var totalFuture = 0;
        
        var i;
        for(i = 0; i <= size;i++){
            try {
            	var inputPrevious = document.getElementById(i + "-inputPreviousYear").value;
            	//var inputPrevious = cmp.find(i + "-inputPreviousYear").get("v.fieldValue");
                if(inputPrevious != 0){
                    totalPrevious =  parseInt(totalPrevious) +  parseInt(inputPrevious);
                }
                var inputCurrent = document.getElementById(i + "-inputCurrentYear").value;
                //var inputCurrent = cmp.find(i + "-inputCurrentYear").get("v.fieldValue");
                if(inputCurrent != 0){
                    totalCurrent =  parseInt(totalCurrent) +  parseInt(inputCurrent);
                }
                var inputFuture = document.getElementById(i + "-inputfutureYear").value;
                //var inputFuture = cmp.find(i + "-inputfutureYear").get("v.fieldValue");
                if(inputFuture != 0){
                    totalFuture =  parseInt(totalFuture) +  parseInt(inputFuture);            
                }
            } catch(err){
                
            }
        }
        
        //debugger;
        
        for(i = 0; i <= id;i++){
            if(totalPrevious!=0){ var inputPrevious = document.getElementById(i + "-inputPreviousYear").value;
            document.getElementById(i+"-previousYear").value =  parseInt((inputPrevious/totalPrevious)*100) + "%";}
           
            
            if(totalCurrent!=0){var inputCurrent = document.getElementById(i + "-inputCurrentYear").value;
                                document.getElementById(i + "-currentYear").value = parseInt((inputCurrent/totalCurrent)*100)+ "%";
                               }
            
            if(totalFuture!=0){
                var inputFuture = document.getElementById(i + "-inputfutureYear").value;
                document.getElementById(i + "-futureYear").value = parseInt((inputFuture/totalFuture)*100)+ "%";
            }
                
        }
        
        document.getElementById("text-input-id-current-1").value = totalPrevious;
        //cmp.find("text-input-id-current-1").set("v.value", totalPrevious);
        document.getElementById("text-input-id-current").value = totalCurrent;
        //cmp.find("text-input-id-current").set("v.value", totalCurrent);
        document.getElementById("text-input-id-current+1").value = totalFuture;
        //cmp.find("text-input-id-current+1").set("v.value", totalFuture);
		helper.validateFields(cmp,event,helper);
    },
    
    validateFields : function(cmp,event,helper){
        helper.validateFields(cmp,event,helper);
        
    },
    
    validateGainedBusiness : function(cmp,event,helper){
        var percent = cmp.find("text-input-percent").get("v.value");
        var amount = cmp.find("text-input-dolarAmount").get("v.value");
        
        if(percent==0 && amount == 0){
            cmp.set("v.GainedBusinessBool","false");
        }
        else{
            cmp.set("v.GainedBusinessBool","true");
        }
        
        if(percent=="" || percent==null){
            percent=0;
        }
        if(amount=="" || amount==null){
            amount=0;
        }
       cmp.set("v.Percent",percent);
        cmp.set("v.Amount",amount);
        
    }
    
})