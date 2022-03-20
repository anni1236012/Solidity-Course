// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract DefiBank {
    // Deposit 
    // WithDraw
    // IssueInterest 
    address public usdc;
    address public ausd;

    address[] public stakers;
    
    mapping(address => uint) public depositBalance;
    mapping(address => bool) public hasDeposited;

    constructor(address _usdc, address _ausd) {
        usdc = _usdc;
        ausd = _ausd;
    }
    
    function depositToken(uint _amount ) public {
        IERC20(usdc).transferFrom(msg.sender, address(this), _amount);
        depositBalance[msg.sender] +=  _amount;

        if(!hasDeposited[msg.sender]) {
            stakers.push(msg.sender);
        }

        hasDeposited[msg.sender] = true;
    }

    function withdraw(uint _amount) public {
        uint balance = depositBalance[msg.sender];
        require(balance > 0, "Balance cannot be 0");
        IERC20(usdc).transfer(msg.sender, _amount);

        depositBalance[msg.sender] -= _amount;

        if (balance - _amount == 0) {
            hasDeposited[msg.sender] = false;
        }
    }

    function issueInterest() public {
        for(uint i; i< stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = depositBalance[recipient];

            if (balance > 0) {
                IERC20(ausd).transfer(recipient, balance);
            }
        } 
    }
}