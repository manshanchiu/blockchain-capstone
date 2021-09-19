const HDWallet = require("truffle-hdwallet-provider");
const proofJson = require("./proof.json");
const Web3 = require("web3");

const contractJson = require("./build/contracts/SolnSquareVerifier.json");
const ABI = contractJson.abi;
const fs = require("fs");
const mnemonic = fs.readFileSync(".secret").toString().trim();


(async () => {
  try {
    const web3 = new Web3(
      new HDWallet(
        mnemonic,
        `https://rinkeby.infura.io/v3/${process.env.INFURAKEY}`
      )
    );

    const contract = new web3.eth.Contract(ABI, process.env.CONTRACT_ADDRESS);

    for (let i = 0; i < 10; i++) {
      const p = proofJson[i];
      let t = await contract.methods
        .addSolution(owner, p.proof.a, p.proof.b, p.proof.c, p.inputs)
        .send({ from: owner });
      console.log(
        `added solution with tokenId = ${i} with transaction hash = ${t.transactionHash}`
      );
      let t2 = await contract.methods
        .mint(owner, p.proof.a, p.proof.b, p.proof.c, p.inputs)
        .send({ from: owner });
      console.log(
        `minted tokenId = ${i} with transaction hash = ${t2.transactionHash}`
      );
    }
  } catch (error) {
    console.log(error);
  }
})();
