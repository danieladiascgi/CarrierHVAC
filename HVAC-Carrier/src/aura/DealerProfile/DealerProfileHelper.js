({
    addToSObjectCollection : function(cmp,event,helper) {
        
        var selectList=cmp.get("v.SelectedBrandList");
        var size=selectList.length;  
        var BrandsList = [];
        for(var i = 0; i< size ; i++){
            var detailtemp = {};
            detailtemp = {'sobjectType': 'Dealer_Profile__c',
                          'Brand__c':'', 
                          'Previous_Year_Percent__c':'',
                          'Previous_Year__c':'',
                          'Current_Year_Percent__c':'',
                          'Current_Year__c':'',
                          'Future_Year_Percent__c':'',
                          'Future_Year__c':''
                         }
            detailtemp.Brand__c =selectList[i];
            
            detailtemp.Previous_Year_Percent__c 	=parseInt(document.getElementById(i+"-previousYear").value);
            detailtemp.Previous_Year__c 			=document.getElementById(i+"-inputPreviousYear").value;
            
            detailtemp.Current_Year_Percent__c		=parseInt(document.getElementById(i+"-currentYear").value);
            detailtemp.Current_Year__c				=document.getElementById(i+"-inputCurrentYear").value;
            
            detailtemp.Future_Year_Percent__c		=parseInt(document.getElementById(i+"-futureYear").value);
            detailtemp.Future_Year__c				=document.getElementById(i+"-inputfutureYear").value;
            BrandsList.push(detailtemp);
        }
        cmp.set("v.BrandsSObjectCollection",BrandsList);
    },
    
     validateFields : function(cmp,event,helper){
        
        var selectList=cmp.get("v.SelectedBrandList");
        var size=selectList.length;
        
        helper.addToSObjectCollection(cmp,event,helper);
        
        cmp.set("v.ShowBarChart","true");
        
        var appEvent = $A.get("e.c:BarChartData");
        appEvent.setParams({
            "BrandsSObjectCollection" : cmp.get("v.BrandsSObjectCollection") });
        appEvent.fire();
        
    },
    
})