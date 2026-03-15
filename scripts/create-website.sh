#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/.." && pwd)
website_dir="$repo_root/website"
cover_source="$repo_root/cover.png"
pdf_source="$repo_root/MANUSCRIPT.pdf"
cover_target="$website_dir/cover.png"
pdf_target="$website_dir/Only-I-Can-Feel-Me.pdf"
html_target="$website_dir/index.html"

require_file() {
  local file_path=$1

  if [[ ! -f "$file_path" ]]; then
    printf 'Required file not found: %s\n' "$file_path" >&2
    exit 1
  fi
}

require_file "$cover_source"
require_file "$pdf_source"

mkdir -p "$website_dir"

cp "$cover_source" "$cover_target"
cp "$pdf_source" "$pdf_target"

cat << 'EOF' > "$html_target"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Launch page for Only I Can Feel Me, a hard sci-fi dystopian novel by Joshua Szepietowski.">
  <title>Only I Can Feel Me | Joshua Szepietowski</title>
  <style>
    :root {
      --bg: #050505;
      --bg-alt: #0d0d0d;
      --panel: rgba(13, 13, 13, 0.82);
      --text: #f4f1eb;
      --muted: #b8afa5;
      --accent: #a10d14;
      --accent-bright: #d41620;
      --border: rgba(255, 255, 255, 0.12);
      --shadow: 0 28px 80px rgba(0, 0, 0, 0.55);
      --mono: "Courier New", "Fira Code", "SFMono-Regular", Consolas, monospace;
      --sans: "Helvetica Neue", Helvetica, Arial, sans-serif;
      --content-width: 1160px;
    }

    * {
      box-sizing: border-box;
    }

    html {
      scroll-behavior: smooth;
    }

    body {
      margin: 0;
      min-height: 100vh;
      background:
        radial-gradient(circle at top, rgba(161, 13, 20, 0.24), transparent 34%),
        linear-gradient(180deg, rgba(255, 255, 255, 0.02), transparent 18%),
        repeating-linear-gradient(
          90deg,
          rgba(255, 255, 255, 0.035) 0,
          rgba(255, 255, 255, 0.035) 1px,
          transparent 1px,
          transparent 88px
        ),
        linear-gradient(180deg, #090909 0%, #040404 55%, #090909 100%);
      color: var(--text);
      font-family: var(--sans);
      line-height: 1.65;
      letter-spacing: 0.01em;
    }

    body::before {
      content: "";
      position: fixed;
      inset: 0;
      background:
        linear-gradient(rgba(255, 255, 255, 0.015), rgba(255, 255, 255, 0.015)),
        repeating-linear-gradient(
          180deg,
          rgba(255, 255, 255, 0.03) 0,
          rgba(255, 255, 255, 0.03) 1px,
          transparent 1px,
          transparent 4px
        );
      mix-blend-mode: soft-light;
      opacity: 0.22;
      pointer-events: none;
    }

    a {
      color: inherit;
      text-decoration: none;
    }

    .shell {
      position: relative;
      width: min(calc(100% - 2rem), var(--content-width));
      margin: 0 auto;
      padding: 1rem 0 4rem;
    }

    .status-bar {
      display: flex;
      justify-content: space-between;
      gap: 1rem;
      padding: 1rem 1.25rem;
      margin-top: 0.75rem;
      border: 1px solid var(--border);
      background: rgba(0, 0, 0, 0.55);
      color: var(--muted);
      font-family: var(--mono);
      font-size: 0.76rem;
      text-transform: uppercase;
      letter-spacing: 0.18em;
      backdrop-filter: blur(10px);
    }

    .status-alert {
      color: var(--accent-bright);
    }

    .hero {
      display: grid;
      grid-template-columns: minmax(0, 420px) minmax(0, 1fr);
      gap: clamp(2rem, 5vw, 5rem);
      align-items: center;
      padding: clamp(2rem, 6vw, 5rem) 0 clamp(2rem, 4vw, 3rem);
    }

    .cover-frame {
      position: relative;
      width: min(100%, 400px);
      margin: 0 auto;
      padding: 1rem;
      border: 1px solid rgba(255, 255, 255, 0.14);
      background: linear-gradient(180deg, rgba(255, 255, 255, 0.04), rgba(255, 255, 255, 0.01));
      box-shadow: var(--shadow);
    }

    .cover-frame::before,
    .cover-frame::after {
      content: "";
      position: absolute;
      width: 22px;
      height: 22px;
      border-color: var(--accent-bright);
      border-style: solid;
      opacity: 0.95;
    }

    .cover-frame::before {
      top: 0.5rem;
      left: 0.5rem;
      border-width: 2px 0 0 2px;
    }

    .cover-frame::after {
      right: 0.5rem;
      bottom: 0.5rem;
      border-width: 0 2px 2px 0;
    }

    .cover-frame img {
      display: block;
      width: 100%;
      max-width: 400px;
      height: auto;
      margin: 0 auto;
      border: 1px solid rgba(255, 255, 255, 0.08);
    }

    .hero-copy {
      display: grid;
      gap: 1.2rem;
    }

    .eyebrow {
      margin: 0;
      color: var(--accent-bright);
      font-family: var(--mono);
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 0.22em;
    }

    h1,
    h2,
    .cta-button,
    .footer-line {
      font-family: var(--mono);
    }

    h1 {
      margin: 0;
      font-size: clamp(2.8rem, 7vw, 5.8rem);
      line-height: 0.92;
      letter-spacing: -0.04em;
      text-transform: uppercase;
      text-wrap: balance;
    }

    .hero-author {
      margin: 0;
      color: var(--muted);
      font-size: 1.08rem;
      letter-spacing: 0.08em;
      text-transform: uppercase;
    }

    .hero-quote {
      margin: 0;
      padding-left: 1.1rem;
      border-left: 3px solid var(--accent-bright);
      font-size: clamp(1.1rem, 2vw, 1.45rem);
      line-height: 1.45;
      max-width: 34rem;
      color: var(--text);
    }

    .hero-note {
      margin: 0;
      max-width: 40rem;
      color: var(--muted);
      font-size: 1rem;
    }

    .content-grid {
      display: grid;
      grid-template-columns: minmax(0, 1.1fr) minmax(300px, 0.7fr);
      gap: 1.5rem;
      align-items: start;
    }

    .panel {
      position: relative;
      overflow: hidden;
      padding: clamp(1.4rem, 3vw, 2rem);
      border: 1px solid var(--border);
      background: var(--panel);
      backdrop-filter: blur(12px);
      box-shadow: var(--shadow);
    }

    .panel::before {
      content: "";
      position: absolute;
      inset: 0 auto auto 0;
      width: 100%;
      height: 3px;
      background: linear-gradient(90deg, var(--accent-bright), transparent 70%);
      opacity: 0.88;
    }

    h2 {
      margin: 0 0 1rem;
      font-size: 0.95rem;
      color: var(--accent-bright);
      letter-spacing: 0.2em;
      text-transform: uppercase;
    }

    .synopsis {
      margin: 0;
      font-size: 1.05rem;
      color: var(--text);
    }

    .meta-list {
      display: grid;
      gap: 1rem;
      margin: 0 0 1.5rem;
    }

    .meta-item {
      padding-bottom: 0.9rem;
      border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    }

    .meta-label {
      display: block;
      margin-bottom: 0.3rem;
      color: var(--muted);
      font-family: var(--mono);
      font-size: 0.72rem;
      letter-spacing: 0.16em;
      text-transform: uppercase;
    }

    .meta-value {
      margin: 0;
      font-size: 1rem;
      color: var(--text);
    }

    .cta-wrap {
      display: grid;
      gap: 0.9rem;
    }

    .cta-button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 100%;
      min-height: 68px;
      padding: 1rem 1.25rem;
      border: 1px solid #f0d7d8;
      background: linear-gradient(180deg, var(--accent-bright), var(--accent));
      color: #fff8f8;
      font-size: 1rem;
      font-weight: 700;
      letter-spacing: 0.16em;
      text-transform: uppercase;
      box-shadow: 0 18px 40px rgba(161, 13, 20, 0.35);
      transition: transform 180ms ease, box-shadow 180ms ease, filter 180ms ease;
    }

    .cta-button:hover,
    .cta-button:focus-visible {
      transform: translateY(-2px);
      box-shadow: 0 22px 48px rgba(161, 13, 20, 0.45);
      filter: saturate(1.08);
    }

    .cta-button:focus-visible {
      outline: 2px solid #fff;
      outline-offset: 3px;
    }

    .cta-caption {
      margin: 0;
      color: var(--muted);
      font-size: 0.92rem;
    }

    footer {
      display: grid;
      gap: 0.6rem;
      margin-top: 1.5rem;
      padding: 1.25rem 0 0;
      border-top: 1px solid rgba(255, 255, 255, 0.08);
      color: var(--muted);
      font-size: 0.92rem;
    }

    .footer-line {
      color: var(--text);
      font-size: 0.86rem;
      text-transform: uppercase;
      letter-spacing: 0.16em;
    }

    .status-line {
      display: inline-flex;
      align-items: center;
      gap: 0.65rem;
      color: var(--muted);
      font-family: var(--mono);
      font-size: 0.78rem;
      text-transform: uppercase;
      letter-spacing: 0.16em;
    }

    .status-dot {
      width: 0.7rem;
      height: 0.7rem;
      border-radius: 999px;
      background: var(--accent-bright);
      box-shadow: 0 0 16px rgba(212, 22, 32, 0.8);
    }

    @media (max-width: 900px) {
      .hero,
      .content-grid {
        grid-template-columns: 1fr;
      }

      .hero {
        padding-top: 2rem;
      }

      .status-bar {
        flex-direction: column;
      }
    }

    @media (max-width: 640px) {
      .shell {
        width: min(calc(100% - 1rem), var(--content-width));
        padding-bottom: 2.5rem;
      }

      .status-bar,
      .panel,
      .cover-frame {
        padding-left: 1rem;
        padding-right: 1rem;
      }

      h1 {
        letter-spacing: -0.03em;
      }

      .hero-author {
        font-size: 1rem;
      }

      .synopsis {
        font-size: 1rem;
      }
    }
  </style>
