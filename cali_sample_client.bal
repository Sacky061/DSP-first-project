import ballerina/grpc;
import ballerina/io;
import ballerina/lang.'int;

//A display function that lets the user select the diferent operation options available to them
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

//A function to add records
function addRecord(){

    io:println("                 ADDING A NEW RECORD.....");
        
    string inputVersion= io:readln("Enter Version Number: ");
    string inputDate=io:readln("Add date in the format: DD/MM/YYYY: ");
    
    string inputBand = io:readln("Enter Band Name: ");
    int|error totalArtistsEr = 'int:fromString(io:readln("Enter total number of contributing artists: "));
    int totalArtists = <int> totalArtistsEr;

      
    artistDetails inputArtist={};
    artistDetails[] arrayArtists = [];

    foreach int i in 0..<totalArtists{
        //addNew.allArtists[i].name = io:readln("Enter Artist Name: ");
        //addNew.allArtists[i].member = io:readln("Member(Enter yes or no): ");
        inputArtist["name"] = io:readln("Enter Artist Name: ");        
        inputArtist["member"] = io:readln("Member(Enter yes or no): ");
        arrayArtists[i] = {name: inputArtist["name"], member: inputArtist["member"]};
    }
    
    song songInfo = {};
    songInfo["title"] = io:readln("Enter Song Title: ");
    
    songInfo["genre"] = io:readln("Enter Song Genre: ");
    
    songInfo["platform"] = io:readln("Enter song platform: ");
    song[] songArray = [songInfo];
    
        
    addRequest addNew = {songVersion: inputVersion,
    date:inputDate,
    
    band:inputBand,
    allArtists:arrayArtists,
    songDetails:songArray
    
    };
    
    //Sending the add requests via http
    caliBlockingClient blockingEp = new("http://localhost:9090");
    
    var addResponse = blockingEp->addRecord(addNew);
    if (addResponse is grpc:Error) {
        io:println("Error from Connector: " + addResponse.reason() + " - "
                                                + <string>addResponse.detail()["message"] + "\n");
    } else {

            io:println("File Succesfully added: ",addResponse);
       
    }
    io:println("Add request details sent were: ", addNew.toString());
    //send the write/add request
    displayOptions();
        
}

//A function to update records****************************************************************
function updateRecord() {

    io:println("                 UPDATING A RECORD.....");
    
    string inputKeyUpdate = io:readln("Enter Song Key Number: ");
    
    string inputVersionUpdate= io:readln("Enter Version Number: ");
    string inputDateUpdate=io:readln("Add date in the format: DD/MM/YYYY: ");
    
    string inputBandUpdate = io:readln("Enter Band Name: ");
    int|error totalArtistsErUpdate = 'int:fromString(io:readln("Enter total number of contributing artists: "));
    int totalArtistsUpdate = <int> totalArtistsErUpdate;

    updateartistDetails inputArtistUpdate={};
    updateartistDetails[] arayArtistsUpdate = [];
    foreach int i in 0..<totalArtistsUpdate{
        
        arayArtistsUpdate[i].name = io:readln("Enter Artist Name: ");
        
        arayArtistsUpdate[i].member = io:readln("Member(Enter yes or no): ");
        
    }
    
    updatesong[] songInfoUpdate = [];
    songInfoUpdate[0].title = io:readln("Enter Song Title: ");
    
    songInfoUpdate[0].genre = io:readln("Enter Song Genre: ");
    
    songInfoUpdate[0].platform = io:readln("Enter song platform: ");
    
    //send the write/add request
        
    updateRequest newUpdate = {
        songKey: inputKeyUpdate,
        songVersion: inputVersionUpdate,
    date:inputDateUpdate,
    
    band:inputBandUpdate,
    allArtists:arayArtistsUpdate,
    songDetails:songInfoUpdate
    
    };
    
    
    caliBlockingClient blockingEp = new("http://localhost:9090");
    
    var updateResponse = blockingEp->updateRecord(newUpdate);
    if (updateResponse is grpc:Error) {
        io:println("Error from Connector: " + updateResponse.reason() + " - "
                                                + <string>updateResponse.detail()["message"] + "\n");
    } else {

            io:println("File Succesfully added: ",updateResponse);
        
    }
    io:println("Add request details sent were: ", newUpdate.toString());
    //send the write/add request
    displayOptions();
        
}


//A function for sending read requests with only a key provided******************************************
function readKey() {
    
    string keyInput = io:readln("Enter Song Key Number: ");

    readRequest newRead = {
            songKey:keyInput
    };  

    //Send Read request
    caliBlockingClient blockingEp = new("http://localhost:9090");
    
    var readResponse = blockingEp->readRecord(newRead);
    if (readResponse is grpc:Error) {
        io:println("Error from Connector: " + readResponse.reason() + " - "
                                                + <string>readResponse.detail()["message"] + "\n");
    } else {

            io:println("File Succesfully added: ",readResponse);
        
    }
    io:println("Add request details sent were: ", newRead.toString());
    
    displayOptions();
    
}

