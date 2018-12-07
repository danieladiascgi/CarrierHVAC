({
    doInit: function(component, event, helper){
        var fromCalc = component.get("v.isFromCalc");
        if(fromCalc !=true){
            helper.loadData(component);
        }else {
            //something
        }
        var obj = component.get("v.input_K_Quotes_List");
        if(obj != undefined && obj != null){
        	//tests
        }
        else {
            component.set("v.input_K_Quotes_List", []);
        } 
        
        
        
    },
    
    onclick: function(cmp, evt, hlpr){
        var list = cmp.get("v.input_K_Quotes_List");
        var quotesList = [];
        for(var i = 0; i< list.length ; i++){
            if (list[i].isSelected == true){
                var space = list[i];
                var detailtemp = {};
                detailtemp = { 'sobjectType': 'K_Quote',
                              'Quote_number':'', 
                              'Quote_Reference_Number':'',
                              'Quote_Description':'',
                              'Effective_Date':'',
                              'Expired_Date':''
                              
                             }
                
                detailtemp.Quote_number = list[i].Quote_number;
                detailtemp.Quote_Reference_Number = list[i].Quote_Reference_Number;
                detailtemp.Quote_Description = list[i].Quote_Description;
                detailtemp.Effective_Date = list[i].Effective_Date;
                detailtemp.Expired_Date = list[i].Expired_Date;
                quotesList.push(detailtemp);
            }
        }
        
        cmp.set("v.output_K_Quotes_List",quotesList);
    }
    
})