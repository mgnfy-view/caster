import { StandardMerkleTree } from "@openzeppelin/merkle-tree";

import { inputValueForm, input } from "./input/input.js";

function generateMerkleRootAndProof() {
    const merkleTree = StandardMerkleTree.of(input, inputValueForm);
    const merkleRoot = merkleTree.root;

    let merkleProof = [];

    for (const [index, value] of merkleTree.entries()) {
        const proof = merkleTree.getProof(index);
        merkleProof.push(proof);
    }

    console.log("Input value form: ", inputValueForm);
    console.log("Input values: ", input);
    console.log("Generated merkle root: ", merkleRoot);
    console.log("Proofs for users in order: ", merkleProof);

    return {
        merkleTree,
        merkleRoot,
        merkleProof,
    };
}

generateMerkleRootAndProof();

export { generateMerkleRootAndProof };
