public class EncryptAndDecrypt {

    /*public static void testingDeCrypt(){
        //blob key = blob.valueOf('ABC123DEF456HIJ789KLM012NOP345QR');
        blob key = Blob.valueOf(Label.EncryptKey);
        blob iv = Blob.valueOf(Label.EncryptValue);
        blob encryptedData = EncodingUtil.base64Decode('EAyVXU6yTu6YO7Evpzr5/EGcd+U/1u2qdG+qC5Cc9JI=');
        blob decryptedData = Crypto.decrypt('AES256', key, iv, encryptedData);                       
        system.debug('#Decrypted Data:'+decryptedData.toString());

    }*/
    public static void testingDecryptWithParameter(String encryptedStr){
        blob key = blob.valueOf('ABC123-EF456HIJ789KLM012NOP345QR');
        blob iv = blob.valueOf('ABC123DEF456HIJ7');
        blob encryptedData = EncodingUtil.base64Decode(encryptedStr);
        blob decryptedData = Crypto.decrypt('AES256', key, iv, encryptedData);                       
        system.debug('##Decrypted Data:'+decryptedData.toString());

    }
    public static String returnJSONPayload(String encryptedStr){
        String toReturn = '';
        /*blob key = blob.valueOf('ABC123-EF456HIJ789KLM012NOP345QR');
        blob iv = blob.valueOf('ABC123DEF456HIJ7');*/
        blob key = Blob.valueOf(Label.EncryptKey);
        blob iv = Blob.valueOf(Label.EncryptValue);
        blob encryptedData = EncodingUtil.base64Decode(encryptedStr);
        blob decryptedData = Crypto.decrypt('AES256', key, iv, encryptedData);                       
        system.debug('Decrypted Data:'+decryptedData.toString());
        toReturn = decryptedData.toString();
        return toReturn;

    }
}