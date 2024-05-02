// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    address public admin;
    uint public candidatesCount;
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;

    constructor() {
        admin = msg.sender;
    }


    event votedEvent(uint indexed _candidateId);

    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted.");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function createCandidate(string memory _name) public onlyAdmin {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public hasNotVoted {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");
        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit votedEvent(_candidateId);
    }

    function declareWinner() public view returns (string memory) {
        uint maxVotes = 0;
        uint winningCandidateId = 0;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVotes) {

                maxVotes = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        return candidates[winningCandidateId].name;
    }

    function audit(address _voter) public view returns (string memory) {
        require(voters[_voter], "Voter has not voted yet.");
        for (uint i = 1; i <= candidatesCount; i++) {
            if (voters[_voter] && candidates[i].voteCount > 0) {
                return candidates[i].name;
            }
        }
        
        return "Voter has not voted yet.";
    }
}