</head>
<body>
  <div class="shell">
    <div class="status-bar">
      <span>Secure Internal Channel // Launch Dossier</span>
      <span class="status-alert" id="statusStamp">Manifest live</span>
    </div>

    <main>
      <section class="hero" aria-labelledby="title">
        <div class="cover-frame">
          <img src="cover.png" alt="Cover art for Only I Can Feel Me by Joshua Szepietowski">
        </div>

        <div class="hero-copy">
          <p class="eyebrow">Unauthorized tenderness is still extraction.</p>
          <h1 id="title">Only I Can Feel Me</h1>
          <p class="hero-author">Joshua Szepietowski</p>
          <p class="hero-quote">"Your inner life is not raw material."</p>
          <p class="hero-note">A hard sci-fi dystopian novel about moderation, moral drift, and the systems that learn to call invasion care.</p>
          <div class="status-line">
            <span class="status-dot" aria-hidden="true"></span>
            <span>Channel integrity holding</span>
          </div>
        </div>
      </section>

      <section class="content-grid" aria-label="Book details and manuscript download">
        <article class="panel">
          <h2>Synopsis</h2>
          <p class="synopsis">Leah is a content moderator, spending her days categorizing the worst of human suffering into policy decisions. Seeking refuge, she joins a quiet, contemplative group meeting above a florist. But when empathy-mapping technology threatens to digitize human emotion, the group's search for peace morphs into "Humans R Humans"—a radical movement determined to protect human interiority at any cost. As peaceful protests curdle into targeted, systematic pressure, Leah must moderate a movement that uses the language of care to justify its own escalating cruelty.</p>
        </article>

        <aside class="panel">
          <h2>Access</h2>
          <div class="meta-list">
            <div class="meta-item">
              <span class="meta-label">Format</span>
              <p class="meta-value">Full manuscript PDF</p>
            </div>
            <div class="meta-item">
              <span class="meta-label">Signal</span>
              <p class="meta-value">Hard sci-fi / dystopian / literary</p>
            </div>
            <div class="meta-item">
              <span class="meta-label">Core Threat</span>
              <p class="meta-value">Human interiority converted into infrastructure</p>
            </div>
          </div>

          <div class="cta-wrap">
            <a class="cta-button" href="Only-I-Can-Feel-Me.pdf" download>[ DOWNLOAD MANUSCRIPT ]</a>
            <p class="cta-caption">Direct PDF download. No platform mediation. No account required.</p>
          </div>
        </aside>
      </section>
    </main>

    <footer>
      <p class="footer-line">Human interior life must remain sovereign.</p>
      <p>&copy; <span id="year"></span> Joshua Szepietowski. All rights reserved.</p>
    </footer>
  </div>

  <script>
    const now = new Date();
    const stamp = now.toISOString().slice(0, 16).replace('T', ' ');
    document.getElementById('year').textContent = String(now.getFullYear());
    document.getElementById('statusStamp').textContent = `Manifest live // ${stamp} UTC`;
  </script>
</body>
</html>
EOF

printf 'Wrote %s\n' "$cover_target"
printf 'Wrote %s\n' "$pdf_target"
printf 'Wrote %s\n' "$html_target"