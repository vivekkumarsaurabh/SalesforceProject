import { LightningElement, wire, track } from 'lwc';
import retriveAccData from '@salesforce/apex/DataTable.retriveAccData';
import ImageHot from '@salesforce/resourceUrl/Hot';
import ImageWarm from '@salesforce/resourceUrl/Warm';
import ImageCold from '@salesforce/resourceUrl/Cold';
import noImage from '@salesforce/resourceUrl/noImage';
const COLUMNS = [
    {label:'Account Name', fieldName:'accLink', type:'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
    {label:'Annual Revenue', fieldName:'AnnualRevenue', type:'currency', cellAttributes:{
        class:{fieldName:'amountColor'},
        iconName:{fieldName:'iconName'}, iconPosition:'right'
    }},
    {label:'Industry', fieldName:'Industry', type:'text', cellAttributes:{
        class:{fieldName:'industryColor'}
    }},
    {label:'Phone', fieldName:'Phone', type:'phone'},
    {label:'Rating', fieldName:'Rating', type:'text',  cellAttributes:{
        class:{fieldName:'ratingColor'}
    }},
    { label: 'Rating Image', fieldName: 'pictureurl', type:'image'
}
]

export default class DataTableLazyLoading extends LightningElement {
    records = [];
    columns = COLUMNS;
    rowLimit = 25;
    rowOffSet = 0;

    constructor(){
        super();
        const style = document.createElement('style');
        style.innerText = '.ratingWarm{color:orange;}';
        document.querySelector('head').appendChild(style);

    }
  
    connectedCallback() {
        this.loadData();
    }

    loadData(){
       return retriveAccData({ limitSize: this.rowLimit , offset : this.rowOffSet })
        .then(result => {
            let updatedRecords = [...this.records, ...result];
            this.records = updatedRecords;
            let data = JSON.parse(JSON.stringify(this.records));
            data.forEach(element => {
                element['accLink'] = '/'+ element.Id; 
               if(element.Rating == 'Hot'){
                element.ratingColor = 'slds-text-color_error';
                element.pictureurl = ImageHot;
               }else if(element.Rating == 'Cold'){                
                element.ratingColor = 'slds-text-color_success';
                element.pictureurl = ImageCold;
               }else if(element.Rating == 'Warm'){
                element.ratingColor = 'ratingWarm';
                element.pictureurl = ImageWarm;
               }else{
                element.pictureurl = noImage;
               }
            });
            this.records = data;
        })       
    }

    loadMoreData(event) {
        const currentRecord = this.records;
        const { target } = event;
        target.isLoading = true;
        this.rowOffSet = this.rowOffSet + this.rowLimit;
        this.loadData().then(()=> {
                target.isLoading = false;
            });   
    }


}