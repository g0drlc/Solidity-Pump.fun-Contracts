// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "./Factory.sol";
import "./Pair.sol";
import "./ERC20.sol";

contract Router is ReentrancyGuard {
    using SafeMath for uint256;

    address private _factory;

    address private _WETH;
    
    constructor(address factory_, address weth) {
        require(factory_ != address(0), "Zero addresses are not allowed.");
        require(weth != address(0), "Zero addresses are not allowed.");

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
        require(_address != address(0), "Zero addresses are not allowed.");

        (bool os, ) = payable(_address).call{value: amount}("");
        require(os, "Transfer ETH Failed.");

        return os;
    }

    function getAmountsOut(address token, address weth, uint256 amountIn) public nonReentrant returns (uint256 _amountOut) {
        require(token != address(0), "Zero addresses are not allowed.");

        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        (uint256 reserveA, uint256 reserveB, ) = _pair.getReserves();

        uint256 k = reserveA.mul(reserveB);

        uint256 amountOut;

        if(weth == _WETH) {
            uint256 newReserveB = reserveB.add(amountIn);

            uint256 newReserveA = k.div(newReserveB, "Division failed");

            amountOut = reserveA.sub(newReserveA, "Subtraction failed.");
        } else {
            uint256 newReserveA = reserveA.add(amountIn);

            uint256 newReserveB = k.div(newReserveA, "Division failed");

            amountOut = reserveB.sub(newReserveB, "Subtraction failed.");
        }

        return amountOut;
    }

    function addLiquidityETH(address token, uint256 amountToken) public payable nonReentrant returns (uint256, uint256) {
        require(token != address(0), "Zero addresses are not allowed.");

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

    function removeLiquidityETH(address token, uint256 liquidity, address to) public nonReentrant returns (uint256, uint256) {
        require(token != address(0), "Zero addresses are not allowed.");
        require(to != address(0), "Zero addresses are not allowed.");

        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        (uint256 reserveA, uint256 reserveB, ) = _pair.getReserves();

        ERC20 token_ = ERC20(token);

        uint256 amountETH = (liquidity * reserveB) / 100;

        uint256 amountToken = (liquidity * reserveA) / 100;

        bool approved = _pair.approval(address(this), token, amountToken);
        require(approved);

        bool os = _pair.transferETH(to, amountETH);
        require(os, "Transfer of ETH failed.");

        bool os1 = token_.transferFrom(pair, to, amountToken);
        require(os1, "Transfer of token failed.");
        
        _pair.burn(amountToken, amountETH, msg.sender);

        return (amountToken, amountETH);
    }

    function swapTokensForETH(uint256 amountIn, address token, address to) public nonReentrant returns (uint256, uint256) {
        require(token != address(0), "Zero addresses are not allowed.");
        require(to != address(0), "Zero addresses are not allowed.");

        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        ERC20 token_ = ERC20(token);

        uint256 amountOut = getAmountsOut(token, address(0), amountIn);

        bool os = token_.transferFrom(to, pair, amountIn);
        require(os, "Transfer of token failed");

        uint fee = factory_.txFee();
        uint256 _amount = (fee * amountOut) / 100;
        uint256 amount = amountOut - _amount;

        address feeTo = factory_.feeTo();

        bool os1 = _pair.transferETH(to, amount);
        require(os1, "Transfer of ETH failed.");

        bool os2 = _pair.transferETH(feeTo, _amount);
        require(os2, "Transfer of ETH failed.");

        _pair.swap(amountIn, 0, 0, amount);

        return (amountIn, amount);
    }

    function swapETHForTokens(address token, address to) public payable nonReentrant returns (uint256, uint256) {
        require(token != address(0), "Zero addresses are not allowed.");
        require(to != address(0), "Zero addresses are not allowed.");

        uint256 amountIn = msg.value;

        Factory factory_ = Factory(_factory);

        address pair = factory_.getPair(token, _WETH);

        Pair _pair = Pair(payable(pair));

        ERC20 token_ = ERC20(token);

        uint256 amountOut = getAmountsOut(token, _WETH, amountIn);

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
    
        _pair.swap(0, amountOut, amount, 0);

        return (amount, amountOut);
    }
}