// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

contract Game {
    address public owner;

   modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }


    uint256 public pool;
    uint8 public target;
    bool public isActive;

    event GameWon(address indexed winner, uint256 reward);

    constructor(uint8 _target) {
        require(_target >= 0 && _target < 100, "Number must be between 0 and 99");

        owner = msg.sender;
        target = _target;
        isActive = true;
    }

    function guess(uint8 _guess) public payable {
        require(isActive, "The game is not active");
        require(msg.value == 1 ether, "You must send exactly 1 ETH");
        require(_guess > 0 && _guess < 100, "Guess must be between 0 and 99");

        console.log(msg.value);
        pool += msg.value;
        if (_guess > target) {
            console.log("Too Large");
        } else if (_guess == target) {
            require(pool > 0, "No rewards to give");
            isActive = false;
            
            uint256 tax = pool / 100 * 5;
            uint256 reward = pool - tax;
            pool = tax;

            payable(msg.sender).transfer(reward);
            payable(owner).transfer(pool);
            pool = 0;
            emit GameWon(msg.sender, reward);
            console.log("Bingo");
        } else {
            console.log("Too Small");
        }
    }

    function setTarget(uint8 _target) public isOwner {
        require(!isActive, "The game is active");
        target = _target;
        isActive = true;
    }
}