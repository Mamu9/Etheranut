/*The creator of this contract was careful enough to protect the sensitive areas of its storage.

Unlock this contract to beat the level.

Things that might help:
    Understanding how storage works
    Understanding how parameter parsing works
    Understanding how casting works

Tips:
Remember that metamask is just a commodity. Use another tool if it is presenting problems. 
Advanced gameplay could involve using remix, or your own web3 provider.*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    // Public state variables
    bool public locked = true;          // Initial lock state (true = locked)
    uint256 public ID = block.timestamp; // Public ID set to deployment timestamp
    
    // Private state variables (Note: On-chain data is NEVER truly private)
    uint8 private flattening = 10;      // 8-bit unsigned integer (0-255)
    uint8 private denomination = 255;   // Max value for uint8 (2^8 - 1)
    uint16 private awkwardness = uint16(block.timestamp); // Truncated timestamp to 16 bits
    
    // Fixed-size byte array storage (32 bytes * 3 slots)
    bytes32[3] private data;            // Private data storage (still visible on-chain)

    // Constructor initializes the private data array
    constructor(bytes32[3] memory _data) {
        data = _data;  // Copies calldata/memory input to storage (costs gas)
    }

    // Unlock function that compares first 16 bytes of data[2] with _key
    function unlock(bytes16 _key) public {
        // Compare input key with first 16 bytes of data[2] (truncates 32-byte value)
        require(_key == bytes16(data[2]), "Invalid key");
        
        locked = false; // Unlock the contract if key matches
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
    */
}


/*
Storage Layout 
---------------------------------------------------------------------------
slot      variable          type              notes
---------------------------------------------------------------------------
0         locked            bool            1 byte(remaining space unused)
---------------------------------------------------------------------------
0	      ID	            uint256	        Full 32-byte slot (overwrites prev)
---------------------------------------------------------------------------
1	      flattening	    uint8	        Packed with denomination & awkwardnes
---------------------------------------------------------------------------
1         denomination      uint8
---------------------------------------------------------------------------
1         awkwardness       uint16
---------------------------------------------------------------------------
2         data[0]           bytes32
---------------------------------------------------------------------------
3         data[1]           bytes32
---------------------------------------------------------------------------
4         data[2]           bytes32        Used in unlock() comparison
---------------------------------------------------------------------------


*/
