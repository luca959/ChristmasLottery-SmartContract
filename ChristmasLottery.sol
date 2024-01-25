// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChristmasLottery{

    // state variables
    struct Ticket{
        uint256 date;
        string Name;
        string Surname;
        uint256 Id;
    }
    mapping(uint256 => Ticket) LotteryFeed;
    address owner;
    address wallet;
    uint256 winner;
    uint256 last;
    uint randNo;
    address[] writers;
    address[] LotteryPartecipants;
    
    event PersonAdded(uint256 _data, string _name, string _surname,string _id,uint256 indexed _NumOfTickets);

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

    function GetAllPartecipants() public view returns (Ticket[] memory) {
        require(msg.sender == owner, "Only Luca can read all the tickets :)");

        Ticket[] memory messages = new Ticket[](writers.length);
        for (uint256 i = 0; i < writers.length; i++) {

            messages[i]=LotteryFeed[i];
        }
        return (messages);
    }
    function removeIndex(uint index) private{   
        require(index < LotteryPartecipants.length,"Tutti i partecipanti sono stati estratti");
        for(uint256 i = index ; i < LotteryPartecipants.length - 1; i ++)
        {
            LotteryPartecipants[i] = LotteryPartecipants[i + 1];
        }
        // swap LP[index] with LP[last] and then pop

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

    function SellTicket(string memory _name,string memory _surname,uint256  _id,uint256  _NumOfTickets) public {
        require (bytes(_name).length > 0 && bytes(_name).length < 256, "Message cannot be empty and cannot be longer than 256 chars");
        require (_NumOfTickets > 0, "Buyer must buy at least 1 ticket");
        require (_NumOfTickets < 99, "Buyer must buy at least 1 ticket");

        if (LotteryFeed[_id].date == 0)
            writers.push(msg.sender);
        
        LotteryFeed[_id] = Ticket(block.timestamp, _name,_surname,_id);
        for (uint256 i = 0; i < _NumOfTickets ; i++) {
            LotteryPartecipants.push(msg.sender);
        }
        last = _id;
        emit PersonAdded(block.timestamp, _name,_surname,_id, _NumOfTickets);
    }
    function closeLottery() public {
        require(msg.sender == owner, "Only Luca can Close the lottery :)");

        for (uint256 i = 0; i < writers.length; i++) {
            delete LotteryFeed[i];
        }
        delete writers;
        delete LotteryPartecipants;
    }


}
