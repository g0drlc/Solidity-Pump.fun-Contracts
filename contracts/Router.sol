// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./Factory.sol";
import "./Pair.sol";
import "./ERC20.sol";

contract Router {
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

    function getAmountsOut(address token, uint256 amountIn) public view returns (uint256 _amountOut) {
        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        (uint256 reserveA, uint256 reserveB, ) = _pair.getReserves();

        uint256 k = reserveA * reserveB;

        uint256 amountOut;

        if(token == _WETH) {
            uint256 newReserveB = reserveB + amountIn;

            uint256 newReserveA = k / newReserveB;

            amountOut = reserveA - newReserveA;
        } else {
            uint256 newReserveA = reserveA + amountIn;

            uint256 newReserveB = k / newReserveA;

            amountOut = reserveB - newReserveB;
        }

        return amountOut;
    }

    function addLiquidityETH(address token, uint256 amountToken) public payable returns (uint256, uint256) {
        uint256 amountETH = msg.value;

        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        ERC20 token_ = ERC20(token);

        bool os = transferETH(pair, amountETH);
        require(os, "Transfer of ETH failed.");

        bool os1 = token_.transferFrom(msg.sender, pair, amountToken);
        require(os1, "Transfer of token failed.");
        
        _pair.mint(amountToken, amountETH, msg.sender);

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

        bool approved = _pair.approval(address(this), token, amountToken);
        require(approved);

        bool os = transferETH(to, amountETH);
        require(os, "Transfer of ETH failed.");

        bool os1 = token_.transferFrom(pair, to, amountToken);
        require(os1, "Transfer of token failed.");
        
        _pair.burn(amountToken, amountETH, msg.sender);

        return (amountToken, amountETH);
    }

    function swapTokensForETH(uint256 amountIn, address token, address to) public returns (uint256, uint256) {
        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        ERC20 token_ = ERC20(token);

        uint256 amountOut = getAmountsOut(token, amountIn);

        bool os = token_.transferFrom(to, pair, amountIn);
        require(os, "Transfer of token failed");

        uint fee = factory_.txFee();
        uint256 _amount = (fee * amountOut) / 100;
        uint256 amount = amountOut - _amount;

        address feeTo = factory_.feeTo();

        bool os1 = transferETH(to, amount);
        require(os1, "Transfer of ETH failed.");

        bool os2 = transferETH(feeTo, _amount);
        require(os2, "Transfer of ETH failed.");

        _pair.swap(amountIn, 0, 0, amountOut);

        return (amountIn, amountOut);
    }

    function swapETHForTokens(address token, address to) public payable returns (uint256, uint256) {
        uint256 amountIn = msg.value;

        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        ERC20 token_ = ERC20(token);

        uint256 amountOut = getAmountsOut(_WETH, amountIn);

        bool approved = _pair.approval(address(this), token, amountOut);
        require(approved, "Not Approved.");

        uint fee = factory_.txFee();
        uint256 _amount = (fee * amountIn) / 100;
        uint256 amount = amountIn - _amount;

        address feeTo = factory_.feeTo();

        bool os = transferETH(pair, amount);
        require(os, "Transfer of ETH failed.");

        bool os1 = transferETH(feeTo, _amount);
        require(os1, "Transfer of ETH failed.");

        bool os2 = token_.transferFrom(pair, to, amountOut);
        require(os2, "Transfer of token failed.");
    
        _pair.swap(0, amountOut, amountIn, 0);

        return (amountIn, amountOut);
    }
}