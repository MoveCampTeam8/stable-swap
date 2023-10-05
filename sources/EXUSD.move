// SPDX-License-Identifier: MIT

module fungible_tokens::ExUSD {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct EXUSD has drop {}

    #[allow(unused_function)]
    fun init(witness: EXUSD, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction sender
        let (treasury_cap, metadata) = coin::create_currency<EXUSD>(witness, 2, b"EXUSD", b"", b"", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<EXUSD>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    public entry fun burn(treasury_cap: &mut TreasuryCap<EXUSD>, coin: Coin<EXUSD>) {
        coin::burn(treasury_cap, coin);
    }

    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(EXUSD {}, ctx)
    }
}
