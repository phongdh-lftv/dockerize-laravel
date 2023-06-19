import { defineConfig } from "vite";
import laravel from 'laravel-vite-plugin';
import manifestSRI from 'vite-plugin-manifest-sri';

export default () => {
    return defineConfig({
        plugins: [
            laravel({
                input: ['resources/css/app.css', 'resources/ts/app.ts'],
                refresh: true,
            }),
            manifestSRI(),
        ],
    });
};
