// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AffiliateManager {
    address public owner;
    mapping(address => address) public referrals;
    mapping(address => uint256) public rewards;

    event ReferralAdded(address indexed affiliate, address indexed referral);
    event RewardPaid(address indexed affiliate, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addReferral(address _referral) public {
        require(referrals[_referral] == address(0), "Referral already exists");
        referrals[_referral] = msg.sender;
        emit ReferralAdded(msg.sender, _referral);
    }

    function distributeReward(address _affiliate, uint256 _amount) public onlyOwner {
        require(_affiliate != address(0), "Invalid affiliate address");
        rewards[_affiliate] += _amount;
        emit RewardPaid(_affiliate, _amount);
    }

    function claimReward() public {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");
        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
    }

    receive() external payable {}
}

//deployed at 0x3173b6edc0172244694aeb36e042c12f2ea10999