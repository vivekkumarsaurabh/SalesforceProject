import { LightningElement, api, track, wire } from 'lwc';
import retriveSobjectName from '@salesforce/apex/InlineEditing.retriveSobjectName';
import getsObjectApiName from '@salesforce/apex/InlineEditing.getsObjectApiName';
import returnObjectLabelName from '@salesforce/apex/InlineEditing.returnObjectLabelName';
import getAllChildRecord from '@salesforce/apex/InlineEditing.getAllChildRecord';
import getColumns from '@salesforce/apex/InlineEditing.getColumns';
import getData from '@salesforce/apex/InlineEditing.getData';
import deletesObjectRecord from '@salesforce/apex/InlineEditing.deletesObjectRecord';
import returnfields from '@salesforce/apex/InlineEditing.returnfields';
import updatesObjectRecord from '@salesforce/apex/InlineEditing.updatesObjectRecord';
import getAllRelatedObject from '@salesforce/apex/InlineEditing.getAllRelatedObject';
import getSObjectName from '@salesforce/apex/InlineEditing.getSObjectName';
import objectIconMethod from '@salesforce/apex/InlineEditing.objectIconMethod';
import gettingFilter from '@salesforce/apex/InlineEditing.gettingFilter';
import getRequiredFields from '@salesforce/apex/InlineEditing.getRequiredFields';
// import getAllFields from '@salesforce/apex/InlineEditing.getAllFields';
// import getsObjectChilds from '@salesforce/apex/InlineEditing.getsObjectChilds';
// import returnRecords from '@salesforce/apex/InlineEditing.returnRecords';
// import returnRecordName from '@salesforce/apex/InlineEditing.returnRecordName';
// import filterByDate from '@salesforce/apex/InlineEditing.filterByDate';
// import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
// import ACCOUNT_OBJECT from '@salesforce/schema/Account';
// import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
// import { CurrentPageReference } from 'lightning/navigation';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InlineEditing extends NavigationMixin(LightningElement) {

    // isRecord = false;   
    // isFilter = false;
    // isChildObject = false;
    // isFilterDisabled = true;
    // isChildTable = false;
    // isDropDown = false;
    // isLastModify = false;
    // isCreatedDate = false;
    // isASC = false;
    // isDESC = false;
    // isConfigureChildObject = false;
    // isNotAscDesc = false;    
    // childObjectSelected;  
    // sChildObjectId;
    // parentRecordName;
    // childRecordName;
    // ascDescVal;
    // dateValue;
    // filterVal = [];   
    // filedFilter = [];
    // childObjectList = [];
    // childColumnList = [];
    // childrecords = [];
    // parentRecordList = [];
    // filterData = [];
    //picklistValues = [];    
    //filterValues = [{ label: 'Created Date', value: 'CreatedDate' }, { label: 'LastModifiedById', value: 'LastModifiedById' }];
    // ascDescValues = [{ label: 'Acending', value: 'ASC' }, { label: 'Decending', value: 'DESC' }];

    isChildRecord = false;
    isLoading = false;
    illustractionTrue = false;
    isIcon = false;
    isDeleteModal = false;
    isCreateModal = false;
    isBtnDisabled = true;
    @track icon;
    @track recordCount;
    @track sObjectLabelName;
    filterFieldName;
    deletesObjectId;
    currentRecordId;
    selectedSObjectId;
   @track sObjectAPIName = 'Account';
    objectInfo;
    records = null;
    @track relatedDataTable = [];
    //defaultOptions = [];
    // fields = [];
    sObjectList = [];
    draftValuesChildRecord = [];
    picklistDetails = [];
    draftValues = [];
    @track columns;
    @track error;
    @track sortBy;
    @track sortDirection;


    //constructor
    constructor() {
        super();
        const style = document.createElement('style');
        style.innerText = `.slds-scrollable_x{          
           overflow: hidden; 
           overflow-x:none;
        }
           .slds-listbox.slds-listbox_vertical.slds-dropdown.slds-dropdown_fluid.slds-dropdown_left {
            max-height: 130px !important;
        }
        .slds-form-element__label{display:none;}`;
        document.querySelector('head').appendChild(style);
    }

    // @wire(CurrentPageReference)
    // getPageReferenceParameters(CurrentPageReference) {
    //     if (CurrentPageReference) {
    //         this.inlineObjectName = CurrentPageReference.attributes.objectApiName;
    //     }
    // }

    // @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    // objectInfo;

    // @wire(getPicklistValues, {
    //     fieldApiName: INDUSTRY_FIELD,
    //     recordTypeId: '$objectInfo.data.defaultRecordTypeId'
    // })
    // wiredPicklistValues({ data, error }) {
    //     if (data) {
    //         // Map the picklist values to the component's picklistValues array
    //         this.picklistValues = data.values;
    //         console.log('picklistValues---->',JSON.stringify(this.picklistValues));

    //     } else if (error) {
    //         this.error = error;
    //     }
    // }

    @wire(getObjectInfo, { objectApiName: '$sObjectAPIName' })
    objectInfo;

    // Fetch the Picklist Values for a specific field (e.g., "Industry" picklist in Account)
    @wire(getPicklistValuesByRecordType, {
        objectApiName: '$sObjectAPIName',
        recordTypeId: '$objectInfo.data.defaultRecordTypeId'
    })
    picklistValues({ data, error }) {
        if (data) {
            this.picklistDetails = data.picklistFieldValues;
            // console.log('fields data----->', JSON.stringify(data));

            //     data.picklistFieldValues.forEach(picklist =>{
            //     this.picklistLabels.push(picklist);
            //   })       
            //  const field  = data.picklistFieldValues[fieldName].values;
            // field.forEach(ele =>{

            //    this.picklistValues.push(ele.value);
            // })

            // const validValues = new Set(field.map(item => item.value));
            // const validValues = field.map(item => item.value);

            //  console.log('field inner data---->',validValues);
            // console.log('field inner data---->',JSON.stringify(validValues));


            // The API name of the picklist field you want to retrieve values for
            // const field = data.fields[fieldName];
            //  console.log('fields------>',JSON.stringify(field));

            // if (field && field.picklistValues) {
            //     console.log('fields picklists------>',JSON.stringify(field.picklistValues));

            //     this.picklistOptions = field.picklistValues.map(option => ({
            //         label: option.label,
            //         value: option.value
            //     }));
            // }
        } else if (error) {
            this.error = error;
        }
    }

    // getPicklistValuesByRecordTypeHandler(){
    //     getPicklistValuesByRecordType({ objectApiName: this.sObjectAPIName, recordTypeId: '$objectInfo.data.defaultRecordTypeId' }).then(res =>{
    //         console.log('picklistValue--->',JSON.stringify(res));
    //     })
    // }

    // getObjectInfoHandler(){
    //     getObjectInfo({ objectApiName: this.sObjectAPIName }).then(object =>{
    //         this.objectInfo = object;   
    //         console.log('objectInfo===>',this.objectInfo);

    //     })
    // }



    //open LWC component add another functionality to invoke LWC with lec Button
    openLWCComponent() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/n/ReportOnReports'
            }
        });
    }


    //connected callback
    connectedCallback() {
        this.retriveSObjectList();

        // returnRecordName({ recordId: this.recordId }).then(recordName => {
        //     if (recordName) {
        //         this.parentRecordName = recordName;
        //     }
        // }).catch(error => {
        //     this.error = error;
        // });

    }

    //handle Asending  filter functionality
    // handleAsc() {
    //     if (this.isASC == false && this.isDESC == false) {
    //         this.ascDescVal = 'ASC';
    //         this.isASC = true;

    //     } else {
    //         this.ascDescVal = null;
    //         this.isASC = false;
    //     }
    //     if (this.filterVal.length > 0 && this.ascDescVal) {
    //         this.getDataHandler();
    //     }
    // }

    //handle Desending  filter functionality
    // handleDesc() {
    //     if (this.isDESC == false && this.isASC == false) {
    //         this.ascDescVal = 'DESC';
    //         this.isDESC = true;
    //     } else {
    //         this.ascDescVal = null;
    //         this.isDESC = false;
    //     }
    //     if (this.filterVal.length > 0 && this.ascDescVal) {
    //         this.getDataHandler();
    //     }
    // }

    //Handler createdDate functionality
    // handleCreatedDate() {
    //     if (this.isCreatedDate) {
    //         let index = this.filterVal.indexOf('CreatedDate');
    //         if (index > -1) {
    //             this.filterVal.splice(index, 1);
    //         }
    //         this.illustractionTrue = false;
    //         this.isNotAscDesc = false;
    //         this.isCreatedDate = false;
    //         this.filterVal = [];
    //         this.records = [];
    //         this.getDataHandler();
    //     } else {
    //         this.filterVal.push('CreatedDate');
    //         this.isCreatedDate = true;
    //     }
    //     if (this.filterVal.length > 0 && this.ascDescVal) {
    //         this.getDataHandler();
    //     }
    //     if (this.filterVal.length == 0) {
    //         this.ascDescVal = null;
    //         this.isASC = false;
    //         this.isDESC = false;
    //     }
    //     if (this.isASC == false && this.isDESC == false && this.isCreatedDate == true) {
    //         this.template.querySelector('.dropDownDiv').style.height = '200px';
    //         this.isNotAscDesc = true;
    //     } else {
    //         this.template.querySelector('.dropDownDiv').style.height = '135px';
    //         this.isNotAscDesc = false;
    //     }
    // }

    //handle last Modifydate functionality
    // handleLastModifedDate() {
    //     if (this.isLastModify) {
    //         let index = this.filterVal.indexOf('LastModifiedById');
    //         if (index > -1) {
    //             this.filterVal.splice(index, 1);
    //         }
    //         this.isLastModify = false;
    //     } else {
    //         this.filterVal.push('LastModifiedById');
    //         this.isLastModify = true;
    //     }
    //     if (this.filterVal.length > 0 && this.ascDescVal) {
    //         this.getDataHandler();
    //     }
    //     if (this.filterVal.length == 0) {
    //         this.ascDescVal = null;
    //         this.isASC = false;
    //         this.isDESC = false;
    //     }
    // }

    //date time change handler
    // dateTimeChangeHandler(event) {
    //     this.records = [];
    //     let tempArr = [];
    //     this.dateValue = event.detail.value;
    //     const found = this.filterData.find(element => element.createDate == this.dateValue);
    //     if (found) {
    //         let result = JSON.parse(JSON.stringify(found.filterdataList));
    //         result.forEach(recElement => {
    //             if (recElement.CreatedDate) {
    //                 const formattedDate = this.formatDateManually(recElement.CreatedDate);
    //                 recElement.CreatedDate = formattedDate;
    //             }
    //             tempArr.push(recElement);
    //         });
    //         this.records = tempArr;
    //         if (this.records.length > 0) {
    //             this.illustractionTrue = false;
    //         }
    //     } else {
    //         if (this.isASC == false && this.isDESC == false) {
    //             this.filterVal = [];
    //         }
    //         this.illustractionTrue = true;
    //     }
    // }


    //handle child relatedObject
    // handleChildReletedObject() {
    //     this.isConfigureChildObject = true;
    // }


    //getting filter 
    gettingFilterHandler() {        
        gettingFilter({ sObjectId : this.selectedSObjectId }).then(filterfield => {
            if (filterfield) {
                this.filterFieldName = filterfield;
            }
        })
    }

    //getting field List
    getfields() {
        returnfields({ sobjectId: this.selectedSObjectId, sObjectName: this.sObjectAPIName }).then(fieldsName => {
            if (fieldsName) {
                this.fields = fieldsName;
                this.fields.push('AccountId');
                let index = this.fields.indexOf('CreatedDate');
                if (index !== -1) {
                    this.fields.splice(index, 1);
                }
            }
        }).catch(error => {
            this.error = error;
        });
    }

    //get SobjectColumn with configration
    getColumnHandler(selecteSObjectId) {
        this.columns = [];
      //  this.defaultOptions = [];
        getColumns({ sobjectId: selecteSObjectId }).then(columnsData => {
            if (columnsData.length > 0) {
                // columnsData.forEach(iterateEle => {
                //     this.defaultOptions.push(iterateEle.fieldName);
                // })                
                this.columns = columnsData;
                let val = { "editable": true, "fieldName": "", "label": "", "sortable": false, "type": "action", "sequence": this.columns.length + 1, "typeAttributes": { "menuAlignment": "auto", "rowActions": [{ "label": "Edit", "name": "edit" }, { "label": "Delete", "name": "delete" }, { "label": "Related Record", "name": "childObject" }] } };
                this.columns.push(val);
                this.columns.sort((a, b) => a.sequence - b.sequence);
            }else{
                this.columns = null;
            }
        }).catch(error => {
            this.error = error;
        });
    }

    //retrive sObject Name List 
    retriveSObjectList() {
        retriveSobjectName().then(sObjectNames => {
            if (sObjectNames) {
                this.sObjectList = sObjectNames;
            }
        }).catch(error => {
            this.error = error;
        });
    }

    //select sObject from comboBox and retrive all record of sObejct
    handleSelectSObject(event) {
        this.selectedSObjectId = event.detail.value;
        if (this.selectedSObjectId) {
            this.isBtnDisabled = false;
        } else {
            this.isBtnDisabled = true;
        }
        this.getColumnHandler(this.selectedSObjectId);        
        this.gettingFilterHandler();
        getsObjectApiName({ sobjectId: this.selectedSObjectId }).then(res => {
            if (res) {                
                this.sObjectAPIName = res;                
                if(this.columns){                  
                 this.getDataHandler();
                }else{
                  this.recordCount = 0;
                  this.records = null;
                }
                returnObjectLabelName({ objApiName: this.sObjectAPIName }).then(obj => {
                    if (obj) {
                        this.sObjectLabelName = obj;
                    }
                }).catch(error => {
                    this.error = error;
                })        
                objectIconMethod({ objectName: this.sObjectAPIName }).then(icon => {
                    if (icon) {
                        this.icon = icon;
                        this.isIcon = true;
                    }
                }).catch(error => {
                    this.error = error;
                });
            }
        }).catch(error => {
            this.error = error;
        });

        

    }


    // childObjectHanlder(event) {
    //     const row = event.target.closest('tr'); // Find the closest <tr> element

    //     if (row) {
    //         // Extract the recordId from the row's data
    //         const recordId = row.getAttribute('data-id'); // The key-field is 'Id', so we access it as 'data-id'
    //         console.log('Record Id:', recordId); // Log or use the recordId
    //     }
    //     //   console.log('eventdetail====>',event.detail.value);
    //     //   console.log('eventdetail====>',event.detail);


    // }

    //filter by Date functionality
    // filterDateHandler() {
    //     filterByDate({ sObjectName: this.sObjectAPIName, parentRecordId: this.recordId, sobjectId: this.selectedSObjectId, parentObject: this.objectApiName }).then(filterByDateData => {
    //         if (filterByDateData) {
    //             this.filterData = filterByDateData;
    //         }
    //     }).catch(error => {
    //         this.error = error;
    //     });
    // }

    //refresh whole data from refresh Handler
    refreshHandler() {
        // this.ascDescVal = null;
        // this.sObjectAPIName = null;
        // this.isChildTable = false;
        // this.isChildObject = false;
        // this.isDropDown = false;
        // this.childObjectSelected = null;
        // this.sChildObjectId = null;
        // this.illustractionTrue = true;
        // this.isRecord = false;
        // this.isBtnDisabled = true;
        // this.childColumnList = [];
        // this.childrecords = [];
        // this.filterVal = [];
        // this.selectedSObject = null;        
        this.isChildRecord = false;
        this.isLoading = false;
        this.icon = null;
        this.isIcon = false;
        this.relatedDataTable = null;
        this.records = null;
        this.columns = null;
        this.isBtnDisabled = true;

    }



    //clear child sObject Handler
    clearHandlder() {
        // if (this.childObjectSelected && this.sChildObjectId) {
        //     this.isChildTable = false;
        //     this.isChildObject = false;
        //     this.childObjectSelected = null;
        //     this.sChildObjectId = null;
        //     this.selectedSObject = null;
        //     if (this.illustractionTrue == true) {
        //         this.illustractionTrue = false;
        //     }
        //     this.childColumnList = [];
        //     this.childrecords = [];
        // }


    }

    //getData from Apex
    /**    getDataHandler() {
           let tempArr = [];
           this.records = [];
           this.parentRecordList = [];
           this.isLoading = true;
           getData({ sobjectId: this.selectedSObjectId, sObjectName: this.sObjectAPIName, parentRecordId: this.recordId, parentObject: this.objectApiName, filterList: this.filterVal, operator: this.ascDescVal }).then(data => {
               if (data.length > 0) {
                   let result = JSON.parse(JSON.stringify(data));
                   result.forEach(recElement => {
                       if (recElement.CreatedDate) {
                           const formattedDate = this.formatDateManually(recElement.CreatedDate);
                           recElement.CreatedDate = formattedDate;
                       }
                       if (recElement.LastName) {
                           this.parentRecordList.push({ label: recElement.LastName, value: recElement.Id });
                       } else {
                           this.parentRecordList.push({ label: recElement.Name, value: recElement.Id });
                       }
                       tempArr.push(recElement);
                   });
                   this.records = tempArr;
                   if (this.records) {
                       this.isDropDown = false;
                       this.isRecord = true;
                       this.isSearchData = false;
                       this.isFilterDisabled = false;
                       this.isLoading = false;
                       this.illustractionTrue = false;
                   } else {
                       this.isDropDown = false;
                       this.isRecord = false;
                       this.illustractionTrue = true;
                       this.isFilterDisabled = true;
                       this.isLoading = false;
                   }
               } else {
                   this.columns = [];
                   this.records = [];
                   this.isLoading = false;
                   this.isBtnDisabled = true;
                   this.isDropDown = false;
                   this.illustractionTrue = true;
               }
           })
       }
           **/

    getDataHandler() {
        this.records = [];
        this.isLoading = true;
        getData({ sObjectConfigurationId: this.selectedSObjectId, parentRecordId: this.recordId, sObjectName: this.sObjectAPIName, parentObjectName: this.objectApiName, filterFieldName : JSON.stringify(this.filterFieldName)}).then(data => {
            if (data) {
                let tempArr = [];
                let result = JSON.parse(JSON.stringify(data));
                result.forEach(recElement => {
                    if (recElement.CreatedDate) {
                        const formattedDate = this.formatDateManually(recElement.CreatedDate);
                        recElement.CreatedDate = formattedDate;
                    }
                    // if (recElement.LastName) {
                    //     this.parentRecordList.push({ label: recElement.LastName, value: recElement.Id });
                    // } else {
                    //     this.parentRecordList.push({ label: recElement.Name, value: recElement.Id });
                    // }
                    tempArr.push(recElement);
                });
                this.records = tempArr;

                if (this.records.length > 4) {
                    this.recordCount = '4+';
                } else {
                    this.recordCount = this.records.length;
                }

                if (this.records) {
                    this.isLoading = false;
                    this.illustractionTrue = false;
                } else {
                    this.illustractionTrue = true;
                    this.isLoading = false;
                }
                console.log('dataooo===>', JSON.stringify(this.records));


            } else {
                this.columns = [];
                this.records = [];
                this.isLoading = false;
                // this.isBtnDisabled = true;
                // this.isDropDown = false;
                this.illustractionTrue = true;
            }

        }).catch(error => {
            this.error = error;
        })
    }

    //remove dropdown handler  //currently that is not used
    // removeDropDownHandler() {
    //     this.isDropDown = false;
    // }

    //format createdDate with datetime 
    formatDateManually(isoDateString) {
        if (isoDateString) {
            const date = new Date(isoDateString);
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            let hours = date.getHours();
            const minutes = String(date.getMinutes()).padStart(2, '0');
            const period = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12 || 12;
            return `${day}/${month}/${year}, ${hours}:${minutes} ${period}`;
        }
    }

    //sorting method
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.records = parseData;
    }

    //sorting child method
    //    sortChildData(fieldname, direction) { 
    //      console.log('relatedDataTable====>',JSON.stringify(this.relatedDataTable));

    //     //   let filterData = this.relatedDataTable.filter(ele => ele.objectName ===);
    //         let parseData = JSON.parse(JSON.stringify(this.records));
    //         let keyValue = (a) => {
    //             return a[fieldname];
    //         };
    //         let isReverse = direction === 'asc' ? 1 : -1;
    //         parseData.sort((x, y) => {
    //             x = keyValue(x) ? keyValue(x) : '';
    //             y = keyValue(y) ? keyValue(y) : '';
    //             return isReverse * ((x > y) - (y > x));
    //         });
    //         this.records = parseData;
    //     }

    //handle openCreate Modal
    // openCreateRecModal(event) {
    //     this.isCreateModal = true;
    // }

    //handle handleCreateSubmit Modal
    // handleCreateSubmit(event) {
    //     this.isCreateModal = false;
    //     this.records = [];
    //     this.getDataHandler();
    //     this.showToast('Record Inserted', 'Inserted Successfully', 'success');
    // }

    //handle handleCancelCreate Modal
    // handleCancelCreate(event) {
    //     this.isCreateModal = false;
    // }


    //sort //currently that not working
    doSorting(event) {
        if (event.detail.fieldName) {
            this.sortBy = event.detail.fieldName;
            this.sortDirection = event.detail.sortDirection;
            this.sortData(this.sortBy, this.sortDirection);
        }
    }

    // doChildSorting(event) {
    //     console.log('fieldName-==---<>',event.detail.fieldName);        
    //     if (event.detail.fieldName) {
    //         this.sortBy = event.detail.fieldName;
    //         this.sortDirection = event.detail.sortDirection;
    //         this.sortChildData(this.sortBy, this.sortDirection);
    //     }
    // }

    //get child object handler
    // getChildsObject() {
    //     getsObjectChilds({ parentsObjectName: this.objectApiName, childsObjectName: this.sObjectAPIName }).then(childObject => {
    //         if (childObject) {
    //             this.childObjectList = childObject;
    //         }
    //     }).catch(error => {
    //         this.error = error;
    //     });
    // }

    //handle child object 
    // handleChildsObject(event) {
    //     this.childObjectSelected = event.detail.value;
    //     this.isChildTable = false;
    //     this.childColumnList = [];
    //     getRequiredFields({ objectName: this.childObjectSelected }).then(column => {
    //         if (column) {
    //             column.forEach(iteratecolumn => {
    //                 let val = { "editable": true, "fieldName": iteratecolumn.value, "label": iteratecolumn.label, "sortable": true, "type": "text" };
    //                 this.childColumnList.push(val);
    //             })
    //         }
    //     }).catch(error => {
    //         this.error = error;
    //     });

    // }

    //cancel configration modal
    // cancelConfigrationModal() {
    //     this.isConfigureChildObject = false;
    // }

    //hanlde configration parent modal
    // handleConfigrationParent(event) {
    //     this.sChildObjectId = event.detail.value;

    // }

    //save child filter configration
    // saveFilterConfigration() {
    //     this.isLoading = true;
    //     if (this.sChildObjectId) {
    //         returnRecordName({ recordId: this.sChildObjectId }).then(recordName => {
    //             if (recordName) {
    //                 this.childRecordName = recordName;
    //             }
    //         })
    //         returnRecords({ schildObjectName: this.childObjectSelected, parentsObjectName: this.objectApiName, parentrecordId: this.recordId, childsObjectName: this.sObjectAPIName, childRecordId: this.sChildObjectId }).then(res => {
    //             if (res.length > 0) {
    //                 this.childrecords = res;
    //                 this.isChildTable = true;
    //                 this.isLoading = false;
    //                 this.isDropDown = false;
    //                 this.isConfigureChildObject = false;
    //             } else {
    //                 this.isLoading = false;
    //                 this.isDropDown = false;
    //                 this.illustractionTrue = true;
    //                 this.isChildTable = false;
    //                 this.childrecords = [];
    //                 this.childColumnList = [];
    //                 this.isConfigureChildObject = false;
    //             }
    //         }).catch(error => {
    //             this.error = error;
    //         });
    //     } else {
    //         this.isDropDown = false;
    //         this.isLoading = false;
    //     }
    // }

    //cancel sObject child Modal
    // cancelsObjectChildModal() {
    //     this.isChildObject = false;
    // }

    //handle rowAction event
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        if (actionName) {
            const row = event.detail.row;
            this.currentRecordId = row.Id;
            switch (actionName) {
                case 'childObject':
                    this.relatedDataTable = [];
                    getAllRelatedObject({ objectName: this.sObjectAPIName }).then(child => {
                        this.isLoading = true;
                        if (child) {
                            let relatedChildList = child;
                            if (relatedChildList.length > 0) {
                                relatedChildList.forEach(objectName => {
                                    getAllChildRecord({ recordId: row.Id, sObjectName: objectName, parentSobjectName: this.sObjectAPIName }).then(childWrapper => {
                                        if (childWrapper) {
                                            this.relatedDataTable.push(childWrapper);
                                            this.isChildRecord = true;
                                            this.isLoading = false;
                                        }
                                    })
                                })
                            }
                        }
                    })
                    break;
                case 'delete':
                    this.deletesObjectId = row.Id;
                    this.isDeleteModal = true;
                    break;
                case 'edit':
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: row.Id,
                            objectApiName: this.sObjectAPIName,
                            actionName: 'edit'
                        }
                    });
                    setTimeout(() => {
                        this.getDataHandler();
                    }, 10000);
                    break;
                default:
            }
        }
    }

    //handle delete Cancel Modal
    deleteCancelModal() {
        this.isDeleteModal = false;
    }

    //handle deleteHandler
    deleteHandler() {
        deletesObjectRecord({ recordId: this.deletesObjectId, objectName: this.sObjectAPIName }).then(result => {
            if (result) {
                this.isDeleteModal = false;
                this.getDataHandler();
                this.showToast('Deleted', 'Deleted Sucessfully', 'success');
            }
        }).catch(error => {
            this.error = error;
        });
    }


    //handler child save  method
    async handleChildSave(event) {
        this.isChildTable = false;
        const updatedFields = event.detail.draftValues;
        let sObjectName;
        getSObjectName({ recordId: updatedFields[0].Id }).then(result => {
            if (result) {
                sObjectName = result;
                if (sObjectName) {
                    updatedFields.forEach(ele => {
                        ele.attributes = { type: sObjectName };
                    })
                    if (updatedFields) {
                        updatesObjectRecord({ data: JSON.stringify(updatedFields) }).then(res => {
                            this.draftValuesChildRecord = [];
                            this.draftValuesChildRecord = null;
                            this.relatedDataTable = [];
                            if (res) {
                                getAllRelatedObject({ objectName: this.sObjectAPIName }).then(child => {
                                    this.isLoading = true;
                                    if (child) {
                                        let relatedChildList = child;
                                        if (relatedChildList.length > 0) {
                                            relatedChildList.forEach(objectName => {
                                                getAllChildRecord({ recordId: this.currentRecordId, sObjectName: objectName, parentSobjectName: this.sObjectAPIName }).then(childWrapper => {
                                                    if (childWrapper) {
                                                        this.relatedDataTable.push(childWrapper);
                                                        this.isChildRecord = true;
                                                        this.isLoading = false;
                                                    }
                                                })
                                            })
                                        }
                                    }
                                })
                            }
                            this.showToast('Updated Related Child Records', 'The changes made are successfully updated', 'success');
                        })
                    }

                }
            }
        })

        // updatesObjectRecord({ data: JSON.stringify(updatedFields) }).then(res => {
        //     this.draftValuesChildRecord = [];
        //     this.draftValuesChildRecord = null;
        //     this.relatedDataTable = null;

        //     // returnRecords({ schildObjectName: this.childObjectSelected, parentsObjectName: this.objectApiName, parentrecordId: this.recordId, childsObjectName: this.sObjectAPIName, childRecordId: this.sChildObjectId }).then(res => {
        //     //     if (res) {
        //     //         this.childrecords = res;
        //     //         this.isChildTable = true;
        //     //     }
        //     // }).catch(error => {
        //     //     this.error = error;
        //     // });

        //     this.showToast('Updated Related Child Records', 'The changes made are successfully updated', 'success');
        // })
    }


    // update method
    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
        let filterColumn;
        if(this.columns){
            filterColumn = this.columns.filter(ele => ele.required == true);
        }      
        let reqFields = [];
        if (filterColumn.length > 0) {
            filterColumn.forEach(ele => {
                reqFields.push(ele.fieldName);
            })
        }
        let isReqField = true;
        let isPicklistField = true;
        let labbelPicklist = Object.keys(this.picklistDetails);
        reqFields.forEach(ele => {
            updatedFields.forEach(iterateColumn => {
                let keys = Object.keys(iterateColumn);
                let labelList = [];
                keys.forEach(iterateKey => {
                    if (labbelPicklist.includes(iterateKey)) {
                        let picklistvalue = this.picklistDetails[iterateKey].values;
                        picklistvalue.forEach(ele => {
                            labelList.push(ele.label);
                        })
                        if (!labelList.includes(iterateColumn[iterateKey])) {
                            isPicklistField = false;
                        }
                    }
                })
                if (iterateColumn.hasOwnProperty(ele) && iterateColumn[ele] == "") {
                   isReqField = false;
                }
            })
        })
        updatedFields.forEach(ele => {
            ele.attributes = { type: this.sObjectAPIName };
        })
        if (!isPicklistField) {
            this.showToast('Picklist Field Should be correct Value', 'Kindly fill correct value in picklist', 'error');
        }
        else if (!isReqField && !isPicklistField) {
            this.showToast('Required Fields', 'Kindly fill the required fields for successful updation', 'error');
        } else {
            this.isLoading = true;
            updatesObjectRecord({ data: JSON.stringify(updatedFields) }).then(res => {
                this.getDataHandler();
                this.draftValues = [];
                this.draftValues = null;
                this.isLoading = false;
                this.showToast('Updated Related Records', 'The changes made are successfully updated', 'success');
            }).catch(error => {
                this.error = error;
            });
        }
    }

    // filterModalHandler() {
    //     this.filedFilter = [];
    //     getAllFields({ sobjectId: this.selectedSObjectId }).then(fields => {
    //         if (fields) {
    //             this.filedFilter = fields;
    //             this.isFilter = true;
    //         }
    //     }).catch(error => {
    //         this.error = error;
    //     });

    // }


    //cancel filter modal
    // cancelFilterModal() {
    //     this.isFilter = false;
    // }


    //handlem drop down 
    // handleDorpDown() {
    //     if (this.isDropDown == true) {
    //         this.isDropDown = false;
    //     } else {
    //         this.getChildsObject();
    //         this.isDropDown = true;
    //     }
    // }



    //select filter values
    // selectFilter(event) {
    //     this.filterVal = event.detail.value;
    //     this.getDataHandler();
    // }


    //select operator handler
    // selectOperatorHandler(event) {
    //     this.ascDescVal = event.detail.value;
    //     if (this.ascDescVal) {
    //         this.getDataHandler();
    //     }
    // }

    //toast method
    showToast(toastTitle, toastMessage, toastVariant) {
        const toastEvent = new ShowToastEvent({
            title: toastTitle,
            message: toastMessage,
            variant: toastVariant,
        })
        this.dispatchEvent(toastEvent);
    }


}