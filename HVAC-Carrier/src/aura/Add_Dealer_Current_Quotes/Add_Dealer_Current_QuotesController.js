({
    doInit : function(cmp, event, helper) {
        var ListTotal = cmp.get("v.InputList");
        //Only shows 4 quotes by default
        if(ListTotal.length != 0){
            var Displayed = [];
            for(var i = 0; i<3; i++){
                Displayed[i] = ListTotal[i];
            }
            cmp.set("v.DisplayList", Displayed);
        }
    },
    //Only shows 4 quotes by default if we want to see more the button  disappears
    showMore : function(cmp, event, helper){
        var ListTotal = cmp.get("v.InputList");
        cmp.set("v.DisplayList", ListTotal);
        if(ListTotal.length >= 4){
            var cmpTarget = cmp.find('changeIt');
            $A.util.addClass(cmpTarget, 'changeMe');
        }
    }
})