# Qoder Auto-Login — JSON Output

Tool otomatis untuk login akun Qoder via Google SSO dan menyimpan token ke file JSON (format `providerConnections`).
Reverse-engineered dari 9router v0.4.71. **Tidak perlu 9router** — output berupa file JSON portable.

## ✨ Features

- **Google SSO** auto-login (multi-language: EN, ID, dll)
- **Batch mode** — login banyak akun sekaligus dari file
- **Concurrent processing** — beberapa browser jalan bareng (1-5)
- **Headless mode** — browser invisible untuk automation
- **JSON output** — save token ke file JSON (format 9router `providerConnections`)
- **Custom output path** — tentukan lokasi file output via `--output`
- **Skip existing** — auto-skip akun yang sudah ada di file JSON output
- **Consent handler** — otomatis handle semua Google agreement screens:
  - "Saya mengerti" / "I understand"
  - "Continue" / "Lanjutkan"
  - "This app isn't verified" → Advanced → Go to...
  - OAuth scope consent
  - Workspace admin consent
- **Interactive mode** — preview akun + toggle headless + pilih output file + confirm sebelum jalan
- **Portable** — tidak perlu 9router, tidak perlu Node.js, cukup Python 3.8+
- **PKCE + nonce** — secure device auth flow (sama persis kayak 9router)

## 📋 Requirements

| Requirement | Minimum |
|-------------|---------|
| **Windows** | 10 / 11 |
| **Python** | 3.8+ |

> **Tidak perlu 9router atau Node.js!** Tool ini standalone — output langsung ke file JSON.

## 🚀 Quick Start

### 1. Install

```bash
# Clone atau download repo ini, lalu:
cd qoder-autologin

# Auto-install dependencies
setup.bat
```

Atau manual:
```bash
pip install -r requirements.txt
playwright install chromium
```

### 2. Pakai

**Single account:**
```bash
python qoder_autologin.py email@gmail.com:password123
```

**Batch dari file:**
```bash
python qoder_autologin.py --batch accounts.txt
```

**Batch dengan custom output:**
```bash
python qoder_autologin.py --batch accounts.txt --output qoder-accounts.json
```

**Test mode (tanpa save):**
```bash
python qoder_autologin.py --batch accounts.txt --test --headless
```

**Interactive (double-click `run-batch.bat`):**

```
  ===================================================
     Qoder Auto-Login — JSON Output - Batch Mode
  ===================================================

  [i] Found 14 account(s) in accounts.txt

  ---------------------------------------------------
    email1@gmail.com
    email2@gmail.com
    ...
  ---------------------------------------------------

  Headless mode? (browser invisible) [y/N]: n
  Concurrent browsers (1-5) [1]: 2
  Output JSON file [qoder-accounts.json]:

  +--------------------------------------+
  |  Accounts:   14
  |  Browser:    Visible
  |  Concurrent: 2
  |  Output:     qoder-accounts.json
  +--------------------------------------+

  Start login? [Y/n]:
```

## 📁 File Structure

```
qoder-autologin/
├── qoder_autologin.py      ← Script utama
├── setup.bat               ← Auto-installer (Python + Playwright)
├── qoder-login.bat         ← CLI launcher
├── run-batch.bat           ← Interactive batch launcher
├── accounts.txt            ← Akun kamu (jangan di-commit!)
├── accounts.txt.example    ← Template (safe to commit)
├── qoder-accounts.json     ← Output file (auto-generated)
├── requirements.txt        ← Python dependencies
├── .gitignore
└── README.md
```

## 📝 Format accounts.txt

```
# Komentar diawali # (di-skip)
# Baris kosong juga di-skip

email1@gmail.com:password1
email2@gmail.com:password2
email3@workspace.com:password3
```

## 📄 Format Output JSON

File output (`qoder-accounts.json`) berisi array JSON dengan format `providerConnections`:

