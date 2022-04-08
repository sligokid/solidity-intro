/ SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ParcelMutex {

    // Authentication
    address owner;

    // Authorization
    mapping(address => bool) authorizedAddresses;

    mapping(string => bool) parcels;

    // notify event to the world (every node) via the transaction receipt
    event alert(string _message);

    constructor() {
        owner = msg.sender;
    }

    modifier isAuthenticated() {
        require(msg.sender == owner, "Only the owner can call me");
        _; // go back and finish out the caller function
    }

    modifier isAuthorized() {
        require(authorizedAddresses[msg.sender], "Only an authorized address can call me");
        _; // go back and finish out the caller function
    }

    function registerNotary(address _notaryWalletAddress) public isAuthenticated {
        authorizedAddresses[_notaryWalletAddress] = true;
    }

    function lockParcel(string memory _upi) public isAuthorized {
        parcels[_upi] = true;
        emit alert(_upi);
    }

    function releaseParcel(string memory _upi) public isAuthorized {
        require(parcels[_upi], "Remove failed - upi not found");
        delete parcels[_upi];
        emit alert(_upi);
    }

    function isLocked(string memory _upi) view external returns (bool)  {
        return parcels[_upi];
    }

}
