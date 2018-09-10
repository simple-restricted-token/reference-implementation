pragma solidity ^0.4.24;
import "./SRS20.sol";
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
 * The implementation MUST take care to implement desired
 * transfer restriction logic correctly.
 */

/// @title Reference implementation for the SRS-20 token
/// @notice This implementation has a transfer restriction that prevents token holders from sending to the zero address
/// @dev Ref https://github.com/ethereum/EIPs/pull/SRS
contract SRS20ReferenceImpl is SRS20, StandardToken {
    /// @notice Restriction codes and messages as constant variables
    /// @dev Holding restriction codes and messages as constants is not required by the standard
    uint8 public constant SUCCESS_CODE = 0;
    uint8 public constant ZERO_ADDRESS_RESTRICTION_CODE = 1;
    string public constant UNKNOWN_MESSAGE = "UNKNOWN";
    string public constant SUCCESS_MESSAGE = "SUCCESS";
    string public constant ZERO_ADDRESS_RESTRICTION_MESSAGE = "ILLEGAL_TRANSFER_TO_ZERO_ADDRESS";


    /// @notice Checks if a transfer is restricted, reverts if it is
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @dev Defining this modifier is not required by the standard, using detectTransferRestriction and appropriately emitting TransferRestricted is however
    modifier notRestricted (address from, address to, uint256 value) {
        uint8 restrictionCode = detectTransferRestriction(from, to, value);
        require(restrictionCode == SUCCESS_CODE, messageForTransferRestriction(restrictionCode));
        _;
    }

    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    /// @dev Overwrite with your custom transfer restriction logic
    function detectTransferRestriction (address from, address to, uint256 value)
        public view returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE; // success
        if (to == address(0x0)) {
            restrictionCode = ZERO_ADDRESS_RESTRICTION_CODE; // illegal transfer to zero address
        }
    }

    /// @notice Returns a human-readable message for a given restriction code
    /// @param restrictionCode Identifier for looking up a message
    /// @return Text showing the restriction's reasoning
    /// @dev Overwrite with your custom message and restrictionCode handling
    function messageForTransferRestriction (uint8 restrictionCode)
        public view returns (string message)
    {
        message = UNKNOWN_MESSAGE;
        if (restrictionCode == SUCCESS_CODE) {
            message = SUCCESS_MESSAGE;
        } else if (restrictionCode == ZERO_ADDRESS_RESTRICTION_CODE) {
            message = ZERO_ADDRESS_RESTRICTION_MESSAGE;
        }
    }

    /// @notice Subclass implementation of StandardToken's ERC20 transfer method
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Transfer success status
    /// @dev Must compare the return value of detectTransferRestriction to 0
    function transfer (address to, uint256 value)
        public notRestricted(msg.sender, to, value) returns (bool)
    {
        return super.transfer(to, value);
    }
  
    /// @notice Subclass implementation of StandardToken's ERC20 transferFrom method
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Transfer success status
    /// @dev Must compare the return value of detectTransferRestriction to 0
    function transferFrom (address from, address to, uint256 value)
        public notRestricted(from, to, value) returns (bool)
    {
        return super.transferFrom(from, to, value);
    }
}
