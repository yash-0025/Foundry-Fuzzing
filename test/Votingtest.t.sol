// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract VotingTest is Test {
// Voting Contract 
    Voting voting;
// Owner address
    address owner = address(0x1);


    function setUp() public {
        vm.startPrank(owner);
// Deploying the voting contract 
        voting = new Voting();
// Setting up the owner of the Voting Contract
        // voting.transferOwnership();
        vm.stopPrank();
    }


    function testOwner() public {
        address con = voting.owner();
        address own = address(owner);
        console.log(con);
        console.log(owner);
        assertEq(con, own);
    }
    function testCreateProposal() public {
        vm.startPrank(owner);
        voting.createProposal("Proposal 1");
        Voting.Proposal memory proposal = voting.getProposal(0);
        assertEq(proposal.description, "Proposal 1");
        assertEq(proposal.voteCount, 0);
        assertEq(proposal.executed, false);
        vm.stopPrank();
    }

    function testFuzzVoting(uint256 proposalId) public {
        vm.startPrank(owner);
        voting.createProposal("Proposal 1");
        vm.stopPrank();

        vm.assume(proposalId == 0);
        voting.vote(proposalId);

        Voting.Proposal memory proposal = voting.getProposal(proposalId);
        assertEq(proposal.voteCount, 1);
        assertTrue(voting.votes(address(this), proposalId));
    }

    function testFuzzDoubleVoting(uint256 proposalId) public {
        vm.startPrank(owner);
        voting.createProposal("Proposal 1");
        vm.stopPrank();

        vm.assume(proposalId == 0);

        voting.vote(proposalId);
        vm.expectRevert("Already Voted");
        voting.vote(proposalId);

        Voting.Proposal memory proposal = voting.getProposal(proposalId);
        assertEq(proposal.voteCount, 1);
    }

    modifier creatingProposal() {
        vm.startPrank(owner);
        voting.createProposal("Proposal 1");
        vm.stopPrank();
        _;
    }
    function testFuzzExecuteProposal(uint256 proposalId) public creatingProposal() {
        vm.assume(proposalId == 0);
        voting.vote(proposalId);

        vm.startPrank(owner);
        voting.executeProposal(proposalId);
        Voting.Proposal memory proposal = voting.getProposal(proposalId);
        assertEq(proposal.executed, true);
        vm.stopPrank();
    }

    function testFuzz
}
