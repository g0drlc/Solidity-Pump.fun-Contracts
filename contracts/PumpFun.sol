// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./Factory.sol";
import "./Pair.sol";
import "./Router.sol";
import "./ERC20.sol";

contract PumpFun {
    address private owner;

    Factory private factory;

    Router private router;

    address private _feeTo;

    uint256 private fee;

    uint private refFee;

    uint private constant lpFee = 5;

    uint256 private constant mcap = 100_000 ether;

    struct Profile {
        address user;
        address referree;
        address[] referrals;
        Token[] tokens;
    }

    struct Token {
        address token;
        address pair;
        string name;
        string ticker;
        uint256 supply;
        string description;
        string image;
        string twitter;
        string telegram;
        string youtube;
        string website;
        bool trading;
    }

    mapping (address => Profile) public profile;

    Profile[] public profiles;

    mapping (address => Token) public token;

    Token[] public tokens;

    event Launched(address indexed token, address indexed pair, uint);

    event Deployed(address indexed token, uint256 amount0, uint256 amount1);

    constructor(address factory_, address router_, address fees_wallet, uint256 _fee, uint _refFee) {
        owner = msg.sender;

        factory = Factory(factory_);

        router = Router(router_);

        _feeTo = fees_wallet;

        fee = (_fee * 1 ether) / 1000;

        require(_refFee <= 5, "Referral Fee cannot exceed 5%.");

        refFee = _refFee;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");

        _;
    }

    function createUserProfile(address _user, address ref) private returns (bool) {
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
        bool exists = false;

        for(uint i = 0; i < profiles.length; i++) {
            if(profiles[i].user == _user) {
                return true;
            }
        }

        return exists;
    }

    function approval(address _user, address _token, uint256 amount) public returns (bool) {
        ERC20 token_ = ERC20(_token);

        token_.approve(_user, amount);

        return true;
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

    function feeTo() public view onlyOwner returns (address) {
        return _feeTo;
    }

    function feeToSetter() public view returns (address) {
        return owner;
    }

    function marketCapLimit() public pure returns (uint256) {
        return mcap;
    }

    function launch(string memory _name, string memory _ticker, string memory desc, string memory img, string[4] memory urls, uint256 _supply, uint maxTx, address ref) public payable returns (address, address, uint) {
        require(msg.value >= fee, "Insufficient amount sent.");

        ERC20 _token = new ERC20(_name, _ticker, _supply, maxTx);

        address weth = router.WETH();

        address _pair = factory.createPair(address(_token), weth);

        _token.excludeFromMaxTx(_pair);

        bool approved = approval(address(router), address(_token), _supply * 10 ** _token.decimals());
        require(approved);

        uint256 liquidity = (lpFee * msg.value) / 100;
        uint256 value = msg.value - liquidity;

        router.addLiquidityETH{value: liquidity}(address(_token), _supply * 10 ** _token.decimals());

        Token memory token_ = Token({
            pair: _pair,
            token: address(_token),
            name: _name,
            ticker: _ticker,
            supply: _supply,
            description: desc,
            image: img,
            twitter: urls[0],
            telegram: urls[1],
            youtube: urls[2],
            website: urls[3],
            trading: true
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

    function deploy(address token_) public onlyOwner {
        Token storage _token = token[token_];

        _token.trading = false;

        (uint256 amount0, uint256 amount1) = router.removeLiquidityETH(token_, 100, owner);

        emit Deployed(token_, amount0, amount1);
    }
}