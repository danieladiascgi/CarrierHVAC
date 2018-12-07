({
    scriptsLoaded : function(component, event, helper) {
        var rnc = component.get("v.rnc");
        console.log(rnc);
        var rncMF = component.get("v.rncMF");
        var aor = component.get("v.aor");
        var com = component.get("v.com"); 
        var dls = component.get("v.dls");
        var retail = component.get("v.retail");
        var ot = component.get("v.ot");
        var data = {
            labels: ["RNC Single Family", "RNC Multi Family", "AOR","Commercial","DLS","Retail","Other"], 
            datasets: [
                {
                    data: [rnc, rncMF, aor,com,dls,retail,ot],
                    backgroundColor: [
                        "rgba(255,203,75,.8)",
                        "rgba(143,134,132,.8)",
                        "rgba(153,119,61,.8)",
                        "rgba(143,119,4,.8)",
                        "rgba(153,119,200,.8)",
                        "rgba(153,200,61,.8)",
                        "rgba(200,119,61,.8)"
                    ],
                    hoverBackgroundColor: [
                        "rgba(255,203,75,1)",
                        "rgba(143,134,132,1)",
                        "rgba(153,119,61,1)",
                        "rgba(143,119,4,1)",
                        "rgba(153,119,200,1)",
                        "rgba(153,200,61,1)",
                        "rgba(200,119,61,1)"
                    ]                
                }
            ]
        };
        
        var ctx = component.find("chart").getElement();
        component.chart = new Chart(ctx,{
            type: 'pie',
            data: data,
            options: {
                responsive: true,
                maintainAspectRatio: false
/*                onClick: function(event) {
                    var elements = component.chart.getElementAtEvent(event);
                    if (elements.length === 1) {
                        var chartEvent = $A.get("e.c:ChartEvent");
                        chartEvent.setParams({
                            data: {
                                year: component.get("v.year"),
                                country: component.get("v.country"),
                                medalType: component.chart.data.labels[elements[0]._index]
                            }
                        });
                        chartEvent.fire();
                    }
                }*/
            }
            
        });
        
    },
    
   /* chartChange: function(component, event, helper) {
        var filters = event.getParam("data");
        component.set("v.year", filters.year);
        component.set("v.country", filters.country);
        var years = window.olympicDataService.getData();
        years.forEach(function(year) {
            if (year.year == filters.year) {
                year.countries.forEach(function(country) {
                    if (country.country == filters.country) {
                        component.set("v.title", year.venue + ' ' + year.year + ", " + filters.country + " (" + (country.gold + country.silver + country.bronze) + " medals)");
                        var medals = [country.gold, country.silver, country.bronze];
                        component.chart.data.datasets[0].data = medals;
                        component.chart.update();
                        return;
                    }
                });
            }
        });
    }*/
    
})