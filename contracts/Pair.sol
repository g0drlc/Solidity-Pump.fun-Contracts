// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Pair {
    receive() external payable {}

    address private _factory;

    address private _tokenA;

    address private _tokenB;

    address private lp;

    struct Pool {
        uint256 reserve0;
        uint256 reserve1;
        uint256 k;
        uint256 lastUpdated;
    }

    Pool private pool;

    constructor(address factory_, address token0, address token1) {
        _factory = factory_;

        _tokenA = token0;

        _tokenB = token1;
    }

    event Mint(uint256 amount0, uint256 amount1, address lp);

    event Burn();

    event Swap();

    function mint(uint256 amount0, uint256 amount1, address _lp) public returns (bool) {
        lp = _lp;

        pool = Pool({
            reserve0: amount0,
            reserve1: amount1,
            k: amount0 * amount1,
            lastUpdated: block.timestamp
        });

        return true;
    }

    function swap(uint256 reserve0, uint256 reserve1) public returns (bool) {
        pool = Pool({
            reserve0: reserve0,
            reserve1: reserve1,
            k: reserve0 * reserve1,
            lastUpdated: block.timestamp
        });

        return true;
    }

    function burn(uint256 reserve0, uint256 reserve1, address _lp) public returns (bool) {
        require(lp == _lp, "Only Lp holders can call this function.");

        pool = Pool({
            reserve0: reserve0,
            reserve1: reserve1,
            k: reserve0 * reserve1,
            lastUpdated: block.timestamp
        });

        return true;
    }

    function liquidityProvider() public view returns (address) {
        return lp;
    }

    function MINIMUM_LIQUIDITY() public pure returns (uint) {
        return 1000;
    }

    function factory() public view returns (address) {
        return _factory;
    }

    function tokenA() public view returns (address) {
        return _tokenA;
    }

    function tokenB() public view returns (address) {
        return _tokenB;
    }

    function getReserves() public view returns (uint256 reserveA, uint256 reserveB, uint256 timestamp) {
        return (pool.reserve0, pool.reserve1, pool.lastUpdated);
    }

    function kLast() public view returns (uint256) {
        return pool.k;
    }

    function priceALast() public view returns (uint256) {
        return (pool.k / pool.reserve1);
    }

    function priceBLast() public view returns (uint256) {
        return (pool.k / pool.reserve0);
    }
}