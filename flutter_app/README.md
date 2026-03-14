# Stroke Mitra — Flutter + Supabase

> AI-Powered Stroke Screening App. Detect stroke early. Save lives.

Migrated from MERN stack (React + Express) to **Flutter + Supabase**.

---

## 🚀 Quick Start

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.16+)
- [Supabase CLI](https://supabase.com/docs/guides/cli) (optional, for local dev)
- A [Supabase project](https://supabase.com/dashboard)

### 1. Clone & Install Dependencies
```bash
cd flutter_app
flutter pub get
```

### 2. Set Up Supabase
1. Create a new project at [supabase.com](https://supabase.com/dashboard)
2. Go to **SQL Editor** and run the migration file:
   ```
   supabase/migrations/20260314000000_initial_schema.sql
   ```
3. Copy your **Project URL** and **anon/public key** from Settings → API

### 3. Configure Environment
Edit `.env` with your credentials:
```
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_ANON_KEY=YOUR_ANON_KEY_HERE
```

### 4. Run the App
```bash
# Mobile
flutter run

# Web
flutter run -d chrome

# iOS
flutter run -d ios
```

---

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point
├── app/
│   ├── router.dart              # GoRouter navigation
│   └── theme.dart               # Design system & colors
├── core/
│   ├── constants.dart           # Config & table names
│   └── supabase_client.dart     # Supabase singleton
├── features/
│   ├── landing/                 # Full marketing landing page
│   │   ├── landing_screen.dart
│   │   └── widgets/             # Hero, Features, Stats, CTA, Footer
│   ├── dashboard/               # Home with 3 action cards
│   ├── face_analysis/           # Camera-based face analysis
│   ├── voice_check/             # Voice recording & analysis
│   └── motion_test/             # Accelerometer motion test
└── shared/
    ├── widgets/                 # AppShell, Disclaimer
    └── utils/                   # SessionService (Supabase calls)
```

---

## 🔄 Migration Summary

| Original (MERN) | Flutter + Supabase |
|:---|:---|
| Express in-memory server | Supabase PostgreSQL |
| `POST /api/session` | `supabase.from('sessions').insert()` |
| `POST /api/data` | `supabase.from('session_data').insert()` |
| `POST /api/complete` | `supabase.from('sessions').update()` |
| React Router | GoRouter |
| React hooks (useState) | StatefulWidget + Riverpod |
| getUserMedia Camera | `camera` package |
| MediaRecorder | `record` package |
| DeviceMotionEvent | `sensors_plus` package |
| CSS Variables | AppTheme constants |
| lucide-react icons | Material Icons |

---

## ⚠️ Disclaimer

This application is for **demonstration and research purposes only**. It is not a medical device and does not provide a diagnosis. If you suspect a stroke, **call emergency services (112) immediately**.
