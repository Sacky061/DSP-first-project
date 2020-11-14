import ballerina/grpc;
import ballerina/log;
import ballerina/io;
import ballerina/lang.'int;

function displayOptions(){
    io:println("Please select a number below according to what you wish to do today");
    io:println("1. Write a new record");
    io:println("2. Update a record");
    io:println("3. Read a record");
    io:println("4. Exit");
    }

function addRecord(){
    io:println("                 ADDING A NEW RECORD.....");
    
    map<json> newRecord= {
        date: "",
        artists: [],
        band: "",
        songs: []
    };
    string inputDate = io:readln("Add date in the format: DD/MM/YYYY: ");
    newRecord["date"] = inputDate;
    
    int|error totalArtistsEr = 'int:fromString(io:readln("Enter total number of contributing artists: "));
    int totalArtists = <int> totalArtistsEr;

    json[] inputArtist = <json[]>newRecord["artists"];
    foreach int i in 0..<totalArtists{
        string inputName = io:readln("Artist Name: ");
        string inputMember = io:readln("Member(Enter yes or no): ");
        //Write to the map        
        inputArtist[i] = {name: inputName, member: inputMember};
        //newRecord["artists"[i]].name=inputName;
    }
    newRecord["artists"] = inputArtist;

    string band = io:readln("Enter Band Name: ");
    newRecord["band"] = band;

    json[] inputSongs = <json[]>newRecord["songs"];
    string inputTitle = io:readln("Enter Song Title: ");
    string inputGenre = io:readln("Enter Song Genre: ");
    string inputPlatform = io:readln("Enter song platform: ");
    inputSongs[0] = {title: inputTitle, genre: inputGenre, platform: inputPlatform};
    newRecord["songs"] = inputSongs;

    io:println("The newly added record is: ", newRecord.toJsonString());
        
}

public function main (string... args) {

    caliBlockingClient caliBlockingEp = new("http://localhost:9090");

    // Add a new record 
    io:println("*****************************************************************************");
    io:println("*****************************************************************************");
    io:println("                     WELCOME TO CALI: A MUSIC STORAGE SYSTEM");
    io:println("*****************************************************************************");
    io:println("*****************************************************************************");
    displayOptions();
    


    log:printInfo("Create a new record");
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


