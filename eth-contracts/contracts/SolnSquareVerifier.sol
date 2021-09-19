pragma solidity >=0.4.21;

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
import "./ERC721Mintable.sol";


// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is CustomERC721Token {
    // TODO define a solutions struct that can hold an index & an address
    struct Solution {
        uint256 index;
        address solution;
        bool used;
    }

    // TODO define an array of the above struct
    uint private numberOfSolutions;

    // TODO define a mapping to store unique solutions submitted
    mapping(address => Solution) private uniqueSolutions;

    // TODO Create an event to emit when a solution is added
    event addedSolution(uint256 index, address solution);

    function solutions() public view returns(uint256){
        return numberOfSolutions;
    }

    // TODO Create a function to add the solutions to the array and emit the event
    function addSolution(address solution, uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[2] memory input) public {
        require(solution != address(0), "please enter a valid address");
        require(uniqueSolutions[solution].solution == address(0), "solution has been added");
        uint256 newIndex = numberOfSolutions + 1;
        Solution memory newSolution = Solution(newIndex,solution,false);
        uniqueSolutions[solution] = newSolution;
        numberOfSolutions++;
        emit addedSolution(newIndex,solution);
    }

    // TODO Create a function to mint new NFT only after the solution has been verified
    //  - make sure the solution is unique (has not been used before)
    //  - make sure you handle metadata as well as tokenSuplly

    function mint(address solution) public {
        require(uniqueSolutions[solution].solution != address(0), "solution doesn't exist");
        require(uniqueSolutions[solution].used != true, "solution has been used");
        uniqueSolutions[solution].used = true;
        super.mint(solution,uniqueSolutions[solution].index);
    }


}











  


























