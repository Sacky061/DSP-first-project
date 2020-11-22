//import ballerina/grpc;
import ballerina/crypto;
import ballerina/io;
import ballerina/lang.'string;
import ballerina/math;

public function hashSha1(byte[] recordKey) returns byte[] {
        //Value to be hashed
        string recordKey =" hash record key";
        byte[] versionNo = recordKey.toBytes();
        result = crypto:hashSha1(versionNo); 
        io:println("record Key: " + result.toBase64());
        
        // reference to RSA private key
    crypto:KeyStore keyStore = {path: "./sampleKeystore.p12", password: "ballerina"};
    var privateKey = crypto:decodePrivateKey(keyStore, "ballerina", "ballerina");

    if (privateKey is crypto:PrivateKey) {
        // signing input value and printing signature value
        result = check crypto:signRsaSha1(versionNo, privateKey);
        io:println("record key signature: " + result.toBase64());
        } else {
        io:println("Invalid private key");
    }
    // generate a 128 bit key
    byte[16] rsaKeyArr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
     foreach var i in 0 ... 15 {
        rsaKeyArr[i] = <byte>(math:randomInRange(0, 255));
     }
     result = check crypto:encryptAesCbc(versionNo, rsaKeyArr, ivArr);
     result = check crypto:decryptAesCbc(result, rsaKeyArr, ivArr);
     io:println("AES CBC PKCS5 decrypted value: " + check 'string:fromBytes(result));
     // public key  used for RSA encryption
     crypto:PublicKey rsaPublicKey = check crypto:decodePublicKey(keyStore, "ballerina");
     // private key used for RSA decryption
     crypto:PrivateKey rsaPrivateKey = check crypto:decodePrivateKey(keyStore, "ballerina","ballerina");

     if(recordsMap.versionNo(recordReq.KEY)){
        error? result = caller->send("Extracting Record's version No: " + recordReq.KEY);
        result = caller->complete();
        if(result is error){
            log:printError("An error occurred: " + result.reason().toString());
        }
    }
    else{
        recordsMap[recordReq.KEY] = <@untainted> recordReq;
        if(file is json){
            error? result = caller->send("New record's version No been added: " + recordReq.KEY);
            result = caller->complete();

            if(result is error){
                log:printError("Error from Connector: " + result.reason().toString());
            }
        }
    }
}