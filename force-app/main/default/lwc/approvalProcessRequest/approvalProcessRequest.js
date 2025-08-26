import { LightningElement } from 'lwc';
import getAllApprovalRequest from '@salesforce/apex/ApprovalProcessRequest.getAllApprovalRequest';
import approveRejectProcessInstance from '@salesforce/apex/ApprovalProcessRequest.approveRejectProcessInstance';
const columns = [
    { label: 'Related To', fieldName: 'relatedToId', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'name' }, target: '_blank' } },
    { label: 'Type', fieldName: 'objectType', sortable: true, type: 'text' },
    { label: 'Status', fieldName: 'status', sortable: true, type: 'text' },
    { label: 'Most Recent Approvar', fieldName: 'mostRecentApprovalUserId', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'mostRecentApprovalName' }, target: '_blank' } },
    { label: 'Submit To', fieldName: 'submitUserIds', type: 'url', sortable: true, typeAttributes: { label: { fieldName: 'submitUserName' }, target: '_blank' } },
    { label: 'Date Submitted', fieldName: 'createDate', sortable: true, type: 'text' }
]

export default class ApprovalProcessRequest extends LightningElement {
    data = [];
    isLoading = false;
    isBtnDisabled = true;
    columns = columns;
    sortBy;
    error;
    approvalAction;
    sortDirection;
    rejectLabel = 'Reject';
    approveLabel = 'Approve';
    selectedRows = [];


    //connected call back
    connectedCallback() {
        this.getAllRequestData();
    }

    //get all request data
    getAllRequestData() {
        this.isLoading = true;
        getAllApprovalRequest().then(approvalReqData => {
            if (approvalReqData) {
                approvalReqData.forEach(ele => {
                    ele['relatedToId'] = '/' + ele.objectId;
                    ele['mostRecentApprovalUserId'] = '/' + ele.mostRecentApprovalId;
                    ele['submitUserIds'] = '/' + ele.submitUserId;
                    ele['createDate'] = this.formatDateManually(ele.dateSubmitted);
                })
                this.data = approvalReqData;
                this.isLoading = false;
                this.isBtnDisabled = true;
                this.selectedRows = [];
            }
        }).catch(err => {
            this.error = err;
        })
    }

    //sort 
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);

    }

    //sorting method
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
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

    //approve Handler
    approveHandler() {
        if (this.selectedRows.length > 0) {
            let approvalRequestlist = [];
            this.selectedRows.forEach(ele => {
                approvalRequestlist.push(ele.processInstanceId);
            })
            this.approvalAction = 'Approve';
            this.changeStatusApprovalProcessHandler(approvalRequestlist, this.approvalAction);
        }
    }

    //reject Handler
    rejectHandler() {
        if (this.selectedRows.length > 0) {
            let approvalRequestlist = [];
            this.selectedRows.forEach(ele => {
                approvalRequestlist.push(ele.processInstanceId);
            })
            this.approvalAction = 'Reject';
            this.changeStatusApprovalProcessHandler(approvalRequestlist, this.approvalAction);
        }
    }


    //change status approval process handler
    changeStatusApprovalProcessHandler(requestList, actionParam) {
        approveRejectProcessInstance({ processInstanceList: requestList, action: actionParam }).then(res => {
            if (res) {
                console.log('response sucessfully');                
                this.getAllRequestData();   
            }
        }).catch(err => {
            this.error = err;
        })
    }


    getSelectedName(event) {
        this.selectedRows = event.detail.selectedRows
        if(this.selectedRows.length == 1){
            this.approveLabel = 'Approve';
            this.rejectLabel = 'Reject';
            this.isBtnDisabled = false;
        }else if(this.selectedRows.length > 1){
            this.approveLabel = 'Approve All';
            this.rejectLabel = 'Reject All';
            this.isBtnDisabled = false;   
        }else{
            this.rejectLabel = 'Reject';
            this.approveLabel = 'Approve';
            this.isBtnDisabled = true;  
        }
        console.log('selectedRows ====--->', JSON.stringify(this.selectedRows));
    }
}