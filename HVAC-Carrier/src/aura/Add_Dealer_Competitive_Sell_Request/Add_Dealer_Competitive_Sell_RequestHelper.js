({
    sObjectCollection : function(cmp,event){
        var List = cmp.get("v.TempList");
        var size = List.length;
        var i; 
        var ModelList = [];
        var x=   cmp.get("v.modelListSelected");
        for(i=0;i<size;i++){
            var detailtemp = {};
            detailtemp = { 'sobjectType': 'Competitive_Sell__c',
                          'Your_Model__c':'', 
                          'Requested_Sell__c':'',
                          'Competitors_Model__c':'',
                          'Competitors_Sell__c':'', 
                          'Buy_1__c':'',
                          'DGM_1__c':'',
                          'Buy_2__c':'',
                          'DGM_2__c':''
                         };
            
            var modelTemp = x[i].split(';')[1];
            detailtemp.Your_Model__c =modelTemp;
            detailtemp.Requested_Sell__c = document.getElementById(i+"requestSell").value;
            detailtemp.Competitors_Model__c = document.getElementById(i+"compMod").value;
            detailtemp.Competitors_Sell__c = document.getElementById(i+"compSell").value;
            detailtemp.Buy_1__c = document.getElementById(i+"buy1").value;
            detailtemp.DGM_1__c = document.getElementById(i+"dgm1").value;
            detailtemp.Buy_2__c = document.getElementById(i+"buy2").value;
            detailtemp.DGM_2__c = document.getElementById(i+"dgm2").value;
            ModelList.push(detailtemp);
        }
        cmp.set("v.OutputList",ModelList);
    },
    
    onSingleSelectChange: function(cmp,event) {
        var index = event.target.name;
        var value = event.target.value;
        var unique_id=index+';'+value;
        var list = cmp.get("v.modelListSelected");
        var exists = false;
        var i;
        for(i=0;i<list.length;i++){
            console.log(list[i].split(';')[0]);
            if(list[i].split(';')[0]==index){
                list[index] = unique_id;
                exists=true;
                break;
            }
        }
        if(exists!=true){
            list.push(unique_id);
        }
        list.sort();
    },
})