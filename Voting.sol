// Etienne - Exercice Alyra
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.14;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Voting is Ownable {
 
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }
    uint winningProposalId;
    Proposal[] public proposals;

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    WorkflowStatus public status;

    event VoterRegistered(address voterAddress);
    event Voted(address voter, bool proposalId);
    event ProposalRegistered(uint proposalId);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);

    mapping(address => Voter) whitelist;


    // Créer une liste blanche d'adresse pouvant voter
    function addRegister (address _address) public onlyOwner {
        require (uint(status) == 0, unicode"L'ajout de votant est fermé.");
        require (!whitelist[_address].isRegistered, unicode"Cette adresse exist déjà.");
        whitelist[_address].isRegistered = true;
        emit VoterRegistered(_address);
    }


    // Choisir un nouveau statut
    function statusVoting (WorkflowStatus _status) public onlyOwner {
        require (uint(_status) < 6, "Ce statut n'existe pas.");
        WorkflowStatus previousStatus = status;
        status = _status;
        emit WorkflowStatusChange(previousStatus, status);
    }


    // Passer automatiquement au statut de vote suivant 
    function nextStepVoting () public onlyOwner {
        require (uint(status) < 5, "Ce statut n'existe pas.");
        WorkflowStatus previousStatus = status;
        status = WorkflowStatus(uint(status) + 1);
        emit WorkflowStatusChange(previousStatus, status);
    }


    // Enregistrement des votes
    function voting (uint _proposalId) public {
        require (whitelist[msg.sender].isRegistered, unicode"Vous n'êtes pas autorisé à voter.");
        require (uint(status) == 3, "Les votes ne sont pas ouverts.");
        require (!whitelist[msg.sender].hasVoted, unicode"Vous avez déjà voté.");
        require (proposals.length > _proposalId, "Cette proposition n'est pas disponible.");

        whitelist[msg.sender].hasVoted = true;
        whitelist[msg.sender].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount++;

        emit Voted(msg.sender, whitelist[msg.sender].hasVoted);
    }


    // Creation de proposition de vote
    function createProposal (string memory _description) public {
        require (whitelist[msg.sender].isRegistered, unicode"Vous n'êtes pas autorisé à ajouter une proposition.");
        require (uint(status) == 1, unicode"La création de proposition est fermée.");
        require (!checkPropalExist(_description), unicode"La proposition existe déjà.");
       
        Proposal memory currentProposal = Proposal({
            description: _description,
            voteCount: 0
        });

        proposals.push(currentProposal);

        emit ProposalRegistered(proposals.length - 1);
    }


    // Compte le résultat du vote
    function countVote () public onlyOwner returns (uint) {
        require (uint(status) == 5, "La comptage des votes n'est pas encore disponible.");

        winningProposalId = proposals[0].voteCount;
        for (uint i = 1; i < proposals.length; i++) {
            if (winningProposalId < proposals[i].voteCount) {
                winningProposalId = i;
            }
        }

        return winningProposalId;
    }


    // Vérifie si la proposition existe déjà
    function checkPropalExist (string memory _description) private view returns (bool) {
        for (uint i= 0; i < proposals.length; i++) {
            if (keccak256(abi.encodePacked(proposals[i].description)) == keccak256(abi.encodePacked(_description))) {
               return true;
            }
        }
        return false;
    }


    // Retourne le gagnant 
    function getWinner () public view returns (string memory) {
        require (uint(status) == 5, "Le gagnant n'est pas encore disponible.");
        return proposals[winningProposalId].description;
    }


    function getStatus () public view returns (WorkflowStatus) {
        return status;
    }


    // Affiche le vote d'une adresse
    function getVote (address _address) public view returns (uint) {
        require (uint(status) >= 3, "Les votes ne sont pas encore ouverts.");
        require (whitelist[_address].isRegistered == true, "Cette addresse n'est pas inscrite.");
        require (whitelist[_address].hasVoted == true, unicode"Cette addresse n'a pas votée.");
        
        return whitelist[_address].votedProposalId;
    }
}
