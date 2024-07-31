// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import "./ProjectToken.sol";

contract ProjectManager {

    struct Beneficiary {
        address walletAddress;
        uint64 amount;
    }

    // Project is uniquely identified by tokenAddress of the project's token
    struct Project {
        string name;
        string tokenSymbol;
        string tokenName;
        address tokenAddress;
        Beneficiary[] beneficiaries;
    }

    Project[] public projects;

    event ProjectCreated(string name, string symbol, address tokenAddress);

    function createProject(string memory name, string memory tokenName, string memory symbol) external {
        ProjectToken token = new ProjectToken(tokenName, symbol, address(this));

        token.mint(msg.sender, 100000 * 10 ** token.decimals());

        projects.push(Project({
            name: name,
            tokenSymbol: symbol,
            tokenName: tokenName,
            tokenAddress: address(token),
            beneficiaries: []
        }));

        emit ProjectCreated(name, symbol, address(token));
    }

    function addBeneficiary(address tokenAddress, address walletAddress, uint64 amount) external {
        bool projectFound = false;
        for (uint i = 0; i < projects.length; i++) {
            if (projects[i].tokenAddress == tokenAddress) {
                projects[i].beneficiaries.push(Beneficiary({
                    walletAddress: walletAddress,
                    amount: amount
                }));
                projectFound = true;
                emit BeneficiaryAdded(tokenAddress, walletAddress, amount);
                break;
            }
        }
        require(projectFound, "Project not found");
    }

    function getProject(uint256 index) external view returns (string memory, string memory, address) {
        require(index < projects.length, "Project does not exist");
        Project storage project = projects[index];
        return (project.name, project.symbol, project.tokenAddress);
    }

    function getAllProjects() external view returns (Project[] memory) {
        return projects;
    }
}
