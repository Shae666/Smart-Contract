// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KYC {
    struct Customer {
        bool isVerified;
        string fullName;
        uint256 idNumber;
    }

    address admin;
    mapping(address => Customer) public customers;

    event CustomerVerified(address indexed customerAddress, string fullName, uint256 idNumber);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function verifyCustomer(address _customerAddress, string memory _fullName, uint256 _idNumber) public onlyAdmin {
        require(customers[_customerAddress].isVerified == false, "Customer already verified");
        customers[_customerAddress] = Customer(true, _fullName, _idNumber);
        emit CustomerVerified(_customerAddress, _fullName, _idNumber);
    }

    function getCustomer(address _customerAddress) public view returns (bool isVerified, string memory fullName, uint256 idNumber) {
        return (customers[_customerAddress].isVerified, customers[_customerAddress].fullName, customers[_customerAddress].idNumber);
    }
}
