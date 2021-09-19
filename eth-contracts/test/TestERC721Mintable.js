var ERC721MintableComplete = artifacts.require('CustomERC721Token');

contract('TestERC721Mintable', accounts => {

    const account_one = accounts[0];
    const account_two = accounts[1];

    describe('match erc721 spec', function () {
        beforeEach(async function () { 
            this.contract = await ERC721MintableComplete.new({from: account_one});

            // TODO: mint multiple tokens
            await this.contract.mint(account_one, 1);
            await this.contract.mint(account_two, 2);
            await this.contract.mint(account_two, 3);
            await this.contract.mint(account_two, 4);
        })

        it('should return total supply', async function () { 
            const total = await this.contract.totalSupply();
            assert.equal(parseInt(total), 4, "Incorrect total supply");
        })

        it('should get token balance', async function () { 
            const balance = await this.contract.balanceOf(account_two);
            assert.equal(parseInt(balance), 3, "Incorrect token balance");
        })

        // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
        it('should return token uri', async function () { 
            const tokenURI = await this.contract.tokenURI(4,{from:account_two});
            assert.equal(tokenURI, "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/4", "Incorrect token uri");
        })

        it('should transfer token from one owner to another', async function () { 
            await this.contract.transferFrom(account_two,account_one,4,{from:account_two});
            const newOwner = await this.contract.ownerOf(4);
            assert.equal(newOwner, account_one, "Incorrect Owner");
        })
    });

    describe('have ownership properties', function () {
        beforeEach(async function () { 
            this.contract = await ERC721MintableComplete.new({from: account_one});
        })

        it('should fail when minting when address is not contract owner', async function () { 
            let e = false;
            try {
                await this.contract.mint(account_one, 1,{from:account_two});
            }catch(err){
                e = true
            }
            assert.equal(e, true, "should fail when minting when address is not contract owner");
        })

        it('should return contract owner', async function () { 
            const owner = await this.contract.owner();
            assert.equal(owner, account_one, "incorrect contract owner");
        })

    });
})