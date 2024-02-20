import { useState } from 'react';
import Head from 'next/head';
import { ConnectKitButton } from 'connectkit';
import { useAccount, useContractReads, useSignTypedData } from 'wagmi';

import erc20PermitABI from '../abi/ERC20Permit.json';

const GHO = '0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f';
const SPENDER = '0x37f26237E2F32731Df8E388414b07a46E69c8297';

export default function Home() {
  const { address: account } = useAccount();
  const { data, isError, isLoading } = useContractReads({
    contracts: [
      {
        address: GHO,
        abi: erc20PermitABI,
        chainId: 1,
        functionName: 'balanceOf',
        args: [ account ],
      },
      {
        address: GHO,
        abi: erc20PermitABI,
        chainId: 1,
        functionName: 'nonces',
        args: [ account ],
      },
    ],
  });

  const [ deadline, setDeadline ] = useState(
    Math.floor(Date.now() / 1000) + (60 * 60 * 96)); // 96 hours from now

  const {
    data: signData,
    isError: signError,
    isLoading: signLoading,
    isSuccess: signSuccess,
    reset: resetSign,
    signTypedData
  } = useSignTypedData({
    domain: {
      version: '1',
      name: 'Gho Token',
      chainId: 1,
      verifyingContract: GHO,
    },
    message: {
      owner: account,
      spender: SPENDER,
      value: data && data[0].result,
      nonce: data && data[1].result,
      deadline,
    },
    primaryType: 'Permit',
    types: {
      Permit: [
        {
          name: 'owner',
          type: 'address',
        },
        {
          name: 'spender',
          type: 'address',
        },
        {
          name: 'value',
          type: 'uint256',
        },
        {
          name: 'nonce',
          type: 'uint256',
        },
        {
          name: 'deadline',
          type: 'uint256',
        },
      ],
    },
  });

  return (
    <>
      <Head>
        <title>Get My GHO</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </Head>
      <main>
        <div className="connectkit">
          <ConnectKitButton />
        </div>
        {data && data[0].status === 'failure' && <p className="form-status error">Error loading details!</p>}
        {data && data[0].status !== 'failure' && <button type="button" onClick={signTypedData}>
          Sign Spend Permit
        </button>}
        {signData && <p>Signature: <code>{signData}</code><br />Deadline: <code>{deadline}</code></p>}
      </main>
    </>
  )
}
