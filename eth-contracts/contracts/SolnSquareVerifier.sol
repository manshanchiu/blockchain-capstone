pragma solidity >=0.4.21;

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
import "./ERC721Mintable.sol";


// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is CustomERC721Token {
    // TODO define a solutions struct that can hold an index & an address
    struct Solution {
        uint256 index;
        address _address;
        bool used;
        bytes32 key;
    }

    // TODO define an array of the above struct
    uint private numberOfSolutions;

    // TODO define a mapping to store unique solutions submitted
    mapping(bytes32 => Solution) private uniqueSolutions;

    // TODO Create an event to emit when a solution is added
    event addedSolution(uint256 index, address _address);

    function solutions() public view returns(uint256){
        return numberOfSolutions;
    }

    // TODO Create a function to add the solutions to the array and emit the event
    function addSolution(address _address, uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[2] memory input) public {
        bytes32 uniqueKey = keccak256(abi.encodePacked(a, b, c, input));
        require(uniqueSolutions[uniqueKey]._address == address(0), "solution has been added");
        uint256 newIndex = numberOfSolutions + 1;
        Solution memory newSolution = Solution(newIndex,_address,false,uniqueKey);
        uniqueSolutions[uniqueKey] = newSolution;
        numberOfSolutions++;
        emit addedSolution(newIndex,_address);
    }

    // TODO Create a function to mint new NFT only after the solution has been verified
    //  - make sure the solution is unique (has not been used before)
    //  - make sure you handle metadata as well as tokenSuplly

    function mint(address _address, uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[2] memory input) public onlyOwner returns(bool) {
        bytes32 uniqueKey = keccak256(abi.encodePacked(a, b, c, input));
        require(uniqueSolutions[uniqueKey]._address != address(0), "solution doesn't exist");
        require(uniqueSolutions[uniqueKey].used != true, "solution has been used");
        uniqueSolutions[uniqueKey].used = true;
        super.mint(_address,uniqueSolutions[uniqueKey].index);
    }


}











  


























