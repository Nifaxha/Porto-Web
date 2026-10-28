# Portofolio (Laravel + Blade + React + Tailwind, jalan di Docker)

- **Laravel 13** menyajikan halaman lewat Blade (`resources/views`)
- **React 19** merender tampilan (`resources/js`), dibangun dengan **Vite**
- **Tailwind CSS 4** untuk gaya (`resources/css/app.css`)
- **Docker**: satu container berisi Nginx dan PHP-FPM, tanpa database

## Menjalankan

Syarat: Docker dan Docker Compose terpasang.

```bash
docker compose up -d --build
```

Buka http://localhost:8080. Build pertama butuh beberapa menit karena mengunduh dependency PHP dan Node.

Perintah berguna:

```bash
docker compose logs -f web      # lihat log
docker compose down             # hentikan
docker compose up -d --build    # bangun ulang setelah mengubah isi
```

Port dan alamat bisa diubah lewat environment, misalnya `APP_PORT=80 APP_URL=https://domainmu.com docker compose up -d --build`.

## Mengganti isi

Edit **`config/portfolio.php`**: nama, tentang, keahlian, kontak, dan daftar proyek. Untuk menambah proyek, salin satu blok di dalam `projects`.

- Gambar proyek: taruh di `public/images/`, lalu isi `'gambar' => 'images/nama-file.png'`
- CV: taruh di `public/`, lalu isi `'cv' => 'cv.pdf'`
- Warna dan font: bagian `@theme` di `resources/css/app.css`

Setelah mengedit, jalankan `docker compose up -d --build`.

## Struktur

| Lokasi | Fungsi |
| --- | --- |
| `config/portfolio.php` | Isi website (satu-satunya file yang biasanya perlu diedit) |
| `app/Http/Controllers/PortfolioController.php` | Mengirim data ke Blade |
| `resources/views/layouts/app.blade.php`, `home.blade.php` | Kerangka HTML, SEO, isi awal untuk mesin pencari |
| `resources/js/components/` | Komponen React (Header, Hero, Projects, About, Contact) |
| `Dockerfile`, `compose.yaml`, `docker/` | Konfigurasi Docker |

## Pengembangan tanpa Docker (opsional)

Butuh PHP 8.3+, Composer, dan Node 22+.

```bash
composer install
cp .env.example .env && php artisan key:generate
npm install
npm run dev            # terminal 1: Vite dengan hot reload
php artisan serve      # terminal 2
php artisan test       # jalankan tes
```

## Soal GitHub dan domain github.io

GitHub Pages (`username.github.io`) hanya bisa menyajikan file statis, jadi **aplikasi Laravel tidak bisa berjalan di sana**. Pilihannya:

1. Simpan kode ini di GitHub sebagai repository biasa, lalu jalankan di server yang mendukung Docker: VPS (DigitalOcean, Hetzner, dan sejenisnya) atau layanan seperti Railway, Fly.io, atau Render. Untuk domain sendiri dan HTTPS, taruh Caddy atau Nginx Proxy Manager di depan container ini.
2. Kalau tujuannya tetap alamat `username.github.io`, pakai versi statis (HTML/CSS/JS) yang dikirim sebelumnya.

## Catatan

- `APP_KEY` dibuat otomatis saat container pertama kali jalan dan disimpan di volume `storage`. Untuk memakai kunci sendiri, isi variabel `APP_KEY` di compose.
- Pemasangan `laravel/boost` yang disebut di `CLAUDE.md` bawaan Laravel bersifat opsional untuk alat bantu pengembangan dan tidak diperlukan untuk menjalankan website ini.
