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
                debugger;
                helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
            }
        });
        $A.enqueueAction(action);
    },
    
    
    updateSelectedText: function (component, event) {
        var list = event.getParam('selectedRows');
        component.set("v.selectedRows", list);
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
        component.set("v.selectedRowsToDealer",quotesList);        
        debugger;
    },
    
    Search: function (component, event) {
        
    },
    
    AddDealer: function (component, event) {        
        var quotesList = [];
        quotesList = component.get("v.selectedRows");
        debugger;
    },
    
    group: function (component, event) {
        component.set("v.isOpen", true);
    }, 
    closeModel: function (component, event) {
        component.set("v.isOpen", false);
    }, 
    submit: function (component, event) {
        component.set("v.isOpen", false);
        var quotesList = component.get("v.selectedRowsToDealer");
        if(quotesList==null){
            component.set("v.showGroupCreation", false);
            component.set("v.showGroupButton", true);
        }else{
            component.set("v.showGroupCreation", true);
            component.set("v.showGroupButton", false);
        }
        
    }, 
    CreatePDF: function (component, event) {
    }, 
    
    updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    }    
});