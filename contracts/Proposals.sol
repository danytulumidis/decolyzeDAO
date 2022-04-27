//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Proposals {

    event ProposalCreated(uint256 proposalID, ProposalType proposalType);

    enum ProposalType {
        MEMBERSHIP,
        IDEA,
        DAO
    }

    enum VoteType {
        YES,
        NO
    }

    struct Proposal {
        uint256 deadline;
        uint256 yesVotes;
        uint256 noVotes;
        ProposalType proposalType;
        bool executed;
        mapping(address => bool) userVoted;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public memberProposalCount;
    mapping(uint256 => address) public proposalToUser;

    uint256 public totalProposalCount;

    function _createNewProposal(Proposal storage _proposal) internal {
        Proposal storage proposal = _proposal;

        proposalToUser[totalProposalCount] = msg.sender;
        memberProposalCount[msg.sender]++;

        totalProposalCount++;
        
        emit ProposalCreated(totalProposalCount - 1, proposal.proposalType);
    }

    function _voteOnProposal(Proposal storage _proposal, VoteType _vote) internal {
        Proposal storage proposal = _proposal;
        require(proposal.userVoted[msg.sender] == false, "ALREADY_VOTED");
        require(proposal.deadline > block.timestamp, "DEADLINE_OVER");

        proposal.userVoted[msg.sender] = true;

        if (_vote == VoteType.YES) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
    }
}