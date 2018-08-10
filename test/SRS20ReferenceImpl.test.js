const SRS20ReferenceImplMock = artifacts.require('./mocks/SRS20ReferenceImplMock')

contract('SRS20ReferenceImpl', ([sender, recipient, ...accounts]) => {
  const initialAccount = sender
  const transferValue = '100000000000000000'
  const initialBalance = '100000000000000000000'
  const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
  
  let token
  let tokenTotalSupply
  let SUCCESS_CODE
  let SUCCESS_MESSAGE
  let ZERO_ADDRESS_RESTRICTION_CODE
  let ZERO_ADDRESS_RESTRICTION_MESSAGE
  before(async () => {
    token = await SRS20ReferenceImplMock.new(initialAccount, initialBalance)
    tokenTotalSupply = await token.totalSupply()
    SUCCESS_CODE = await token.SUCCESS_CODE()
    SUCCESS_MESSAGE = await token.SUCCESS_MESSAGE()
    ZERO_ADDRESS_RESTRICTION_CODE = await token.ZERO_ADDRESS_RESTRICTION_CODE()
    ZERO_ADDRESS_RESTRICTION_MESSAGE = await token.ZERO_ADDRESS_RESTRICTION_MESSAGE()
  })

  let senderBalanceBefore
  let recipientBalanceBefore
  beforeEach(async () => {
    senderBalanceBefore = await token.balanceOf(sender)
    recipientBalanceBefore = await token.balanceOf(recipient)
  })

  it('should mint total supply of tokens to initial account', async () => {
    const initialAccountBalance = await token.balanceOf(initialAccount)
    assert(initialAccountBalance.eq(tokenTotalSupply))
  })

  it('should allow transfer between non-zero addresses', async () => {
    await token.transfer(recipient, transferValue, { from: sender })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(transferValue)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))
  })

  it('should allow transferFrom between non-zero addresses (after approval)', async () => {
    await token.approve(sender, transferValue, { from: sender })
    await token.transferFrom(sender, recipient, transferValue, {
      from: sender
    })
    const senderBalanceAfter = await token.balanceOf(sender)
    const recipientBalanceAfter = await token.balanceOf(recipient)
    assert(senderBalanceAfter.eq(senderBalanceBefore.minus(transferValue)))
    assert(recipientBalanceAfter.eq(recipientBalanceBefore.plus(transferValue)))

  })
  
  it('should deny transfer to the zero address', async () => {
    let transferReverted = false
    try {
      await token.transfer(ZERO_ADDRESS, transferValue, { from: sender })
    } catch (err) {
      transferReverted = true
    }
    assert(transferReverted)
  })

  it('should deny transferFrom to the zero address (after approval)', async () => {
    let transferReverted = false
    try {
      await token.approve(sender, transferValue, { from: sender })  
      await token.transferFrom(sender, ZERO_ADDRESS, transferValue, {
        from: sender
      })
    } catch (err) {
      transferReverted = true
    }
    assert(transferReverted)
  })

  it('should detect success for transfer between non-zero addresses', async () => {
    const code = await token.detectTransferRestriction(sender, recipient, transferValue)
    assert(code.eq(SUCCESS_CODE))
  })

  it('should detect zero address restriction for transfer between non-zero addresses', async () => {
    const code = await token.detectTransferRestriction(sender, ZERO_ADDRESS, transferValue)
    assert(code.eq(ZERO_ADDRESS_RESTRICTION_CODE))
  })

  it('should ensure success code is 0', async () => {
    assert.equal(SUCCESS_CODE, 0)
  })
  
  it('should return success message for success code', async () => {
    const message = await token.messageForTransferRestriction(SUCCESS_CODE)
    assert.equal(SUCCESS_MESSAGE, message)
  })

  it('should return restriction message for zero address restriction code', async () => {
    const message = await token.messageForTransferRestriction(ZERO_ADDRESS_RESTRICTION_CODE)
    assert.equal(ZERO_ADDRESS_RESTRICTION_MESSAGE, message)
  })
})
