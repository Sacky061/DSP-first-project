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
    string choice = io:readln("Enter Choice: ");

    if (choice == "1"){
        addRecord();
    }
    else if (choice == "2"){
        updateRecord();

    }
    else if (choice == "3"){
        readRecord();
    }
    else if(choice == "4"){
        exit();
    }
    else {
        io:println("Error: Incorrect input");
        displayOptions();
    }
    }


function addRecord(){

    io:println("                 ADDING A NEW RECORD.....");
    
    map<json> newRecord= {
        songVersion: "",
        date: "",
        artists: [],
        band: "",
        songs: []
    };

    string inputVersion = io:readln("Enter Version Number: ");
    newRecord["songVersion"] = inputVersion;

    string inputDate = io:readln("Add date in the format: DD/MM/YYYY: ");
    newRecord["date"] = inputDate;
    
    int|error totalArtistsEr = 'int:fromString(io:readln("Enter total number of contributing artists: "));
    int totalArtists = <int> totalArtistsEr;

    json[] inputArtist = <json[]>newRecord["artists"];
    foreach int i in 0..<totalArtists{
        string inputName = io:readln("Enter Artist Name: ");
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
    displayOptions();
        
}

function updateRecord() {

    io:println("                 UPDATING A RECORD.....");
    
    map<json> newRecord= {
        songKey: "",
        songVersion: "",
        date: "",
        artists: [],
        band: "",
        songs: []
    };

    string inputKey = io:readln("Enter Song Key Number: ");
    newRecord["songKey"] = inputKey;

    string inputVersion = io:readln("Enter Version Number: ");
    newRecord["songVersion"] = inputVersion;

    string inputDate = io:readln("Add date in the format: DD/MM/YYYY: ");
    newRecord["date"] = inputDate;
    
    int|error totalArtistsEr = 'int:fromString(io:readln("Enter total number of contributing artists: "));
    int totalArtists = <int> totalArtistsEr;

    json[] inputArtist = <json[]>newRecord["artists"];
    foreach int i in 0..<totalArtists{
        string inputName = io:readln("Enter Artist Name: ");
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

    io:println("A record has been updated as follows: ", newRecord.toJsonString());
    displayOptions();
        
}
function readKey() {
    map<json> readRecord = {
        songKey: ""
    };

    string inputKey = io:readln("Enter Song Key Number: ");
    readRecord["songKey"] = inputKey;
    
}
function readKeyVersion() {
    map<json> readRecord = {
        songKey: "",
        songVersion: ""
    };
}

function readCriteria() {
    map<json> readRecord= {
        songKey: "",
        songVersion: "",
        date: "",
        artists: [],
        band: "",
        songs: []
    };

    io:println("Searching a record by criteria or combination of criterion:.....");

    //Prompting User for the Key
    io:println("Do you wish to add the Key to the criteria?(Reply Y/N)");
    string choice = io:readln("Enter Choice: ");
    while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        string inputKey = io:readln("Enter Song Key Number: ");
    readRecord["songKey"] = inputKey;
    
    }
    
    else if (choice == "N"){
        io:println("The record key will not be included in the search criteria!");
    }

    //Prompting user for the Version Number
    io:println("Do you wish to add the Version to the criteria?(Reply Y/N)");
    choice = io:readln("Enter Choice: ");
    while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        string inputVersion = io:readln("Enter Version Number: ");
        readRecord["songVersion"] = inputVersion;
        
    }
    else if (choice == "N"){
        io:println("The record Version will not be included in the search criteria!");
    }
   
    

    string inputDate = io:readln("Add date in the format: DD/MM/YYYY: ");
    readRecord["date"] = inputDate;
    //Does user want to add more criteria
        string moreCriteria = io:readln("Do you wish to add more criteria?(Reply Y/N)");
        while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
        }
    
    int|error totalArtistsEr = 'int:fromString(io:readln("Enter total number of contributing artists: "));
    int totalArtists = <int> totalArtistsEr;

    json[] inputArtist = <json[]>newRecord["artists"];
    foreach int i in 0..<totalArtists{
        string inputName = io:readln("Enter Artist Name: ");
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

    io:println("A record has been updated as follows: ", newRecord.toJsonString());
    displayOptions();
     
}
function readRecord(){
    io:println("How would you like to search a record? Pick a nummber Option Below: ");
    io:println("1: Search by Key Only: ");
    io:println("2: Search by Key and Version: ");
    io:println("3: Search by Criteroin: ");

    string choice = io:readln("Enter Choice: ");
    if(choice == "1"){
        readKey();
    }
    else if(choice == "2"){
        readKeyVersion();
    }
    else if(choice == "3"){
        readCriteria();
    }
    else{
        io:println("Error!! Incorrcet input.");
        readRecord();
    }
    displayOptions();
}
function exit() {
    io:println("*******************GOOD BYE!!***********************");
}



//Functions that allow for the System to Read and Write to a JSON File
function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",err = result);
    }
}

function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",err = result);
    }
}

function write(json content, string path) returns @tainted error? {

    io:WritableByteChannel wbc = check io:openWritableFile(path);

    io:WritableCharacterChannel wch = new (wbc, "UTF8");
    var result = wch.writeJson(content);
    closeWc(wch);
    return result;
}

function read(string path) returns @tainted json|error {

    io:ReadableByteChannel rbc = check io:openReadableFile(path);

    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var result = rch.readJson();
    closeRc(rch);
    return result;
}







public function main (string... args) {

    caliBlockingClient caliBlockingEp = new("http://localhost:9090");
    string fileName = "Record";
    
    //path to json file location
    string filePath = "./files/" + fileName + ".json";

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
			name: "Baaba Maal",
			member: "no"
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


