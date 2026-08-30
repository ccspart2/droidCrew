# Project profile

Detected by `/droidcrew:setup` on YYYY-MM-DD. The codebase always wins over this file; if they drift, fix this file.

| | |
|---|---|
| App module | `:app` |
| Package | |
| minSdk / targetSdk / compileSdk | |
| Kotlin / AGP / Compose BOM | |
| UI | Jetpack Compose + Material 3 |
| DI | Hilt |
| Navigation | |
| Architecture | MVVM · StateFlow UI state · Channel/SharedFlow one-shot events |
| Persistence | |
| Networking | |
| Test stack | JUnit, kotlinx-coroutines-test, fakes (no mocks), MainDispatcherRule |
| Theme package | `…/ui/theme/` (the only place `dp`/`sp`/colour literals may live) |
| Modules | |

## Build & verify
```bash
./gradlew :app:assembleDebug --rerun-tasks
./gradlew :app:testDebugUnitTest --rerun-tasks   # count from app/build/test-results/testDebugUnitTest/*.xml
```
Last verified test baseline: **0 tests** on YYYY-MM-DD.

## Conventions observed in the repo
- 