```json
[
  {
    "displayName": "John Doe",
    "accessToken": "eyJ...",
    "refreshToken": "AMf-...",
    "expiresAt": "2026-06-12T12:00:00+00:00",
    "testStatus": "active",
    "expiresIn": 2591998,
    "providerSpecificData": {
      "authMethod": "device",
      "userId": "user-uuid",
      "machineId": "machine-uuid",
      "organizationId": ""
    },
    "lastError": null,
    "errorCode": null,
    "lastErrorAt": null,
    "backoffLevel": 0,
    "id": "connection-uuid",
    "provider": "qoder",
    "authType": "oauth",
    "name": "email@gmail.com",
    "email": "email@gmail.com",
    "priority": 1,
    "isActive": true,
    "createdAt": "2026-06-11T12:00:00+00:00",
    "updatedAt": "2026-06-11T12:00:00+00:00"
  }
]
```

> Format ini kompatibel dengan 9router `providerConnections` — bisa di-import manual jika diperlukan.

## 🔧 CLI Options

```
usage: qoder_autologin.py [-h] [--batch FILE] [--output FILE]
                          [--headless] [--concurrent N]
                          [--test] [--debug] [--interactive]
                          [--no-skip-existing]
                          [accounts ...]

positional arguments:
  accounts              email:password pairs

options:
  -b, --batch FILE      Read accounts from file
  -o, --output FILE     Output JSON file path (default: qoder-accounts.json)
  --headless            Run browser in headless mode (invisible)
  -c, --concurrent N    Concurrent browser sessions (1-5, default: 1)
  -t, --test            Test mode: get token but don't save to JSON
  -d, --debug           Enable debug output
  -i, --interactive     Interactive prompts before running
  --no-skip-existing    Re-login even if account already exists in output JSON
```

## 🛡️ Safety Features

### Skip Existing Accounts
By default, akun yang sudah ada di file JSON output **di-skip otomatis**.
Gunakan `--no-skip-existing` untuk force re-login (misal token expired).

### Test Mode
`--test` flag: jalankan login tanpa save ke JSON. Berguna untuk testing akun baru.

### Merge & Update
Kalau file output sudah ada, akun baru di-**append** dan akun yang sudah ada di-**update** (token, expiry, dll). Priority otomatis di-increment.

## 🔄 Transfer ke Device Lain

1. Zip folder `qoder-autologin`
2. Kirim ke device baru
3. Jalankan `setup.bat`
4. Isi `accounts.txt`
5. Double-click `run-batch.bat`
6. File `qoder-accounts.json` berisi semua token yang berhasil login

## ⚡ Performance

| Mode | Per Account | 10 Accounts |
|------|------------|-------------|
| Visible, concurrent=1 | ~24s | ~4 min |
| Headless, concurrent=1 | ~20s | ~3.5 min |
| Visible, concurrent=3 | ~24s each | ~1.5 min |
| Headless, concurrent=3 | ~20s each | ~1 min |

> ⚠️ Concurrent > 2 bisa trigger Google rate-limiting. Recommended: **concurrent 1-2**.

## 🐛 Troubleshooting

**Browser error / context destroyed:**
- Sudah di-handle otomatis (retry). Kalau masih gagal, coba `--concurrent 1`

**Token tidak datang:**
- Cek koneksi internet
- Pastikan akun Google tidak kena suspend/blocked

**Google CAPTCHA / 2FA:**
- Browser visible (default) biar bisa handle manual
- Atau disable 2FA sementara di akun Google

**Consent screen stuck:**
- Script auto-handle kebanyakan consent screen
- Kalau ada yang baru, submit issue dengan screenshot

## 📝 Changelog

### v4 (Current)
- **BREAKING**: Output berubah dari 9router SQLite DB → file JSON portable
- Hapus dependency ke 9router, Node.js, dan SQLite
- Tambah `--output / -o` untuk custom output path
- Batch save dengan merge/update logic
- Format JSON kompatibel dengan 9router `providerConnections`
- Performance optimization: login 39% lebih cepat (39s → 24s)
- Robust selectAccounts handling dengan retry + fallback

### v3
- Headless support, consent handling, private network blocking

### v2
- Initial batch mode + Google SSO

## 📄 License

MIT — pakai sesuka hati.

## ⚠️ Disclaimer

Tool ini untuk penggunaan personal. Gunakan responsibly.
Penulis tidak bertanggung jawab atas penyalahgunaan tool ini.
