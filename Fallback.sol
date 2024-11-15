// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    /*The constructor is called when the contract is deployed, 
    and it initializes two variables:
    * owner: sets the current deployer as the owner of the contract.
    * contributions[msg.sender]: assigns an initial contribution 
    value to the deployer.*/

    constructor() {
        owner = msg.sender; //sets the current deployer as the owner of the contract.
        contributions[msg.sender] = 1000 * (1 ether); //assigns an initial contribution value to the deployer.
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }
/*The contribute() function allows anyone to send Ether to 
the contract and update their contribution value:
* The first line checks that the sent amount is less than 0.001 ether.
* It then updates the contributor's balance in the contributions 
mapping by adding the received amount (msg.value).
* If a new contributor has more contributions than 
the current owner, it sets them as the new owner.*/
    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

  /* The getContribution() function allows anyone to retrieve 
     their contribution value:
   * It simply returns the contributor's balance from the 
   contributions mapping.*/


    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    /*The withdraw() function can only be called by the owner 
    and transfers all contract funds to the owner:
    * The first line checks that the caller is indeed 
    the owner using the onlyOwner modifier.
   * It then uses a fallback payment (explained below) 
   to transfer the entire balance of the contract to the owner.*/

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

/* The receive() function is a fallback payment handler that 
can be called when someone sends Ether directly to this contract:
* The first line checks two conditions: the sender must have sent 
some value (msg.value > 0) and their contribution balance should 
not be zero.
* If both are true, it sets them as the new owner.
 Note how these functions interact with each other! */

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
/* So basically any person/anyone can send say 10 wei and become 
the owner of this contract.
Implemented security measures to prevent unauthorized access 
or modifications to the contract state.
Implement authentication and authorization mechanisms 

pragma solidity ^0.8.0;

contract MyContract {
    // Restrict ownership to only specific addresses
    address public immutable _owner;
    
    constructor() {
        _owner = msg.sender; // Set the owner as the contract creator
    }

    function transferOwnership(address newOwner) external {
        require(msg.sender == _owner, "Only the current owner can change it");
        _setNewOwner(newOwner);
    }

    function setRole(uint256 roleIndex, address userAddress) external onlyAuthorized(_owner) {
        // Update roles and permissions here
    }
}

An immutable variable _owner can't be changed once the contract 
is deployed.

The transferOwnership() function checks if the caller has 
ownership before allowing them to change it.

*/
