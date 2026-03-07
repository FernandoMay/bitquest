import { NextResponse } from 'next/server';

interface BitcoinPriceResponse {
  btc_mxn: number;
  btc_usd: number;
  change_24h: number;
  timestamp: string;
}

// Cache for Bitcoin price (refresh every 30 seconds)
let cachedPrice: BitcoinPriceResponse | null = null;
let lastFetch = 0;
const CACHE_DURATION = 30000; // 30 seconds

async function fetchBitcoinPrice(): Promise<BitcoinPriceResponse> {
  const now = Date.now();
  
  // Return cached price if still valid
  if (cachedPrice && (now - lastFetch) < CACHE_DURATION) {
    return cachedPrice;
  }

  try {
    // Fetch from CoinGecko API (free, no API key needed)
    const response = await fetch(
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=mxn,usd&include_24hr_change=true',
      {
        next: { revalidate: 30 },
      }
    );

    if (!response.ok) {
      throw new Error('Failed to fetch from CoinGecko');
    }

    const data = await response.json();
    
    cachedPrice = {
      btc_mxn: data.bitcoin.mxn,
      btc_usd: data.bitcoin.usd,
      change_24h: data.bitcoin.usd_24h_change || 0,
      timestamp: new Date().toISOString(),
    };
    lastFetch = now;

    return cachedPrice;
  } catch (error) {
    console.error('Error fetching Bitcoin price:', error);
    
    // Return mock data if API fails
    return {
      btc_mxn: 1245678.90,
      btc_usd: 72345.67,
      change_24h: 2.34,
      timestamp: new Date().toISOString(),
    };
  }
}

export async function GET() {
  try {
    const price = await fetchBitcoinPrice();
    return NextResponse.json(price);
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch Bitcoin price' },
      { status: 500 }
    );
  }
}
