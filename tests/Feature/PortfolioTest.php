<?php

namespace Tests\Feature;

use Tests\TestCase;

class PortfolioTest extends TestCase
{
    public function test_halaman_utama_menampilkan_nama_dan_proyek(): void
    {
        $response = $this->get('/');

        $response->assertOk();
        $response->assertSee(config('portfolio.profile.nama'));
        $response->assertSee(config('portfolio.projects.0.judul'));
    }
}
