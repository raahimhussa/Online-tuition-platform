/** @type {import('next').NextConfig} */
const nextConfig = {
  trailingSlash: true, // Ensures all routes end with a trailing slash
  modularizeImports: {
    '@mui/material': {
      transform: '@mui/material/{{member}}', // Modularizes MUI imports
    },
    '@mui/lab': {
      transform: '@mui/lab/{{member}}',
    },
  },
  webpack(config) {
    // Adds support for importing SVG files as React components
    config.module.rules.push({
      test: /\.svg$/,
      use: ['@svgr/webpack'],
    });
    return config; // Return the updated config
  },
};

module.exports = nextConfig; // Export the configuration
