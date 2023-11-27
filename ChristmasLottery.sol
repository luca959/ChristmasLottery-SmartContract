// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChristmasLottery{

    // state variables
    struct Ticket{
        uint256 date;
        string Name;
        string Surname;
    }
    mapping(address => Ticket) LotteryFeed;
    address owner;
    address wallet;
    address last;
    uint randNo;
    address[] writers;
    address[] LotteryPartecipants;
    address[] ExtractedPartecipants;
    
    event PersonAdded(uint256 _data, string _name, string _surname,uint256 indexed _NumOfTickets);

    constructor() {
        last = owner = msg.sender;
    }

    function getLastTicketSold() public view returns (Ticket memory) {
        require(msg.sender == owner, "Only Luca can read the last ticket bought :)");
        return (LotteryFeed[last]);
    }

    function GetNumOfPartecipants() public view returns (uint256  num ){
        require(msg.sender == owner, "Only Luca can read the number of Tickets bought :)");
        num =writers.length ;
        return (num);
    }

    function GetAllPartecipants() public view returns (Ticket[] memory) {
        require(msg.sender == owner, "Only Luca can read all the tickets :)");

        Ticket[] memory messages = new Ticket[](writers.length);
        for (uint256 i = 0; i < writers.length; i++) {

            messages[i]=LotteryFeed[writers[i]];
        }
        return (messages);
    }
    function removeIndex(uint index) private{   
        require(index < LotteryPartecipants.length,"Tutti i partecipanti sono stati estratti");
        for(uint256 i = index ; i < LotteryPartecipants.length - 1; i ++)
        {
            LotteryPartecipants[i] = LotteryPartecipants[i + 1];
        }

        LotteryPartecipants.pop();
    }
   // function showExtractNum() public view returns(uint ){ // i use this to check if the rand int is really random
     //   return randNo; 
    //}
    function Extraction() public returns (address[] memory) {
        require (LotteryPartecipants.length >= 1, "To extract the winner we must have at least 1 partecipant");
        require(msg.sender == owner, "Only Luca can extract the winners :)");
        randNo= uint (keccak256(abi.encodePacked (msg.sender, block.timestamp)))%LotteryPartecipants.length;
        wallet=LotteryPartecipants[randNo];
        removeIndex(randNo);
        return LotteryPartecipants;

    }
    function Winner() public view returns (Ticket memory) {
        require(msg.sender == owner, "Only Luca can read all the tickets :)");
        return LotteryFeed[wallet];
    }

    function SellTicket(string memory _name,string memory _surname, uint256  _NumOfTickets) public {
        require (bytes(_name).length > 0 && bytes(_name).length < 256, "Message cannot be empty and cannot be longer than 256 chars");
        require (_NumOfTickets > 0, "Buyer must buy at least 1 ticket");
        if (LotteryFeed[msg.sender].date == 0)
            writers.push(msg.sender);
        
        LotteryFeed[msg.sender] = Ticket(block.timestamp, _name,_surname);
        for (uint256 i = 0; i < _NumOfTickets ; i++) {
            LotteryPartecipants.push(msg.sender);
        }
        last = msg.sender;
        emit PersonAdded(block.timestamp, _name,_surname, _NumOfTickets);
    }

}
