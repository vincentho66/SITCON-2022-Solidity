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
