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
        uint256 amount;
    }

    // Project is uniquely identified by tokenAddress of the project's token
    struct Project {
        string name;
        string tokenSymbol;
        string tokenName;
        address tokenAddress;
        address[] beneficiaries;
        address[] vendor;

    }

    Project[] public projects;


    mapping(address =>uint256) projectToken;

    event ProjectCreated(string name, string symbol, address tokenAddress);

    event BeneficiaryAdded(address indexed tokenAddress,address  indexed benAddress,uint256 amount);

    event VendorAdded(address indexed vendorAddress, uint256 indexed project);

    event TransferToVendor(address indexed vendorAddress,address indexed ben,uint256 amount);

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
        project.beneficiaries.push(walletAddress);
        ProjectToken(tokenAddress).transfer(walletAddress,amount);
        emit BeneficiaryAdded(tokenAddress, walletAddress, amount);
    }

    function addVendor(address _vendorAddress,address tokenAddress ) external {
        uint256 projectId = projectToken[tokenAddress];
        projects[projectId].vendor.push(_vendorAddress);
        vendorAddress.add(_vendorAddress);
        emit VendorAdded(_vendorAddress,projectId);

    }

    function getProject(uint256 index) external view returns (string memory, string memory, address) {
        require(index < projects.length, "Project does not exist");
        Project storage project = projects[index];
        return (project.name, project.tokenSymbol, project.tokenAddress);
    }

    // function transferToVendor(address _vendorAddress,address _tokenAddress, uint256 _amount) external {
    //     uint256 projectId = projectToken[_tokenAddress];
    //     // updateBenAmount(msg.sender, _amount, projectId);
    //     ProjectToken(_tokenAddress).transferFrom(msg.sender,_vendorAddress,_amount);
    //     emit TransferToVendor(_vendorAddress, msg.sender, _amount);
    // }

    // function updateBenAmount(address _ben, uint256 _amount, uint256 _projectId) private {
    //     Project storage project = projects[_projectId];

    //     for (uint256 i = 0; i < project.beneficiaries.length; i++) {
    //     if (project.beneficiaries == _ben) {
    //         project.beneficiaries[i].amount = project.beneficiaries[i].amount- _amount;
    //         return;
    //     }
    // }
    
    // revert("Beneficiary not found");

    // }

    function getAllProjects() external view returns (Project[] memory) {
        return projects;
    }

    function getBeneficiaries(uint256 projectIndex) external view returns(address[] memory benAddress){
          benAddress = projects[projectIndex].beneficiaries;
          return benAddress;
    }

    function getVendors() external view  returns(address[] memory vendor){
        return vendorAddress.values();

    } 

    function getProjectVendor(uint256 projectId) external view returns(address[] memory vendors){
        return projects[projectId].vendor;
    }
    
}
