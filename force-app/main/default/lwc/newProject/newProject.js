import { LightningElement } from 'lwc';

export default class NewProject extends LightningElement {
    contacts=[
        {
            Id: 1,
            Name: "Vivek",
            Title: "VP of Engineering",
          },
          {
            Id: 2,
            Name: "Saurabh",
            Title: "VP of Sales",
          }, 
    ];
    firstName = '';
    lastName = '';
    firstnameField(event){
        this.firstName = event.target.value;
    }
    lastNameField(event){
        this.lastName = event.target.value;
    }
    
    fullName = '';

    handlefield(){
         this.fullName=this.firstName+'  '+ this.lastName;    
        
    }
}