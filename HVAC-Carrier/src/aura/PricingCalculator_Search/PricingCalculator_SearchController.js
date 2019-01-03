({
    doInit: function(component, event, helper) {        
        component.set('v.columns', [
            {label: 'Quote Number', fieldName: 'Quote_number', type: 'text', sortable: true},
            {label: 'SKU', fieldName: 'Quote_number', type: 'text', sortable: true},
            {label: 'Sell Price', fieldName: 'Sell_Price', type: 'number', sortable: true},
            {label: 'Buy Price', fieldName: 'Buy_Price', type: 'number', sortable: true},
            {label: 'Margin', fieldName: 'Margin', type: 'number', sortable: true},
            {label: 'Distributor Gross', fieldName: 'Distributor_Gross', type: 'number', sortable: true}  
        ]);        
        var action = component.get("c.generateDealerAddData");
        action.setParams({
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
                helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
                console.log('Response Time: '+((new Date().getTime())-requestInitiatedTime));
                component.set("v.totalPages", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
                component.set("v.allData", response.getReturnValue());
                component.set("v.currentPageNumber",1);
                console.log(response.getReturnValue());
                helper.buildData(component, helper);
            }
        });
        var requestInitiatedTime = new Date().getTime();
        $A.enqueueAction(action);
        console.log(component.get("v.data"));
    },
    
    updateSelectedText: function (component, event) {
        component.set("v.checkList", false);
        var list = event.getParam('selectedRows');
        component.set("v.selectedRows",list);
            
        var quotesList = [];
        for(var i = 0; i< list.length ; i++){
            var detailtemp = {};
            detailtemp = { 'sobjectType': 'K_Quote__c',
                          'Quote_number__c':'', 
                          'Quote_Reference_Number__c':'',
                          'Quote_Description__c':'',
                          'Effective_Date_Text__c':'',
                          'Expired_Date_Text__c':''
                         };
            detailtemp.Quote_number__c = list[i].Quote_number;
            detailtemp.Quote_Reference_Number__c = list[i].Quote_Reference_Number;
            detailtemp.Quote_Description__c = list[i].Quote_Description;
            detailtemp.Effective_Date_Text__c = list[i].Effective_Date;
            detailtemp.Expired_Date_Text__c = list[i].Expired_Date;
            quotesList.push(detailtemp);
        }
       // console.log(JSON.stringify(quotesList));
        component.set("v.output_K_Quotes_List",quotesList);        
  
    },
    
    addDealer: function (component, event) {
        component.set("v.showPriceCal",false);
        var output = component.get("v.output_K_Quotes_List");
        component.set("v.sObjectCalculatorKQuote", output);
        var isFromCalc = component.get("v.isFromCalc");
        console.log(isFromCalc);
        var sObjectCalculatorKQuote = component.get("v.sObjectCalculatorKQuote");
        var flow = component.find("flowData");
        var inputVariables = [
            {
                name: 'sObjectCalculatorKQuote', type: 'SObject', value: sObjectCalculatorKQuote
            },
            { name : "varSource", type : "Boolean", value: isFromCalc}
            
        ];
        // pass variables
        flow.startFlow("Dealer_Add", inputVariables);        
    },
    
    updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    group: function (component, event) {
        var checkList = component.get("v.output_K_Quotes_List");
        var check1 = checkList.length;
        debugger;
        if(check1 === 0){
            component.set("v.checkList", true); 
        }else{
            component.set("v.isOpen", true);   
        }          
    },
    
    submit: function (component, event) {
        component.set("v.isOpen", false);
        component.set("v.showGroupCreation", true);
        component.set("v.showGroupButton", false); 
    },
    
    groupSubmit: function (component, event) {
        component.set("v.isOpen", false);
        component.set("v.showGroupCreation", true);
        component.set("v.showGroupButton", false); 
    },
    
    CreatePDF: function (component, event) {
    },
    
    closeModel: function (component, event) {
        component.set("v.isOpen", false);
    },
    
    Search: function (component, event) {
        if((component.get("v.searchSKU") && component.get("v.searchSellPrice")) == null){
            component.set("v.checkInput", true); 
        }else{  
            component.set("v.checkInput", false);
        } 
    }, 
    
    priceStudy: function (component, event) { 
        
    },
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    
});