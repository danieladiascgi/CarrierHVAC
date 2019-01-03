public class JWTDecryptFinal {

    String token = '';
    //blob key = blob.valueOf('ABC123DEF456HIJ789KLM012NOP345QR');
    /*blob key = blob.valueOf('ABC123-EF456HIJ789KLM012NOP345QR');
    blob iv = blob.valueOf('ABC123DEF456HIJ7');*/
    /*public JWTDecryptFinal(String token){
        this.token = token;
        token = token.replace('-', '+');
        token = token.replace('_','/');
        token = token + '=';
        String[] tokenArray = token.split('\\.');
        System.debug('#tokenArray size:'+tokenArray.size());
        //for(String eachToken : tokenArray){
        String s1 = EncodingUtil.base64Decode(tokenArray[0]).toString();
        String s2 = EncodingUtil.base64Decode(tokenArray[1]).toString();
        //String s3 = EncodingUtil.base64Decode(tokenArray[2]).toString();
        System.debug('#1 st:'+s1);
        System.debug('#2 st:'+s2);
        //blob encryptedData = EncodingUtil.base64Decode(s2);
        //blob decryptedData = Crypto.decrypt('AES256', key, iv, encryptedData);                       
        //system.debug('#Final Decrypted Data:'+decryptedData.toString());
        s2 = s2.remove('"');
        System.debug('#3 st:'+s2);
        EncryptAndDecrypt.testingDecryptWithParameter(s2);
    }
    public JWTDecryptFinal(){
        
    }*/
    /*public String getFirstName(String token){
        String toReturn = '';
        token = token.replace('-', '+');
        token = token.replace('_','/');
        token = token + '=';
        String[] tokenArray = token.split('\\.');
        System.debug('#tokenArray size:'+tokenArray.size());
        //for(String eachToken : tokenArray){
        String s1 = EncodingUtil.base64Decode(tokenArray[0]).toString();
        String s2 = EncodingUtil.base64Decode(tokenArray[1]).toString();
        //String s3 = EncodingUtil.base64Decode(tokenArray[2]).toString();
        System.debug('#1 st:'+s1);
        System.debug('#2 st:'+s2);
        //blob encryptedData = EncodingUtil.base64Decode(s2);
        //blob decryptedData = Crypto.decrypt('AES256', key, iv, encryptedData);                       
        //system.debug('#Final Decrypted Data:'+decryptedData.toString());
        s2 = s2.remove('"');
        System.debug('#3 st:'+s2);
        toReturn = EncryptAndDecrypt.returnJSONPayload(s2);
        System.debug('#toReturn:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.contains('Fn:')){
                    toReturn = eachKeyValue.subString(3, eachKeyValue.length());
                }
            }
        }
        return toReturn;
    }
    public String getLastName(String token){
        String toReturn = '';
        token = token.replace('-', '+');
        token = token.replace('_','/');
        token = token + '=';
        String[] tokenArray = token.split('\\.');
        System.debug('#tokenArray size:'+tokenArray.size());
        //for(String eachToken : tokenArray){
        String s1 = EncodingUtil.base64Decode(tokenArray[0]).toString();
        String s2 = EncodingUtil.base64Decode(tokenArray[1]).toString();
        //String s3 = EncodingUtil.base64Decode(tokenArray[2]).toString();
        System.debug('#1 st:'+s1);
        System.debug('#2 st:'+s2);
        //blob encryptedData = EncodingUtil.base64Decode(s2);
        //blob decryptedData = Crypto.decrypt('AES256', key, iv, encryptedData);                       
        //system.debug('#Final Decrypted Data:'+decryptedData.toString());
        s2 = s2.remove('"');
        System.debug('#3 st:'+s2);
        toReturn = EncryptAndDecrypt.returnJSONPayload(s2);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.contains('Ln:')){
                    toReturn = eachKeyValue.subString(3, eachKeyValue.length());
                }
            }
        }
        return toReturn;
    }
    public String getEmail(String token){
        String toReturn = '';
        token = token.replace('-', '+');
        token = token.replace('_','/');
        token = token + '=';
        String[] tokenArray = token.split('\\.');
        System.debug('#tokenArray size:'+tokenArray.size());
        //for(String eachToken : tokenArray){
        String s1 = EncodingUtil.base64Decode(tokenArray[0]).toString();
        String s2 = EncodingUtil.base64Decode(tokenArray[1]).toString();
        //String s3 = EncodingUtil.base64Decode(tokenArray[2]).toString();
        System.debug('#1 st:'+s1);
        System.debug('#2 st:'+s2);
        //blob encryptedData = EncodingUtil.base64Decode(s2);
        //blob decryptedData = Crypto.decrypt('AES256', key, iv, encryptedData);                       
        //system.debug('#Final Decrypted Data:'+decryptedData.toString());
        s2 = s2.remove('"');
        System.debug('#3 st:'+s2);
        toReturn = EncryptAndDecrypt.returnJSONPayload(s2);
        System.debug('#Email thing:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.contains('Email:')){
                    toReturn = eachKeyValue.subString(6, eachKeyValue.length());
                }
            }
        }
        return toReturn;
    }*/
    public String getFirstNameDecrypt(String token){
        String toReturn = '';        
        toReturn = EncryptAndDecrypt.returnJSONPayload(token);
        System.debug('#toReturn:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            System.debug('#splitResp:'+splitResp);
            System.debug('#splitResp Size:'+splitResp.size());
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.containsIgnoreCase('Fn:')){
                    System.debug('#eachKeyValue:'+eachKeyValue);
                    toReturn = eachKeyValue.subString(3, eachKeyValue.length());
                }
            }
        }
        System.debug('#FN:'+toReturn);
        return toReturn;
    }
    public String getLastNameDecrypt(String token){
        String toReturn = '';        
        toReturn = EncryptAndDecrypt.returnJSONPayload(token);
        System.debug('#toReturn:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.containsIgnoreCase('Ln:')){
                    toReturn = eachKeyValue.subString(3, eachKeyValue.length());
                }
            }
        }
        System.debug('#LN:'+toReturn);
        return toReturn;
    }
    public String getEmailDecrypt(String token){
        String toReturn = '';        
        toReturn = EncryptAndDecrypt.returnJSONPayload(token);
        System.debug('#Email thing:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.containsIgnoreCase('Email:')){
                    toReturn = eachKeyValue.subString(6, eachKeyValue.length());
                }
            }
        }
        System.debug('#email:'+toReturn);
        return toReturn;
    }
    public String getHVACIDDecrypt(String token){
        String toReturn = '';        
        toReturn = EncryptAndDecrypt.returnJSONPayload(token);
        System.debug('#HVAC thing:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.containsIgnoreCase('HVACPin:')){
                    toReturn = eachKeyValue.subString(8, eachKeyValue.length());
                }
            }
        }
        System.debug('#hvac id:'+toReturn);
        return toReturn;
    }
    public String getSHIPTODecrypt(String token){
        String toReturn = '';        
        toReturn = EncryptAndDecrypt.returnJSONPayload(token);
        System.debug('#HVAC thing:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.containsIgnoreCase('SoldTo:')){
                    toReturn = eachKeyValue.subString(7, eachKeyValue.length());
                }
            }
        }
        System.debug('#shipTo id:'+toReturn);
        if(toReturn!=null && toReturn.length()>0 && toReturn.isNumeric()){
            Integer temp = Integer.valueOf(toReturn);
            toReturn = String.valueOf(temp);
        }
        return toReturn;
    }
    public String getPhoneNo(String token){
        String toReturn = '';        
        toReturn = EncryptAndDecrypt.returnJSONPayload(token);
        System.debug('#Phone thing:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.containsIgnoreCase('Phone:')){
                    toReturn = eachKeyValue.subString(6, eachKeyValue.length());
                }
            }
        }
        System.debug('#Phone no:'+toReturn);
        return toReturn;
    }
    public String getUsername(String token){
        String toReturn = '';        
        toReturn = EncryptAndDecrypt.returnJSONPayload(token);
        System.debug('#Username thing:'+toReturn);
        if(toReturn.contains(',')){
            List<String> splitResp = toReturn.split(',');
            for(String eachKeyValue : splitResp){
                if(eachKeyValue.containsIgnoreCase('Username:')){
                    toReturn = eachKeyValue.subString(9, eachKeyValue.length());
                }
            }
        }
        System.debug('#Username:'+toReturn);
        return toReturn;
    }
}