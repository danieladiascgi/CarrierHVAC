({
    doInit: function(component, event, helper) {        
        component.set('v.columns', [
            {label: 'Quote Number', fieldName: 'Quote_number', type: 'text', sortable: true},
            {label: 'SKU', fieldName: 'Quote_number', type: 'text', sortable: true},
            {label: 'Sell Price', fieldName: 'Sell_Price', type: 'text', sortable: true},
            {label: 'Buy Price', fieldName: 'Buy_Price', type: 'Date', sortable: true},
            {label: 'Margin', fieldName: 'Margin', type: 'Date', sortable: true},
            {label: 'Distributor Gross', fieldName: 'Distributor_Gross', type: 'text', sortable: true}  
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
                helper.buildData(component, helper);
            }
        });
        var requestInitiatedTime = new Date().getTime();
        $A.enqueueAction(action);
    },
    
    updateSelectedText: function (component, event) {
        component.set("v.checkList", false);
        var list = event.getParam('selectedRows');
        component.set("v.selectedRows",list);
        debugger;        
        var quotesList = [];
        for(var i = 0; i< list.length ; i++){
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
        console.log(JSON.stringify(quotesList));
        component.set("v.output_K_Quotes_List",quotesList);        
        debugger;
    },
    
    addDealer: function (component, event) {
        component.set("v.showPriceCal",false);      
        var flow = component.find("flowData");
        flow.startFlow("Dealer_Add");        
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
    }, 
    
    priceStudy: function (component, event) { 
        var inputVariables = [{
            name : "quotesList", 
            type : "object", 
            value: component.get("v.output_K_Quotes_List")
        },
                              {
                                  name : "isFromCalc", 
                                  type : "boolean", 
                                  value: component.get("v.isFromCalc")
                              }
                             ]; 
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