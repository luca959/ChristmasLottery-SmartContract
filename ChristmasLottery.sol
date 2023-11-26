// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChristmasLottery{

    // state variables
    struct Ticket{
        uint256 date;
        string Name;
    }
    mapping(address => Ticket) LotteryFeed;
    address owner;
    address last;
    address[] writers;
    address[] LotteryPartecipants;
    
    event PersonAdded(uint256 _data, string _name, uint256 indexed _NumOfTickets);

    constructor() {
        last = owner = msg.sender;
    }

    function getLastTicketSold() public view returns (Ticket memory) {
        require(msg.sender == owner, "Only Luca can read the last ticket bought :)");
        return (LotteryFeed[last]);
    }

    function GetNumOfTicket() public view returns (uint256  num ){
        require(msg.sender == owner, "Only Luca can read the number of Tickets bought :)");
        num =writers.length ;
        return (num);
    }

    function GetAllTickets() public view returns (Ticket[] memory) {
        require(msg.sender == owner, "Only Luca can read all the tickets :)");

        Ticket[] memory messages = new Ticket[](writers.length);
        for (uint256 i = 0; i < writers.length; i++) {

            messages[i]=LotteryFeed[writers[i]];
        }
        return (messages);
    }

    function GetAllPartecipants() public view returns (address[] memory) {
        require(msg.sender == owner, "Only Luca can read all the Partecipants :)");
        return (LotteryPartecipants);
    }
    function ExtractLottery() public view returns(Ticket memory) {
        require (LotteryPartecipants.length >= 1, "To extract the winner we must have at least 1 partecipant");
        require(msg.sender == owner, "Only Luca can extract the winners :)");
        uint randNo= uint (keccak256(abi.encodePacked (msg.sender, block.timestamp)))%5;
        address wallet=LotteryPartecipants[randNo];
        return LotteryFeed[wallet];
    }

    function SellTicket(string memory _name, uint256  _NumOfTickets) public {
        require (bytes(_name).length > 0 && bytes(_name).length < 256, "Message cannot be empty and cannot be longer than 256 chars");
        require (_NumOfTickets > 0, "Buyer must buy at least 1 ticket");
        if (LotteryFeed[msg.sender].date == 0)
            writers.push(msg.sender);
        
        LotteryFeed[msg.sender] = Ticket(block.timestamp, _name);
        for (uint256 i = 0; i < _NumOfTickets ; i++) {
            LotteryPartecipants.push(msg.sender);
        }
        last = msg.sender;
        emit PersonAdded(block.timestamp, _name, _NumOfTickets);
    }

}
