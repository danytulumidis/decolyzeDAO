//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Proposals.sol";

contract DecolyzeDAO is Proposals, Ownable {

    enum IdeaType {
        DAO,
        DEX,
        DEFI,
        NFT
    }

    struct Idea {
        uint256 id;
        string name;
        IdeaType ideaType;
        uint256 upvotes;
        uint256 funds;
        bool minted;
        mapping(address => uint256) fundsPerUser;
    }

    struct Candidates {
        uint256 requestTime;
        string name;
        string[] skills;
    }

    struct Member {
        uint256 joinedAt;
        string name;
        string[] skills;
    }

    mapping(address => Member) public members;
    mapping(uint256 => address) public memberToUser;
    mapping(address => Candidates) public candidates;
    mapping(uint256 => address) public candidateToUser;

    uint256 public totalProposals;
    uint8 public firstTenMembers;

    modifier membersOnly() {
        require(members[msg.sender].joinedAt > 0, "NOT_A_MEMBER");
        _;
    }

    modifier onlyNonMembers() {
        require(members[msg.sender].joinedAt == 0, "ALREADY_MEMBER");
        _;
    }

    function _addMemberToDAO() private onlyNonMembers {
        require(candidates[msg.sender].requestTime != 0, "NOT_A_CANDIDATE");
        Member storage member = members[msg.sender];
        member.joinedAt = block.timestamp;
        member.name = candidates[msg.sender].name;
        member.skills = candidates[msg.sender].skills;
    }

    function createProposal(ProposalType _proposalType, string memory _name, string[] memory _skills) external onlyNonMembers {

        Proposal storage proposal = proposals[totalProposalCount];
        proposal.deadline = block.timestamp + 7 days;
        proposal.proposalType = _proposalType;
        
        if (_proposalType == ProposalType.MEMBERSHIP) {
            _createCandidate(_name, _skills);
        }

        memberProposalCount[msg.sender]++;

        _createNewProposal(proposal);
    }

    function _createCandidate(string memory _name, string[] memory _skills) private onlyNonMembers {
        require(candidates[msg.sender].requestTime == 0, "ALREADY_REQUESTED_MEMBERSHIP");
        Candidates storage candidate = candidates[msg.sender];
        candidate.name = _name;
        candidate.requestTime = block.timestamp;
        candidate.skills = _skills;
    }

    function voteOnProposal(uint256 _proposalID, VoteType _vote) external membersOnly {
        Proposal storage proposal = proposals[_proposalID];
        require(proposal.userVoted[msg.sender] == false, "ALREADY_VOTED");
        require(proposal.deadline > block.timestamp, "DEADLINE_OVER");

        _voteOnProposal(proposal, _vote);
    }

    function executeProposal(uint256 _proposalID) external membersOnly {
        Proposal storage proposal = proposals[_proposalID];

        if (proposal.proposalType == ProposalType.MEMBERSHIP) {
            if (proposal.yesVotes > proposal.noVotes) {
                _addMemberToDAO();
            }
        }
    }

    function leaveDAO() public membersOnly() {
        // Must be Member for a minimum of 7 Days
        uint256 minimumTime = block.timestamp - 7 days;
        require(members[msg.sender].joinedAt > minimumTime, "MIN_MEMBERSHIP_REQUIRED");

        delete members[msg.sender];
    }


    function addFirstMembers(address _newMember ,string calldata _name, string[] calldata _skills) external onlyOwner onlyNonMembers {
        require(firstTenMembers <= 9, "INITIAL_MEMBERSHIP_DONE");
        Member storage member = members[_newMember];
        member.joinedAt = block.timestamp;
        member.name = _name;
        member.skills = _skills;

        firstTenMembers++;
    }

    receive() external payable {}

    fallback() external payable {}
}