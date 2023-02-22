// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Auction {
    address public Auctioneer;
    mapping(address => uint256) public bidAmount;
    mapping(string => uint256) public auctionStartTime;
    mapping(string => uint256) public auctionEndTime;
    mapping(address => string[]) private auctionOf;

    constructor() {
        Auctioneer = msg.sender;
    }

    function getAuctions(address user) public view returns (string[] memory) {
        return auctionOf[user];
    }

    function initialize(
        string memory AuctionName,
        uint256 _deadline
    ) public {
        require(
            msg.sender == Auctioneer,
            "Only the auctioneer can create an auction "
        );
        require(_deadline > block.timestamp, "invalid time out");
        auctionStartTime[AuctionName] = block.timestamp;
        auctionEndTime[AuctionName] = _deadline;
        auctionOf[msg.sender].push(AuctionName);
    }
}
