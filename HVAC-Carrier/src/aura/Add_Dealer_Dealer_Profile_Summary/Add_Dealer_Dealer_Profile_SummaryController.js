({
    init : function(component, event, helper) {
        var today = new Date();
        component.set('v.year', today.getFullYear());
        var quotesList = [];
        if( component.get("v.BrandsSObjectCollection").length==0){
            for(var i = 0; i< 3 ; i++){
                var detailtemp = {};
                detailtemp ={};
                detailtemp = { 'sobjectType': 'Dealer_Profile__c',
                              'Brand__c':'', 
                              'Previous_Year_Percent__c':'',
                              'Previous_Year__c':'',
                              'Current_Year_Percent__c':'',
                              'Current_Year__c':'',
                              'Future_Year_Percent__c':'',
                              'Future_Year__c':''
                             };
                
                detailtemp.Brand__c = "Brand"+i;
                detailtemp.Previous_Year_Percent__c = i;
                detailtemp.Previous_Year__c = i+20;
                
                detailtemp.Current_Year_Percent__c = i;
                detailtemp.Current_Year__c = i+15;
                
                detailtemp.Future_Year_Percent__c = i;
                detailtemp.Future_Year__c = i+75;
                
                quotesList.push(detailtemp);
                
            }
            component.set("v.BrandsSObjectCollection",quotesList); 
        }
        
        //component.set("v.SelectedBrandList",quotesList);  
        
        
    },
})