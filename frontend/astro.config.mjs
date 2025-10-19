// @ts-check
import { defineConfig } from 'astro/config';
import vue from '@astrojs/vue';

// https://astro.build/config
export default defineConfig({
  integrations: [vue()],
  server: {
    host: '0.0.0.0',
    port: 4321
  },
  vite: {
    server: {
      watch: {
        usePolling: true
      }
    }
  }
});
