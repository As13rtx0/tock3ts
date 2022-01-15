// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Enumerable.sol";
import "./Ownable.sol";


contract Tock3ts is ERC721Enumerable, Ownable {

    event NewEventCreated(Event newEvent);
    event NewEventTock3tCreated(EventTock3t newEventTock3t);
    event NewSale(uint eventid, uint tock3tAmount);

    struct Event {
        uint id;
        address owner;
        string name;
        string description;
        uint startDate;
        uint endDate;
        string location;
        string[] images;
        uint saleStartDate;
        uint saleEndDate;
    }

    struct EventTock3t {
        uint id;
        uint eventId;
        string name;
        string description;
        uint maxSupply;
        uint tokenPrice;
        uint mintedSupply;
        string baseImageURI;
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
    mapping(address => bool) isAddressVerified;

    uint registerPrice;
    uint createEventPrice;

    constructor (uint _registerPrice, uint _createEventPrice) ERC721("tock3ts", "TOCK3T"){
        registerPrice = _registerPrice;
        createEventPrice = _createEventPrice;
    }

    function createEvent(string _eventName, string _eventDescription, uint _eventStartDate, uint _eventEndDate,
        string _eventLocation, string[] _eventImages, uint _saleStartDate, uint _saleEndDate, string[] _eTName,
        string[] _eTDescription, uint[] _eTMaxSupply, uint[] _eTTokenPrice, string[] _eTBaseImageURI) public payable {
        require(createEventPrice <= msg.value, "tock3ts: incorrect payable amount.");
        require(isAddressVerified[msg.sender], "tock3ts: address not verified.");
        require(_eTName.length == _eTDescription.length == _eTMaxSupply.length ==
            _eTTokenPrice.length == _eTBaseURI.length, "tock3ts: array lengths do not coincide.");

        Event memory newEvent = Event(events.length + 1, msg.sender, _eventName, _eventDescription, _eventStartDate,
            _eventEndDate, _eventLocation, _eventImages, _saleStartDate, _saleEndDate);
        events.push(newEvent);
        NewEventCreated(newEvent);

        for (uint i=0; i < _eTName.length; i++){
            EventTock3t memory eventTock3t = EventTock3t(eventTock3ts.length +1, newEvent.id, _eTName[i],
                _eTDescription[i], _eTMaxSupply[i], _eTTokenPrice[i], 0, _eTBaseImageURI[i]);
            eventTock3ts.push(eventTock3t);
            NewEventTock3tCreated(eventTock3t);
        }

    }

    function buyTok3ts(uint eventTock3tId, uint tock3tAmount) public payable{
        EventTock3t memory eventTock3t = _getEventTock3t(eventTock3tId);
        Event memory thisEvent = _getEvent(eventId);
        require(eventTock3t.mintedSupply + tock3tAmount <= eventTock3t.maxSupply,
            "tock3ts: tock3t allocation exceeded.");
        require(eventTock3t.tokenPrice * tock3tAmount <= msg.value,
            "tock3ts: incorrect payable amount.");
        require(block.timestamp >= thisEvent.saleStartDate,
            "tock3ts: sale for this event has not started");
        require(block.timestamp < thisEvent.saleEndDate,
            "tock3ts: sale for this event has ended");

        for (uint i=0; i < tock3tAmount; i++){
            Tock3t memory tock3t;
            tock3t.id = tock3ts.length + 1;
            tock3t.eventTock3tId = eventTock3tId;
            tock3t.tokenNumber = eventTock3t.mintedSupply.Add(1);
            tock3t.revealed = false;
            _safeMint(msg.sender, tock3t.id);
        }
        payable(thisEvent.owner).transfer((eventTock3t.tokenPrice * tock3tAmount) * 4 / 5);
        NewSale(eventTock3t.eventId, tock3tAmount);
    }

    function register() payable public {
        require(registerPrice <= msg.value, "tock3ts: incorrect payable amount.");

        isAddressRegistered[msg.sender] = true;
    }

    function verify(address addr) public onlyOwner{
        isAddressVerified[addr] = true;
        isAddressRegistered[addr] = false;
    }

    function bulkVerify(address[] addresses) public onlyOwner{
        for (uint i=0; i < addresses.length; i++){
            isAddressVerified[addresses[i]] = true;
            isAddressRegistered[addresses[i]] = false;
        }
    }

    function unverify(address addr) public onlyOwner{
        isAddressVerified[addr] = false;
    }

    function isVerified(address addr) public returns (bool){
        return isAddressVerified[addr];
    }

    function isRegistered(address addr) public returns (bool){
        return isAddressRegistered[addr];
    }

    function setRegisterPrice(uint _registerPrice) public onlyOwner{
        registerPrice = _registerPrice;
    }

    function setCreateEventPrice(uint _createEventPrice) public onlyOwner{
        createEventPrice = _createEventPrice;
    }

    function withdraw() external onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }

    function _getEvent(uint eventId) private returns (Event){
        return events[eventId];
    }

    function _getEventTock3t(uint eventTock3tId) private returns (EventTock3t){
        return eventTock3ts[eventTock3tId];
    }

    function _getTock3t(uint tock3tId) private returns (Tock3t){
        return tock3ts[tock3tId];
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        require(_exists(tokenId), "Cannot query non-existent token");

        return _getEventTock3t(_getTock3t(tokenId).eventTock3tId).baseImageURI);
    }
}
