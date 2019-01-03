({
    doInit: function(cmp, event, helper){
        //fromCalc
        //caseid
        //input-kquotes 
        //outputkquotes
        var fromCalc = cmp.get("v.isFromCalc");
        if(fromCalc !=true){
            helper.loadData(cmp);
        }else {
            debugger;
            //something 
            var display_data = cmp.get("v.input_K_Quotes_List");
            cmp.set("v.DisplayData", display_data);
        }
        var obj = cmp.get("v.input_K_Quotes_List");
        if(obj != undefined && obj != null){
            //tests
        }
        else {
            cmp.set("v.input_K_Quotes_List", []);
        }  
    },
    
    onclick: function(cmp, event, helper){
        var list = cmp.get("v.input_K_Quotes_List");
        var quotesList = [];
        for(var i = 0; i< list.length ; i++){
            if (list[i].isSelected == true){
                var space = list[i];
                var detailtemp = {};
                detailtemp = { 'sobjectType': 'K_Quote__c',
                              'isSelected':'',
                              'Quote_number__c':'', 
                              'Quote_Reference_Number__c':'',
                              'Quote_Description__c':'',
                              'Effective_Date_Text__c':'',
                              'Expired_Date_Text__c':''
                             };
                detailtemp.isSelected = list[i].isSelected;
                detailtemp.Quote_number__c = list[i].Quote_number;
                detailtemp.Quote_Reference_Number__c = list[i].Quote_Reference_Number;
                detailtemp.Quote_Description__c = list[i].Quote_Description;
                detailtemp.Effective_Date_Text__c = list[i].Effective_Date;
                detailtemp.Expired_Date_Text__c = list[i].Expired_Date;
                quotesList.push(detailtemp);
            }
        }
        
        cmp.set("v.output_K_Quotes_List",quotesList);      
    },
    
    onclickCalc: function(cmp, event, helper){
        var list = cmp.get("v.input_K_Quotes_List");
        var quotesList = [];
        for(var i = 0; i< list.length ; i++){
            if (list[i].isSelected == true){
                var space = list[i];
                var detailtemp = {};
                detailtemp = { 'sobjectType': 'K_Quote__c',
                              'isSelected':'',
                              'Quote_number__c':'', 
                              'Quote_Reference_Number__c':'',
                              'Quote_Description__c':'',
                              'Effective_Date_Text__c':'',
                              'Expired_Date_Text__c':''
                             };
                detailtemp.isSelected = list[i].isSelected;
                detailtemp.Quote_number__c = list[i].Quote_number__c;
                detailtemp.Quote_Reference_Number__c = list[i].Quote_Reference_Number__c;
                detailtemp.Quote_Description__c = list[i].Quote_Description__c;
                detailtemp.Effective_Date_Text__c = list[i].Effective_Date_Text__c;
                detailtemp.Expired_Date_Text__c = list[i].Expired_Date_Text__c;
                quotesList.push(detailtemp);
            }
        }
        
        cmp.set("v.output_K_Quotes_List",quotesList);      
    },
    
    
    displayFilteredData : function(cmp,event,helper){
        var search = cmp.find("search-phrase");
        var value = search.get("v.value") ;
        var quotesList = cmp.get("v.input_K_Quotes_List");
        var newData = [];
        
        var i;
        for(i=0;i<quotesList.length;i++){
            if(quotesList[i].Quote_number.substring(0,value.length) == value){
                newData.push(quotesList[i]);
            }else if(quotesList[i].Quote_Reference_Number.substring(0,value.length) == value){
                newData.push(quotesList[i]);
            }
        }
        cmp.set("v.DisplayData", newData);
        
    },
    displayFilteredDataCalc : function(cmp,event,helper){
        var search = cmp.find("search-phrase");
        var value = search.get("v.value") ;
        var quotesList = cmp.get("v.input_K_Quotes_List");
        var newData = [];
        
        var i;
        for(i=0;i<quotesList.length;i++){
            if(quotesList[i].Quote_number__c.substring(0,value.length) == value){
                newData.push(quotesList[i]);
            }else if(quotesList[i].Quote_Reference_Number__c.substring(0,value.length) == value){
                newData.push(quotesList[i]);
            }
        }
        cmp.set("v.DisplayData", newData);
        
    }
    
})