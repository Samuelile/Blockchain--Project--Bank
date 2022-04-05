// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Ownable {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
    require (msg.sender == owner, "Only owner of the contract can perform this action.");
    _;
    }
}

contract Bank is Ownable {
    mapping(address => uint) public balances;
    
    event depositDone (uint amount, address indexed depositedTo);
    
    function deposit() public payable onlyOwner returns(uint) {
        balances[msg.sender] += msg.value;
        emit depositDone (msg.value, msg.sender);
        return balances[msg.sender];
    }
    function getBalance() public view returns (uint) {
        returns balances[msg.sender];
    }
    function _transfer(address from, address to, uint amount) private {
        balances[from] -= amount;
        balances[to] += amount;
    }
    function transferWithChecks(address recipient, unit amount) public onlyOwner {
        require(balances[msg.sender] >= amount, "Not enough funds.");
        require(msg.sender != recipient, "Cannot transfer to your own account.");
        
        uint previousSenderBalance = balances[msg.sender];
        
        _transfer(msg.sender, recipient, amount);
        
        assert(balances[msg.sender] == previousSenderBalance - amount);
    }
    function withdrawFromBalances(uint amount) public onlyOwner returns (uint) {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        return balances[msg.sender];
    }
}
