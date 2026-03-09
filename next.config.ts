import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  
  // Configuración para Flutter Web integration
  async rewrites() {
    return [
      // Flutter app routes
      {
        source: '/flutter/:path*',
        destination: '/flutter/:path*',
      },
      // API routes (si existen)
      {
        source: '/api/:path*',
        destination: '/api/:path*',
      },
    ];
  },

  // Headers para Flutter assets
  async headers() {
    return [
      {
        source: '/flutter/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
        ],
      },
      {
        // Headers para archivos Flutter específicos
        source: '/flutter/(.*\\.(js|css|wasm|json|png|jpg|jpeg|gif|svg|ico))',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ];
  },

  // Configuración de imágenes para Flutter assets
  images: {
    domains: [],
    unoptimized: true,
  },

  // TypeScript config
  typescript: {
    ignoreBuildErrors: true,
  },
  
  // React config
  reactStrictMode: false,

  // Webpack config para Flutter
  webpack: (config, { isServer }) => {
    // Ignorar archivos Flutter en el build del servidor
    if (isServer) {
      config.externals.push({
        'flutter': 'flutter',
        'flutter_bootstrap': 'flutter_bootstrap',
      });
    }
    
    return config;
  },
};

export default nextConfig;
