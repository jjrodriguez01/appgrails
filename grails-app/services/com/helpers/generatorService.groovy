package com.helpers


import grails.transaction.Transactional
import java.util.Random

@Transactional
class generatorService {


    def public  String numericGenerationByLength(Integer length){
        def String answer = ""
        Random rand = new Random()  
        def intStream = rand.ints(length, 0, 10).toArray()
        for(int i in intStream){
            answer+=""+i
        } 
        return answer
    }


    def public  String numericGenerationByRange(Integer init, Integer end){
        def String answer = ""
        Random rand = new Random()  
        def intStream = rand.ints(1, init, end).toArray()
        for(int i in intStream){
            answer+=""+i
        } 
        return answer
    }


    def public  String alfabeticGenerationByLenth(Boolean numbers, Boolean punctuation, Boolean specialChars, Boolean letters, Boolean symbols, Boolean space,  Integer length, String aditionalChars){
        String charset = "";
        if(numbers){
            charset+="0123456789"
        }
        if(punctuation){
            charset+=".,:;¿?!¡"
        }
        if(specialChars){
            charset+="áéíóúñü"
        }
        if(symbols){
            charset+="@#\$%&*(){}[]<>"
        }
        if(space){
            charset+=" "
        }
        if(letters){
            charset+="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        if(aditionalChars!=""){
            charset+=aditionalChars
        }
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        while (salt.length() < length) {
            int index = (int) (rnd.nextFloat() * charset.length());
            salt.append(charset.charAt(index));
        }
        String saltStr = salt.toString();
        return saltStr;
    }


    def public  String alfabeticGenerationByLength(Integer length){
        String charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        while (salt.length() < length) {
            int index = (int) (rnd.nextFloat() * charset.length());
            salt.append(charset.charAt(index));
        }
        String saltStr = salt.toString();
        return saltStr.toLowerCase();
    }


    def public  String alfabeticGenerationByPattern(String pattern){
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        int length = pattern.length()
        while (salt.length() < length) {
            int index = (int) (rnd.nextFloat() * pattern.length());
            salt.append(pattern.charAt(index));
        }
        String saltStr = salt.toString();
        return saltStr;
    }



}
