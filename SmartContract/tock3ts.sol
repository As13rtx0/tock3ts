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
        uint mintedSupply;
        string baseURI;
    }

    struct Tock3t {
        uint id;
        uint eventTock3tId;
        uint tokenNumber;
        bool revealed;
    }

    Event[] events;
    EventTock3t[] eventTock3ts;
    Tock3t[] tock3ts;

    mapping(address => bool) isAddressRegistered;
    mapping(address => uint) isAddressVerified;

    //mapping(uint => address) public tock3tToOwner;
    //mapping(address => uint) ownerTock3tCount;

    uint registerPrice;
    uint createEventPrice;

    //Prices go in ether
    constructor(uint _registerPrice, uint _createEventPrice) ERC721("tock3ts", "TOCK3T"){
        registerPrice = _registerPrice * 1 ether;
        createEventPrice = _createEventPrice * 1 ether;
    }

    function createEvent(string _eventName, string _eventDescription, uint _eventStartDate, uint _eventEndDate,
        string _eventLocation, string[] _eventImages, uint _saleStartDate, string[] _eTName, string[] _eTDescription,
        uint[] _eTMaxSupply, uint[] _eTTokenPrice, string[] _eTBaseURI) public payable {
        require(createEventPrice <= msg.value, "tock3ts: incorrect payable amount.");
        require(isAddressVerified[msg.sender], "tock3ts: address not verified.");
        require(_eTName.length == _eTDescription.length == _eTMaxSupply.length ==
            _eTTokenPrice.length == _eTBaseURI.length, "tock3ts: array lengths do not coincide.");

        EventTock3t[] newEventTock3ts;
        for (uint i=0; i < _eTName.length; i++){
            Tock3t[] emptyTock3ts;
            EventTock3t eventTock3t = EventTock3t(eventTock3ts.length +1, events.length + 1, emptyTock3ts, _eTName[i],
                _eTDescription[i], _eTMaxSupply[i], _eTTokenPrice[i], 0, _eTBaseURI[i]);
            eventTock3ts.push(eventTock3t);
            newEventTock3ts.push(eventTock3t);
        }

        Event newEvent = Event(events.length + 1, msg.sender, newEventTock3ts, _eventName, _eventDescription, _eventStartDate,
            _eventEndDate, _eventLocation, _eventImages, _saleStartDate);
        events.push(newEvent);
        NewEvent(newEvent);
    }

    function buyTok3ts(uint eventTock3tId, uint tock3tAmount) payable{
        require(eventTock3ts[eventTock3tId].mintedSupply + tock3tAmount <= eventTock3ts[eventTock3tId].maxSupply,
            "tock3ts: tock3t allocation exceeded.");
        require(eventTock3ts[eventTock3tId].tokenPrice * tock3tAmount <= msg.value,
            "tock3ts: incorrect payable amount.");

        for (uint i=0; i < tock3tAmount; i++){
            Tock3t tock3t;
            tock3t.id = tock3ts.length + 1;
            tock3t.eventTock3tId = eventTock3tId;
            tock3t.tokenNumber = eventTock3ts[eventTock3tId].mintedSupply.Add(1);
            tock3t.revealed = false;
            _safeMint(msg.sender, tock3t.id);
        }
    }

    function register() payable {
        require(registerPrice <= msg.value, "tock3ts: incorrect payable amount.");

        isAddressRegistered[msg.sender] = true;
    }

    function verify(address addr) onlyOwner{
        isAddressVerified[addr] = true;
    }

    function bulkVerify(address[] addresses) onlyOwner{
        for (uint i=0; i < addresses.length; i++){
            isAddressVerified[addresses[i]] = true;
        }
    }

    function unverify(address addr) onlyOwner{
        isAddressVerified[addr] = false;
    }

    function isVerified(address addr) returns (bool){
        return isAddressVerified[addr];
    }

    function isRegistered(address addr) returns (bool){
        return isAddressRegistered[addr];
    }

    //Price goes in ether
    function setRegisterPrice(uint _registerPrice) onlyOwner{
        registerPrice = _registerPrice * 1 ether;
    }

    //Price goes in ether
    function setCreateEventPrice(uint _createEventPrice) onlyOwner{
        createEventPrice = _createEventPrice * 1 ether;
    }

}
