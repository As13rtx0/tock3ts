pragma solidity ^0.8.0;

import "./ERC721Enumerable.sol";
import "./Ownable.sol";


contract EventFactory is ERC721Enumerable, Ownable {

    event NewEvent(Event newEvent);

    struct Event {
        uint id;
        address owner;
        EventTickets[] EventTock3ts;
        string name;
        string description;
        uint startDate;
        uint endDate;
        string location;
        string[] images;
        uint saleStartDate;
    }

    struct EventTock3t {
        uint id;
        uint eventId;
        Tock3t[] tock3ts;
        string name;
        string description;
        uint maxSupply;
        uint tokenPrice;
        uint available;
        string baseURI;
    }

    struct Tock3t {
        uint id;
        address owner;
        uint eventTock3tId;
        bool revealed;
    }

    Event[] events;
    EventTock3t[] eventTock3ts;
    Tock3t[] tock3ts;

    constructor() ERC721("tock3ts", "TOCK3T"){

    }

    function createEvent(string _eventName, string _eventDescription, uint _eventStartDate, uint _eventEndDate,
        string _eventLocation, string[] _eventImages, uint _saleStartDate, string[] _eTName, string[] _eTDescription,
        uint[] _eTMaxSupply, uint[] _eTTokenPrice, uint[] _eTAvailable, string[] _eTBaseURI) public payable {

        require(_eTName.length == _eTDescription.length == _eTMaxSupply.length ==
            _eTTokenPrice.length == _eTAvailable.length == _eTBaseURI.length, "tock3ts: group lengths do not coincide");

        EventTock3t[] newEventTock3ts;
        for (uint i=0; i < _eTName.length; i++){
            Tock3t[] emptyTock3ts;
            EventTock3t eventTock3t = EventTock3t(eventTock3ts.length +1, events.length + 1, emptyTock3ts, _eTName[i],
                _eTDescription[i], _eTMaxSupply[i], _eTTokenPrice[i], _eTAvailable[i], _eTBaseURI[i]);
            eventTock3ts.push(eventTock3t);
            newEventTock3ts.push(eventTock3t);
        }

        Event newEvent = Event(events.length + 1, msg.sender, newEventTock3ts, _eventName, _eventDescription, _eventStartDate,
            _eventEndDate, _eventLocation, _eventImages, _saleStartDate);
        events.push(newEvent);
        NewEvent(newEvent);
    }

    function buyTok3ts(uint eventTock3tId, uint tock3tAmount) payable{
        require(eventTock3ts[eventTock3tId].available >= tock3tAmount,
            "tock3ts: tock3t allocation exceeded");
        require(eventTock3ts[eventTock3tId].tokenPrice * tock3tAmount >= msg.value,
            "tock3ts: incorrect payable amount");

    }

    function register() payable {

    }

    function verify() onlyOwner{

    }


}
