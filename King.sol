// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract King {
    
    address king; // Stores the address of the current "king" (the person who sent the highest value).
    uint256 public prize; // Public variable to store the current prize amount (minimum value required to become the king).
    address public owner; // Public variable to store the address of the contract owner.

    // Constructor function that runs once when the contract is deployed.
    // The `payable` keyword allows the constructor to receive Ether.
    constructor() payable {
        owner = msg.sender; // Sets the contract deployer as the owner.
        king = msg.sender; // Sets the contract deployer as the initial king.
        prize = msg.value;  // Sets the initial prize as the Ether sent during deployment.
    }

    /* Fallback function that is triggered when Ether is sent to the contract.
     The `payable` keyword allows the function to receive Ether.*/
    receive() external payable {
         /* Ensures that the sent Ether is greater than or equal to the current prize,
        or the sender is the owner (owner can always send Ether without restrictions).*/
        require(msg.value >= prize || msg.sender == owner);       
 
        payable(king).transfer(msg.value); // Transfers the sent Ether to the current king.

        king = msg.sender; // Updates the king to the address of the sender.

        prize = msg.value; // Updates the prize to the value of the Ether sent.
    }

    /* Public view function to return the address of the current king.
     The `view` keyword indicates that this function does not modify the state.*/
    function _king() public view returns (address) {
        return king; // Returns the address of the current king.
    }
}
