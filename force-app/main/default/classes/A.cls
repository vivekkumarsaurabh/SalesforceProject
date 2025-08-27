public without sharing  class A{
    public static void method(){
        System.debug('hello World 2');
    }
    
    public with sharing class B{
        public B(){
            method();   
        }
    }
}