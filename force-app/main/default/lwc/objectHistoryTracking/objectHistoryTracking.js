import { LightningElement, api, track, wire } from 'lwc';
import retriveObjectHistory from '@salesforce/apex/ObjectHistoryTracking.retriveObjectHistory';
import objectIconMethod from '@salesforce/apex/ObjectHistoryTracking.objectIconMethod';
import returnObjectLabelName from '@salesforce/apex/ObjectHistoryTracking.returnObjectLabelName';
import objectHistoryColumn from '@salesforce/apex/ObjectHistoryTracking.objectHistoryColumn';
import returnLengthObjectHistoryRecords from '@salesforce/apex/ObjectHistoryTracking.returnLengthObjectHistoryRecords';
import tabName from '@salesforce/label/c.tabName';
import userLabel from '@salesforce/label/c.UserLabel';
import ObjectHistoryEvent from '@salesforce/label/c.ObjectHistoryEvent'
import { subscribe } from 'lightning/empApi';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';


export default class ObjectHistoryTracking extends NavigationMixin(LightningElement) {
    isShow = true;
    isShowTable = true;
    @api channelName = ObjectHistoryEvent;
    totalCount;
    error;
    icon;
    @track columns;
    rowLimit = 4;
    rowUltraLimit = 20;
    rowOffSet = 0;
    objLabelName;
    totalRecord;
    recordIdOfCurrentPageRecord;
    objectName;
    @track records = [];
    subscription = {};


    //this method is used for currentPageReference for retrive recordId,objectName of current page  and get data
    @wire(CurrentPageReference)
    getPageReferenceParameters(CurrentPageReference) {        
        if (CurrentPageReference) {          
            if(CurrentPageReference.attributes.attributes){
                if (String(CurrentPageReference.attributes.attributes.isShow) == 'false') {
                    this.isShow = String(CurrentPageReference.attributes.attributes.isShow) == 'false' ? false : true;
                }
            }
            
            if (this.isShow) {
                this.objectName = CurrentPageReference.attributes.objectApiName;
                this.recordIdOfCurrentPageRecord = CurrentPageReference.attributes.recordId;
            } else {                
                this.objectName = CurrentPageReference.attributes.attributes.objectName;
                this.recordIdOfCurrentPageRecord = CurrentPageReference.attributes.attributes.recordId;
                this.columns = JSON.parse(CurrentPageReference.attributes.attributes.column);
                this.rowOffSet = 0;
            }
            if (this.objectName && this.recordIdOfCurrentPageRecord) {
                objectIconMethod({ objectName: this.objectName }).then(objectIcon => {
                    if (objectIcon) {
                        this.icon = objectIcon;
                    }
                }).catch(error => {
                    this.error = error;
                });
                returnObjectLabelName({ objApiName: this.objectName }).then(objectLabel => {
                    if (objectLabel) {
                        this.objLabelName = objectLabel;
                    }
                }).catch(error => {
                    this.error = error;
                });
                objectHistoryColumn().then(columnWithConfiguration => {
                    if (columnWithConfiguration) {
                        this.columns = columnWithConfiguration.sort((a, b) => a.sequence - b.sequence);                        
                    }
                }).catch(error => {
                    this.error = error;
                });
                this.retriveLengthHandler(this.objectName, this.recordIdOfCurrentPageRecord);
                this.retriveHistoryDataHandler();
            }
            this.handleSubscribe();

        }
    }


    //this method is used for handling event publish by trigger then load our component automatically refresh with new value in table.
    handleSubscribe() {
        const messageCallback = (response) => {
            this.retriveLengthHandler(this.objectName, this.recordIdOfCurrentPageRecord);
            var obj = JSON.parse(JSON.stringify(response));
            let objData = obj.data.payload;
            this.isShowTable = objData.isShowTable__c;
            this.retriveHistoryDataHandler();
        };
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }

    //this method is retrive all data from database
    retriveHistoryDataHandler() {
        if (!this.isShow) {
            if ((this.objectName != null && this.objectName != undefined) && (this.recordIdOfCurrentPageRecord != null && this.recordIdOfCurrentPageRecord != undefined)) {
                this.retriveHistoryData(this.recordIdOfCurrentPageRecord, this.objectName, this.rowUltraLimit);
            }
        } else {
            this.retriveHistoryData(this.recordIdOfCurrentPageRecord, this.objectName, this.rowLimit);
        }
    }

    // retrive  all history record from database behalf of recordId and objectApiName
    retriveHistoryData(recodId, objectApiName, rowLimit) {        
        return retriveObjectHistory({ limitsize: rowLimit, objName: objectApiName, recId: recodId, offset: this.rowOffSet }).then(result => {
            if (result) {
                this.records = [];                
                let updatedRecords = [...this.records, ...result];                
                updatedRecords.forEach(element => {
                    element[userLabel] = '/' + element.userId;
                })
                this.records = updatedRecords;
                if (this.records.length == 0) {
                    this.isShowTable = false;
                } else {
                    this.isShowTable = true;
                }
            }
        }).catch(error => {
            this.error = error;
            this.records = undefined;
        });
    }

    //this method call another lwc component
    handleViewAll() {
        var relatedListComponentDetails = {
            componentDef:"c:objectHistoryTracking",
            attributes:{
              recordId:this.recordIdOfCurrentPageRecord,
              isShow: false, 
              objectName: this.objectName,
              column: JSON.stringify(this.columns),           
            }
        }           
        var encodedRelatedListComponentDetails= btoa(JSON.stringify(relatedListComponentDetails));           
        this[NavigationMixin.Navigate]({
            type:'standard__webPage',
            attributes:{
              url:'/one/one.app#'+ encodedRelatedListComponentDetails

            }

        });    
    }

    //this method is used for retrive length of records of Object History
    retriveLengthHandler(obj, rec) {
        returnLengthObjectHistoryRecords({ objName: obj, recId: rec }).then(res => {
            this.totalRecord = res;
            if (this.totalRecord > 4) {
                this.totalCount = '4+';
            } else {
                this.totalCount = res;
            }
        }).catch(error => {
            this.error = error;
        });
    }

    loadMoreData(event) {
        const { target } = event;
        target.isLoading = true;
        this.rowOffSet = this.rowOffSet + this.rowUltraLimit;
        if (this.rowOffSet < this.totalRecord) {
            this.retriveHistoryDataHandler().then(() => {
            }).catch(error => {
                this.error = error;
            })
            target.isLoading = false;
        }
        target.isLoading = false;
    }

}