// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.19;

import "./Mincomind.sol";

// contract that stores the deposits from the games
contract Pot {

    address public MINCOMIND; // todo: address of the Mincomind contract
    

    constructor(
        address _mincomind
    ) {
        MINCOMIND = _mincomind;
    }    
    
    event FundsWithdrawn(address player, uint256 amount);

    function withdrawFunds() public {
        uint32 points = Mincomind(MINCOMIND).points(msg.sender);
        uint32 totalPoints = Mincomind(MINCOMIND).totalPoints();
        uint256 pot = address(this).balance;
        uint32  precision = 100;
        
        uint256 amount = (points * precision / totalPoints * pot) / precision;

        // set points to 0 for user
        Mincomind(MINCOMIND).zeroPoints();

        // transfer funds to user

        emit FundsWithdrawn(msg.sender, amount);
    }

}
