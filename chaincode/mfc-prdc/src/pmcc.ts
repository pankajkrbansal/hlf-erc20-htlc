const { Contract, Context } = require('fabric-contract-api');
const crypto = require('crypto');
const State = require('./state.js');

// Import the ChaincodeStubInterface for ledger access
const { ChaincodeStubInterface } = require('fabric-shim');

class ERC20Token extends Contract {

    async instantiate(ctx) {
        console.log('ERC20 token instantiated');
        // Define and set initial token state
        const initialTokenState = {
            totalSupply: 1000000,
            balances: {},
            allowances: {},
            htlcs: {}
        };
        await ctx.stub.putState('tokenState', Buffer.from(JSON.stringify(initialTokenState)));
    }

    async mint(ctx, to, amount) {
        console.log('Minting tokens');
        // Get current token state
        const tokenStateBytes = await ctx.stub.getState('tokenState');
        const tokenState = JSON.parse(tokenStateBytes.toString());
        
        // Check if caller is the minter (identity validation)
        //if (ctx.clientIdentity.getMSPID() !== 'YourMSPID') {
        //    throw new Error('Only minter can mint tokens');
        //}
        
        // Update balances
        tokenState.balances[to] = tokenState.balances[to] || 0;
        tokenState.balances[to] += amount;
        tokenState.totalSupply += amount;

        // Save updated state
        await ctx.stub.putState('tokenState', Buffer.from(JSON.stringify(tokenState)));
    }

    async transfer(ctx, to, amount) {
        console.log('Transferring tokens');
        // Get current token state
        const tokenStateBytes = await ctx.stub.getState('tokenState');
        const tokenState = JSON.parse(tokenStateBytes.toString());
        
        // Check if caller has enough tokens (validation)
        if (tokenState.balances[ctx.clientIdentity.getID()] < amount) {
            throw new Error('Insufficient balance');
        }

        // Transfer tokens
        tokenState.balances[ctx.clientIdentity.getID()] -= amount;
        tokenState.balances[to] = tokenState.balances[to] || 0;
        tokenState.balances[to] += amount;

        // Save updated state
        await ctx.stub.putState('tokenState', Buffer.from(JSON.stringify(tokenState)));
    }

    async htlcTransfer(ctx, to, amount, hashlock, expiresAt) {
        console.log('Conditional transferring tokens');
        // Get current token state
        const tokenStateBytes = await ctx.stub.getState('tokenState');
        const tokenState = JSON.parse(tokenStateBytes.toString());
        
        // Check if caller has enough tokens (validation)
        if (tokenState.balances[ctx.clientIdentity.getID()] < amount) {
            throw new Error('Insufficient balance');
        }

        // Calculate HTLC ID (assumed to be unique)
        const htlcID = crypto.createHash('sha256').update(to + amount + hashlock + expiresAt).digest('hex');
        // Create HTLC object
        tokenState.htlcs[htlcID] = {
            from: ctx.clientIdentity.getID(),
            to: to,
            amount: amount,
            hashlock: hashlock,
            expiresAt: expiresAt,
            claimed: false
        };
        // Save updated state
        await ctx.stub.putState('tokenState', Buffer.from(JSON.stringify(tokenState)));
        return htlcID;
    }

    async claimHTLC(ctx, htlcID, password) {
        console.log('Claiming HTLC');
        // Get current token state
        const tokenStateBytes = await ctx.stub.getState('tokenState');
        const tokenState = JSON.parse(tokenStateBytes.toString());
        
        // Check if HTLC exists
        if (!tokenState.htlcs[htlcID]) {
            throw new Error('HTLC not found');
        }

        const htlc = tokenState.htlcs[htlcID];

        // Check if password matches hashlock (validation)
        if (crypto.createHash('sha256').update(password).digest('hex') !== htlc.hashlock) {
            throw new Error('Invalid password');
        }

        // Check if current time is before expiry time (validation)
        if (Date.now() >= htlc.expiresAt) {
            throw new Error('HTLC expired');
        }

        // Transfer tokens
        tokenState.balances[htlc.from] -= htlc.amount;
        tokenState.balances[htlc.to] = tokenState.balances[htlc.to] || 0;
        tokenState.balances[htlc.to] += htlc.amount;
        // Mark HTLC as claimed
        htlc.claimed = true;
        tokenState.htlcs[htlcID] = htlc;

        // Save updated state
        await ctx.stub.putState('tokenState', Buffer.from(JSON.stringify(tokenState)));
    }
}

module.exports = ERC20Token;
