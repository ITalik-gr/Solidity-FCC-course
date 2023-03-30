// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint public minimumUsd = 50 * 1e18;
// Треба. Щоб надсилати можна було тіки більше 50 USD. 
    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumUsd, "Didn`t send enough");
    }

    function getPrice() public view returns(uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint) {
        uint ethPrice = getPrice();
        uint ethPriceInUsd = (ethPrice * ethAmount) / 1e18;
        return ethPriceInUsd;
    }

    // function withdrawn() {

    // }
}