// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;
//chainlink interface to get latest conversion
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

//import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    // safe math library check uint256 for integer overflows
    // using SafeMathChainlink for uint256;
    //creating mapping of address to  uint456(value)
    mapping(address => uint256) public addressToAmountFunded;
    address public owner;
    address[] public funders;

    AggregatorV3Interface public priceFeed;

    constructor(address _pricefeed) public {
        priceFeed = AggregatorV3Interface(_pricefeed);
        owner = msg.sender;
    }

    //payable here means that it can perform a transaction
    function Fund() public payable {
        //setting minimimum usd value and converting it into
        uint256 minimumUSD = 50 * 10**18;
        //to make sure that the transfer doesnot happen oif the entered amount is less than 50$USD
        require(
            getConverionRate(msg.value) >= minimumUSD,
            "Need to spend more ETH you miser bitch"
        );
        //here msg.addres & msg.value are special keywords to keep track of all the funding
        //msg.sender is the sender of the vlaur
        //msg.value is the amount of money sent and everything will be saved in the addressToAmountFunded
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        //interfaces help to interact with contracts they compile down to ABI which we discussed earlier
        //ABI's are the one that tells what functions to call or use from the contract or how to interact with other contracts
        //as discussed earlier we know that ABI is one of the nessicety to interact with another contract
        //when we go to the cod ewe see that the code is an interface not a contract
        /* so here to interact with the interface we will call its type like we used to in structs or variables in this case it is the "AggregatorV3Interface" and 
        then we would give its visibility but hrere we are in the contract and if we follow rthe link we see the visubility is alredy told for the it so we will name it
        then we do equals and name of interface "vAggregatorV3Interface" and then in the bracket we type the contract address 
        we get he contract form chainlink data site which acts as oracles here an we find the contract with the testchain/mainnet we want to use
        here we are using the rinkbey test chain whivh is "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"and the contract addres is diffrent for every cain   */
        //the line mean that we have an interface "AggregatorV3Interface" having some functions at agddress"0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"

        /**code_commented_as_not_needed_no_longer:
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );*/
        return priceFeed.version();
        //here we made a contract call form one caontract o another contrac using interfaces
    }

    function getPrice() public view returns (uint256) {
        /**code_commented_as_not_needed_no_longer:
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );*/

        /*here extra commas mean that ther is afunction but we wnat to ignore it 
        as in the interface we use have 5 function and we inly need one*/
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        /*here we used uint256 because in the interface it is
        set as int256 anw while defining the function 
        we said tht we want the output to be uint256
        In additonn to that we multlipid it to 10000000000 to convert the gwei to wei 
        so that the all the values have 18 decimal places since we had 8 decimal places alredy hence we multiplied it to 10 additional decimal places  */
        return uint256(answer * 10000000000);
    }

    function getConverionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUSD;
    }

     function getEntranceFee() public view returns (uint256) {
        // minimumUSD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you greedy son of bitch");
        _;
    }

    function withdraw() public payable onlyOwner {
        //transfer is a function that we can call on any
        //this are keyword in saolidity which meant the coontract we are
        //hence address of this means the address of the contract we areworing on
        //this mean that who ever cakk the withdraw finction transfer them all the money
        payable(msg.sender).transfer(address(this).balance);
        //iterate through all the mappings and make them 0
        //since all the deposited amount has been withdrawn
        //resetting the whole ammount to zero as the all the currewncy will be withdrawn by the owner
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //funders array will be initialized to 0
        funders = new address[](0);
    }
}
