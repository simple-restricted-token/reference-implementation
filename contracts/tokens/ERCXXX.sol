pragma solidity ^0.4.24;

interface ERCXXX {
    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    /// @dev Override with your custom transfer restriction logic
    function detectTransferRestriction (
        address from,
        address to,
        uint value
    ) external view returns (uint restrictionCode);

    /// @notice Returns a human-readable message for a given restriction code
    /// @param restrictionCode Identifier for looking up a message
    /// @return Text showing the restriction's reasoning
    /// @dev Override with your custom message and restrictionCode handling
    function messageForTransferRestriction (
        uint restrictionCode
    ) external view returns (string message);
}