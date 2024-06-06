// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "./Factory.sol";
import "./Pair.sol";
import "./Router.sol";
import "./ERC20.sol";

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);
}

contract PumpFun is ReentrancyGuard {
    address private owner;

    Factory private factory;

    Router private router;

    address private _feeTo;

    uint256 private minMCap;

    uint256 private fee;

    uint private refFee;

    uint private constant lpFee = 5;

    uint256 private constant mcap = 100_000 ether;

    IUniswapV2Router02 private uniswapV2Router;

    struct Profile {
        address user;
        address referree;
        address[] referrals;
        Token[] tokens;
    }

    struct Token {
        address creator;
        address token;
        address pair;
        string name;
        string ticker;
        uint256 supply;
        uint256 mCap;
        uint256 liquidity;
        string description;
        string image;
        string[4] urls;
        bool trading;
        bool tradingOnUniswap;
    }

    mapping (address => Profile) public profile;

    Profile[] public profiles;

    mapping (address => Token) public token;

    Token[] public tokens;

    event Launched(address indexed token, address indexed pair, uint);

    event Deployed(address indexed token, uint256 amount0, uint256 amount1);

    constructor(address factory_, address router_, address fee_to, uint256 _fee, uint _refFee, uint256 min) {
        owner = msg.sender;

        require(factory_ != address(0), "Zero addresses are not allowed.");
        require(router_ != address(0), "Zero addresses are not allowed.");
        require(fee_to != address(0), "Zero addresses are not allowed.");
    
        factory = Factory(factory_);

        router = Router(router_);

        _feeTo = fee_to;

        fee = (_fee * 1 ether) / 1000;

        require(_refFee <= 5, "Referral Fee cannot exceed 5%.");

        refFee = _refFee;

        minMCap = min;

        uniswapV2Router = IUniswapV2Router02(0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");

        _;
    }

    function createUserProfile(address _user, address ref) private returns (bool) {
        require(_user != address(0), "Zero addresses are not allowed.");

        Token[] memory _tokens;

        address[] memory _referrals;

        Profile memory _profile = Profile({
            user: _user,
            referree: ref,
            referrals: _referrals,
            tokens: _tokens
        });

        profile[_user] = _profile;

        profiles.push(_profile);

        return true;
    }

    function checkIfProfileExists(address _user) private view returns (bool) {
        require(_user != address(0), "Zero addresses are not allowed.");

        bool exists = false;

        for(uint i = 0; i < profiles.length; i++) {
            if(profiles[i].user == _user) {
                return true;
            }
        }

        return exists;
    }

    function _approval(address _user, address _token, uint256 amount) private returns (bool) {
        require(_user != address(0), "Zero addresses are not allowed.");
        require(_token != address(0), "Zero addresses are not allowed.");

        ERC20 token_ = ERC20(_token);

        token_.approve(_user, amount);

        return true;
    }

    function approval(address _user, address _token, uint256 amount) external nonReentrant returns (bool) {
        bool approved = _approval(_user, _token, amount);

        return approved;
    }

    function launchFee() public view returns (uint256) {
        return fee;
    }

    function updateLaunchFee(uint256 _fee) public returns (uint256) {
        fee = _fee;

        return _fee;
    }

    function referralFee() public view returns (uint256) {
        return refFee;
    }

    function updateReferralFee(uint256 _fee) public returns (uint256) {
        refFee = _fee;

        return _fee;
    }

    function liquidityFee() public pure returns (uint256) {
        return lpFee;
    }

    function feeTo() public view returns (address) {
        return _feeTo;
    }

    function feeToSetter() public view returns (address) {
        return owner;
    }

    function setFeeTo(address fee_to) public onlyOwner{
        require(fee_to != address(0), "Zero addresses are not allowed.");

        _feeTo = fee_to;
    }

    function marketCapLimit() public pure returns (uint256) {
        return mcap;
    }

    function getUserTokens() public view returns (Token[] memory) {
        require(checkIfProfileExists(msg.sender), "User Profile dose not exist.");

        Profile memory _profile = profile[msg.sender];

        return _profile.tokens;
    }

    function getTokenUrls(address tk) public view returns (string[4] memory) {
        require(tk != address(0), "Zero addresses are not allowed.");

        Token memory _token = token[tk];

        return _token.urls;
    }

    function getTokens(uint256 ethInUSD) public returns (Token[] memory) {
        for(uint i = 0; i < tokens.length; i++) {
            Pair pair = Pair(payable(tokens[i].pair));
            ERC20 tk = ERC20(tokens[i].token);

            (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();

            Token storage _token = token[tokens[i].token];

            if(reserve0 > 0) {
                uint256 liq = ((reserve1 / 10 ** 18) * 2) * ethInUSD;
                uint256 _mcap = ((tk.totalSupply() / 10 ** 18) * (reserve1 / reserve0) * ethInUSD) + minMCap;

                _token.mCap = _mcap;
                _token.liquidity = liq;

                tokens[i].mCap = _mcap;
                tokens[i].liquidity = liq;
            }
        }

        return tokens;
    }

    function getUserReferrals() public view returns (address[] memory) {
        require(checkIfProfileExists(msg.sender), "User Profile dose not exist.");
        
        Profile memory _profile = profile[msg.sender];

        return _profile.referrals;
    }

    function launch(string memory _name, string memory _ticker, string memory desc, string memory img, string[4] memory urls, uint256 _supply, uint maxTx, address ref, uint256 ethInUSD) public payable nonReentrant returns (address, address, uint) {
        require(msg.value >= fee, "Insufficient amount sent.");

        ERC20 _token = new ERC20(_name, _ticker, _supply, maxTx);

        address weth = router.WETH();

        address _pair = factory.createPair(address(_token), weth);

        bool approved = _approval(address(router), address(_token), _supply * 10 ** _token.decimals());
        require(approved);

        uint256 liquidity = (lpFee * msg.value) / 100;
        uint256 value = msg.value - liquidity;

        router.addLiquidityETH{value: liquidity}(address(_token), _supply * 10 ** _token.decimals());

        uint256 liq = ((liquidity / 10 ** 18) * 2) * ethInUSD;
        uint256 _mcap = ((liquidity / 10 ** 18) * ethInUSD) + minMCap;

        Token memory token_ = Token({
            creator: msg.sender,
            token: address(_token),
            pair: _pair,
            name: _name,
            ticker: _ticker,
            supply: _supply,
            mCap: _mcap,
            liquidity: liq,
            description: desc,
            image: img,
            urls: urls,
            trading: true,
            tradingOnUniswap: false
        });

        token[address(_token)] = token_;

        tokens.push(token_);

        bool exists = checkIfProfileExists(msg.sender);

        if(exists) {
            Profile storage _profile = profile[msg.sender];

            if(_profile.referree == address(0)) {
                (bool os, ) = payable(_feeTo).call{value: value}("");
                require(os);
            } else {
                Profile storage profile_ = profile[_profile.referree];

                profile_.referrals.push(msg.sender);

                uint256 refAmount = (refFee * value) / 100;
                uint256 amount = value - refAmount;

                (bool os, ) = payable(_profile.referree).call{value: refAmount}("");
                require(os);

                (bool os1, ) = payable(_feeTo).call{value: amount}("");
                require(os1);
            }

            _profile.tokens.push(token_);
        } else {
            bool created = createUserProfile(msg.sender, ref);

            if(created) {
                Profile storage _profile = profile[msg.sender];

                if(_profile.referree == address(0)) {
                    (bool os, ) = payable(_feeTo).call{value: value}("");
                    require(os);
                } else {
                    Profile storage profile_ = profile[_profile.referree];

                    profile_.referrals.push(msg.sender);

                    uint256 refAmount = (refFee * value) / 100;
                    uint256 amount = value - refAmount;

                    (bool os, ) = payable(_profile.referree).call{value: refAmount}("");
                    require(os);

                    (bool os1, ) = payable(_feeTo).call{value: amount}("");
                    require(os1);
                }

                _profile.tokens.push(token_);
            }
        }

        uint n = tokens.length;

        emit Launched(address(_token), _pair, n);

        return (address(_token), _pair, n);
    }

    function deploy(address tk) public onlyOwner nonReentrant {
        require(tk != address(0), "Zero addresses are not allowed.");

        address weth = router.WETH();

        address pair = factory.getPair(tk, weth);

        ERC20 token_ = ERC20(tk);

        token_.excludeFromMaxTx(pair);

        Token storage _token = token[tk];

        (uint256 amount0, uint256 amount1) = router.removeLiquidityETH(tk, 100, address(this));

        openTradingOnUniswap(tk);

        _token.trading = false;
        _token.tradingOnUniswap = true;

        emit Deployed(tk, amount0, amount1);
    }

    function openTradingOnUniswap(address tk) private {
        require(tk != address(0), "Zero addresses are not allowed.");

        ERC20 token_ = ERC20(tk);

        Token storage _token = token[tk];

        require(_token.trading && !_token.tradingOnUniswap, "trading is already open");

        bool approved = _approval(address(uniswapV2Router), tk, token_.balanceOf(address(this)));
        require(approved, "Not approved.");

        address uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(tk, uniswapV2Router.WETH());

        uniswapV2Router.addLiquidityETH{value: address(this).balance}(
            tk,
            token_.balanceOf(address(this)),
            0,
            0,
            address(this),
            block.timestamp
        );

        ERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
    }

    function withdraw() public returns (bool) {
        (bool os, ) = payable(owner).call{value: address(this).balance}("");
        require(os, "Transfer ETH Failed.");

        return os;
    }
}