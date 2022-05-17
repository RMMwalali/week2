#!/bin/bash

cd circuits

if [ -f ./powersOfTau28_hez_final_15.ptau ]; then
    echo "powersOfTau28_hez_final_15.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_15.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_15.ptau
fi

echo "Compiling circuit.circom..."

# compile circuit

circom circuit.circom --r1cs --wasm --sym -o 
snarkjs r1cs info circuit.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup circuit.r1cs powersOfTau28_hez_final_15.ptau circuit_final.zkey


snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier circuit_final.zkey ../contracts/verifier.sol

cd ..