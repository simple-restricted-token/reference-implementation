pragma solidity ^0.4.24;
import "./ERCXXX.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

/**
 * An `ERC20` compatible token that that posits a standardized interface
 * for issuing tokens with transfer restrictions.
 *
 * Implementation Details.
 *
 * An implementation of this token standard SHOULD provide the following:
 *
 * `name` - for use by wallets and exchanges.
 * `symbol` - for use by wallets and exchanges.
 * `decimals` - for use by wallets and exchanges
 * `totalSupply` - for use by wallets and exchanges 
 *
 * The implementation MUST take care to implmement desired
 * transfer restriction logic correctly.
 */

/// @title Reference implementation for the ERC-XXX token
/// @author TokenSoft Inc
/// @dev Ref https://github.com/ethereum/EIPs/pull/XXX
/// @notice An ERC-20 
contract ERCXXXReferenceImplementation is ERCXXX, StandardToken {
    /// @notice 0 is the reserved restrictionCode returned when there are no detected transfer restrictions
    uint constant SUCCESS_CODE = 0;

    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    /// @dev Override with your custom transfer restriction logic
    function detectTransferRestriction (address from, address to, uint value)
        public
        view
        returns (uint restrictionCode)
    {
        /* ... */
    }

    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    /// @dev Override with your custom message and restrictionCode handling
    function messageForTransferRestriction (uint restrictionCode)
        public
        view
        returns (string message)
    {
        /* ... */
    }

    /// @notice Subclass implementation of StandardToken's ERC20 transfer method
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Transfer success status
    /// @dev Must compare the return value of detectTransferRestriction to succes code (0)
    function transfer (address to, uint value)
        public
        returns (bool success)
    {
        uint restrictionCode = detectTransferRestriction(msg.sender, to, value);
        string message = messageForTransferRestriction(restrictionCode);
        require(restrictionCode == SUCCESS_CODE, message);
        success = super.transfer(to, value);
    }
  
    /// @notice Subclass implementation of StandardToken's ERC20 transferFrom method
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Transfer success status
    /// @dev Must compare the return value of detectTransferRestriction to success code (0)
    function transferFrom (address from, address to, uint value)
        public
        returns (bool success)
    {
        uint restrictionCode = detectTransferRestriction(msg.sender, to, value);
        string message = messageForTransferRestriction(restrictionCode);
        require(restrictionCode == SUCCESS_CODE, message);
        success = super.transferFrom(from, to, value);
    }
}