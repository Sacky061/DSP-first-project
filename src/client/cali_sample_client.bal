import ballerina/grpc;
import ballerina/log;

public function main (string... args) {

    caliBlockingClient caliBlockingEp = new("http://localhost:9090");

    // Add a new record 
    log:printInfo("Create a new records");
    json j1 = {
		RecordVersionNo: "01",
        date: "22/10/2020 ",
	artists: [
		{
			name: "Winston Marshall",
			member: "yes"
		},
		{
			name: "Ben Lovett",
			member: "yes"
		},
		{
			name: "Baaba Maal"),
			member: "no")
		}
	],
	band: "Mumford & Sons",
	songs: [
		{
			title: "There will be time",
			genre: "folk rock",
			platform: "Deezer"
		}
	]

    };
    var addResponse = caliblockingEp->addRecords(recordReq);
    if (addResponse is error) {
        log:printError("Error from Connector: " + addResponse.reason() + " - "
                                                + <string>addResponse.detail().message + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        (result, resHeaders) = addResponse;
        log:printValue("Response - " + result + "\n");
    }
	// Update the record
    log:printInfo("Update the Record");
    recordInfo updateReq = {recordVersionNo:"01", description:"Updated."};
    var updateResponse = caliBlockingEp->updateRecord(updateReq);
    if (updateResponse is error) {
        log:printError("Error from Connector: " + updateResponse.reason() + " - "
                                                + <string>updateResponse.detail()["message"] + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = updateResponse;
        log:printInfo("Response - " + result + "\n");
    }
	// read the record
    log:printInfo("Read the Record");
    var readResponse = caliBlockingEp->readRecord("01");
    if (readResponse is error) {
        log:printError("Error from Connector: " + readResponse.reason() + " - "
                                                + <string>readResponse.detail()["message"] + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = readResponse;
        log:printInfo("Response - " + result + "\n");
    }
}


