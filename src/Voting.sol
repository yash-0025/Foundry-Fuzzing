// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";
contract Voting is Ownable{


// @note :: Proposal struct for paramaters of proposal
    struct Proposal {
        string description;
        uint256 voteCount;
        bool executed;
    }

// Array of proposals
    Proposal[] public proposals;

// Tracking the address with ID and boolean to check the user has voted on which ID 
    mapping(address => mapping(uint256 => bool)) public votes;
    constructor() Ownable(msg.sender) {
        _transferOwnership(msg.sender);
    }

// OnlyOwner can create proposal
// Owner describe the parameters and create proposal
    function createProposal(string memory _description) public onlyOwner {
        proposals.push(Proposal({
            description: _description,
            voteCount: 0,
            executed: false
        }));
    }

// Anyone can vote on the proposal using the proposal Id
    function vote(uint256 proposalId) public {
// If the proposal Id is greater than the number of proposals then it will revert
        require(proposalId < proposals.length, "Proposal does not exist");
// If the caller has already voted on that proposalId then it will revert
        require(!votes[msg.sender][proposalId], "Already voted");
// if not voted then the vote will be count from that user
        votes[msg.sender][proposalId] = true;
// Increasing the vote count on that proposalId
        proposals[proposalId].voteCount++;
    }

// Only owner can execute proposal
    function executeProposal(uint256 proposalId) public onlyOwner {
// If the proposal ID is greater than number of proposal  then it will revert
        require(proposalId < proposals.length, "Proposal does not exist");
// Fetching teh proposal using the porposal ID
        Proposal storage proposal = proposals[proposalId];
// Checking if the proposal in not already executed
        require(!proposal.executed, "Already executed");
// If not then it is set as executed and the owner can execute accordingly by defining the code if any
        proposal.executed = true;
    }
// Getting the proposal using the proposal ID 
    function getProposal(uint256 proposalId) public view returns (Proposal memory) {
// If the proposal Id is greater than the length of proposal array then it will revert because it means that proposal didn't exist 
        require(proposalId < proposals.length, "Proposal does not exist");
// If the ID is ok then it will return the proposal from the array
        return proposals[proposalId];
    }
}