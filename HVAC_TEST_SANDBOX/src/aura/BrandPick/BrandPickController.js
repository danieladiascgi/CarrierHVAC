({
    
    FireEvent : function(cmp, event){
        var appEvent = $A.get("e.c:BrandPickEvent");
        
        var selectedBrands =cmp.find("InputSelectMultiple").get("v.value").split(";");
        var Brands =cmp.get("v.BrandList");
        var UnselectedBrands = [];
        var i;
        var x;
        for(i=0;i<Brands.length;i++){
            var currentBrand = Brands[i];
            var isUnselected = true;
            for(x=0;x<selectedBrands.length;x++){
                var selectBrand = selectedBrands[i];
                if( currentBrand == selectBrand){
                    isUnselected = false;
                }
            }
            if(isUnselected){
                UnselectedBrands.push(Brands[i]) ;
            }
        }
        
        appEvent.setParams({
            "SelectedBrands" : selectedBrands,
            "NonSelectedBrands" :UnselectedBrands
        });
        appEvent.fire();
        
    },
    
    onMultiSelectChange: function(cmp) {
        var selectCmp = cmp.find("InputSelectMultiple");
        var resultCmp = cmp.find("multiResult");
        resultCmp.set("v.value", selectCmp.get("v.value"));
    },
    
})