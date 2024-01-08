//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
contract Auction {
    address public auctioneer;
    address public highestBidder;
    uint public highestBid;
    uint public highestBidAmount; // Declare highestBidAmount variable
    bool public ended;

    mapping(address => uint256) public bids;

    event BidPlaced(address indexed bidder, uint amount);
    event AuctionEnded(address indexed winner, uint amount);

    modifier onlyAuctioneer(){
        require(msg.sender == auctioneer, "Only auctioneer can call this function");
        _;
    }

modifier notEnded(){
 require(!ended, "Auction has already ended");
    _;
}

 constructor() {
    auctioneer = msg.sender;
}

function placeBid() external payable notEnded {
    require(msg.value > highestBid, "Bid amount must be higher than the current highest bid");

    if (highestBidder !=address (0)) {
        // Refund the previous highest bidder 
        payable (highestBidder).transfer(highestBid);
    }

    highestBidAmount = msg.value;
    highestBidder = msg.sender;

    bids[msg.sender] += msg.value;

    emit BidPlaced(msg.sender, msg.value);
}

function endAuction() external onlyAuctioneer notEnded {
    ended = true;
    emit AuctionEnded(highestBidder, highestBidAmount);

    // Transfer the funds to the auctioneer
    payable (auctioneer).transfer(highestBidAmount);
  }
}