// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract TestToken is ERC20Upgradeable {
    uint8 private _decimal;

    address public owner;
    mapping(address => bool) public isMinter;

    // Modifier
    modifier onlyMinter() {
        require(isMinter[msg.sender], "!onlyMinter");
        _;
    }

    // Initializer
    function initialize(
        string memory name,
        string memory symbol,
        uint8 decimal
    ) external initializer {
        __ERC20_init(name, symbol);
        _decimal = decimal;

        isMinter[msg.sender] = true;
        owner = msg.sender;
    }

    // View
    function decimals() public view override returns (uint8) {
        return _decimal;
    }

    // Restricted
    function setMinter(address _minter, bool _state) external {
        require(msg.sender == owner, "!onlyOwner");

        isMinter[_minter] = _state;
    }

    function mint(address _to, uint _amount) external onlyMinter {
        _mint(_to, _amount);
    }

    function burn(address _to, uint _amount) external onlyMinter {
        _burn(_to, _amount);
    }
}
