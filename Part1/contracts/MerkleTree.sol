//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root
    uint256 public constant MAXIMUMLEAVES = 8;//constant to declare maximum number of leaves on tree
    uint256 public constant SIZE_OF_TREE = 15;//total hashes from tree
    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        for (uint256 i = 0; i < SIZE_OF_TREE; i++){
            hashes.push(0);
        }
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        require(index < MAXIMUMLEAVES,"Merkle tree is full I'm afraid");
        //statement should revert actions if tree is full
        hashes[index] = hashedLeaf;
        //saves leaf to given index
        index++;
        //moves to next leaf
        uint256 HASH_ID = MAXIMUMLEAVES;
        //assigns first calculated hash
        //for loop to calculate and update new hashes
        for(uint256 i = 0;i < SIZE_OF_TREE - 1; i += 2){
            uint256 j PoseidonT3.poseidon([hashes[i],hashes[i+1]]);
            hashes[HASH_ID] = j;
            HASH_ID++;
        }
        root = hashes[SIZE_OF_TREE - 1];
        //updates value of final hash
        return root;
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        if(!Verifier.verifyProof(a ,b ,c ,input)){
            return false;
        }

        uint256 Proof = input[0];
        if (Proof != root){
            return false
        }
        return true
    }
}
