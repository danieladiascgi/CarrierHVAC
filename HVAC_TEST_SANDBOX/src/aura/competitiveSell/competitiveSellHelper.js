({
    
    sObjectCollection : function(cmp,evt){
        var List = cmp.get("v.ListCenas");
        var size = List.length;
        var i;
        var ModelList = [];
        var x=   cmp.get("v.modelListSelected");
        for(i=0;i<size;i++){
            var detailtemp = {};
            detailtemp = { 'sobjectType': 'Competitive_Sell_Request__c',
                          'Your_Model__c':'', 
                          'Request_Sell__c':'',
                          'Competitor_Model__c':'',
                          'Competitor_Sell__c':'',
                          'Buy1__c':'',
                          'DGM1__c':'',
                          'Buy2__c':'',
                          'DGM2__c':''
                         };
            
            var modelTemp = x[i].split(';')[1];
            detailtemp.Your_Model__c =modelTemp;
            detailtemp.Request_Sell__c = document.getElementById(i+"requestSell").value;
            detailtemp.Competitor_Model__c = document.getElementById(i+"compMod").value;
            detailtemp.Competitor_Sell__c = document.getElementById(i+"compSell").value;
            detailtemp.Buy1__c = document.getElementById(i+"buy1").value;
            detailtemp.DGM__c = document.getElementById(i+"dgm1").value;
            detailtemp.Buy2__c = document.getElementById(i+"buy2").value;
            detailtemp.DGM2__c = document.getElementById(i+"dgm2").value;
            
            ModelList.push(detailtemp);
        }
        cmp.set("v.OutputList",ModelList);
    }
})