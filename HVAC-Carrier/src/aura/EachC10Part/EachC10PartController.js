({
	initiateChat : function(component, event, helper) {
		var caseNum = '';
        var purpose = 'Order Status and Maintenance';
        var subPurpose = 'Checking Status';
        var partNumber = '';
        var orderNumber = '';
        var eachWrap = component.get("v.wrap");
        if(eachWrap!=null && eachWrap!='undefined' && eachWrap.partId!=null && eachWrap.partId!='undefined' && eachWrap.partId.length>0){
            partNumber = eachWrap.partId;
        }
        if(eachWrap!=null && eachWrap!='undefined' && eachWrap.salesOrderNo!=null && eachWrap.salesOrderNo!='undefined' && eachWrap.salesOrderNo.length>0){
            orderNumber = eachWrap.salesOrderNo;
        }
        /*var nameVal = event.getSource().get("v.name");
        if(nameVal.indexOf(';')!=-1){
            var nameArr = nameVal.split(';');
            caseNum = nameArr[0];
            purpose = nameArr[1];
            subPurpose = nameArr[2];
            
        }*/
        
        var urlVal = 'https://utc-ccs-customersgateway.secure.force.com/LiveChatButton?value='+sessionStorage.getItem('payload')+'&purpose='+purpose+'&subPurpose='+subPurpose+'&partNumber='+partNumber+'&orderNumber='+orderNumber;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urlVal 
        });
        urlEvent.fire();
	}
})