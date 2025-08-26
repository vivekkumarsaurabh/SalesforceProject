import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import returnRecordTypeName from '@salesforce/apex/DecribeSObjectHandler.returnRecordTypeName';
import getLayoutName from '@salesforce/apex/DecribeSObjectHandler.getLayoutName';
import returnlayout from '@salesforce/apex/DecribeSObjectHandler.returnlayout';
import customObjectApiName from '@salesforce/label/c.sObject_Printable_View_Label';


export default class CustomPrintViewButton extends LightningElement {
    recordId;
    objectApiName = customObjectApiName;
    detailRecordType = [];
    layoutInformation = [];
    activeSections = [];
    // constructor(){
    //     super();
    //     // window.print();
    //     setTimeout(() => {
    //         window.print();            
    //     }, 100);
    // }

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
            returnRecordTypeName({ objectName: this.objectApiName }).then(result => {
                if (result) {
                    this.detailRecordType = result;
                    let recordTypeId = this.detailRecordType[0].value;
                    getLayoutName({ recordId: recordTypeId }).then(result => {
                        let layoutName;
                        result.forEach(ele => {
                            layoutName = ele.value;
                        })
                        let layoutN = this.objectApiName + '-' + layoutName;
                        // let layoutN = 'Account-Account Layout';               
                        returnlayout({ layoutName: layoutN }).then(result => {
                            result.forEach(element => {
                                this.activeSections.push(element.sectionName);
                            })
                            this.layoutInformation = result;
                        })
                    });
                }
            })
        }
    }
}