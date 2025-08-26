public class IntegerClass {
    public static void formatmethod(){
        // Declare year,month and day one by one
        
        String Year = '2023';
        
        String Month = '4';
        
        String Day = '5';
        
        // Concatenate all of them into a string
        
        String string_type = Year + '-' + Month + '-' + Day;
        
        // Convert string-Date to Date
        
        Date converted_date = date.valueOf(string_type);
        
        system.debug(converted_date);
        
        // format()
        
        system.debug(converted_date.format());
        
        
        //valueOf(StringToInteger) 
        
        string str='123';
        
        Integer a=Integer.valueOf(str);
        System.debug(a);
        
        //valueOf(FieldValue)
        
    }
    
}