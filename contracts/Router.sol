// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./Factory.sol";
import "./Pair.sol";
import "./ERC20.sol";

contract Router {
    using SafeMath for uint256;

    address private _factory;

    address private _WETH;
    
    constructor(address factory_, address weth) {
        _factory = factory_;

        _WETH = weth;
    }

    function factory() public view returns (address) {
        return _factory;
    }

    function WETH() public view returns (address) {
        return _WETH;
    }

    function transferETH(address _address, uint256 amount) private returns (bool) {
        (bool os, ) = payable(_address).call{value: amount}("");
        require(os);

        return os;
    }

    function getAmountsOut(address token, uint256 amountIn) public view returns (uint256 reserve0, uint256 reserve1, uint256 _amountOut) {
        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        (uint256 reserveA, uint256 reserveB, ) = _pair.getReserves();

        uint256 k = reserveA.mul(reserveB);

        if(token == _WETH) {
            uint256 newReserveB = reserveB.add(amountIn);

            uint256 newReserveA = k.div(newReserveB);

            uint256 amountOut = newReserveA.sub(reserveA);

            return (newReserveA, newReserveB, amountOut);
        } else {
            uint256 newReserveA = reserveA.add(amountIn);

            uint256 newReserveB = k.div(newReserveA);

            uint256 amountOut = newReserveB.sub(reserveB);

            return (newReserveA, newReserveB, amountOut);
        }
    }

    function addLiquidityETH(address token, uint256 amountToken) public payable returns (uint256, uint256) {
        uint256 amountETH = msg.value;

        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        ERC20 token_ = ERC20(token);

        bool os = transferETH(pair, amountETH);

        if(os) {
            bool os1 = token_.transferFrom(msg.sender, pair, amountToken);

            if(os1) {
                _pair.mint(amountToken, amountETH, msg.sender);
            }
        }

        return (amountToken, amountETH);
    }

    function removeLiquidityETH(address token, uint256 liquidity, address to) public payable returns (uint256, uint256) {
        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        (uint256 reserveA, uint256 reserveB, ) = _pair.getReserves();

        ERC20 token_ = ERC20(token);

        uint256 amountETH = (liquidity * reserveB) / 100;

        uint256 amountToken = (liquidity * reserveA) / 100;

        bool os = transferETH(to, amountETH);

        if(os) {
            bool os1 = token_.transferFrom(pair, to, amountToken);

            if(os1) {
                _pair.burn(amountToken, amountETH, msg.sender);
            }
        }

        return (amountToken, amountETH);
    }

    function swapTokensForETH(uint256 amountIn, address token, address to) public returns  (uint256, uint256) {
        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        ERC20 token_ = ERC20(token);

        (uint256 reserve0, uint256 reserve1, uint256 amountOut) = getAmountsOut(token, amountIn);

        bool os = token_.transferFrom(to, pair, amountIn);

        if(os) {
            bool os1 = transferETH(to, amountOut);

            if(os1) {
                _pair.swap(reserve0, reserve1);
            }
        }

        return (amountIn, amountOut);
    }

    function swapETHForTokens(address token, address to) public payable returns (uint256, uint256) {
        uint256 amountIn = msg.value;

        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        ERC20 token_ = ERC20(token);

        (uint256 reserve0, uint256 reserve1, uint256 amountOut) = getAmountsOut(_WETH, amountIn);

        bool os = transferETH(pair, amountIn);

        if(os) {
            bool os1 = token_.transferFrom(pair, to, amountOut);

            if(os1) {
                _pair.swap(reserve0, reserve1);
            }
        }

        return (amountIn, amountOut);
    }
}