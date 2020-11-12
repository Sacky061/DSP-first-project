import ballerina/log;
import ballerina/grpc;
import ballerina/io;


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

    caliSystemServiceBlockingClient blockingEp = new("http://localhost:9090");
    //Variables used to enter data into JSON file from user input
    string RecID = io:readln("Record ID: ");
    string date = io:readln("Date of Entry (d/m/y): ");
    string artistName = io:readln("Artist Name: ");
    string artistMembership = io:readln("Member (Yes/No): ");
    string songTitle = io:readln("Song Title: ");
    string songGenre = io:readln("Genre: ");
    string songPlatform = io:readln("Platform: ");
    string band = io:readln("Band: ");
    
    //USING This variable to allow the user to enter a file name for the json file(currently not functional)
    string fileName = "Record";
    
    //path to json file location
    string filePath = "./files/" + fileName + ".json";
    //json file structure
        json j1 = {
        date: date,
	artists: [
		{
			name: artistName,
			member: artistMembership
		}	
	],
	band: band,
	songs: [
		{
			title: songTitle,
			genre: songGenre,
			platform: songPlatform
		}
	]

    };
    io:println("WRITING TO JSON FILE");

    var wResult = write(j1, filePath);
    if (wResult is error) {
        log:printError("Error occurred while writing json: ", wResult);
    } else {
        io:println("Preparing to read the content written");

        var rResult = read(filePath);
        if (rResult is error) {
            log:printError("Error occurred while reading json: ",
                            err = rResult);
        } else {
            io:println(rResult.toJsonString());
        }
    }



    
    

    

    // This method is a test to get varibales from the RecordInfo class, allowing for variables not to be declared again
    log:printInfo("*Create Record*");
    RecordInfo value = {
        
    
    };

    //Error if file is not written/created
    var addResponse = blockingEp->addRecord(value);
    if (addResponse is error) {
        log:printError("Error from Connector: " + addResponse.reason() + " - " + <string>addResponse.detail()["message"] + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = addResponse;
        log:printInfo("Response - " + result + "\n");
    }

}


