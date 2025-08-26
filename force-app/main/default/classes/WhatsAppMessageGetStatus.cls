/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 26/04/2024
* @Description : This is Wrapper Class for get Whatsapp Response in Whatsapp Integration;
******************************************************************/
public class WhatsAppMessageGetStatus {
    public String objectName;
    public List<entry> entry;
    public class entry {
        public String id;
        public List<changes> changes;
    }
    public class changes {
        public value value;
        public String field;
    }
     public class value {
        public String messaging_product;
        public metadata metadata;
        public statuses[] statuses;
    }
    
    public class statuses{
        public String id;
        public String status;
        public String timestamp;
        public String recipient_id;
    }
     public class metadata {
        public String display_phone_number;
        public String phone_number_id;
    }
}