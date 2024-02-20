import { ConnectKitProvider, getDefaultConfig } from "connectkit";

import { WagmiConfig, createConfig, configureChains } from "wagmi";
import { mainnet } from "wagmi/chains";
import { publicProvider } from 'wagmi/providers/public';

import '@/styles/globals.css';

const { publicClient, chains } = configureChains(
  [ mainnet ],
  [ publicProvider() ],
);

const config = createConfig(
  getDefaultConfig({
    walletConnectProjectId: 'ba13d5bdabc28403d3af4b511efa2bf3',
    appName: 'Get My GHO',
    chains,
    publicClient,
  }),
);

export default function App({ Component, pageProps }) {
  return <WagmiConfig config={config}>
    <ConnectKitProvider>
      <Component {...pageProps} />
    </ConnectKitProvider>
  </WagmiConfig>;
}
