({
    
    handleApplicationEvent : function(cmp, event , helper) {
        
        var msg = event.getParam("message");
        console.log(msg + 'MESSAGEM') ;
        if(msg == 'Previous Page'){
            var nextPage = parseInt(cmp.get("v.pageNumber")) -1;
        }
        else{
            var nextPage = parseInt(cmp.get("v.pageNumber")) + 1;
        }
        cmp.set("v.pageNumber", nextPage);
        if(nextPage==1){
            helper.step1(cmp, event);
        }
        if(nextPage == 2){
            helper.step2(cmp, event);
        }else
            if(nextPage == 3){
                helper.step3(cmp, event);
            }else
                if(nextPage == 4){
                    helper.step4(cmp, event);
                }
    } 
})