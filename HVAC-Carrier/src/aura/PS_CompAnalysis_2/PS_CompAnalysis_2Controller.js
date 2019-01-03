({
    addgroup : function(component, event, helper) {
        component.set("v.isOpen",true);
    },
    submit : function(component, event, helper) {
        var groupname=component.get("v.groupName");
        var list = component.get("v.groupList");
        var size = list.length;
        var detailtemp = {};
        detailtemp = {
                      'name' :'',
                      'K_Quote__c':[]
                     };

        detailtemp.name = groupname;
        list.push(detailtemp);
        component.set("v.isOpen",false);
        component.set("v.groupList",list);
        component.set("v.groupName","");
    },
    addmodel : function(component, event, helper){
        var quote = {};
        var list = component.get("v.groupList");
        var i = event.getSource().get("v.name");
        var kquote = list[i].K_Quote__c;
        var size = kquote.length;
        quote = {
            'carrierModel':'',
            'compModel':'',
            'compPrice':'',
            'desiredSell':'',
            'desiredCap':''
        };
        quote.carrierModel = "ca1";
        quote.compModel = "ca1";
        quote.compPrice = "100"; 
        quote.desiredSell = "95";
        quote.desiredCap = "40%";
        kquote[size]=quote;
        component.set("v.groupList", list);
    }
})