import adapter from '@sveltejs/adapter-vercel';
import preprocess from 'svelte-preprocess';
import WindiCSS from 'vite-plugin-windicss';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: preprocess(),

  kit: {
    adapter: adapter(),
    vite: {
      plugins: [WindiCSS()]
    }
  }
};

export default config;
