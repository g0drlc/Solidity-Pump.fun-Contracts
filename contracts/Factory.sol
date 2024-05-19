// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./Pair.sol";

contract Factory {
    address private owner;

    address private _feeTo;

    mapping (address => mapping (address => address)) private pair;

    address[] private pairs;

    uint private constant fee = 5;

    constructor(address fees_wallet) {
        owner = msg.sender;

        _feeTo = fees_wallet;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");

        _;
    }

    event PairCreated(address indexed tokenA, address indexed tokenB, address pair, uint);

    function createPair(address tokenA, address tokenB) public returns (address) {
        Pair _pair = new Pair(address(this), tokenA, tokenB);

        pair[tokenA][tokenB] = address(_pair);
        pair[tokenB][tokenA] = address(_pair);

        pairs.push(address(_pair));

        uint n = pairs.length;

        emit PairCreated(tokenA, tokenB, address(_pair), n);

        return address(_pair);
    }

    function getPair(address tokenA, address tokenB) public view returns (address) {
        return pair[tokenA][tokenB];
    }

    function allPairs(uint n) public view returns (address)  {
        return pairs[n];
    }

    function allPairsLength() public view returns (uint) {
        return pairs.length;
    }

    function feeTo() public view onlyOwner returns (address) {
        return _feeTo;
    }

    function feeToSetter() public view returns (address) {
        return owner;
    }

    function txFee() public pure returns (uint) {
        return fee;
    }
}