// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract HellowWorld {

    // notify event to the world (every node) via the transaction receipt
    event alert(string message);
    
    // long term storage 
    string public message;
    
    function updateMessage(string memory _message) public isAuthorized {


        message = _message;
        emit alert(_message);
    }

    // Authentication
    address owner;

    modifier isAuthenticated() {
        require(msg.sender == owner, "Only the owner can call me");
        _; // go back and finish out the caller function
    }

    // Authorization
    mapping(address => bool) authorizedAddresses;

    function registerAuthorizedUser(address _authorizedUserAddress) public isAuthenticated {
        authorizedAddresses[_authorizedUserAddress] = true;
    }

    modifier isAuthorized() {
        require(authorizedAddresses[msg.sender], "Only an authorized address can call me");
        _; // go back and finish out the caller function
    }

    function anyoneCanCallMe(string memory _message) public {
        message = _message;
        emit alert(_message);
    }

    constructor() {
        owner = msg.sender;
    }

    // Storage is expensive, transaction calls are cheap
}