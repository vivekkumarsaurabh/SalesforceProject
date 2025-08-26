import { LightningElement, api, track, wire } from 'lwc';
import retriveSobjectName from '@salesforce/apex/CustomListView.retriveSobjectName';
import getsObjectApiName from '@salesforce/apex/CustomListView.getsObjectApiName';
import getColumns from '@salesforce/apex/CustomListView.getColumns';
import getData from '@salesforce/apex/CustomListView.getData';
import deletesObjectRecord from '@salesforce/apex/CustomListView.deletesObjectRecord';
import returnfields from '@salesforce/apex/CustomListView.returnfields';
import updatesObjectRecord from '@salesforce/apex/CustomListView.updatesObjectRecord';
import searchKey from '@salesforce/apex/CustomListView.searchKey';
import getAllFields from '@salesforce/apex/CustomListView.getAllFields';
import getfilterList from '@salesforce/apex/CustomListView.getfilterList';
import arrangeFiled from '@salesforce/apex/CustomListView.arrangeFiled';
import objectIconMethod from '@salesforce/apex/CustomListView.objectIconMethod';
import gettingListView from '@salesforce/apex/CustomListView.gettingListView';
import gettingFilter from '@salesforce/apex/CustomListView.gettingFilter';
import createListView from '@salesforce/apex/CustomListView.createListView';
import updateListViewMetadata from '@salesforce/apex/CustomListView.updateListViewMetadata'
import deleteListViewMetadata from '@salesforce/apex/CustomListView.deleteListViewMetadata';
import gettingRecords from '@salesforce/apex/CustomListView.gettingRecords';
import getFieldNameFromApiName from '@salesforce/apex/CustomListView.getFieldNameFromApiName';
import getRichTextFields from '@salesforce/apex/CustomListView.getRichTextFields';
import timeInterval from '@salesforce/apex/CustomListView.timeInterval';
import { subscribe } from 'lightning/empApi';
import refreshListView from '@salesforce/label/c.ObjectHistoryEvent'
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ListView extends NavigationMixin(LightningElement) {
    isLoading = false;
    isRecord = false;
    isDeleteModal = false;
    isCreateModal = false;
    isFilter = false;
    isBtnDisabled = true;
    isIcon = false;
    isSearchData = false;
    illustractionTrue = true;
    isAscDescFilter = false;
    isPopovers = false;
    isSaveFilter = false;
    isListViewControls = false;
    isFieldDisplay = false;
    isListView = false;
    isCreateListView = false;
    isDeleteListView = false;
    isSharingSetting = false;
    isSharingForAnyOne = false;
    isGroup = false;
    isRichText = false;
    isRenameListView = false;
    isOwnerFilter = false;
    isAutoRefresh = false;
    isFile = false;
    selectedTarget = 'Queue';
    icon;
    error;
    selectedSObjectId;
    sObjectAPIName;
    sObjectLabelName;
    deletesObjectId;
    @track recordSize;
    popoverClass;
    selectedField;
    selectedOperator;
    selectedValue;
    selectedListView;
    listViewLabel;
    selectedListViewSharing;
    listViewName;
    listViewAPiName;
    searchKeyOfGroup;
    @track richTextAreaVal;
    myRichTextId;
    newClone;
    preCount;
    timeSet;
    autoTime;
    timer;
    sortingName = 'Name';
    sortBy;
    sortDirection;
    openFilter = [];
    defaultOptions = [];
    fields = [];
    sObjectList = [];
    records = [];
    draftValues = [];
    filedFilter = [];
    selectedDisplayField = [];
    searchData = [];
    filterList = [];
    filterRecord = [];
    listViewData = [];
    columnNameList = [];
    groups = [];
    groupList = [];
    updateDraftValues = [];
    isShowPopUp = [];
    tempArrDraftValue = [];
    richfieldApiNames = [];
    ownerFilterValue;
    timeIntervalValue;
    richTextVal;
    automationValue;
    listChangeOptions = [{ label: 'Only I can see this list view', value: 'onlyICanSeeThisListView' }, { label: 'All users can see this list view', value: 'AllUsersCanSeeThisListView' }, { label: 'Share list view with groups of users', value: 'ShareListViewWithGroupsOfUsers' }];
    OperatorOption = [{ label: 'equals', value: 'equals' }, { label: 'not equal to', value: 'not equal to' }, { label: 'less than', value: 'less than' }, { label: 'greater than', value: 'greater than' }, { label: 'greater or equal', value: 'greater or equal' }, { label: 'less or equal', value: 'less or equal' }, { label: 'contains', value: 'contains' }, { label: 'does not contains', value: 'does not contains' }, { label: 'starts with', value: 'starts with' }];
    ownerFilterOption = [{ label: `All ${this.sObjectAPIName}`, value: 'Everything' }, { label: `My ${this.sObjectAPIName}`, value: 'Mine' }, { label: 'Filter By Scope', value: 'ScopingRule' }];
    @track customDiv = [];
    automationConfigration = [{ label: 'Enable', value: 'Enabled' }, { label: 'Disabled', value: 'Disabled' }];
    timeLabel = [];
    requiredOptions = ['Name'];
    subscription = {};
    @api channelName = refreshListView;
    targetObjects = [{

        label: 'Public Groups',
        value: 'regular',
        icon: 'utility:groups'
    },
    {
        label: 'Roles',
        value: 'role',
        icon: 'utility:hierarchy'
    },
    {
        label: 'Roles and Internal Subordinates',
        value: 'roleAndSubordinates',
        icon: 'utility:hierarchy'
    },
    {
        label: 'Roles, Internal and Portal Subordinates',
        value: 'roleAndSubordinatesInternal',
        icon: 'utility:hierarchy'
    }
    ];
    handleChange(event) {
        this.richTextVal = event.target.value;
        console.log('data----->', this.richTextVal);

    }

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
        table thead th lightning-primitive-header-factory .slds-th__action{
        border:1px solid #ddd7d7;
        }
        .slds-file-selector__text{display: none;}
        .slds-card__body{border:1px solid #000000;}`;
        document.querySelector('head').appendChild(style);
    }

    //connected callback
    connectedCallback() {
        timeInterval().then(res => {
            if (res) {
                this.timeLabel = res;
            }
        })
        this.retriveSObjectList();
        this.handleSubscribe();
    }

    //this method is used for handling event publish by trigger usng platform event then refresh our component.
    handleSubscribe() {
        const messageCallback = (response) => {
            // this.retriveLengthHandler(this.objectApiName, this.recordId);
            var obj = JSON.parse(JSON.stringify(response));
            let objData = obj.data.payload;
            console.log('refereshh--->', objData.isShowTable__c);
            if (objData.isShowTable__c) {
                this.getDataHandler();
            }
        };
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }

    renderedCallback() {
        const parentElement = this.template.querySelector('.listViewDiv');
        if (parentElement) {
            const buttonElement = parentElement.querySelector('.slds-button');
            if (buttonElement) {
                console.log('listView==----->', parentElement);
                buttonElement.classList.remove('slds-button_icon-border');
            }
        }
        //const v = lsView.querySelector('.slds_button');

    }


    autoRefreshHandler() {
        this.isAutoRefresh = true;
    }

    changeAutomationHandler(event) {
        this.automationValue = event.detail.value;
    }

    handleTimeInterval(event) {
        this.timeIntervalValue = event.detail.value;
    }

    saveAutoTimeHandler() {

        this.refreshHandlerAuto();
    }

    cancelAutoRefresh() {
        this.isAutoRefresh = false;
    }

    getAllRichTextField() {
        getRichTextFields({ objectName: this.sObjectAPIName }).then(res => {
            if (res) {
                this.richfieldApiNames = res;
            }
        })
    }

    //getting field List
    getfields() {
        returnfields({ sobjectId: this.selectedSObjectId }).then(fieldsName => {
            if (fieldsName) {
                this.fields = fieldsName;
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
        this.defaultOptions = [];
        getColumns({ sobjectId: selecteSObjectId }).then(columnsData => {
            if (columnsData) {
                columnsData.forEach(iterateEle => {
                    this.defaultOptions.push(iterateEle.fieldName);
                    if (iterateEle.label == 'File Extension') {
                        iterateEle.fieldName = '';
                        let obj = { iconName: { fieldName: 'dynamicIcon' } };
                        iterateEle.cellAttributes = obj;
                    }
                })
                this.columns = columnsData;
                let val = { "editable": true, "fieldName": "", "label": "", "sortable": false, "type": "action", "sequence": this.columns.length + 1, "typeAttributes": { "menuAlignment": "auto", "rowActions": [{ "label": "Edit", "name": "edit" }, { "label": "Delete", "name": "delete" }] } };
                this.columns.push(val);
                this.columns.sort((a, b) => a.sequence - b.sequence);
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
                this.isIcon = false;
            }
        }).catch(error => {
            this.error = error;
        });
    }

    //select sObject from comboBox and retrive all record of sObejct
    handleSelectSObject(event) {
        this.selectedSObjectId = event.detail.value;
        this.template.querySelector('.objectConfigration').style.height = '5vh';
        if (this.selectedSObjectId) {
            this.isBtnDisabled = false;
        } else {
            this.isBtnDisabled = true;
        }
        this.getColumnHandler(this.selectedSObjectId);
        this.getAllFieldsHandler(this.selectedSObjectId);
        getsObjectApiName({ sobjectId: this.selectedSObjectId }).then(res => {
            if (res) {
                this.sObjectAPIName = res;
                let labelName = this.sObjectList.filter(ele => this.selectedSObjectId.includes(ele.value));
                this.sObjectLabelName = labelName[0].label;
                if(this.sObjectAPIName == 'ContentVersion'){
                this.isFile = true;
                }
                this.getObjectIcon(this.sObjectAPIName);
                this.gettingListViewHandler(this.sObjectAPIName);
                this.getDataHandler();
                this.getAllRichTextField();
                // this.filterDateHandler();
                this.getfields();
            }
        }).catch(error => {
            this.error = error;
        });

    }

   

    handleUploadFinished(event){
        const uploadedFiles = event.detail.files;
        this.getDataHandler();        
        this.showToast('Upload File',uploadedFiles.length+' File Uploaded','success');  
    }

    // uploadFileHandler(){  
    //     console.log('clickee');
    //     this.handleFileInList();
           
    //     console.log('data----->',this.template.querySelector('.fileInput'));
           
    //     this.template.querySelector('.fileInput').click();
    // }


    //getting standard List view List items
    gettingListViewHandler(sObjectName) {
        gettingListView({ sObjectName: sObjectName }).then(data => {
            if (data) {
                this.listViewData = data;
                if (this.listViewData.length > 0) {
                    this.listViewLabel = this.listViewData[0].label;
                    this.gettingFilterApplied(this.listViewData[0].value, this.sObjectAPIName);
                    this.timeRuningHandler();
                    this.isListView = true;
                }

                /** let temp = this.template.querySelectorAll('.listViewDiv');
                 console.log('temp==--->', temp);
                 console.log('temp JSON=---->', JSON.stringify(temp));**/
            }
        }).catch(error => {
            this.error = error;
        });
    }

    handleListView(event) {
        this.selectedListView = event.detail.value;
        if(this.selectedListView){
            let listViewL = this.listViewData.filter(ele => ele.value === this.selectedListView);
        if (listViewL) {
            this.listViewLabel = listViewL[0].label;
        }        
        this.timeRuningHandler();
        this.gettingFilterApplied(this.selectedListView, this.sObjectAPIName);
        }
    }

    //getting filters applied on ListView
    gettingFilterApplied(lstViewName, objectName) {
        this.filterList = [];
        this.customDiv = [];
        this.preCount = null;
        gettingFilter({ listViewName: lstViewName, sObjectName: objectName }).then(filter => {
            if (filter) {
                this.filterList = filter;
                if (this.filterList.length == 0) {
                    this.getDataHandler();
                } else {
                    this.filterList.forEach(ele => {
                        if (ele) {
                            if (this.preCount) {
                                this.preCount++;
                            } else {
                                this.preCount = 1;
                            }
                            let customClass = `custom${this.preCount}`;
                            this.customDiv.push(customClass);
                            ele.displayClass = customClass;                            
                            // this.addFilterHandler(); 
                            // let newFilter = `${ele.fieldName} ${ele.operator} ${ele.value}`; 
                            // this.template.querySelector(`[data-filterval="${customClass}"]`).innerHTML = newFilter;
                            this.isPopovers = false;
                        }
                    })
                    this.handleSaveFilter();
                }
            } else {

            }
        })
    }

    //get object Icon with apex
    getObjectIcon(sobjectName) {
        this.sObjectList = [];
        this.isIcon = true;
        objectIconMethod({ objectName: sobjectName }).then(res => {
            if (res != null && res != undefined) {
                this.icon = res;
            }
        }).catch(error => {
            this.error = error;
            this.records = undefined;
        });
    }


    //refresh whole data from refresh Handler
    refreshHandler() {
        this.getDataHandler();
    }


    refreshHandlerAuto() {
        let timeInterval;
        if (this.automationValue == 'Enabled') {
            if (this.timeIntervalValue == 'Time_30_second') {
                timeInterval = 30000;
            } else if (this.timeIntervalValue == 'Time_20_second') {
                timeInterval = 20000;
            } else {
                timeInterval = 10000;
            }
            this.autoTime = setInterval(() => {
                this.getDataHandler();
            }, timeInterval);
        } else {
            clearInterval(this.autoTime);
        }
        this.isAutoRefresh = false;
    }


    //clear child sObject Handler
    clearHandlder() {
        if (this.selectedSObjectId) {
            this.isIcon = false;
            this.ascDescVal = null;
            this.sObjectAPIName = null;
            this.isChildObject = false;
            this.isDropDown = false;
            this.illustractionTrue = true;
            this.isRecord = false;
            this.isBtnDisabled = true;
            this.isListView = false;
            this.isFile = false;
            this.childColumnList = [];
            this.childrecords = [];
            this.selectedSObject = null;
            this.listViewLabel = null;
            this.retriveSObjectList();
            this.closeFilterHandler();
            clearInterval(this.autoTime);
            this.template.querySelector('.objectConfigration').style.height = '8vh';
        }
    }

    //getData from Apex
    getDataHandler() {
        let tempArr = [];
        this.records = [];
        this.parentRecordList = [];
        this.isLoading = true;
        getData({ sobjectId: this.selectedSObjectId, sObjectName: this.sObjectAPIName }).then(data => {
            if (data.length > 0) {
                let result = JSON.parse(JSON.stringify(data));
                result.forEach(recElement => {
                    if (recElement.FileExtension) {
                        if (recElement.FileExtension == 'png' || recElement.FileExtension == 'jpg'  || recElement.FileExtension == 'jpeg' ) {
                            recElement.dynamicIcon = 'doctype:image';
                        } else if (recElement.FileExtension == 'xlsx') {
                            recElement.dynamicIcon = 'doctype:csv';
                        } else if (recElement.FileExtension == 'docx') {
                            recElement.dynamicIcon = 'doctype:word';
                        }else {
                            recElement.dynamicIcon = 'doctype:' + recElement.FileExtension.toLowerCase();
                        }
                    }
                    //  recElement['conLink'] = '/'+ recElement.Id; 
                    if (recElement.CreatedDate) {
                        const formattedDate = this.formatDateManually(recElement.CreatedDate);
                        recElement.CreatedDate = formattedDate;
                    }
                    if (recElement.LastName) {
                        this.parentRecordList.push({ label: recElement.LastName, value: recElement.Id });
                    } else if (recElement.Name) {
                        this.parentRecordList.push({ label: recElement.Name, value: recElement.Id });
                    } else if (recElement.CreatedBy) {
                        recElement['CreatedBy.Name'] = recElement.CreatedBy.Name;
                    }
                    tempArr.push(recElement);
                });
                this.records = tempArr;
                this.recordSize = this.records.length;
                if (this.records) {
                    //  this.records = data;
                    this.isDropDown = false;
                    this.isRecord = true;
                    this.isSearchData = false;
                    this.isFilter = false;
                    this.isLoading = false;
                    this.illustractionTrue = false;
                } else {
                    this.isDropDown = false;
                    this.isRecord = false;
                    this.isFilter = false;
                    this.illustractionTrue = true;
                    this.isLoading = false;
                }
            } else {
                this.columns = [];
                this.records = [];
                this.isLoading = false;
                this.isFilter = false;
                this.isBtnDisabled = true;
                this.isDropDown = false;
                this.illustractionTrue = true;
            }
        }).catch(error => {
            this.error = error;
        });
    }

    //search Handler
    searchHandler(event) {
        this.searchValue = event.target.value;
        if (this.searchValue) {
            this.serchDataHandler(this.searchValue, this.sObjectAPIName, this.selectedSObjectId);
        } else {
            this.getDataHandler();
        }
    }

    //search Data Handler with apex
    serchDataHandler(searchValue, sObjectName, sObjectId) {
        searchKey({ searchVal: searchValue, sObjectName: sObjectName, sObjectId: sObjectId }).then(data => {
            if (data) {
                let result = JSON.parse(JSON.stringify(data));
                result.forEach(recElement => {
                    if (recElement.FileExtension) {
                        if (recElement.FileExtension == 'png' || recElement.FileExtension == 'jpg'  || recElement.FileExtension == 'jpeg' ) {
                            recElement.dynamicIcon = 'doctype:image';
                        } else if (recElement.FileExtension == 'xlsx') {
                            recElement.dynamicIcon = 'doctype:csv';
                        } else if (recElement.FileExtension == 'docx') {
                            recElement.dynamicIcon = 'doctype:word';
                        }  else {
                            recElement.dynamicIcon = 'doctype:' + recElement.FileExtension.toLowerCase();
                        }
                    }
                    if (recElement.CreatedDate) {
                        const formattedDate = this.formatDateManually(recElement.CreatedDate);
                        recElement.CreatedDate = formattedDate;
                    }
                    if (recElement.LastName) {
                        this.parentRecordList.push({ label: recElement.LastName, value: recElement.Id });
                    } else if (recElement.Name) {
                        this.parentRecordList.push({ label: recElement.Name, value: recElement.Id });
                    } else if (recElement.CreatedBy) {
                        recElement['CreatedBy.Name'] = recElement.CreatedBy.Name;
                    }
                })
                this.isSearchData = true;
                this.searchData = result;
                this.recordSize = this.searchData.length;
            } else {
                this.getDataHandler();
            }
        }).catch(error => {
            this.error = error;
        });
    }


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

    //handle openCreate Modal
    openCreateRecModal(event) {
        if (this.selectedSObjectId) {
            this.isCreateModal = true;
        }
    }

    //handle handleCreateSubmit Modal
    handleCreateSubmit(event) {
        this.isCreateModal = false;
        this.records = [];
        this.getDataHandler();
        this.showToast('Record Inserted', 'Inserted Successfully', 'success');
    }

    //handle handleCancelCreate Modal
    handleCancelCreate(event) {
        this.isCreateModal = false;
    }


    //sort 
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        if (this.sortBy) {
            getFieldNameFromApiName({ sObjectName: this.sObjectAPIName, apiName: this.sortBy }).then(res => {
                if (res) {
                    this.sortingName = res;
                }
            }).catch(error => {
                this.error = error;
            })
            // this.sortBy = event.detail.fieldName;
            this.sortDirection = event.detail.sortDirection;
            this.sortData(this.sortBy, this.sortDirection);
        }
    }

    //handle rowAction event
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        if (actionName) {
            const row = event.detail.row;
            switch (actionName) {
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
                case 'delete':
                    this.deletesObjectId = row.Id;
                    this.isDeleteModal = true;
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


    // update method
    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
        updatedFields.forEach(ele => {
            ele.attributes = { type: this.sObjectAPIName };
        })
        if (this.updateDraftValues.length > 0) {
            updatedFields.forEach(iterateDraft => {
                let filterDrafValues = this.updateDraftValues.filter(ele => ele.Id == iterateDraft.Id);
                if (filterDrafValues) {
                    filterDrafValues.forEach(filterIterate => {
                        let draft = Object.keys(filterIterate);
                        this.richfieldApiNames.forEach(field => {
                            if (draft.includes(field)) {
                                iterateDraft[field] = filterIterate[field];
                            }
                        })
                    })
                }
            })
            this.updatesObjectRecordHandler(updatedFields);
        } else {
            this.updatesObjectRecordHandler(updatedFields);
        }
    }

    //used for field update
    getAllFieldsHandler(sObjectId) {
        this.filedFilter = [];
        getAllFields({ sobjectId: sObjectId }).then(fields => {
            if (fields) {
                this.filedFilter = fields;
                // this.isFilter = true;
            }
        }).catch(error => {
            this.error = error;
        });

    }

    handleDisplayField(event) {
        this.selectedDisplayField = event.detail.value;
    }

    // save filter modal of arrange field with meta data arrange filter
    saveFilterModal() {
        let index = 1;
        let finalField = [];
        this.columns = [];
        if (this.selectedDisplayField) {
            this.selectedDisplayField.forEach(field => {
                let obj = { key: field, value: index };
                index++;
                finalField.push(obj);
            })
        }
        if (finalField) {
            this.isRecord = false;
            console.log('final list===--->',JSON.stringify(finalField));            
            setTimeout(() => {
                arrangeFiled({ finnalFieldList: JSON.stringify(finalField), sobjectId: this.selectedSObjectId, sObjectName: this.sObjectAPIName }).then(res => {
                    this.getColumnHandler(this.selectedSObjectId);
                    this.getDataHandler();
                    this.isFilter = false;
                    this.isRecord = true;
                })
            }, 3000);
        }
    }

    //cancel filter modal
    cancelFilterModal() {
        this.isFieldDisplay = false;
    }

    handleFilterAscDec() {
        if (this.isAscDescFilter == true) {
            this.template.querySelector('.mainBody').style.width = '100%';
            this.isAscDescFilter = false;
        } else {
            this.template.querySelector('.mainBody').style.width = '70%';
            this.isAscDescFilter = true;
        }
    }


    closeFilterHandler() {
        this.template.querySelector('.mainBody').style.width = '100%';
        this.isAscDescFilter = false;
    }

    addFilterHandler() {
        if (this.preCount) {
            if (this.preCount <= 10) {
                this.preCount++;
            }
        } else {
            this.preCount = 1;
        }
        this.isPopovers = false;
        this.isSaveFilter = true;
        this.isShowPopUp.push(true);
        let customClass = `custom${this.preCount}`;
        this.popoverClass = customClass;
        this.customDiv.push(customClass);
        this.selectedField = null;
        this.selectedOperator = null;
        this.selectedValue = null;
        this.isPopovers = true;
    }

    removeSingleFilter(event) {
        let customClass = event.currentTarget.dataset.id;
        this.filterList = this.filterList.filter(item => !customClass.includes(item.displayClass));
        this.isPopovers = false;
        let index = this.customDiv.indexOf(customClass);
        if (index !== -1) {
            this.customDiv.splice(index, 1);
        }
        this.isShowPopUp.pop();
        this.isSaveFilter = true;
        this.template.querySelector(`[data-pop="${customClass}"]`).style.display = 'none';
    }

    removeFilters() {
        this.openFilter = [];
        this.customDiv = [];
        this.filterList = [];
        this.isRecord = true;
        this.isFilter = false;
        this.isSaveFilter = false;
        this.isPopovers = false;
        this.isShowPopUp = [];
        this.getDataHandler();
    }


    //filter open handler
    // filterOpenHandler() {
    //     this.isFilterAsc = true;
    // }

    handleField(event) {
        this.selectedField = event.detail.value;
    }

    handleOperator(event) {
        this.selectedOperator = event.detail.value;
    }

    handleValue(event) {
        this.selectedValue = event.detail.value;
    }

    filterSaveHandler(event) {
        if (this.openFilter.length > 0) {
            this.isPopovers = false;
        } else {
            let customClass = event.currentTarget.dataset.btn;
            let obj = { displayClass: customClass, fieldName: this.selectedField, operator: this.selectedOperator, value: this.selectedValue };
            let newFilter = `${this.selectedField}  ${this.selectedOperator} ${this.selectedValue}`;
            this.filterList.push(obj);
            this.template.querySelector(`[data-pop="${customClass}"]`).style.display = 'none';
            if (this.selectedField == null && this.selectedOperator == null) {
                newFilter = 'New Filter*';
                this.template.querySelector(`[data-filterval="${customClass}"]`).innerHTML = newFilter;
            } else {
                this.template.querySelector(`[data-filterval="${customClass}"]`).innerHTML = newFilter;
            }
            this.isPopovers = false;
            this.popoverClass = null;
        }
    }

    filterOpenHandler(event) {
        this.openFilter = [];
        this.selectedField = null;
        this.selectedOperator = null;
        this.selectedValue = null;
        this.isPopovers = false;
        let customClass = event.currentTarget.dataset.openfilter;
        this.openFilter = this.filterList.filter(ele => ele.displayClass === customClass);
        if (this.openFilter.length > 0) {
            this.selectedField = this.openFilter[0].fieldName;
            this.selectedOperator = this.openFilter[0].operator;
            this.selectedValue = this.openFilter[0].value;
            this.isPopovers = true;
        } else {
            this.isPopovers = true;
        }
    }

    handleSaveFilter() {
        getfilterList({ filter: JSON.stringify(this.filterList), sObjectName: this.sObjectAPIName, sObjectId: this.selectedSObjectId }).then(data => {
            if (data) {
                let result = JSON.parse(JSON.stringify(data));
                result.forEach(recElement => {
                    if (recElement.CreatedDate) {
                        const formattedDate = this.formatDateManually(recElement.CreatedDate);
                        recElement.CreatedDate = formattedDate;
                    }
                })
                this.filterRecord = result;
                this.recordSize = this.filterRecord.length;
                this.updatefilterListView();
                if (this.isShowPopUp.length != 0) {
                    this.showToast('List View Updated', 'List View Updated Successfully', 'success');
                }
                this.isSaveFilter = false;
                this.isRecord = false;
                this.isFilter = true;
            }

        }).catch(error => {
            this.error = error;
        });

    }

    listViewControlsHandler() {
        if (this.isListViewControls == true) {
            this.isListViewControls = false;
        } else {
            this.isListViewControls = true;
        }
    }

    fieldDisplayHandler() {
        this.isFieldDisplay = true;
        this.isListViewControls = false;
    }

    listNameChangeHandler(event) {
        this.selectedListViewSharing = event.detail.value;
        if (this.selectedListViewSharing == '') {
            this.isSharingForAnyOne = true;
        } else {
            this.isSharingForAnyOne = false;
        }
        console.log('data sharing----', this.selectedListViewSharing);

    }

    handleNewListView() {
        this.selectedListViewSharing = null;
        this.selectedTarget = null
        this.listViewName = null;
        this.listViewAPiName = null;
        this.groupList = [];
        this.groups = [];
        this.isCreateListView = true;
        this.newClone = 'New';
        this.isListViewControls = false;
    }

    cancelCreateListView() {
        this.isCreateListView = false;
    }

    saveListViewHandler() {
        let columnNameList = [];
        this.listViewData = [];
        let x = true;
        this.columns.forEach(ele => {
            if (ele.fieldName) {
                if (x) {
                    let name = `${this.sObjectAPIName.toUpperCase()}.${ele.fieldName.toUpperCase()}`;
                    columnNameList.push(name);
                    x = false;
                }

            }
        })
        if (this.isInputValid()) {
            createListView({ sObjectName: this.sObjectAPIName.toUpperCase(), listViewLabelName: this.listViewName, listViewApiName: this.listViewAPiName, columnsList: columnNameList }).then(res => {
                if (res) {
                    this.gettingListViewHandler(this.sObjectAPIName);
                    this.showToast('List View Created', 'List View Create Successfully', 'success');
                    this.isCreateListView = false;
                }
            })
        }

    }

    listNameChange(event) {
        this.listViewName = event.detail.value;
        this.listViewAPiName = this.returnApiName(this.listViewName);
    }

    returnApiName(listName) {
        let listAPIName;
        for (let i = 0; i < listName.length; i++) {
            if (i == 0) {
                listAPIName = listName[i];
            } else {
                if (listName[i] == ' ') {
                    listAPIName += '_'
                } else {
                    listAPIName += listName[i];
                }
            }
        };
        return listAPIName;
    }

    listApiNameChange(event) {
        this.listViewAPiName = event.detail.value;
        console.log('data sharing----', this.listViewAPiName);

    }

    listNameChangeHandler(event) {
        this.selectedListViewSharing = event.detail.value;
        if (this.selectedListViewSharing == 'ShareListViewWithGroupsOfUsers') {
            this.isSharingForAnyOne = true;
        } else {
            this.groupList = [];
            this.groups = [];
            this.isSharingForAnyOne = false;
        }
    }

    //check input validation of appointment
    isInputValid() {
        let isValid = true;
        let inputNameFields = this.template.querySelectorAll('.input');
        inputNameFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;
    }

    updatefilterListView() {
        let columnNameList = [];
        let x = true;
        this.columns.forEach(ele => {
            if (ele.fieldName) {
                if (x) {
                    let name = `${this.sObjectAPIName.toUpperCase()}.${ele.fieldName.toUpperCase()}`;
                    columnNameList.push(name);
                    x = false;
                }

            }
        })
        if (this.listViewLabel) {
            let lslabel = this.listViewData.filter(ele => ele.label == this.listViewLabel);
            if (lslabel.length != 0) {
                updateListViewMetadata({ sObjectName: this.sObjectAPIName.toUpperCase(), listViewLabelName: lslabel[0].label, listViewApiName: lslabel[0].value, columnsList: columnNameList, filtersJSON: JSON.stringify(this.filterList), shareToList: JSON.stringify(this.groupList), filterScop: this.ownerFilterValue }).then(res => {
                    if (res) {
                        //  this.showToast('List View Created', 'List View Create Successfully', 'success');
                    }
                })
            }
        }

    }

    //clone list view creating 
    handleCloneCreateListView() {
        this.selectedListViewSharing = null;
        this.selectedTarget = null;
        this.isCreateListView = true;
        this.newClone = 'Clone';
        this.isListViewControls = false;
        this.groupList = [];
        this.groups = [];
        let lslabel = [];
        if (this.listViewLabel) {
            lslabel = this.listViewData.filter(ele => ele.label == this.listViewLabel);
            this.listViewName = `Copy of ${lslabel[0].label}`;
            this.listViewAPiName = this.returnApiName(this.listViewName);
        }
    }

    //delete list view Modal handler
    handleDeleteListView() {
        this.isDeleteListView = true;
        this.isListViewControls = false;
    }

    //cancel delete list view modal
    cancelDeleteListView() {
        this.isDeleteListView = false;
    }

    //delete list view handler
    deleteListViewHanlder() {
        if (this.listViewLabel) {
            let lslabel = this.listViewData.filter(ele => ele.label == this.listViewLabel);
            if (lslabel.length != 0) {
                deleteListViewMetadata({ listViewName: lslabel[0].value, sObjectName: this.sObjectAPIName.toUpperCase() }).then(res => {
                    if (res) {
                        this.gettingListViewHandler(this.sObjectAPIName);
                        this.showToast('List View Deleted', 'List View Deleted Successfully', 'success');
                    }
                })
            }
        }
        this.isDeleteListView = false;
    }

    //sharing Setting modal handler
    sharingSettingHandle() {
        this.groupList = [];
        this.groups = [];
        this.selectedListViewSharing = null;
        this.isSharingSetting = true;
        this.isListViewControls = false;
    }

    //edit list filter Handler
    editListFilter() {
        this.isListViewControls = false;
        this.handleFilterAscDec();
    }

    //cancel sharing setting handler
    cancelSharingSetting() {
        this.isSharingSetting = false;
    }

    //save sharing Setting Handler
    saveSharingSettingHandle() {
        this.updatefilterListView();
    }

    //handle target selection 
    handleTargetSelection(event) {
        this.isGroup = false;
        this.selectedTarget = event.detail.value;
    }

    //getting group to assign in sharing setting 
    gettingGroup() {
        this.groups = [];
        gettingRecords({ typeOfGroup: this.selectedTarget, key: this.searchKeyOfGroup }).then(group => {
            if (group) {
                this.isGroup = true;
                this.groups = group;
            }
        })
    }


    //search group handler
    searchGroupHandler(event) {
        this.searchKeyOfGroup = event.target.value;
        this.gettingGroup();

    }

    //select group handler
    selectGroupHandler(event) {
        let groupName = event.currentTarget.dataset.group;
        let groupIcon = event.currentTarget.dataset.icon;
        let groupType = event.currentTarget.dataset.grouptype;
        let groupObj = { name: groupName, icon: groupIcon, groupType: groupType };
        this.groupList.push(groupObj);
        this.isGroup = false;
    }

    //handler remove 
    handleRemove(event) {
        let pillRemove = event.currentTarget.dataset.pill;
        this.groupList = this.groupList.filter(ele => ele.name !== pillRemove);
    }

    //handle rename list view
    handleRenameListView() {
        this.newClone = 'Rename';
        let lslabel = [];
        if (this.listViewLabel) {
            lslabel = this.listViewData.filter(ele => ele.label == this.listViewLabel);
            this.listViewName = lslabel[0].label;
            this.listViewAPiName = lslabel[0].value;
        }
        this.isRenameListView = true;
        this.isListViewControls = false;
    }

    //list rename  change
    listRenameChnage(event) {
        this.listViewName = event.target.value;
    }

    saveRenameListView() {
        let columnNameList = [];
        let x = true;
        this.columns.forEach(ele => {
            if (ele.fieldName) {
                if (x) {
                    let name = `${this.sObjectAPIName.toUpperCase()}.${ele.fieldName.toUpperCase()}`;
                    columnNameList.push(name);
                    x = false;
                }
            }
        })
        updateListViewMetadata({ sObjectName: this.sObjectAPIName.toUpperCase(), listViewLabelName: this.listViewName, listViewApiName: this.listViewAPiName, columnsList: columnNameList, filtersJSON: JSON.stringify(this.filterList), shareToList: JSON.stringify(this.groupList), filterScop: this.ownerFilterValue }).then(res => {
            if (res) {
                this.isRenameListView = false;
                this.gettingListViewHandler(this.sObjectAPIName);
                this.showToast('List View Updated', 'List View update Successfully', 'success');
            }
        }).catch(error => {
            this.error = error;
        })
    }

    //cancel modal of rename list view
    cancelRenameListView() {
        this.isRenameListView = false;
    }


    handleRichTextChange(event) {
        this.richTextAreaVal = event.target.value;
    }

    dataTableHandler(event) {
        let values = event.target.draftValues;
        if (this.tempArrDraftValue.length == 0) {
            this.tempArrDraftValue = event.target.draftValues;
            let keys = Object.keys(this.tempArrDraftValue[0]);
            this.richfieldApiNames.forEach(iterateField => {
                this.myRichTextId = this.tempArrDraftValue[0]['Id'];
                if (keys.includes(iterateField)) {
                    this.richTextAreaVal = this.tempArrDraftValue[0][iterateField];
                    this.isRichText = true;
                }
            })
        } else {
            values.forEach(ele => {
                let obj = this.tempArrDraftValue.filter(key => key.Id === ele.Id);
                if (obj.length != 0) {
                    let keys = Object.keys(ele);
                    this.richfieldApiNames.forEach(iterateField => {
                        if (keys.includes(iterateField)) {
                            if (obj[0][iterateField] != ele[iterateField]) {
                                obj[0][iterateField] = ele[iterateField];
                                this.richTextAreaVal = ele[iterateField];
                                this.myRichTextId = ele['Id'];
                                this.isRichText = true;
                            }
                        }
                    })
                } else {
                    let keys = Object.keys(ele);
                    this.richfieldApiNames.forEach(iterateField => {
                        if (keys.includes(iterateField)) {
                            this.richTextAreaVal = ele[iterateField];
                            this.isRichText = true;
                        }
                    })
                    this.tempArrDraftValue.push(ele);
                    this.myRichTextId = ele['Id'];
                }
            })
        }
    }



    // handlerClick(event){        
    //     const data = event.target;
    //     console.log('event-target=====---->',event.target);

    //     console.log('event-detail=====---->',event.detail);
    // }

    cancelRichTextHandler() {
        this.isRichText = false;
    }

    saveRichTextHandler() {
        this.updateDraftValues.push({ Id: this.myRichTextId, All_Information__c: this.richTextAreaVal });
        this.isRichText = false;
    }

    updatesObjectRecordHandler(updateJson) {
        updatesObjectRecord({ data: JSON.stringify(updateJson) }).then(res => {
            if (res) {
                this.draftValues = [];
                this.updateDraftValues = [];
                this.tempArrDraftValue = [];
                this.myRichTextId = null;
                this.richTextAreaVal = null;
                this.getDataHandler();
                this.showToast('Updated Related Records', 'The changes made are successfully updated', 'success');
            }
        }).catch(error => {
            this.error = error;
        });
    }

    timeRuningHandler() {
        this.timer = 0;
        this.timeSet = setInterval(() => {
            this.timeAsc();
        }, 60000);
    }

    timeAsc() {
        if (this.timer == 60) {
            let timeBody = 'an hour';
            this.template.querySelector('.time').innerHTML = timeBody;
            clearInterval(this.timeSet);
        } else if (this.timer == 0) {
            this.template.querySelector('.time').innerHTML = 'few seconds';
            this.timer++;
        } else {
            let timeBody = `${this.timer++} minutes`;
            this.template.querySelector('.time').innerHTML = timeBody;
        }
    }

    filterOwner() {
        this.isOwnerFilter = true;
    }

    changeFilterByOwnerHandler(event) {
        this.ownerFilterValue = event.detail.value;
    }

    ownerFilterHandler() {
        if (this.ownerFilterValue == 'Everything') {
            this.template.querySelector('.ownerFilterText').innerHTML = `All ${this.sObjectAPIName}`;
            this.isSaveFilter = true;
        } else if (this.ownerFilterValue == 'Mine') {
            this.template.querySelector('.ownerFilterText').innerHTML = `My ${this.sObjectAPIName}`;
            this.isSaveFilter = true;
        } else if (this.ownerFilterValue == 'ScopingRule') {
            this.template.querySelector('.ownerFilterText').innerHTML = 'Filter By Scope';
            this.isSaveFilter = true;
        }

        this.isOwnerFilter = false;
    }

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