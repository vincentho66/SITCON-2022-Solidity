// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract SITCON_Lottery {
    address payable public owner;
    address payable[] public players;
    address payable public winnerAddr;
    bool public status;

    constructor() {
        owner = payable(msg.sender);
        status = true;
    }

    function getWinnerAddress() public view returns (address payable) {
        return winnerAddr;
    }

    function getPrizePool() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enter() public payable {
        require(status == true, "Game is over.");
        require(msg.value >= 0.001 ether, "You must pay greater than 0.001 MATIC!");
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyowner {
        uint index = getRandomNumber() % players.length;
        require(players[index] != owner, "Owner can't be the winner lol.");
        players[index].transfer(address(this).balance);
        winnerAddr = players[index];
        status = false;
    }

    function BOMB() public onlyowner {
        selfdestruct(owner);
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Bad hacker, ur not the owner!");
        _;
    }
}
