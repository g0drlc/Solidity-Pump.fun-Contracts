// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./ERC20.sol";

contract Pair {
    receive() external payable {}

    address private _factory;

    address private _tokenA;

    address private _tokenB;

    address private lp;

    struct Pool {
        uint256 reserve0;
        uint256 reserve1;
        uint256 lastUpdated;
    }

    Pool private pool;

    constructor(address factory_, address token0, address token1) {
        _factory = factory_;

        _tokenA = token0;

        _tokenB = token1;
    }

    event Mint(uint256 reserve0, uint256 reserve1, address lp);

    event Burn(uint256 reserve0, uint256 reserve1, address lp);

    event Swap(uint256 amount0In, uint256 amount0Out, uint256 amount1In, uint256 amount1Out);

    function mint(uint256 reserve0, uint256 reserve1, address _lp) public returns (bool) {
        lp = _lp;

        pool = Pool({
            reserve0: reserve0,
            reserve1: reserve1,
            lastUpdated: block.timestamp
        });

        emit Mint(reserve0, reserve1, _lp);

        return true;
    }

    function swap(uint256 amount0In, uint256 amount0Out, uint256 amount1In, uint256 amount1Out) public returns (bool) {
        uint256 _reserve0 = pool.reserve0 + amount0In - amount0Out;
        uint256 _reserve1 = pool.reserve1 + amount1In - amount1Out;

        pool = Pool({
            reserve0: _reserve0,
            reserve1: _reserve1,
            lastUpdated: block.timestamp
        });

        emit Swap(amount0In, amount0Out, amount1In, amount1Out);

        return true;
    }

    function burn(uint256 reserve0, uint256 reserve1, address _lp) public returns (bool) {
        require(lp == _lp, "Only Lp holders can call this function.");

        pool = Pool({
            reserve0: reserve0,
            reserve1: reserve1,
            lastUpdated: block.timestamp
        });

        emit Burn(reserve0, reserve1, _lp);

        return true;
    }

    function approval(address _user, address _token, uint256 amount) public returns (bool) {
        ERC20 token_ = ERC20(_token);

        token_.approve(_user, amount);

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

    function kLast() public view returns (uint256, uint256) {
        return (pool.reserve0, pool.reserve1);
    }

    function priceALast() public view returns (uint256, uint256) {
        return (pool.reserve1, pool.reserve0);
    }

    function priceBLast() public view returns (uint256, uint256) {
        return (pool.reserve0, pool.reserve1);
    }
}