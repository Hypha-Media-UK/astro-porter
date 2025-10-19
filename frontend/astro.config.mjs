// @ts-check
import { defineConfig } from 'astro/config';
import vue from '@astrojs/vue';
import tailwind from '@astrojs/tailwind';

// https://astro.build/config
export default defineConfig({
  integrations: [
    vue(),
    tailwind({
      applyBaseStyles: false, // We'll use our own base styles
    })
  ],
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
