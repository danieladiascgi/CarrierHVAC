({
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
    },
    
    doInit : function(component, event, helper) {
        
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert('state'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // alert('storeResponse'+JSON.stringify(storeResponse));
                if(storeResponse!=null && storeResponse!='undefined' && 
                   storeResponse!=undefined && storeResponse.alias!='undefined' &&
                   (storeResponse.Alias=='guest' ))
                { 
                    //  alert('inside if');
                    var getUrlParameter = function getUrlParameter(sParam) {
                        
                        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                            sURLVariables = sPageURL.split('&'),
                            sParameterName,
                            i;
                        
                        for (i = 0; i < sURLVariables.length; i++) {
                            sParameterName = sURLVariables[i].split('=');
                            // alert('Params**'+sParameterName);
                            
                            if (sParameterName[0] === sParam) {
                                return sParameterName[1] === undefined ? true : sParameterName[1];
                            }
                        }
                    };
                    var payload = getUrlParameter('value');
                    // alert('payload'+payload);
                    if((payload!=null && payload!='undefined' && payload!=undefined && payload.length>0) && (sessionStorage.getItem('payload')=='undefined' || sessionStorage.getItem('payload')==undefined || sessionStorage.getItem('payload')==null || sessionStorage.getItem('payload')=='')){
                        sessionStorage.setItem('payload', payload);
                    }
                    if(payload==null && sessionStorage.getItem('payload')!='undefined' && sessionStorage.getItem('payload')!=null && sessionStorage.getItem('payload')!=undefined && sessionStorage.getItem('payload').length>0){
                        payload = sessionStorage.getItem('payload');
                    }
                    if(payload!=null){
                        var action2  = component.get("c.getparsePayloadAndGetValues");
                        action2.setParams({"payloadStr" : payload});
                        action2.setCallback(this,function(response)
                                            {
                                                component.set("v.value",response.getReturnValue());
                                                var state=response.getState();
                                                var result=response.getReturnValue();
                                                // alert(response);
                                                if(state=="SUCCESS"){
                                                    // component.set("v.value",result);
                                                    var action3 = component.get("c.getC10ParentVal");
                                                    //alert(JSON.stringify(component.get("c.getC10ParentVal")));
                                                    action3.setParams({
                                                        "recId" : component.get("v.recordId"),
                                                        "value" : component.get("v.value")
                                                    });
                                                    //alert('Value'+JSON.stringify(component.get("v.value")));
                                                    action3.setCallback(this, function(a) {
                                                        if (a.getState() === "SUCCESS") {
                                                            component.set("v.SearchKeyWord1", a.getReturnValue()); 
                                                            //alert(JSON.stringify(a.getReturnValue()));
                                                            component.set("v.value", a.getReturnValue());
                                                            
                                                        }
                                                        else{
                                                            //alert('error');
                                                            component.set("v.SearchKeyWord1", '');
                                                        }
                                                    });
                                                    
                                                    $A.enqueueAction(action3);
                                                    
                                                }
                                            }); 
                        $A.enqueueAction(action2);
                    }
                    else
                    {
                        // alert('Unauthenticated User');
                        
                    }
                }
                else
                {
                    //  alert('inside else');
                }
            }
            
        }); 
        $A.enqueueAction(action); 
        // alert(payload);
        
        component.set("v.populatedCustNo","");
        var button = component.find("createCaseBtn");
        $A.util.addClass(button.getElement(), 'invisible');
        /*var action3 = component.get("c.getC10ParentVal");
        alert(JSON.stringify(component.get("c.getC10ParentVal")));
        action3.setParams({
            "recId" : component.get("v.recordId"),
            "value" : component.get("v.value")
        });
        
        action3.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.SearchKeyWord1", a.getReturnValue()); 
                alert(JSON.stringify(a.getReturnValue()));
                component.set("v.value", a.getReturnValue());
                
            }
            else{
                //alert('error');
                component.set("v.SearchKeyWord1", '');
            }
        });
        
        $A.enqueueAction(action3);*/
    },
    
    showToolTip: function(component, event, helper){
        component.set("v.dispayToolTip",true);  
    },
    
    hideToolTip: function(component, event, helper){
        component.set("v.dispayToolTip",false);  
    },
    
    populateCustPO : function(component, event, helper) {
        //alert('hi');
        
        //var poNum = component.find('cstPO').get("v.value");
        var poNum = event.getSource().get("v.value");
        component.set("v.populatedCustNo", poNum);
        component.set("v.secondTableTrue",false);
        
    },
    populateCustPOOnRowClick : function(component, event, helper) {
        //alert('hi');
        
        //var poNum = component.find('cstPO').get("v.value");
        var poNum = event.getSource().get("v.id");
        component.set("v.populatedCustNo", poNum);
        component.set("v.secondTableTrue",false);
        
    },
    popupDisp : function(component, event, helper) {
        //alert('hi');
        
        var clickedPartId = event.getSource().get("v.value");
        component.set("v.clickedPartId",clickedPartId);
        var searchResults = component.get("v.lstWrapperMain");
        //alert('searchResults..'+searchResults);
        //alert('value'+clickedPartId);
        if(searchResults.length>0){
            for (var i = 0; i < searchResults.length; i++) { 
                var searchRec = searchResults[i];
                if(searchRec.partId == clickedPartId){
                    var desc = searchRec.description;
                    component.set("v.clickedDescription",desc);
                }
            }
        }
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        return false;
    },
    
    callSearch : function(component, event, helper) {
        
        var checkVar = component.get("v.selectedAccRecord");
        if(checkVar!='' && checkVar!=null && checkVar != undefined){
            // var custnum = component.get("v.selectedAccRecord.CCC_C10_Parent__c");
            var custnum = component.get("v.customer");
        }
        else{
            var custnum = component.find("custno").get("v.value");  
        }
        var custByPO = component.find("custByPO").get("v.value");
        var partNo = component.get("v.selectedRecord.compressedId");
        //alert('custnum..'+custnum);
        //alert('partNo..'+partNo);
        var salesOrderNo = component.find("salesOrderNo").get("v.value");
        
        try {
            if(custnum==undefined || custnum=='undefined' || typeof(custnum)=='undefined' || custnum==''){
                throw new Error("Customer No is Mandatory. Please contact your Administrator or start a Live chat with our Agent!");
            }
            if(custnum!='' && ((custByPO==undefined || custByPO=='') /*&& (partNo==undefined || partNo=='')*/ && (salesOrderNo==undefined || salesOrderNo==''))){
                throw new Error("Either of Customer PO/Part NO/Sales Order No is Mandatory.");
            }
            component.set("v.custnumMandat", false);
            component.set("v.atLeastOneMandat", false);
            
            component.set("v.spinnerShow",true);    
            if(custnum!='' && custByPO!=''){
                //alert('custByPO1'+custByPO);
                var action = component.get("c.searchC10records");
                action.setParams({"custnum":custnum,"custByPO":custByPO,"salesOrderNo":null});
            }
            /* if(custnum!='' && partNo!='' && partNo != undefined && partNo != null){
            //alert('partNo.....'+partNo);
            //alert('custByPO2'+custByPO);
            //var action = component.get("c.searchPartsData");
            action.setParams({"custnum":custnum,"partNo":partNo});
        }*/
            if(custnum!='' && salesOrderNo!=''){
                //alert('salesOrderNo....'+salesOrderNo);
                var action = component.get("c.searchC10records");
                action.setParams({"custnum":custnum,"custByPO":null,"salesOrderNo":salesOrderNo});
            }  
            
            action.setCallback(this, function(actionResult) {
                var state = actionResult.getState();
                if(state === "SUCCESS"){
                    
                    component.set("v.spinnerShow",false);
                    
                    
                    
                    if((custnum!='' && custByPO!='')||(custnum!='' && salesOrderNo!='')){
                        component.set("v.lstWrapperMain", actionResult.getReturnValue()); 
                        component.set("v.lstWrapper", actionResult.getReturnValue()); 
                        component.set("v.secondTableTrue",false);
                        component.set("v.firstTableTrue",true);
                        
                    }
                    if(custnum!='' && partNo!='' && partNo != undefined && partNo != null){
                        component.set("v.lstWrapperMain", actionResult.getReturnValue()); 
                        component.set("v.lstWrapper", actionResult.getReturnValue()); 
                        component.set("v.firstTableTrue",true);
                        component.set("v.secondTableTrue",false);   
                        var button = component.find("createCaseBtn");
                        $A.util.removeClass(button.getElement(), 'invisible');
                        
                    }
                    
                    setTimeout(function(){ 
                        $('#sampleTable').DataTable().destroy();
                        $('#sampleTable').DataTable();
                        // add lightning class to search filter field with some bottom margin..  
                        $('div.dataTables_filter input').addClass('slds-input');
                        $('div.dataTables_filter input').css("marginBottom", "10px");
                    }, 1);
                    
                    // alert('thelist..'+JSON.stringify(component.get("v.lstWrapperMain")));
                    //$('#sampleTable').DataTable().destroy();
                    /*setTimeout(function() {
                 $('#sampleTable').DataTable({
               "ordering": true,
            
            "preDrawCallback": function( settings ) {
           
                $('.odd').remove();
                $('.even').remove();
            }
           });
          }, 5000);*/
                    
                }
                else{
                    component.set("v.spinnerShow",false);
                    var ary = new Array();
                    component.set("v.lstWrapperMain", ary);
                    component.set("v.lstWrapper", ary);
                    //alert('No records to show');
                    component.set("v.noRecsErrMsg",true);
                }
            });	
            $A.enqueueAction(action);
        }catch (e) {
            /*$A.createComponents([
                ["ui:message",{
                    "title" : "Error",
                    "severity" : "error",
                }],
                ["ui:outputText",{
                    "value" : e.message
                }]
                ],
                function(components, status, errorMessage){
                    if (status === "SUCCESS") {
                        var message = components[0];
                        var outputText = components[1];
                        // set the body of the ui:message to be the ui:outputText
                        message.set("v.body", outputText);
                        var div1 = component.find("div1");
                        // Replace div body with the dynamic component
                        div1.set("v.body", message);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
                }
            );*/
            if(custnum==undefined || custnum=='undefined' || typeof(custnum)=='undefined' || custnum==''){
                component.set("v.custnumMandat", true);
            }else if(custnum!='' && ((custByPO==undefined || custByPO=='') && (partNo==undefined || partNo=='') && (salesOrderNo==undefined || salesOrderNo==''))){
                component.set("v.atLeastOneMandat", true);
            }
            
        }
    },
    
    callSearch1 : function(component, event, helper) {
        
        var Startdate = component.get("v.sd");
        var Enddate = component.get("v.ed");
        //alert(Startdate);
        var searchResutsListTemp = new Array();
        var searchResultsList = component.get("v.lstWrapperMain");
        // alert('searchResults..'+searchResultsList);
        if(searchResultsList.length>0)
        {
            // alert('inside if');
            if(Startdate != '' && Startdate != null && Startdate != undefined && Enddate !='' && Enddate != null && Enddate != undefined  )
            {
                //alert('inside if2');
                for (var i = 0; i < searchResultsList.length; i++)
                { 
                    var searchRecList = searchResultsList[i];
                    if(searchRecList.promiseShipDate > Startdate && searchRecList.promiseShipDate < Enddate )
                    {
                        searchResutsListTemp.push(searchRecList);
                    }
                    
                }
                
                //alert('Date'+JSON.stringify(searchResutsListTemp));
                component.set("v.firstTableTrue",false);
                component.set("v.thirdTableTrue",true);
                
                component.set("v.lstWrapperList", searchResutsListTemp);
            }
            else if( Enddate !='' && Enddate != null && Enddate != undefined  )
            {
                alert('inside if3');
                for (var i = 0; i < searchResultsList.length; i++)
                { 
                    var searchRecList = searchResultsList[i];
                    if( searchRecList.promiseShipDate < Enddate )
                    {
                        searchResutsListTemp.push(searchRecList);
                    }
                    
                }
                
                //alert('Date'+JSON.stringify(searchResutsListTemp));
                component.set("v.firstTableTrue",false);
                component.set("v.thirdTableTrue",true);
                
                component.set("v.lstWrapperList", searchResutsListTemp);
            }
                else if( Startdate != '' && Startdate != null && Startdate != undefined  )
                {
                    alert('inside if4');
                    for (var i = 0; i < searchResultsList.length; i++)
                    { 
                        var searchRecList = searchResultsList[i];
                        if( searchRecList.promiseShipDate > Startdate )
                        {
                            searchResutsListTemp.push(searchRecList);
                        }
                        
                    }
                    
                    // alert('Date'+JSON.stringify(searchResutsListTemp));
                    component.set("v.firstTableTrue",false);
                    component.set("v.thirdTableTrue",true);
                    
                    component.set("v.lstWrapperList", searchResutsListTemp);
                }
                    else
                    {
                        component.set("v.lstWrapperList", searchResutsList);     
                    }
            setTimeout(function(){ 
                $('#sampleTable').DataTable().destroy();
                $('#sampleTable').DataTable();
                // add lightning class to search filter field with some bottom margin..  
                $('div.dataTables_filter input').addClass('slds-input');
                $('div.dataTables_filter input').css("marginBottom", "10px");
            }, 1);
        }
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.  
        //alert(getInputkeyWord); 
        if( getInputkeyWord.length > 3){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
    
    keyPressController1 : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord1");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.  
        //alert(getInputkeyWord); 
        if( getInputkeyWord.length > 3){
            var forOpen = component.find("searchRes1");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchAccHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfAccountRecords", null ); 
            var forclose = component.find("searchRes1");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
    
    onFocusOut : function(component, event, helper) {
        var forclose = component.find("searchRes1");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord" , null);
        
    },
    
    clear1 :function(component,event,heplper){
        
        var pillTarget = component.find("lookup-pill1");
        var lookUpTarget = component.find("lookupField1"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        
        component.set("v.SearchKeyWord1",null);
        component.set("v.listOfAccountRecords", null );
        component.set("v.selectedAccRecord" , null);
    },
    
    clearWhenUserClicksOutside :function(component,event,heplper){
        
        var pillTarget = component.find("lookup-pill1");
        var lookUpTarget = component.find("lookupField1"); 
        var searchResutsCustNum = component.find("searchRes1");
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        /*$A.util.addClass(lookUpTarget, 'slds-hide');
         $A.util.removeClass(lookUpTarget, 'slds-show');*/
        $A.util.addClass(searchResutsCustNum, 'slds-is-close');
        $A.util.removeClass(searchResutsCustNum, 'slds-is-open');
        
        
        //component.set("v.SearchKeyWord1",null);
        component.set("v.listOfAccountRecords", null );
        component.set("v.selectedAccRecord" , null);
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        
        // get the selected Account record from the COMPONETN event 
        component.set("v.spinnerShow",true);	 
        var selectedAccountGetFromEvent = event.getParam("partnoByEvent");
        //var CaseNum = selectedAccountGetFromEvent.CaseNumber;
        var partId = selectedAccountGetFromEvent.compressedId;
        console.log('selectedAccountGetFromEvent'+ selectedAccountGetFromEvent.Id);
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        component.set("v.SearchText",partId);
        //alert(CaseId);
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');
        //this.onShowPartRecord(component, event, helper);
        component.set("v.secondTableTrue",false);
        var partNo = component.get("v.selectedRecord.compressedId");
        var checkVar = component.get("v.selectedAccRecord");
        if(checkVar!='' && checkVar!=null && checkVar != undefined){
            var custnum = component.get("v.selectedAccRecord.CCC_C10_Parent__c");
        }
        else{
            var custnum = component.find("custno").get("v.value");  
        }
        //alert('custnum'+custnum);
        helper.showPartRecord(component,event,partNo,custnum);  
        
    },
    
    handleComponentEvent1 : function(component, event, helper) {
        
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccGetFromEvent = event.getParam("custnoByEvent");
        //var CaseNum = selectedAccountGetFromEvent.CaseNumber;
        var partId = selectedAccGetFromEvent.CCC_C10_Parent__c;
        //console.log('selectedAccountGetFromEvent'+ selectedAccountGetFromEvent.Id);
        component.set("v.selectedAccRecord" , selectedAccGetFromEvent); 
        component.set("v.SearchText",partId);
        // alert(JSON.stringify(selectedAccGetFromEvent));
        var forclose = component.find("lookup-pill1");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        
        var forclose = component.find("searchRes1");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField1");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
    
    onValueSelect : function(component, event, helper) {
        //   var selectedCaseGetFromEvent = event.getParam("caseByEvent");
        //component.set("v.spinnerShow",true);    
        var selected = component.get("v.selectedRecord"); 
        component.set("v.secondTableTrue",false);
        // alert('selected'+selected);
        component.set("v.SearchText",selected);
        
        //component.set("v.secondTableTrue",true);    
        
        
    },
    
    
    onShowPartRecord : function(component, event, helper){
        var partNo = component.get("v.selectedRecord.compressedId");
        var checkVar = component.get("v.selectedAccRecord");
        if(checkVar!='' && checkVar!=null && checkVar != undefined){
            var custnum = component.get("v.selectedAccRecord.CCC_C10_Parent__c");
        }
        else{
            
            var custnum = component.find("custno").get("v.value");  
        }
        
        //alert('custnum'+custnum);  
        
        helper.showPartRecord(component,event,partNo,custnum);
        
        
        
        
    },
    
    onValueSelect1 : function(component, event, helper) {
        
        //   var selectedCaseGetFromEvent = event.getParam("caseByEvent");
        var selected = component.get("v.selectedAccRecord");
        // alert('selected'+selected);
        component.set("v.SearchText",selected);
        
        
    },
    
    checkForMatchingRecords : function(component, event, helper) {
        var searchStr = component.find("Search").get("v.value");
        var searchResutsTemp = new Array();
        var searchResults = component.get("v.lstWrapperMain");
        //alert('searchResults..'+searchResults);
        if(searchResults.length>0){
            if(searchStr != '' && searchStr != null && searchStr != undefined){
                for (var i = 0; i < searchResults.length; i++) { 
                    //console.log('Current Index:'+i);
                    var searchRec = searchResults[i];
                    if(searchRec.description!=undefined && searchRec.description.toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.lineId!=undefined && searchRec.lineId.toString().toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.lineType!=undefined && searchRec.lineType.toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.priorityCode!=undefined && searchRec.priorityCode.toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.partId!=undefined && searchRec.partId.toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.status!=undefined && searchRec.status.toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.carrier!=undefined && searchRec.carrier.toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.quantity!=undefined && searchRec.quantity.toString().toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.unitPrice!=undefined && searchRec.unitPrice.toString().toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.extendedPrice!=undefined && searchRec.extendedPrice.toString().toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.pickListId!=undefined && searchRec.pickListId.toString().toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.promiseShipDate!=undefined && searchRec.promiseShipDate.toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.invoiceId!=undefined && searchRec.invoiceId.toString().toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }else if(searchRec.trackingId!=undefined && searchRec.trackingId.toLowerCase().indexOf(searchStr.toLowerCase())!=-1){
                        //console.log(searchRec.description.toLowerCase());                
                        searchResutsTemp.push(searchRec);                
                    }	            
                }          
                component.set("v.lstWrapper", searchResutsTemp);            
            }
            else{
                component.set("v.lstWrapper", searchResults);     
            }
        }              
    },
    closeModal:function(component,event,helper){ 
        //component.set("v.dispayModal",false);
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    contactCustService : function(component, event, helper) {
        alert('contactCustService');
        
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //  alert('storeResponse'+JSON.Stringify(response.getReturnValue()));
                if(storeResponse!=null && storeResponse!='undefined' && storeResponse!=undefined && storeResponse.alias!='undefined' && (storeResponse.Alias=='guest' || storeResponse.Alias=='tjamb')){
                    //  helper.redirectToCCS(component);   
                    var event = $A.get("e.c:NavigateToCCS");
                    event.setParams({ "view": "This is Testing"});
                    //alert('Firing Evt:'+event);
                    event.fire();
                }else{
                    alert('Error');        
                }
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    NavigateToCCS : function(component,event,helper) {
        //alert('Navigate to CCS');
        /* var destination = "c:RC_CCS";
       
        $A.createComponent(destination, { }, 
                           function(view) {
                               var content = component.find("content");
                               //alert('#content:'+content);
                               content.set("v.body", view);
                           });*/
        var getUrlParameter = function getUrlParameter(sParam) {
            
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;
            
            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');
                // alert('Params**'+sParameterName);
                
                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
        };
        var payload = getUrlParameter('value');
        if(payload==null && sessionStorage.getItem('payload')!='undefined' && sessionStorage.getItem('payload')!=null && sessionStorage.getItem('payload')!=undefined && sessionStorage.getItem('payload').length>0){
            payload = sessionStorage.getItem('payload');
        }
        var actionParsePayload  = component.get("c.getparsePayloadAndGetValues");
        
        actionParsePayload.setParams({"payloadStr" : payload});
        actionParsePayload.setCallback(this,function(response){
            var state=response.getState();
            if(state=="SUCCESS"){
                var customPONO = '';
                // var partNO= '';
                var resultArr = component.get("v.lstWrapper");
                // alert('resultArr'+component.get("v.lstWrapper"));
                if(resultArr!=null && resultArr!='undefined' && resultArr.length>0){
                    var firstOrder = resultArr[0];
                    // alert('firstOrder'+firstOrder);
                    customPONO = firstOrder.customPoNo;
                    
                    
                }
                var RowItemList = []; 
                RowItemList.push({
                    'sobjectType': 'WrapperCls__c',
                    'Customer_PO__c': customPONO,
                    'Customer_PO_check__c':false
                    
                });
                
                
                //Console.log('#Response:'+response.getReturnValue());
                var email = response.getReturnValue();
                var purp  ='Technical/Part Info';
                var destination = "c:RC_CCS";
                //alert(destination);
                $A.createComponent(destination, { "email":email, "custPO":RowItemList}, 
                                   function(view) {
                                       var content = component.find("content");
                                       // alert('#content:'+content);
                                       content.set("v.body", view);
                                   });
            }
        });
        $A.enqueueAction(actionParsePayload);
    }
})