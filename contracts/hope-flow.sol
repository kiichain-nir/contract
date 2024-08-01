// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import "./ProjectToken.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract ProjectManager {

    using EnumerableSet for EnumerableSet.AddressSet;
    // Declare a set state variable
    EnumerableSet.AddressSet private vendorAddress;

    struct Beneficiary {
        address walletAddress;
        uint64 amount;
    }

    struct Vendor{
        address vendorAddress;
        uint256 tokenBalance;
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


    mapping(address =>uint256) projectToken;

    event ProjectCreated(string name, string symbol, address tokenAddress);

    event BeneficiaryAdded(address indexed tokenAddress,address  indexed benAddress,uint256 amount);

    function createProject(string memory name, string memory tokenName, string memory symbol) external returns(uint256 length){
        ProjectToken token = new ProjectToken(tokenName, symbol);
        uint256 index = projects.length ;

        token.mint(address(this), 100000 * 10);
       address tokenAddress = address(token);
       projects.push();
        Project storage project = projects[index];
        project.name =name;
        project.tokenSymbol = symbol;
        project.tokenName = tokenName;
        project.tokenAddress = tokenAddress;

        emit ProjectCreated(name, symbol, address(token));

        return index;
    }

    function addBeneficiary(address tokenAddress, address walletAddress, uint64 amount) external {
        uint256 projectLength = projects.length;

        uint256 projectId = projectToken[tokenAddress];
        require(projectLength > 0,"Project not created");
        Project storage project = projects[projectId];
        project.beneficiaries.push(Beneficiary({
            walletAddress:walletAddress,
            amount:amount
        }));
    }

    function addVendor(address _vendorAddress ) external {
        vendorAddress.add(_vendorAddress);

    }

    function getProject(uint256 index) external view returns (string memory, string memory, address) {
        require(index < projects.length, "Project does not exist");
        Project storage project = projects[index];
        return (project.name, project.tokenSymbol, project.tokenAddress);
    }

    function getAllProjects() external view returns (Project[] memory) {
        return projects;
    }

    function getBeneficiaries(uint256 projectIndex) external view returns(Beneficiary[] memory benDetails){
          benDetails = projects[projectIndex].beneficiaries;
          return benDetails;
    }

    function getVendors() external view  returns(address[] memory vendor){
        return vendorAddress.values();

    } 
    
}
