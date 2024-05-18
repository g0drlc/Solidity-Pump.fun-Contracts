// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./Factory.sol";
import "./Pair.sol";
import "./Router.sol";
import "./ERC20.sol";

contract PumpFun {
    address private owner;

    Factory private factory;

    Pair private pair;

    Router private router;

    struct Profile {
        address user;
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
    }

    mapping (address => Profile) private profile;

    Profile[] private profiles;

    mapping (address => Token) private token;

    Token[] private tokens;

    event Launched(address indexed token, address indexed pair, uint);

    constructor(address factory_, address router_) {
        owner = msg.sender;

        factory = Factory(factory_);

        router = Router(router_);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");

        _;
    }

    function createUserProfile(address _user) private returns (bool) {
        Token[] memory _tokens;

        Profile memory _profile = Profile({
            user: _user,
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

    function launch(string memory _name, string memory _ticker, string memory desc, string memory img, string[4] memory urls, uint256 _supply, uint maxTx) public payable returns (address, address, uint) {
        ERC20 _token = new ERC20(_name, _ticker, _supply, maxTx);

        address weth = router.WETH();

        address _pair = factory.createPair(address(_token), weth);

        bool approved = approval(address(router), address(_token), _supply * 10 ** _token.decimals());

        if(approved) {
            router.addLiquidityETH(address(_token), _supply * 10 ** _token.decimals());
        }

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
            website: urls[3]
        });

        token[address(_token)] = token_;

        tokens.push(token_);

        bool exists = checkIfProfileExists(msg.sender);

        if(exists) {
            Profile storage _profile = profile[msg.sender];

            _profile.tokens.push(token_);
        } else {
            bool created = createUserProfile(msg.sender);

            if(created) {
                Profile storage _profile = profile[msg.sender];

                _profile.tokens.push(token_);   
            }
        }

        uint n = tokens.length;

        emit Launched(address(_token), _pair, n);

        return (address(_token), _pair, n);
    }
}