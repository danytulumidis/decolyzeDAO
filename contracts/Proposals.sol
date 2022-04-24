//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Proposals {

    event ProposalCreated(uint256 proposalID, ProposalType proposalType);

    enum ProposalType {
        MEMBERSHIP,
        IDEA,
        DAO
    }

    struct Proposal {
        uint256 deadline;
        uint256 yesVotes;
        uint256 noVotes;
        ProposalType proposalType;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public memberProposalCount;
    mapping(address => uint256) public userVotingToProposal;
    mapping(uint256 => address) public proposalToUser;

    uint256 public totalProposalCount;

    function _createNewProposal(ProposalType _proposalType) internal {
        Proposal storage proposal = proposals[totalProposalCount];
        proposal.deadline = block.timestamp + 7 days;
        proposal.proposalType = _proposalType;

        proposalToUser[totalProposalCount] = msg.sender;
        memberProposalCount[msg.sender]++;

        if (_proposalType == ProposalType.MEMBERSHIP) {
            _createMembershipProposal(proposals[totalProposalCount]);
        }

        totalProposalCount++;
        
        emit ProposalCreated(totalProposalCount - 1, _proposalType);
    }

    function _createMembershipProposal(Proposal storage _proposal) private {
        require(_proposal.proposalType == ProposalType.MEMBERSHIP, "WRONG_PROPOSAL_TYPE");
        
    }

    function executeProposal() public {}
}