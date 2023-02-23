// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Auction {
    address public Auctioneer;
    mapping(address => uint256) public bidAmount;
    mapping(string => uint256) public auctionStartTime;
    mapping(string => uint256) public auctionEndTime;
    mapping(address => string[]) private auctionOf;
    uint256 public highestBid;
    address public highestBidder;
    bool public isAuctionEnd;

    constructor() {
        Auctioneer = msg.sender;
    }

    event bidInfo(address bidder, uint256 amount, string actionFor);

    function getAuctions(address user) public view returns (string[] memory) {
        return auctionOf[user];
    }

    function createAuction(string memory AuctionName, uint256 _deadline)
        public
    {
        require(
            msg.sender == Auctioneer,
            "Only the auctioneer can create an auction "
        );
        require(_deadline > block.timestamp, "invalid time out");
        auctionStartTime[AuctionName] = block.timestamp;
        auctionEndTime[AuctionName] = _deadline;
        auctionOf[msg.sender].push(AuctionName);
    }

    function bidding(string memory auctionName) public payable {
        require(auctionStartTime[auctionName] > 0, "Not a valid Auction");
        require(
            auctionStartTime[auctionName] < block.timestamp &&
                auctionEndTime[auctionName] > block.timestamp,
            "Time out"
        );
        require(msg.value > highestBid, "Please bid higher amount");
        require(Auctioneer != msg.sender, "caller is not the owner");
        if (highestBid != 0) {
            bidAmount[msg.sender] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit bidInfo(msg.sender, msg.value, auctionName);
    }

    function endAuction(string memory auctionName) public {
        require(msg.sender == Auctioneer, "caller is not the owner");
        require(
            auctionEndTime[auctionName] < block.timestamp,
            "Auction not yet ended"
        );
        require(!isAuctionEnd, "Auction has already ended");
        isAuctionEnd = true;
        payable(Auctioneer).transfer(highestBid);
    }
}
