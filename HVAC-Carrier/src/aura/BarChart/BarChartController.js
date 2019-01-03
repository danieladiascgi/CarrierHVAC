({
    scriptsLoaded : function(component, event, helper) {
        var currentTime = new Date();
        
        var ctx = document.getElementById("bar-chart-grouped");
        component.chart = new Chart(ctx,{
            type: 'bar',
            data: {
                labels: [currentTime.getFullYear()-1,currentTime.getFullYear(),currentTime.getFullYear()+1],
                datasets: []
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        });
        
        
        if(component.get("v.FromSummary")==true){
            var a = component.get('c.chartChangeSummary');
            $A.enqueueAction(a);    
        }
        
        
        
    },
    
    
    chartChange: function(component, event, helper) {
        var message = event.getParam("BrandsSObjectCollection");
        component.set("v.BrandsSObjectCollection", message);
        
        try{
            var ChartData = component.chart.data;
            var datasets = ChartData.datasets;
            var test=datasets.length;
            ChartData.datasets.splice(0,datasets.length);
        }
        catch(err){
            
        }
        
        var BrandsData = component.get("v.BrandsSObjectCollection");
        var i;
        
        for(i=0;i<BrandsData.length;i++){
            var newDataset = {
                label: BrandsData[i].Brand__c ,
                backgroundColor: 'rgba(99, 255, 132, 0.2)',
                borderColor: 'rgba(99, 255, 132, 1)',
                borderWidth: 1,
                data: [BrandsData[i].Previous_Year__c, BrandsData[i].Current_Year__c, BrandsData[i].Future_Year__c],
            }
            try{
                ChartData.datasets.push(newDataset);
                component.chart.update();
            }
            catch(err){
                
            }
        }
        
        
        
    },
    
    
    chartChangeSummary: function(component, event, helper) {
        
        try{
            var ChartData = component.chart.data;
            var datasets = ChartData.datasets;
            var test=datasets.length;
            ChartData.datasets.splice(0,datasets.length);
        }
        catch(err){
            
        }
        
        var BrandsData = component.get("v.BrandsSObjectCollection");
        var i;
        
        for(i=0;i<BrandsData.length;i++){
            var newDataset = {
                label: BrandsData[i].Brand__c ,
                backgroundColor: 'rgba(99, 255, 132, 0.2)',
                borderColor: 'rgba(99, 255, 132, 1)',
                borderWidth: 1,
                data: [BrandsData[i].Previous_Year__c, BrandsData[i].Current_Year__c, BrandsData[i].Future_Year__c],
            }
            try{
                ChartData.datasets.push(newDataset);
                component.chart.update();
            }
            catch(err){
                
            }
        }
        
        
        
    }
    
})