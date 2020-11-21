import ballerina/grpc;
import ballerina/crypto;
import ballerina/io;
import ballerina/math;
import ballerina/lang.'string;

listener grpc:Listener ep = new (9090);
map<addRequest> caliMap = {};
service cali on ep {

    resource function addRecord(grpc:Caller caller, addRequest value) {
     // add the new record to the map
        string recordVersionNo = recordReq.VersionNo;
        caliMap[recordReq.recordVersionNo] = <@untained>recordReq;
        string payload = " Status : Record created; VersionNo :" + recordVersionNo;

        // send response to the caller
        error? result = caller->send(payload);
        result = caller->complete();
        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + "-" + <tring>result.detail()["message"] + "\n");
        }
        caliMap[string.convert(recordVersionNo)] = value;
        json j1 = checkpanic json.convert(caliMap[string.convert(recordVersionNo)]);
        string newValue = "Record value "+j1.toString();
    }
    // SHA1 hashing algorithm
    public function hashSha1(byte[] recordVersionNo) returns byte[] {
    //Value to be hashed
    string recordVersionNo ="record version number";
    byte[] versionNo = recordVersionNo.toBytes();
    result = crypto:hashSha1(versionNoArr);
    io:println("Base64 encoded hash with SHA1: " + result.toBase64());
        
        // reference to RSA private key
    crypto:KeyStore keyStore = {path: "./sampleKeystore.p12", password: "ballerina"};
    var privateKey = crypto:decodePrivateKey(keyStore, "ballerina", "ballerina");

    if (privateKey is crypto:PrivateKey) {
        // signing input value and printing signature value
        result = check crypto:signRsaSha1(versionNo, privateKey);
        io:println("Base64 encoded RSA-SHA1 signature: " + result.toBase64());
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
    }
    resource function updateRecord(grpc:Caller caller, updateRequest value) {
    string payload;
        error? result = ();
        // Find the record that needs to be updated.
        string recordVersionNo = updateRecord.versionNo;
        if (caliMap.hasKey(recordVersionNo)) {
            // Update the existing record.
            caliMap[recordVersionNo] = <@untained>updateRecord;
            payload = "Record : '" + recordVersionNo + "' updated.";
            // Send response to the caller.
            result = caller->send(payload);
            result = caller->complete();
        } else {
            // Send entity not found error.
            payload = "Record : '" + recordVersionNo + "' Record does not exist";
            result = caller->sendError(grpc:NOT_FOUND, payload);
        }

        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
        
    }
    resource function readRecord(grpc:Caller caller, readRequest value) {
    string payload = "";
        error? result = ();
        // read the requested record from the map.
        if (caliMap.hasKey(recordVersionNo)) {
            var jsonValue = typedesc<json>.constructFrom(caliMap[recordVersionNo]);
            if (jsonValue is error) {
                // Send casting error as internal error.
                result = caller->sendError(grpc:INTERNAL, <string>jsonValue.detail()["message"]);
            } else {
                json recordDetails = jsonValue;
                payload = recordDetails.toString();
                // Send response to the caller.
                result = caller->send(payload);
                result = caller->complete();
            }
        } else {
            // Send entity not found error.
            payload = "Record : '" + recordVersionNo + "' Record does not exist";
            result = caller->sendError(grpc:NOT_FOUND, payload);
        }

        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
        
}

public type addRequest record {|
    record {| string key; string value; |}[] songrecord = [];
|};

public type updateRequest record {|
    record {| string key; string value; |}[] songrecord = [];
|};

public type readRequest record {|
    record {| string key; string value; |}[] songrecord = [];
|};

public type addResponse record {|
    record {| string key; string value; |}[] songrecord = [];
|};

public type updateResponse record {|
    record {| string key; string value; |}[] songrecord = [];
|};

public type readResponse record {|
    record {| string key; string value; |}[] songrecord = [];
|};



const string ROOT_DESCRIPTOR = "0A0F70726F746F46696C652E70726F746F2288010A0A61646452657175657374123B0A0A736F6E675265636F726418012003280B321B2E616464526571756573742E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801228E010A0D75706461746552657175657374123E0A0A736F6E675265636F726418012003280B321E2E757064617465526571756573742E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801228A010A0B7265616452657175657374123C0A0A736F6E675265636F726418012003280B321C2E72656164526571756573742E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801228A010A0B616464526573706F6E7365123C0A0A736F6E675265636F726418012003280B321C2E616464526573706F6E73652E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A0238012290010A0E757064617465526573706F6E7365123F0A0A736F6E675265636F726418012003280B321F2E757064617465526573706F6E73652E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801228C010A0C72656164526573706F6E7365123D0A0A736F6E675265636F726418012003280B321D2E72656164526573706F6E73652E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801328A010A0463616C6912260A096164645265636F7264120B2E616464526571756573741A0C2E616464526573706F6E7365122F0A0C7570646174655265636F7264120E2E757064617465526571756573741A0F2E757064617465526573706F6E736512290A0A726561645265636F7264120C2E72656164526571756573741A0D2E72656164526573706F6E7365620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "protoFile.proto":"0A0F70726F746F46696C652E70726F746F2288010A0A61646452657175657374123B0A0A736F6E675265636F726418012003280B321B2E616464526571756573742E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801228E010A0D75706461746552657175657374123E0A0A736F6E675265636F726418012003280B321E2E757064617465526571756573742E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801228A010A0B7265616452657175657374123C0A0A736F6E675265636F726418012003280B321C2E72656164526571756573742E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801228A010A0B616464526573706F6E7365123C0A0A736F6E675265636F726418012003280B321C2E616464526573706F6E73652E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A0238012290010A0E757064617465526573706F6E7365123F0A0A736F6E675265636F726418012003280B321F2E757064617465526573706F6E73652E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801228C010A0C72656164526573706F6E7365123D0A0A736F6E675265636F726418012003280B321D2E72656164526573706F6E73652E536F6E675265636F7264456E747279520A736F6E675265636F72641A3D0A0F536F6E675265636F7264456E74727912100A036B657918012001280952036B657912140A0576616C7565180220012809520576616C75653A023801328A010A0463616C6912260A096164645265636F7264120B2E616464526571756573741A0C2E616464526573706F6E7365122F0A0C7570646174655265636F7264120E2E757064617465526571756573741A0F2E757064617465526573706F6E736512290A0A726561645265636F7264120C2E72656164526571756573741A0D2E72656164526573706F6E7365620670726F746F33"
        
    };
}

