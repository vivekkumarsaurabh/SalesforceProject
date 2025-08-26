public class TestClass {
  
    {
        System.debug('test000');
    }
    private Integer g=09;
    
    static{
        SYstem.debug('teesting');
    }
       //public static Integer var=102;
     //private final Integer var=100;
    Integer valuuu=100;
    //constructor
    public TestClass(Integer k){
        System.debug('constructor'+k);
        
        
    }
    public TestClass(String p){
    
        System.debug('const '+p);
    }
    
//inner class
 public class SecondInnerClass1{
    
        public void fun1(){
            System.debug('Hello');
        }
    
    }
    
    //inner class
public class ThirdInnerClass2{
    
      
       public void fun2(){
          
            System.debug('World');
        }
    
    public Integer sum(Integer a,Integer b){
        return a+b;
    }
    
    }
       
 //String var='vivek';
    
    
   // public enum Namm{121,123,321}
           
    public void testMethods(){
        
        
        // var = 'kumar';
        
      //var=200;
        valuuu=2000;
        //System.debug(valuuu);
        
       // System.debug(var);
        System.debug('Main Class Method');
        
       /** String str='monday';
        switch on str{
            when 'monday'{
                System.debug('monday hai');
                       }
            when 'tuesday'{
                System.debug('tuesday hai');
            }
                when else{
                    System.debug('Nothing');
                         }
        }
        **/
         //dowhile loop
        //Integer coin=1;
       /** do{
            System.debug(coin);
            coin++;
        }while(coin<=10); **/
        
            
        //while loop
      /**  integer i=1;
        while(i<10){
            System.debug(i);
            i++;
        }
       **/
        //Infinite Loop
       /** while(true){
            System.debug('Infinite Loop');
        }**/
        
       /** integer a=5;
        //1001
        //101
        System.debug(a>>2);**/
        
       // System.debug(a<<2);
        
      //   Namm vi=Namm.vivek;
       // System.debug(vi);
       
        
        //call Innner class
       
       //  SecondInnerClass1 obj11=new SecondInnerClass1();
       // obj11.fun1();
    
      
        
      // ThirdInnerClass2 obj22=new ThirdInnerClass2();
       // obj22.fun2();
    }
    
    public void testMethods2(){
        System.debug(valuuu);
    }
}