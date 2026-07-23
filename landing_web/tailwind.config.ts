import type { Config } from "tailwindcss";

export default {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["SpaceGrotesk", "sans-serif"],
      },
      colors: {
        "accent-orange": "#FF8D28",
      },
    },
  },
  plugins: [],
} satisfies Config;
