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
    uint256 randNo;
    address[] writers;
    uint256[] LotteryPartecipants;
    uint256[] LotteryKey;
    uint256 randNonce = 0;

    
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

    //function GetWriters() public view returns (address[] memory ){
      //  return (writers);
    //}
    function GetAllPartecipants() public view returns (Ticket[] memory) {
        require(msg.sender == owner, "Only Luca can read all the tickets :)");

        Ticket[] memory messages = new Ticket[](LotteryKey.length);
        for (uint256 i = 0; i <LotteryKey.length; ++i) {

            messages[i]=LotteryFeed[LotteryKey[i]];
        }
        return (messages);
    }
    function removeIndex() private {   
        require (LotteryPartecipants.length >0, " we must have at least 1 partecipant");
        uint256 lastItem=LotteryPartecipants.length-1;
        winner=LotteryPartecipants[randNo];
        if (LotteryPartecipants.length>0){
            LotteryPartecipants[randNo]=LotteryPartecipants[lastItem];
        }
        LotteryPartecipants.pop();
    }
 //
    function Extraction() public {

        require (LotteryPartecipants.length >= 1, "To extract the winner we must have at least 1 partecipant");
        require(msg.sender == owner, "Only Luca can extract the winners :)");
        randNo= uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce)))%LotteryPartecipants.length;
        randNonce++;
        //wallet=LotteryPartecipants[randNo];
        //randNo++;
        removeIndex();
    }
    //function GetW() public view returns (uint256  x ){
    //    return (randNo);
   // }
    function Winner() public view returns (Ticket memory) {
        require(msg.sender == owner, "Only Luca can read all the tickets :)");

        return (LotteryFeed[winner]);
    }

    function SellTicket(string memory _name,string memory _surname,uint256  _NumOfTickets) public {
        require (bytes(_name).length > 0 && bytes(_name).length < 256, "Message cannot be empty and cannot be longer than 256 chars");
        require (_NumOfTickets > 0, "Buyer must buy at least 1 ticket");
        require (_NumOfTickets < 99, "Buyer must buy at least 1 ticket");
        id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 900;
        id = id + 100;
        randNonce++;
        //check to do not replace an id
        while (LotteryFeed[id].matricola == id){
            id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 900;
            id = id + 100;
            randNonce++;
        }
        if (LotteryFeed[id].date == 0)
            writers.push(msg.sender);
        LotteryFeed[id] = Ticket(block.timestamp, _name,_surname,id);
        for (uint256 i = 0; i < _NumOfTickets ; i++) {
            LotteryPartecipants.push(id);
        }
        LotteryKey.push(id);
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
        delete LotteryKey;
        delete winner;
        delete randNo;
        delete randNonce;
    }


}