//A function for sending a read request using a key and version
function readKeyVersion() {
    
    string keyInput = io:readln("Enter Song Key Number: ");
    string readSongVersion = io:readln("Enter Song Version Number: ");
    readRequest newRead = {
            songKey:keyInput,
            songVersion: readSongVersion
    };
    
    sendReadRequest();
}

//A function to send read requests using a specified criteria
function readCriteria() {
    readRequest newRead = {};      
    io:println("Searching a record by criteria or combination of criterion:.....");

    //Prompting User for the Key
    io:println("Do you wish to add the Key to the criteria?(Reply Y/N)");
    string choice = io:readln("Enter Choice: ");
    while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        newRead["songKey"] = io:readln("Enter Song Key Number: ");   
    
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
        newRead["songVersion"] = io:readln("Enter Song Version Number: ");
                
    }
    else if (choice == "N"){
        io:println("The record Version will not be included in the search criteria!");
    }
       
    //Prompting user for the date
    io:println("Do you wish to add the Date to the criteria?(Reply Y/N)");
    choice = io:readln("Enter Choice: ");
    while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        newRead["date"] = io:readln("State date in the format: DD/MM/YYYY: ");
                
    }
    else if (choice == "N"){
        io:println("The Date will not be included in the search criteria!");
    }
    
    //Does user want to add artist name(s) to criteria
    choice = io:readln("Do you wish to add artist name(s) to the criteria?(Reply Y/N)");
    while (choice != "Y" && choice != "N") {
    io:println("Error!! Invalid input!");
    choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        int|error totalArtistsErRead = 'int:fromString(io:readln("Enter the total number artists you wish to add to the criteria: "));
        int totalArtistsRead = <int> totalArtistsErRead;

        //readartistDetails inputArtistRead1={};
        readartistDetails[] arayArtistsRead1 = [];
        foreach int i in 0..<totalArtistsRead{
        
        arayArtistsRead1[i].name = io:readln("Enter Artist Name: ");
        
        arayArtistsRead1[i].member = io:readln("Member(Enter yes or no): ");
        
    }
        newRead["allArtists"] = arayArtistsRead1;
    }
    else if (choice == "N"){
        io:println("The Artist name(s) will not be included in the search criteria!");
    }
    
    //Does user want to include band name
    io:println("Do you wish to add the band name to the criteria?(Reply Y/N)");
    choice = io:readln("Enter Choice: ");
    while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        newRead["band"] = io:readln("Enter Band Name: ");
             
    }
    else if (choice == "N"){
        io:println("The Band Name will not be included in the search criteria!");
    }
    
    //readsong songInfoRead = {};
    readsong[] songInfoRead = [];
    
    //Does user want to include song name
    io:println("Do you wish to add the song name to the criteria?(Reply Y/N)");
    choice = io:readln("Enter Choice: ");
    while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        songInfoRead[0].title = io:readln("Enter Song Title: ");      
    }
    else if (choice == "N"){
        io:println("The Song Name will not be included in the search criteria!");
    }

    //Does user want to include Genre
    io:println("Do you wish to add the Genre to the criteria?(Reply Y/N)");
    choice = io:readln("Enter Choice: ");
    while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        songInfoRead[0].genre = io:readln("Enter Song Genre: ");      
    }
    else if (choice == "N"){
        io:println("The Song Genre will not be included in the search criteria!");
    }

    //Does user want to include Platform
    io:println("Do you wish to add the Platform to the criteria?(Reply Y/N)");
    choice = io:readln("Enter Choice: ");
    while (choice != "Y" && choice != "N") {
        io:println("Error!! Invalid input!");
        choice = io:readln("Enter Y or N: ");
    }
    if(choice == "Y"){
        songInfoRead[0].platform = io:readln("Enter song platform: ");   
    }
    else if (choice == "N"){
        io:println("The Song Platform will not be included in the search criteria!");
    }   
    newRead["songDetails"] = songInfoRead;
     
    
    //Send Read Request and wait for response
    caliBlockingClient blockingEp = new("http://localhost:9090");
    
    var readResponse = blockingEp->readRecord(newRead);
    if (readResponse is grpc:Error) {
        io:println("Error from Connector: " + readResponse.reason() + " - "
                                                + <string>readResponse.detail()["message"] + "\n");
    } else {

            io:println("File Succesfully added: ",readResponse);
        
    }
    io:println("Add request details sent were: ", newRead.toString());
    
    displayOptions();
        
}

//A function that implements the send and receive functionionality of a read request

function sendReadRequest(){
    
    
}

//A function that allows the user to pick the type of read request they want to perform
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
    //send the read request to the server
    
}
function exit() {
    io:println("*******************GOOD BYE!!***********************");
}

public function main (string... args) {

    caliBlockingClient blockingEp = new("http://localhost:9090");

    // Welcome message
    io:println("*****************************************************************************");
    io:println("*****************************************************************************");
    io:println("                     WELCOME TO CALI: A MUSIC STORAGE SYSTEM");
    io:println("*****************************************************************************");
    io:println("*****************************************************************************");
    displayOptions();
    
}







//public function main (string... args) {

  //  caliBlockingClient blockingEp = new("http://localhost:9090");

//}





