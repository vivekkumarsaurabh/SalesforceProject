import { LightningElement, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

export default class ListViewComponent extends LightningElement {

    listViewRecords;
    error;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountInfo;

    @wire(getListUi, { objectApiName: ACCOUNT_OBJECT, listViewApiName: 'AllAccounts' })
    listViewData({ error, data }) {
        if (data) {
            this.listViewRecords = data.records.records;
        } else if (error) {
            this.error = error;
        }
    }

}