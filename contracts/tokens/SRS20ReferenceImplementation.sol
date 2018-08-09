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
/// @author TokenSoft Inc
/// @dev Ref https://github.com/ethereum/EIPs/pull/SRS
contract SRS20ReferenceImplementation is SRS20, StandardToken {
    /// @notice Checks if a transfer is restricted, reverts if so
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @dev Defining this modifier is not for the standard, but purely for the ref implementation
    modifier onlyLawfulTransfer (address from, address to, uint256 value) {
        uint restrictionCode = detectTransferRestriction(from, to, value);
        bool restrictionDetected = restrictionCode != SUCCESS_CODE;
        if (restrictionDetected) {
            emit TransferRestricted(from, to, value, restrictionCode);
            revert(messageForTransferRestriction(restrictionCode));
        }
        _;
    }

    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    /// @dev Overwrite with your custom transfer restriction logic
    function detectTransferRestriction (address from, address to, uint256 value)
        public view returns (uint restrictionCode)
    {
        restrictionCode = 0; // success
        if (to == address(0x0)) {
            restrictionCode = 1; // illegal transfer to zero address
        }
    }

    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    /// @dev Overwrite with your custom message and restrictionCode handling
    function messageForTransferRestriction (uint restrictionCode)
        public view returns (string message)
    {
        if (restrictionCode == 0) {
            message = "SUCCESS";
        } else if (restrictionCode == 1) {
            message = "ILLEGAL_TRANSFER_TO_ZERO_ADDRESS";
        } else {
            message = "ILLEGAL_UNKNOWN";
        }
    }

    /// @notice Subclass implementation of StandardToken's ERC20 transfer method
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Transfer success status
    /// @dev Must compare the return value of detectTransferRestriction to succes code (0)
    function transfer (address to, uint256 value)
        public onlyLawfulTransfer(msg.sender, to, value) returns (bool)
    {
        return super.transfer(to, value);
    }
  
    /// @notice Subclass implementation of StandardToken's ERC20 transferFrom method
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Transfer success status
    /// @dev Must compare the return value of detectTransferRestriction to success code (0)
    function transferFrom (address from, address to, uint256 value)
        public onlyLawfulTransfer(from, to, value) returns (bool)
    {
        return super.transferFrom(from, to, value);
    }
}