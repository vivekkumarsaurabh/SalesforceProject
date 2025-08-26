import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import ChartJS from '@salesforce/resourceUrl/ChartJS';
import getReports from '@salesforce/apex/DynamicChart.getReports';

export default class DashBoardWithMultipleChart extends LightningElement {

reportsDataMap = [];
error;

connectedCallback(){
    this.getAllreportData();
}

getAllreportData(){
    getReports().then(reportData => {
        //console.log('json-- ok-->'+JSON.stringify(this.reportsDataMap));

        if(reportData){
          this.reportsDataMap = reportData;  
          console.log('json---->'+JSON.stringify(this.reportsDataMap));
         this.reportsDataMap.forEach(ele =>{
           // const label = getLabels(ele);
           // console.log('label------>',JSON.stringify(label));
            console.log('data---->',JSON.stringify(ele));         
            
        })
          
        }

      
    }).catch(error => {
        this.error = error;
    });
}

getLabels(data) {
    return data.map(item => {
        return Object.entries(item).map(([key, value]) => `${key}: ${value}`);
    });
}


}