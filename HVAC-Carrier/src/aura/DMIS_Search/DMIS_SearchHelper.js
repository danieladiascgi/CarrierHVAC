({
	helperFun : function(component,event,secId) {
	  var acc = component.find(secId);
        	for(var cmp in acc) {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},
    closeModalHere:function(component){ 
        //alert('Inside Helper');
        //component.set("v.dispayModal",false);
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        /*var fadeEffect = setInterval(function () {
        if (!cmpTarget.style.opacity) {
            cmpTarget.style.opacity = 1;
        }
        if (cmpTarget.style.opacity < 0.1) {
            clearInterval(fadeEffect);
        } else {
            cmpTarget.style.opacity -= 0.1;
        }
    }, 2000);
        var fadeEffect1 = setInterval(function () {
        if (!cmpBack.style.opacity) {
            cmpBack.style.opacity = 1;
        }
        if (cmpBack.style.opacity < 0.1) {
            clearInterval(fadeEffect1);
        } else {
            cmpBack.style.opacity -= 0.1;
        }
    }, 200);*/
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    
})