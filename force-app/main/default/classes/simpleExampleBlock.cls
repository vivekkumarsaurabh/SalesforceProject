public class simpleExampleBlock {

      static{
        System.debug('Hello');
    }//It always Execute
    {
        System.debug('World');
    }
    
    public simpleExampleBlock(){
        System.debug('test');
        
    }  
    
    public static void method(){
        System.debug('testing 2');
    }

}