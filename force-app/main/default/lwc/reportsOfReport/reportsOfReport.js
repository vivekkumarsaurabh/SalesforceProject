import { LightningElement, wire } from 'lwc';
import getAllReports from '@salesforce/apex/ReportOnReports.getAllReports';
import { CurrentPageReference } from 'lightning/navigation';

export default class ReportsOfReport extends LightningElement {
    isLoading = false;
    isFilter = false;
    isPopovers = false;
    error;
    baseUrl;    
    searchValue;
    selectedFilter;
    operator;
    filterValue;
    selectedValueHeading;
    reports = [];
    ownerList = [];
    folderList = [];
    formatList = [];
    filterValues = [];    
    column = [];
    selectedDisplayFilter = [];
    filters = [{ label: 'Filter By Name', value: 'Name' }, { label: 'Filter By Created Date', value: 'CreatedDate' }, { label: 'Filter By Owner', value: 'Owner.Name' }];
    filterOption = [{ label: 'Owner Name', value: 'Owner.Name' }, { label: 'Folder Name', value: 'FolderName' }, { label: 'Format', value: 'Format' }];
    filterOperation = [{ label: 'equals', value: '=' }];
    

    //connected call back 
    connectedCallback() {
        this.getAllReport(null, '');
    }

    //for getting base Url
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference) {
            this.baseUrl = window.location.origin;
        }
    }

    //getting reports data using apex
    getAllReport(columnFilters, searchKey) {
        this.isLoading = true;
        if (searchKey == null || searchKey == undefined) {
            searchKey = '';
        }
        getAllReports({ columnFilterList: JSON.stringify(columnFilters), key: searchKey }).then(reports => {
            if (reports) {
                this.reports = reports;
                this.isLoading = false;
            }
            this.reports.forEach(ele => {
                if (!this.ownerList.includes(ele.ownerName)) {
                    this.ownerList.push(ele.ownerName);
                }

                if (!this.folderList.includes(ele.folderName)) {
                    this.folderList.push(ele.folderName);
                }

                if (!this.formatList.includes(ele.format)) {
                    this.formatList.push(ele.format);
                }
            })
        }).catch(error => {
            this.error = error;
        });
    }

    //open filter modal
    openFilterReportHandler() {
        this.isFilter = true;
    }

    //cancel filter modal handler
    cancelFilterModal() {
        this.isFilter = false;
    }

    //open report handler
    handleClick(event) {
        let reportId = event.currentTarget.dataset.id;
        let url = this.baseUrl + '/lightning/r/Report/' + reportId + '/view';
        window.open(url, '_blank');
    }

    //save filter modal 
    saveFilterModal() {
        if ((this.selectedFilter == null || this.selectedFilter == undefined) || (this.operator == null || this.operator == undefined) || (this.filterValue == null || this.filterValue == undefined)) {
            this.getAllReport(null, '');
        } else {
            let filterObject = { fieldName: this.selectedFilter, value: this.filterValue };
            this.column.push(filterObject);
            this.getAllReport(this.column, this.searchValue);
        }
        this.isFilter = false;
        this.isPopovers = false;
    }

    //search handler
    searchHandler(event) {
        this.searchValue = event.detail.value;
        this.getAllReport(this.column, this.searchValue);
    }

    //handler filter
    handleFilter(event) {
        this.selectedFilter = event.detail.value;
        if (this.selectedFilter == 'Owner.Name') {
            this.filterValues = [];
            this.ownerList.forEach(ele => {               
                    this.filterValues.push({ label: ele, value: ele });             
            })
        } else if (this.selectedFilter == 'FolderName') {
            this.filterValues = [];
            this.folderList.forEach(ele => {
                this.filterValues.push({ label: ele, value: ele });
            })
        } else {
            this.filterValues = [];
            this.formatList.forEach(ele => {
                this.filterValues.push({ label: ele, value: ele });
            })
        }
    }

    //handle operator 
    handlerOperation(event) {
        this.operator = event.detail.value;
    }

    //handle filter value
    handleFilterVlaue(event) {
        this.filterValue = event.detail.value;
    }

    //clear handler 
    handleClear() {
        this.selectedFilter = null;
        this.operator = null;
        this.filterValue = null;
        this.column = [];
        this.isFilter = false;
        this.isPopovers = false;
        this.getAllReport(null, '');
    }

    //folder Name Handler
    folderNameHanlder() {
        this.selectedValueHeading = 'Folder Name';
        this.selectedFilter = 'FolderName';
        this.filterValues = [];
        this.folderList.forEach(iterateFolter => {
            this.filterValues.push({ label: iterateFolter, value: iterateFolter });
        })
        this.isPopovers = true;
    }

    //format Name Handler
    formatNameHandler() {
        this.isPopovers = true;
        this.selectedValueHeading = 'Format';
        this.selectedFilter = 'Format';
        this.filterValues = [];
        this.formatList.forEach(iterateFormat => {
            this.filterValues.push({ label: iterateFormat, value: iterateFormat });
        })
        this.isPopovers = true;
    }

    //owner Name Handler
    ownerNameHandler() {
        this.selectedValueHeading = 'Owner Name';
        this.selectedFilter = 'Owner.Name';
        this.filterValues = [];
        this.ownerList.forEach(iterateOwner => {         
                this.filterValues.push({ label: iterateOwner, value: iterateOwner });            
        })
        this.isPopovers = true;
    }

    //filter close Handler
    filterCloseHandler() {
        this.isPopovers = false;
    }

    //clear filter handler
    clearFilter() {
        this.filterValues = [];
    }
}