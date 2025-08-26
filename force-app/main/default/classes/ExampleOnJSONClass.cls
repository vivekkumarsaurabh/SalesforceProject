public class ExampleOnJSONClass {
    
    public static void method(){
        String jsonInput = '{\n' +
            ' "description" :"An appliance",\n' +
            ' "accessories" : [ "powerCord", ' + 
            '{ "right":"door handle1", ' + 
            '"left":"door handle2" } ],\n' +
            ' "dimensions" : ' + 
            '{ "height" : 5.5 , ' + 
            '"width" : 3.0 , ' + 
            '"depth" : 2.2 },\n' +
            ' "type" : null,\n' +
            ' "inventory" : 2000,\n' +
            ' "price" : 1023.45,\n' +
            ' "isShipped" : true,\n' +
            ' "modelNumber" : "123"\n' +
            '}';
        
        
        String str = '{'+'"Name": "Vivek"'+'}';
        
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsonInput);
        System.debug(m);
        
        List<Object> a = (List<Object>)m.get('accessories');
        System.debug(a[1]);     
        System.assertEquals('An appliance', m.get('description'));
        Map<String, Object> mapOfJSon = (Map<String, Object>)JSON.deserializeUntyped(str);
        System.debug(mapOfJSon.get('Name'));
    }
}