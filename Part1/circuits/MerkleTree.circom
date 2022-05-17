pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "hasherPoseidon.circom";


template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    //var declaration of total leaves to simplify signal
    var tLeaves = 2 ** n;
    //implememntation of total number of leaves declaration into signal
    //input signal
    signal input leaves[tLeaves];
    //output signal (merkle root value)
    signal output root;
    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
    
    //total hash components (leftright)
    var HasherComponents = tLeaves / 2;

    //components to hash the output of the left hasher components
    var InterMediateHashers = HasherComponents - 1;

    // The total number of hashers
    var TotalHashers = tLeaves - 1;

    component hashers[TotalHashers];
    
    // Instantiate all hashers
    var i;
    for (i=0; i < TotalHashers; i++) {
        hashers[i] = HashLeftRight();
    }

    // Wire the leaf values into the leaf hashers
    for (i=0; i < HasherComponents; i++){
        hashers[i].left <== leaves[i*2];
        hashers[i].right <== leaves[i*2+1];
    }

    // Wire the outputs of the leaf hashers to the intermediate hasher inputs
    var k = 0;
    for (i = HasherComponents;i < HasherComponents + InterMediateHashers; i++) {
        hashers[i].left <== hashers[k*2].hash;
        hashers[i].right <== hashers[k*2+1].hash;
        k++;
    }

    // Wire the output of the final hash to this circuit's output
    root <== hashers[TotalHashers-1].hash;
}

