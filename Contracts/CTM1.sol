// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract SITCON_CTM1 {
    mapping(address => int256) public playerPoints;
    uint256 public pointstoWin = 1e10;
    uint256 public prize;
    bool public status;
    address public winner;
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
        status = true;
    }

    function addPrize() payable public {
        require(status == true, "Game is over.");
        prize += msg.value;
    }

    function getPrizePool() public view returns (uint) {
        return address(this).balance;
    }

    function addPoints(int256 _a) public {
        require(status == true, "Game is over.");
        require(_a <= 10, "Only allow to add less then 10 points!");
        playerPoints[msg.sender] += _a;
    }

    function win() public {
        require(uint256(playerPoints[msg.sender]) >= pointstoWin, "Not yet.");
        winner = msg.sender;
        status = false;
        payable(msg.sender).transfer(address(this).balance);
    }

    function BOMB() public onlyowner {
        selfdestruct(owner);
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Bad hacker, ur not the owner!");
        _;
    }
}
