// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-contracts-06/math/SafeMath.sol"; //optdated. Must be replaced with Math.sol

contract Fallout {
    using SafeMath for uint256;
    
    mapping(address => uint256) allocations;
    address payable public owner;

    /* constructor */
    function Fal1out() public payable {  //outdated. Now constructor is defined by the constructor() keyword
        owner = msg.sender;
        allocations[owner] = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    /*Allows any address to add to their allocation by sending Ether. And 
    increases the allocation of the caller (`msg.sender`) by the 
    amount sent (`msg.value`).*/
    function allocate() public payable {
        allocations[msg.sender] = allocations[msg.sender].add(msg.value);
    }
    
     /*Transfers the allocated Ether to a specified `allocator` address if 
     they have a positive allocation. It checks if the allocator's balance 
     is greater than 0 before transferring.*/
    function sendAllocation(address payable allocator) public {
        require(allocations[allocator] > 0);
        allocator.transfer(allocations[allocator]);
    }

    /*Allows the contract owner to collect all the Ether stored in 
    the contract (`address(this).balance`) and transfer it to their address. 
    This is restricted to the `owner` using the `onlyOwner` modifier.*/
    function collectAllocations() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    //A view aka read only function that returns the 
    //current allocation balance for a specified `allocator` address.
    function allocatorBalance(address allocator) public view returns (uint256) {
        return allocations[allocator];
    }
}

// Import OpenZeppelin's Math library to use utility functions.
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/Math.sol";

contract Fallout {
    // Mapping of user addresses (keys) and their allocated Ether values (values).
    mapping(address => uint256) public allocations;

    // The owner of this contract, initialized with the sender's address.
    address private owner;

    constructor() public payable {
        // Set initial state: allocate caller's sent Ether to themselves.
        owner = msg.sender;
        allocations[owner] = msg.value;  // Allocate funds from constructor call
    }

    modifier onlyOwner() {  
      require(msg.sender == owner);   
      _; 
    } 

   function allocate(uint256 amount) public {
       // Update allocation for the current user (msg.sender).
       allocations[msg.sender].add(amount);
     }
    
function sendAllocation(address payable allocator, uint256 amount)
        external
        onlyOwner()
{
  require(msg.sender == owner);  
      msg.value =amount;
    }

 function collectAllocations() public {
   // Allow owner to withdraw all accumulated balances from users.
   (owner).transfer(address(this).balance);
 }
