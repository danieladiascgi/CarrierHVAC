({
    addToSObjectCollection : function(cmp,event,helper) {
        
        var selectList=cmp.get("v.SelectedBrandList");
        var size=selectList.length;
        
        
        var BrandsList = [];
        for(var i = 0; i< size ; i++){
            var detailtemp = {};
            detailtemp = {'sobjectType': 'Dealer_Profile__c',
                          'Brand':'', 
                          'Previous_Year_Percent__c':'',
                          'Previous_Year__c':'',
                          'Current_Year_Percent__c':'',
                          'Current_Year__c':'',
                          'Future_Year_Percent__c':'',
                          'Future_Year__c':''
                         }
            
            detailtemp.Brand 						=selectList[i];
            detailtemp.Previous_Year_Percent__c 	= document.getElementById(i+"-previousYear").value;
            detailtemp.Previous_Year__c 			=document.getElementById(i+"-inputPreviousYear").value;
            detailtemp.Current_Year_Percent__c		=document.getElementById(i+"-currentYear").value;
            detailtemp.Current_Year__c				=document.getElementById(i+"-inputCurrentYear").value;
            detailtemp.Future_Year_Percent__c		=document.getElementById(i+"-futureYear").value;
            detailtemp.Future_Year__c				=document.getElementById(i+"-inputfutureYear").value;
            BrandsList.push(detailtemp);
        }
        cmp.set("v.BrandsSObjectCollection",BrandsList);
        console.log(JSON.stringify(BrandsList));
        var x;
    }
    
    
    
}
)