/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 26/04/2024
* @Description : This is Wrapper Class for get Whatsapp Response in Whatsapp Integration;
******************************************************************/
public class WhatsAppMessage {
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
        public contacts[] contacts;
        public List<messages> messages;
    }
    public class metadata {
        public String display_phone_number;
        public String phone_number_id;
    }
    public class contacts {
        public profile profile;
        public String wa_id;
    }
    public class profile {
        public String name;
    }
    public class messages {
        public String fromNumber;
        public String id;
        public String timestamp;
        public text text;
        public String type;
        public context context;
        public button button;
        public image image;
        public audio audio;
        public video video;
    }
    public class context{
        public String fromNumber;
        public String id;
    }
    public class text {
        public String body;
    }
    public class image {
        public String mime_type;
        public String sha256;
        public String id;
        public String caption;
    }
    public class audio {
        public String mime_type;
        public String sha256;
        public String id;
        public Boolean voice;
    }
    public class video {
        public String mime_type;
        public String sha256;
        public String id;
        public Boolean caption;
    }
    public class button {
        public String payload;
        public String text;
    }
    public class document {
        public String filename;
        public String mime_type;
        public String sha256;
        public String id;
    }
}