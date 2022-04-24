//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Proposals.sol";

contract DecolyzeDAO is Proposals {
    
    enum VoteType {
        YES,
        NO
    }

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

    modifier membersOnly(address _user) {
        require(members[_user].joinedAt > 0, "NOT_A_MEMBER");
        _;
    }

    function enterDAO() public {

    }

    function leaveDAO() public membersOnly(msg.sender) {

    }

    function _addMemberToDAO() private {

    }

    function _createProposal(ProposalType _proposalType, address _user) public {
        
        if (_proposalType == ProposalType.MEMBERSHIP) {
            require(members[_user].joinedAt == 0, "ALREADY_MEMBER");
        }

        _createNewProposal(_proposalType);
    }

    receive() external payable {}

    fallback() external payable {}
}