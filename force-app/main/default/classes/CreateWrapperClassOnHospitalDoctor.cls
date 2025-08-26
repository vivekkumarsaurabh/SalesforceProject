public class CreateWrapperClassOnHospitalDoctor {    
    public static List<HospitalDoctorWrapper> returnHospitalDoctorData(){
        List<HospitalDoctorWrapper> listOfHosDocRec = new List<HospitalDoctorWrapper>();
        List<DoctorWrapper>  listOfDoctorWrapper = new List<DoctorWrapper>();        
        for(Doctors__c iterateHosRec :  [SELECT Name, Doctor_Ammount__c, Doctor_Email__c FROM Doctors__c WHERE Name != Null]){
            DoctorWrapper createDocSingleRec = new DoctorWrapper();
            createDocSingleRec.DoctorName = iterateHosRec.Name;
            createDocSingleRec.DocAmmount = iterateHosRec.Doctor_Ammount__c;
            createDocSingleRec.DocEmail = iterateHosRec.Doctor_Email__c;  
            listOfDoctorWrapper.add(createDocSingleRec);
        }        
        for(Hospital__c itrateRec :[SELECT Name, Patient_Address__c, Patient_Email__c FROM Hospital__c WHERE Name != Null]){
            HospitalDoctorWrapper createHostDocWrapper = new HospitalDoctorWrapper();
            createHostDocWrapper.HospitalName = itrateRec.Name;
            createHostDocWrapper.PatientAddress = itrateRec.Patient_Address__c;
            createHostDocWrapper.PatientEmail = itrateRec.Patient_Email__c; 
            createHostDocWrapper.docWrap = listOfDoctorWrapper;  
            listOfHosDocRec.add(createHostDocWrapper);
        }
        return listOfHosDocRec;
    }    
    
    public static void printData(){
        List<HospitalDoctorWrapper> listOfHosDoc = returnHospitalDoctorData();
        for(HospitalDoctorWrapper iterateRec :listOfHosDoc){
            System.debug('Wrapper Class Record ==> '+iterateRec);
        }
    }
    
    public  class DoctorWrapper{
        public String DoctorName;
        public decimal DocAmmount;
        public String DocEmail;
    }
    
    public class HospitalDoctorWrapper{
        Public String HospitalName;
        public String PatientAddress;
        public String PatientEmail;  
        public List<DoctorWrapper> docWrap;
    }
}