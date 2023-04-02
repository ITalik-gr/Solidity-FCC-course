// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint public minimumUsd = 50 * 1e18;
// Треба. Щоб надсилати можна було тіки більше 50 USD. 

    mapping(address => uint) public addressToAmountFunder;
    address[] public funders;


    function fund() public payable { 
        require(msg.value.getConversionRate() >= minimumUsd, "Didn`t send enough");
        funders.push(msg.sender);
        addressToAmountFunder[msg.sender] += msg.value;
    }

    function withdrawn() public {
        for (uint i = 0; i < funders.length; i++) { // ресет мапінг для кожного фандера
            address funder = funders[i];
            addressToAmountFunder[funder] = 0;
        }
        // reset the array
        funders = new address[](0); // заміняємо весь масив на новий пустий

        (bool callSuccsess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccsess, "Call failed");
    }
}