import ballerina/io;
import ballerina/log;

function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}

function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
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



    

public function main() {

    string recordName = "Cali Record";


    string filePath = "./files/" + recordName +".json";

    json j1 = {
        date: io:readln("Date: "),
	artists: [
		{
			name: io:readln("Enter Name: "),
			member: io:readln("Membership Status: ")
		},
		{
			name: io:readln("Enter Name: "),
			member: io:readln("Membership Status: ")
		},
		{
			name: io:readln("Enter Name: "),
			member: io:readln("Membership Status: ")
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



    io:println("Preparing to write json file");

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
}