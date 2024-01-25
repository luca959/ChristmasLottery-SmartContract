// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChristmasLottery{

    // state variables
    struct Ticket{
        uint256 date;
        string Name;
        string Surname;
        uint256 matricola;
    }
    uint256 id=0;
    mapping(uint256 => Ticket) LotteryFeed;
    //in order to delete map keep an array of all the keys
    address owner;
    address wallet;
    uint256 winner;
    uint256 last;
    uint randNo;
    address[] writers;
    address[] LotteryPartecipants;
    
    event PersonAdded(uint256 _data, uint256 id,string _name, string _surname,uint256 indexed _NumOfTickets);

    constructor() {
        owner = msg.sender;
    }

    function getLastTicketSold() public view returns (Ticket memory) {
        require(msg.sender == owner, "Only Luca can read the last ticket bought :)");
        return (LotteryFeed[last]);
    }

    function GetNumOfPartecipants() public view returns (uint256  num ){
        num =writers.length ;
        return (num);
    }

    function GetWriters() public view returns (address[] memory ){
        return (writers);
    }
    function GetAllPartecipants() public view returns (Ticket[] memory) {
        require(msg.sender == owner, "Only Luca can read all the tickets :)");

        Ticket[] memory messages = new Ticket[](id);
        for (uint256 i = 0; i <id; ++i) {

            messages[i]=LotteryFeed[i+1];
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
 
    function Extraction() public returns (address[] memory) {
        require (LotteryPartecipants.length >= 1, "To extract the winner we must have at least 1 partecipant");
        require(msg.sender == owner, "Only Luca can extract the winners :)");
        randNo= uint (keccak256(abi.encodePacked (msg.sender, block.timestamp)))%LotteryPartecipants.length;
        //wallet=LotteryPartecipants[randNo];
        winner=randNo;
        removeIndex(randNo);
        return LotteryPartecipants;

    }
    function Winner() public view returns (Ticket memory) {
        require(msg.sender == owner, "Only Luca can read all the tickets :)");

        return (LotteryFeed[winner]);
    }

    function SellTicket(string memory _name,string memory _surname,uint256  _NumOfTickets) public {
        require (bytes(_name).length > 0 && bytes(_name).length < 256, "Message cannot be empty and cannot be longer than 256 chars");
        require (_NumOfTickets > 0, "Buyer must buy at least 1 ticket");
        require (_NumOfTickets < 99, "Buyer must buy at least 1 ticket");
        id= id+1;

        if (LotteryFeed[id].date == 0)
            writers.push(msg.sender);
        
        LotteryFeed[id] = Ticket(block.timestamp, _name,_surname,id);
        for (uint256 i = 0; i < _NumOfTickets ; i++) {
            LotteryPartecipants.push(msg.sender);
        }
        last = id;
        emit PersonAdded(block.timestamp,id, _name,_surname,_NumOfTickets);
    }

    function closeLottery() public {
        require(msg.sender == owner, "Only Luca can Close the lottery :)");

        for (uint256 i = 1; i < id; i++) {
            delete LotteryFeed[i];
        }
        delete writers;
        delete LotteryPartecipants;
        delete id;
        delete last;
    
    }


}
