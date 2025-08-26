public class ObjectTest {
    public static void LeepYear(Integer year){
        if(year != null){
            if(Math.mod(year,4)==0 && Math.mod(year,400)==0 || Math.mod(year,100)!=0){
                System.debug('Year is leep year');
            }else{
                System.debug('Year is not leep year');
            }
        }else{
            System.debug('Enter valid Input');
        }
        
    }
    
    
}