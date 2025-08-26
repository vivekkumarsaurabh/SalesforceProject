public without sharing  class A{
    public static void method(){
        System.debug('hello');
    }
    
    public with sharing class B{
        public B(){
            method();   
        }
    }
}