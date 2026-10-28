@extends('layouts.app')

@section('title', $portfolio['profile']['nama'] . ' | Portofolio')
@section('description', $portfolio['profile']['peran'] . ' di ' . $portfolio['profile']['lokasi'] . '. ' . $portfolio['profile']['intro'])

@section('content')
    {{-- Data untuk React. JSON_HEX_TAG mencegah "</script>" di dalam teks merusak halaman. --}}
    <script id="portfolio-data" type="application/json">@json($portfolio, JSON_HEX_TAG | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE)</script>

    {{-- Isi awal yang dirender server. React menggantinya setelah JavaScript termuat,
         jadi mesin pencari dan pengunjung tanpa JavaScript tetap melihat isi dasar. --}}
    <div id="root">
        <main class="wrap py-16">
            <h1 class="font-display text-5xl font-extrabold tracking-tight">{{ $portfolio['profile']['nama'] }}</h1>
            <p class="mt-2 text-accent">{{ $portfolio['profile']['peran'] }}</p>
            <p class="mt-6 max-w-xl">{{ $portfolio['profile']['intro'] }}</p>
            <h2 class="mt-12 font-display text-3xl font-extrabold">Proyek</h2>
            <ul class="mt-4 list-disc pl-5">
                @foreach ($portfolio['projects'] as $project)
                    <li>{{ $project['judul'] }}, {{ $project['tahun'] }}. {{ $project['ringkas'] }}</li>
                @endforeach
            </ul>
        </main>
    </div>
@endsection

@section('footer')
    &copy; {{ date('Y') }} {{ $portfolio['profile']['nama'] }}, {{ $portfolio['profile']['lokasi'] }}
@endsection
