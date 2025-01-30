// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12; //Current version of solidity is 0.8.28

import "openzeppelin-contracts-06/math/SafeMath.sol"; 

contract Reentrance {
    
    using SafeMath for uint256; // Attaches SafeMath functions to the `uint256` type for safe arithmetic operations.

    mapping(address => uint256) public balances; // A public mapping to store the Ether balances of addresses.
    
     
     /*A payable function that allows users to donate Ether to a specific address.
       The `payable` keyword allows the function to receive Ether.*/
    function donate(address _to) public payable {
 	
 	// Adds the sent Ether (`msg.value`) to the balance of the 
 	// specified address (`_to`). Uses SafeMath's `add` function to prevent overflow.
        balances[_to] = balances[_to].add(msg.value);
       
    }
 	
 	// to check the balance of a specific address.
    function balanceOf(address _who) public view returns (uint256 balance) {       
     
        return balances[_who];// Returns the balance of the specified address (`_who`).
    }

	// allows users to withdraw a specified amount of Ether.
    function withdraw(uint256 _amount) public {        

        if (balances[msg.sender] >= _amount) { // Checks if the sender's balance is greater than or equal to the requested amount.
            

            (bool result,) = msg.sender.call{value: _amount}("");
            // Sends the specified amount of Ether to the sender using a low-level `call`.
            // The `call` function returns a boolean indicating success or failure.

            if (result) { // Checks if the Ether transfer was successful.
                _amount;
                
            }

            balances[msg.sender] -= _amount;
            // Deducts the withdrawn amount from the sender's balance.
            // Note: This line is vulnerable to reentrancy attacks because the balance is updated after the transfer.
        }
    }

    receive() external payable {}
    // Fallback function that allows the contract to receive Ether.
    // The `payable` keyword allows the function to receive Ether.
}

--------------updated version
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// Imports the ReentrancyGuard contract from OpenZeppelin 5.0 to prevent reentrancy attacks.

contract Reentrance is ReentrancyGuard {
 
    mapping(address => uint256) public balances;
    // A public mapping to store the Ether balances of addresses.
    
     /*A payable function that allows users to donate Ether to a specific address.
        The `payable` keyword allows the function to receive Ether.*/
    function donate(address _to) public payable {

        balances[_to] += msg.value;
        // Adds the sent Ether (`msg.value`) to the balance of the specified address (`_to`).
        // Solidity 0.8.x has built-in overflow checks, so SafeMath is no longer needed.
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
 
        return balances[_who];      
    }
    
       /*A function that allows users to withdraw a specified amount of Ether.
         The `nonReentrant` modifier prevents reentrancy attacks.*/
    function withdraw(uint256 _amount) public nonReentrant {

        require(balances[msg.sender] >= _amount, "Insufficient balance");// Ensures the sender has enough balance to withdraw the specified amount.

        balances[msg.sender] -= _amount;
        // Deducts the withdrawn amount from the sender's balance.
        // This is done BEFORE sending Ether to prevent reentrancy attacks.

        (bool success, ) = msg.sender.call{value: _amount}("");
        // Sends the specified amount of Ether to the sender using a low-level `call`.
        // The `call` function returns a boolean indicating success or failure.

        require(success, "Transfer failed");
        // Ensures the Ether transfer was successful. If not, it reverts the transaction.
    }

    receive() external payable {}
    // Fallback function that allows the contract to receive Ether.
    // The `payable` keyword allows the function to receive Ether.
}
