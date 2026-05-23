/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./{app,components,libs,pages,hooks}/**/*.{html,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        brand: {
          brown: '#BE185D',
          carton: '#BE185D',
          cream: '#F3F3F3',
          purple: '#F472B6',
          pink: '#FFCCCC',
          coral: '#FF6666',
          yellow: '#FFFFCC',
          tan: '#BE185D',
          gold: '#FFCC00',
          oxblood: '#9A1900',
          rose: '#FF9999',
        },
      },
      fontFamily: {
        sans: ['Montserrat', 'sans-serif'],
        display: ['Montserrat', 'sans-serif'],
      },
    },
  },
  plugins: [],
}

