public without sharing  class A{
    public static void method(){
        System.debug('hello World ....');
    }
    
    public with sharing class B{
        public B(){
            method();   
        }
    }
}