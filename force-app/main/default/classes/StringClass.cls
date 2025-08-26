public class StringClass {
    public static void stringMethods(){
        
       //abbreviate(maxWidth)
        String s='VivekKumar';
        String s1=s.abbreviate(4);
        //System.debug(s1);
        
        //abbreviate(maxWidth,offset)
        
       String str='VivekKumarSaurabh';
        String str1=str.abbreviate(10,5);
       // System.debug(str1);
        
        //capitalize()
        
        String a='vivek';
        String b=a.capitalize();
        //System.debug(b);
        
        //center(size)
        String str2='vivek';
        String name=str2.center(9);
        //System.debug(name);
        
        //center(size,paddingString)
        String str3='vivek';
        String name1=str3.center(9,'-');
        //System.debug(name1);
        
        //charAt(index)
        String str4='vivekkumarsaurabh';
        integer name2=str4.charAt(0);
        // System.debug(name2);
        
        //codePointAt(index)
        String str5='%vivek';
        integer name3=str5.codePointAt(0);
        //System.debug(name3);
        
        //codePointBefore(index)
       String str6='vivek';
        integer nam=str6.codePointBefore(1);
        //System.debug(nam);
        
        
       //codePointCount(beginIndex,endIndex);
        String str8='vivek';
        integer nam3=str8.codePointCount(0,3);
        //System.debug(nam3);
        
        //compareTo(secondString)
        String str9='vivek';
        String nam4='viv';
        integer i=str9.compareTo(nam4);
        //System.debug(i);
        
        //contains(substring)
        String str0='vivek';
        String n='vivp';
        boolean k=str0.contains(n);
        //System.debug(k);
        
        //containsAny(inputString)
        String str10='vivek';
        boolean ce=str10.containsAny('es');
        // System.debug(ce);    
        
        //containsIgnoreCase(substring);
        String str11='vivek';
        boolean d=str11.containsIgnoreCase('VI');
       // System.debug(d);
        
        //containsNone(inputString);
        
        String str12='kumar';
       // System.debug(str12.containsNone('uk'));
        
        //containsOnly(inputString)
        
        String str13='Saurabh';
        //System.debug(str13.containsOnly('Saurabh'));
        
        //countMatches(Substring)
         String str14='Hello Hello';
        
        //System.debug(str14.countMatches('Hello'));
        
        //deleteWhiteSpace()
        String str15 = 'Vivek Kumar Saurabh';
        //System.debug(str15.deleteWhitespace());
        
        //difference()
        String str16 = 'Vivek Kumar Saurabh';
        //System.debug(str16.difference('Vivek'));
        
        //endsWith(suffix)
        String str17='Vivek Kumar Saurabh';
       // System.debug(str17.endsWith('Saurabh'));
        
       //endsWithIgnoreCase(Suffix)
       String str18='Vivek Kumar Saurabh';
        //System.debug(str18.endsWithIgnoreCase('saurabh'));
        
        //equals(SecondString)
        String str19='Vivek Kumar Saurabh';
        //System.debug(str19.equals('Vivek Kumar Saurabh'));
        
        //equals(StringOrId);
        Object str20='str123';
        //System.debug(str20.equals('str123'));
        
        //equalsIgnoreCase()
        String str21='vivek';
       // System.debug(str21.equalsIgnoreCase('VIVEK'));
        
        //escapeCsv();
        String str22='vivek,"Kumar"';
        //System.debug(str22.escapeCsv());
        
        //ecapeEcmaScript()
        //String str23='VivekSau/rabh';
        String str23='"Vivek"Sau/rabh';
        //System.debug(str23.escapeEcmaScript());
        
        
        //escapeHtmal3()
        
        String str24='"<Vivek,Kumar&Saurabh>"';
        //System.debug(str24.escapeHtml3());
        
        //esapeHtml4()
       
        String str25='"<Vivek,Kumar&Saurabh>"';
        //System.debug(str25.escapeHtml4());
        
        
        //escapeJava()
        String str26='Vivek,:"KumarSaurabh"';
        //System.debug(str26.escapeJava());
        
        //escapeSingleQuotes()
        String str27='\'Hello Jason\''; //'Hello Jason'
        String str28=String.escapeSingleQuotes(str27);
        //System.debug(str28);
        
        
       //escapeUnicode()
       String str29 = 'Vivêk ê';
        //System.debug(str29.escapeUnicode()); //convert into unicode 
        
        //escapeXml()
        String str30='"<HTML>"';
        //System.debug(str30.escapeXml());
        
        
        String template = '{0} am so {1}';
//List<String> parameters = new List<String> {'I','happy'};
        List<Object> parameters=new List<Object>{'I',DateTime.newInstance(2018, 11, 15)};
String formatted = String.format(template, parameters);
//System.debug ('Newly formatted string is:' + formatted);
        
        //fromCharArray()
        //String str31='{0} am so Lucky';
        List<Integer> para = new Integer[]{73};
            String formated = String.fromCharArray(para);
       // System.debug(formated);
        
        
        //getChars()
        String str32='Vivek';
        Integer[] chars=str32.getChars();
        //System.debug(chars[1]);
         
        
        //getCommonPrefix(String)
        List<String> li=new List<String>{'VivekSaurabh','VivekKumar'};
           String str33=String.getCommonPrefix(li);
           // System.debug(str33);
        
        //getLevenshteinDistance(StringToCompare)
        String str34='Vivek Kumar';
        Integer l=str34.getLevenshteinDistance('Vivek Saurabha');
        //System.debug(l);
        
        //getLevenshteinDistance(StringToCompare,thresold)
        String str35='Vivek Kumar';
        Integer f=str35.getLevenshteinDistance('Vivek saurabh',9);
        System.debug(f);
        
        //hashCode()
        String str36='vivek kumar';
        //System.debug(str36.hashCode());
       
        //indexOf(Substring)
        String str37='vivekkumar';
       // System.debug(str37.indexOf('skku'));
        
        //indexOf(Substring,index)
        String str38='vivekkumarsaurabh';
        //System.debug(str38.indexOf('kk',9));
      
        //indexOfAny(Substring)
        String str39='vivekkumar';
        //System.debug(str39.indexOfAny('xm'));
        
        
       //indexOfAnyBut(Substring)
        String str40='vivek';
       // System.debug(str40.indexOfAnyBut('v'));
        
        //indexOfChar(Character)
        String str41='My name is vivek';
        //System.debug(str41.indexOfChar(97));
       
        //indexOfChar(Character,StartIndex);
        String str42='namea is vivek';
        //System.debug(str42.indexOfChar(97,6));
        
        //indexOfDifference(StringToCompare)
        String str43='vivek';
        //System.debug(str43.indexOfDifference('vivekS'));
        
        //indexOfIgnoreCase(Substring)
        String str44 = 'vivek';
        //System.debug(str44.indexOfIgnoreCase('VE'));
        
        //indexOfIgnoreCase(Substring, startPosition)
        String str45='kumarasur';
        //System.debug(str45.indexOfIgnoreCase('A',6));
        
        //isAllLowerCase()
        String str46='kumar';
        //System.debug(str46.isAllLowerCase());
        
        //isAllUpperCase()
        String str47='VIvek';
        //System.debug(str47.isAllUpperCase());
        
        //isAlpha()
        String str49='viv  ek';
        //System.debug(str49.isAlpha());
        
        //isAlphaSpace()
        String str50='vivek 123vk';
        //System.debug(str50.isAlphaSpace());
        
        //isAlphanumeric()
        String str51='vivek122%%';
        //System.debug(str51.isAlphanumeric());
        
        //isAlphanumericSpace()
        String str52='vivek kumar 121 %%%*&$&*$^';
       // System.debug(str52.isAlphanumericSpace());
        
        //isAsciiPrintable()
        String str53='!@#$%^&*()`~-_+={[}]|:<,>.?';
        //System.debug(str53.isAsciiPrintable());
        
        //isBlank(inputString)
           String str54='k';
          //  System.debug(String.isBlank(str54));
        
        //isEmpty()
        String str55='  ';
       // System.debug(String.isEmpty(str55));
        
        //isNotBlank(inputString);
       String str56='  ';
        //System.debug(str56.isNotBlank(str56));
       // System.debug(String.isNotBlank(str56));
        
        //isNumeric()
          String str57='12341';
        //System.debug(str57.isNumeric());
        
        //isNumericSpace()
        String str58='12 232';
        //System.debug(str58.isNumericSpace());
        
        //isWhiteSpace()
        String str59='12 23   53';
        //System.debug(str59.isWhiteSpace());
        
        //join(iterableObj,Separator)
        List<Integer> li1=new List<Integer>{10,20,40};
            //System.debug(String.join(li1,'-'));
        
        //LastIndexOf(substring)
        String str61='vivek';
        //System.debug(str61.LastIndexOf('v'));
        
        //LastIndexOf(substring,endposition)
        String str62='ijrvivekop';
        //System.debug(str62.LastIndexOf('v',2));
        
        
        //LastIndexOfChar(character)
        String str63='abcad';
        //System.debug(str63.LastIndexOfChar(97));
        
         //LastIndexOfChar(character,lastIndex)
          String str64='rtabcadp';
        //System.debug(str64.LastIndexOfChar(97,2));
        
        //LastIndexOfIgnorecase(substring)
        String str65='abcpqpe';
        //System.debug(str65.LastIndexOfIgnoreCase('PQ'));
        
          //LastIndexOfIgnorecase(substring,endPosition)
        String str66='abcpqpqei';
        //System.debug(str66.LastIndexOfIgnoreCase('PQ',8));
        
        
        //Left(length)
        String str67='vivek';
        //System.debug(str67.Left(3));
        
        //LeftPad(length);
        String str68='vivr';
        //System.debug(str68.LeftPad(10));
        
        //LeftPad(length,PadStr)
         String str69='viv';
        //System.debug(str69.LeftPad(10,'xy'));
        
        //Length()
        String str70='vivekkumar';
        //System.debug(str70.Length());
        
        //mid()
        String str71='viveksaurabhkumar';
        //System.debug(str71.mid(5,7));
        
        //normalizeSpace()
        String str72='vivek kumar \n saurabh \t';
        //System.debug(str72.normalizeSpace());
        
        //OffSetByCodePoints(index,codePointOffset)
        
        String str73='vivek saurabh';
        //System.debug(str73.offsetByCodePoints(3,5));
        
        
        //remove(Substring)
        String str74='vivek Kumar';
       // System.debug(str74.remove('viv'));
        
        //removeEnd(Substring)
         String str75='vivek Kumar';
        //System.debug(str75.remove('mar'));     
        
        //removeEndIgnoreCase(Substring)
         String str76='vivek Kumar';
        //System.debug(str76.removeEndIgnoreCase('MAR')); 
        
        //removeStart(Substring)
        String str77='vivek Kumar';
        //System.debug(str77.removeStart('viv')); 
        
        //removeStartIgnoreCase(Substring)
         String str78='vivek Kumar';
        //System.debug(str78.removeStartIgnoreCase('VIV')); 
        
        //repeat(numberOfTimes)
         String str79='vivek';
        //System.debug(str79.repeat(2));
        
        //repeat(seperator,numberOfTimes)
         String str80='viv';
        //System.debug(str80.repeat('--',2)); 
        
        //replace(target,replacement)
         String str81='vivek Kumar';
        //System.debug(str81.replace('vi','di')); 
        
        //replaceAll(regExp,replacement)
         String str82='vivek';
        String reg='[a-zA-z]';
        //System.debug(str82.replaceAll(reg,'0'));
        
        //replaceFirst(regExp,replacement)
        String str83='a b 3 13 xyz';
        String reg1='[a-zA-z]{3}';
        String replace='3';
        //System.debug(str83.replaceFirst(reg1,replace));

       //reverse()
       String str84='vivek';
        //stem.debug(str84.reverse());

      //right(length)
      String str85='vivek';
        //System.debug(str85.right(3));    
      
       //rightPad(length)
          String str86='viv';
        //System.debug(str86.rightPad(7));  
        
        //rightPad(length,PadStr)
           String str87='viv';
        //System.debug(str87.rightPad(5,'ek'));  
        
        //split(regExp)
        String str88='vi.ve.k';
        //List<String> list11=new List<String>str88.split('.');
        String[] str89= str88.split('\\.');
    
        /**for(integer z=0; z<str89.size(); z++){
            System.debug(str89[z]);
        }**/
        
        //split(regExp,limit)
        String str90='vivek:kumar:saurabh';
        //String[] str91=str90.split('\\:',2);
         String[] str91=str90.split('\\:',-2);
            /**for(integer z=0; z<str91.size(); z++){
            System.debug(str91[z]);
        }**/
        //System.debug(str91);
        
        //splitByCharacterType()
        String str92='vivekkumar';
        List<String> ss=str92.splitByCharacterType();
        //System.debug(ss);
        
        //splitByCharacterTypeCamelCase()
          String str93='VivekKumar';
        List<String> ss1=str93.splitByCharacterTypeCamelCase();
        //System.debug(ss1);
        
        //startsWith(prefix)
        String str94='vivek';
        //System.debug(str94.startsWith('vi'));
        
        //startsWithIgnoreCase(prefix)
        String str95='vivek';
        //System.debug(str95.startsWithIgnoreCase('VI'));
        
        //stripHtmlTags()
        String str96='<b>Vivek Kumar</b>';
        //System.debug(str96.stripHtmlTags());
        
        //substring(startIndex)
        String str97='vivekkumar';
        //System.debug(str97.substring(5));
        
        //substring(startIndex,endIndex)
        String str98='omviveksivay';
        //System.debug(str98.substring(2,7));
        
        
       //substringAfter(seperator)
        String str99='vivek.kumar.saurabh';
        //System.debug(str99.substringAfter('.'));
        
        //substringAfterLast(seperator)
        String str100='vivek.kumar.saurabh';
        //System.debug(str100.substringAfterLast('.'));
        
        //substringBefore(Seperator)
        String str101='vivek.kumar.saurabh';
        //System.debug(str101.substringBefore('.'));
        
        //substringBeforeLast(Seperator)
        String str102='vivek.kumar.saurabh';
        //System.debug(str102.substringBeforeLast('.'));
        
        //substringBetween(tag)
        String str103='vivekkumarvivek';
        //System.debug(str103.substringBetween('vivek'));
       
        //substringBetween(open,close)
        String str104='vivekkumarsaurabh';
        //System.debug(str104.substringBetween('vivek','saurabh'));
        
       //swapCase()
       String str105='Vivek';
        //System.debug(str105.swapCase());
        
        //toLowerCase() //return default locale (English US)
        String str106='VIVEK';
        //System.debug(str106.toLowerCase());
            
        
        //toLowerCase(Locale)
        String str107='VİVEK';
        //System.debug(str107.toLowerCase());
        
        //toUpperCase();
        String str108='vivek';
        //System.debug(str108.toUpperCase());
        
        //toUpperCase(Locale)
        String str109='vivek';
        //System.debug(str109.toUpperCase('tr'));
        
        //trim()
        String str110='    Vivek   ';
        //System.debug(str110.trim());
        
        //uncapitialize()
        String str111='Vivek Kumar';
        //System.debug(str111.uncapitalize());
        
        //unescapeCsv()
        String str112='"Vive,,Kumar",""Saurabh""';
        //System.debug(str112.unescapeCsv());
        
        //unescapeEcmaScript()
        String str113='Vivek"\"Kumar"\"Saurabh';
        //System.debug(str113.unescapeEcmaScript());
        
        //unescapeHtml3()
        String str114='&quot;&lt;Vivek&amp;Saurabh&gt;&quot;';
        //System.debug(str114.unescapeHtml3());
        
        //unescapeHtml4()
         String str115='&quot;&lt;Vivek&amp;Saurabh&gt;&quot;';
          //System.debug(str115.unescapeHtml4());
        
        //unescapeJava()
        String str116='Vivek:"\\Kumar\\"';
        //System.debug(str116.unescapeJava());
        
        //unescapeUnicode()
        String str117='Viv101k';
        //System.debug(str117.unescapeUnicode());
        
        //unescapeXml()
         String str118='&quot;&lt;Vivek&amp;Saurabh&gt;&quot;';
        //System.debug(str118.unescapeXml());
        
       
      //valueOf(dateTOConvert)
      Date myDate=Date.today();
      System.debug(String.valueOf(myDate));
        
       
     
     //valueOf(dateTimeToConvert)
       datetime dt=datetime.newInstance(2023,09,11);
        System.debug(String.valueOf(dt));
        
        //valueOf(decimalToConvert)
        Decimal dec=12.4;
        System.debug(String.valueOf(dec));
        
        //valueOf(doubleToConvert)
         Double doub=112.4;
        System.debug(String.valueOf(doub));
        
        
        //valueOf(integerToConvert)
        integer abc=82;
        System.debug(String.valueOf(abc));
        
        //valueOf(LongToConvert)
        Long myLong= 123456789;
        System.debug(String.valueOf(myLong));
         
        //valueOf(toConvert)
        List<integer> list123=new List<Integer>{10,20};
          System.debug(String.valueOf(list123));
        
        //valueOfGmt(datetime to convert)
         datetime dts=datetime.newInstance(2023,09,11);
        System.debug(String.valueOf(dts));
        
        
        //string to  char array 1stconcept
        String str119='MynameisVivek';
        String[] str120=str119.split('');
       // System.debug(str120);
        /**for(integer y=0; y<str120.size(); y++){
            System.debug(str120[y]);
            System.debug('\n');
        }**/
        
        
        
       /** String sente='{0}{1} is good';
        List<Integer> para1=new Integer[]{86,73};
            String sente1=String.fromCharArray(para1);
         System.debug(sente1);
        **/
      
        String stt='';
         System.debug(String.isBlank(stt));
        
        
        //string to  char array 2ndconcept
        String str1111='vivek';
        Integer lengthOfString = str1111.length();
      
        for(Integer i1 = 1; i1 <= lengthOfString; i1++){
            System.debug(str1111.substring(i1-1,i1));
        }
       
        String str00='vivek kumar saurabh';
        String[] arr=str00.split('\\s');
        System.debug(arr);
        
         
    } 
    
    
}