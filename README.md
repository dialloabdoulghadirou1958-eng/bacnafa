# BacNafa

<div align="center">

**« Ton succès commence ici »**

Application mobile **EdTech** conçue pour accompagner les élèves de **Terminale** (Guinée) dans la préparation au **Baccalauréat** : sujets d'examens, corrections, quiz d'entraînement, bibliothèque personnelle et profil de progression.

</div>

---

## Sommaire

- [Présentation](#présentation)
- [Fonctionnalités principales](#fonctionnalités-principales)
- [Stack technique](#stack-technique)
- [Architecture](#architecture)
- [Structure du projet](#structure-du-projet)
- [Design System](#design-system)
- [Gestion d'état (Riverpod)](#gestion-détat-riverpod)
- [Navigation & routes](#navigation--routes)
- [Couche de données (repositories & mocks)](#couche-de-données-repositories--mocks)
- [Modèles de domaine](#modèles-de-domaine)
- [Démarrage / Installation](#démarrage--installation)
- [Scripts & commandes utiles](#scripts--commandes-utiles)
- [Tests](#tests)
- [Intégration continue (CI/CD)](#intégration-continue-cicd)
- [Génération de l'icône d'application](#génération-de-licône-dapplication)
- [Configuration & outillage agent](#configuration--outillage-agent)
- [Plateformes supportées](#plateformes-supportées)
- [Licence & statut](#licence--statut)

---

## Présentation

**BacNafa** est une application Flutter multiplateforme (Android prioritaire, iOS/Web/Desktop configurés). Elle vise à devenir le **hub intelligent** des élèves guinéens de Terminale : un point d'accès unique aux **sujets du Bac**, aux **corrigés**, aux **quiz** et à un **suivi de progression** personnalisé.

> ⚠️ **État actuel :** l'application fonctionne avec des **données simulées (mock)** en mémoire. Aucun backend n'est encore branché — la couche repository est conçue pour permettre un passage transparent de `Mock*` à une vraie API/Firebase/SQLite (voir § [Couche de données](#couche-de-données-repositories--mocks)).

La navigation, le onboarding, l'authentification simulée, le parcours `Année → Filière → Matière → Sujets`, la visualisation d'un sujet, la mise en favoris, l'historique et le quiz interactif sont fonctionnels.

## Fonctionnalités principales

L'application est découpée en **8 modules fonctionnels** (`lib/features/`) :

| Module | Rôle | État |
|--------|------|------|
| **onboarding** | Présentation au premier lancement + sélection de la classe (`Terminale`) et de la série. | ✅ |
| **auth** | Création du profil élève (prénom, nom, ville/commune, lycée) + login/logout simulés. | ✅ (mock) |
| **home** | Tableau de bord : matières en progression, dernières consultations. | ✅ |
| **subjects** | Parcours hiérarchique **Année du Bac → Filière → Matière → Sujets disponibles** avec recherche et filtre « corrigés uniquement ». | ✅ |
| **exam_viewer** | Affichage du contenu complet d'un sujet (en-tête, parties, exercices, points) + ajout aux favoris / historique. | ✅ (mock) |
| **library** | « Ma Bibliothèque » : favoris + historique récent (max 20 éléments). | ✅ (mock) |
| **quiz** | Quiz interactif à choix multiples avec score, feedback instantané, barre de progression et résultat (réussite ≥ 50 %). | ✅ (mock) |
| **profile** | Profil de l'élève, statistiques (sujets vus / favoris / quiz), progression globale, paramètres et déconnexion. | ✅ (mock) |

Parcours type d'un utilisateur :
```
Splash ──► Onboarding (1er lancement) ──► Login (création profil) ──► Accueil
                                                  │
                              Bottom navigation (4 onglets)
                              ┌──────────────┬───────────────┬────────┬────────┐
                              │  Accueil     │   Sujets      │  Quiz  │ Profil │
                              └──────────────┴──────┬────────┴────────┴────────┘
                                                   │
                              Année → Filière → Matière → Sujets → Sujet détaillé
```

## Stack technique

- **Flutter** (Material 3) — SDK Dart `^3.12.2`, channel `stable`
- **flutter_riverpod** `^3.3.2` — gestion d'état (`Notifier`, `NotifierProvider`, `FutureProvider`, `Provider`)
- **go_router** `^17.3.0` — navigation déclarative + `StatefulShellRoute.indexedStack` (bottom nav persistante)
- **flutter_svg** `^2.3.0` — affichage des icônes de matières au format SVG
- **cupertino_icons** `^1.0.8`
- *Dev :* **flutter_lints** `^6.0.0`, **flutter_launcher_icons** `^0.13.1`

### Dépendances atelier / IA (hors app)
- `.kilo/` + `kilo.json` : configuration [Kilo](https://kilo.ai) (MCP **dart** local via `dart mcp-server`, skills Dart/Flutter verrouillés dans `skills-lock.json`).
- `.mcp.json` : serveur MCP **Supabase** (http) — prêt pour un futur backend Supabase (non utilisé à ce jour).

## Architecture

Le projet suit une architecture **Feature-First** inspirée de **Clean Architecture**, détaillée dans [`ARCHITECTURE.md`](./ARCHITECTURE.md).

Principes :
- **Immuabilité** des modèles de données (classes `final`, `copyWith`).
- **Séparation des responsabilités** : UI / logique métier / accès aux données.
- **Découplage** : les repositories sont des **interfaces** (contrats) ; l'UI ne connaît que l'interface, ce qui permet de permuter la source de données (`Mock*` → API/Firebase) sans toucher l'UI.

### Flux de données unidirectionnel
```
UI (Widgets) ──► Providers Riverpod ──► Repositories (interfaces) ──► Data Sources
   ▲  observe l'état                                            (Mock / API / Local DB)
   └────── rebuild sur changement d'état
```

Pour chaque `feature` on retrouve idéalement :
- `data/` — implémentations concrètes des repositories (mocks, future API).
- `domain/` — modèles de données + interfaces (`abstract class`) des repositories.
- `presentation/` — pages, widgets, providers Riverpod propres à la feature.

> 📝 Toute la logique métier vit dans les **providers**. **Aucune logique métier dans les widgets** — ils se contentent d'appeler les méthodes du provider et d'observer l'état.

## Structure du projet

```
bac_nafa/
├── lib/
│   ├── main.dart                    # Entry point — runApp(ProviderScope(BacNafaApp))
│   ├── app/                         # Configuration globale
│   │   ├── app.dart                 # MaterialApp.router (thème + GoRouter)
│   │   ├── router.dart              # GoRouter + StatefulShellRoute (bottom nav)
│   │   ├── routes.dart              # Constantes de routes (AppRoutes)
│   │   ├── main_scaffold.dart       # Scaffold + bottom navigation
│   │   ├── splash/splash_page.dart  # Écran de démarrage + redirection
│   │   └── theme/
│   │       ├── app_colors.dart      # Palette (ColorScheme light)
│   │       ├── app_text_styles.dart # Typographies (Roboto)
│   │       └── app_theme.dart       # ThemeData Material 3 + status bar
│   ├── core/                        # Éléments transverses
│   │   ├── design/                  # Tokens du Design System
│   │   │   ├── app_spacing.dart     # AppSpacing (xs..xxxl, paddings)
│   │   │   ├── app_radius.dart      # AppRadius (rayons)
│   │   │   ├── app_dimensions.dart  # AppDimensions (hauteurs, icônes)
│   │   │   ├── app_shadows.dart     # AppShadows (none→premium)
│   │   │   ├── app_borders.dart     # AppBorders (subtle→focus/error/success)
│   │   │   └── page_transitions.dart# Transitions de pages custom
│   │   ├── models/                  # Modèles globaux
│   │   │   ├── student_profile.dart # StudentProfile
│   │   │   └── subject.dart         # CoreSubject (dashboard)
│   │   ├── providers/
│   │   │   └── mock_providers.dart  # currentUserProvider, subjectsProvider
│   │   ├── services/                # "Action coordinators" (effets croisés)
│   │   │   ├── auth_actions.dart    # authStatusProvider, logoutActionProvider
│   │   │   ├── exam_actions.dart     # favoris/historique: toggle/add/isFavorite
│   │   │   └── library_counts.dart  # favoritesCountProvider, historyCountProvider
│   │   └── widgets/                # Composants atomiques réutilisables
│   │       ├── app_bottom_navigation.dart
│   │       ├── app_card_premium.dart
│   │       ├── app_primary_button.dart
│   │       ├── app_progress_indicator.dart
│   │       ├── app_section_title.dart
│   │       ├── app_selection_card.dart
│   │       ├── app_selection_sheet.dart  # bottom sheet groupé + recherche
│   │       └── app_text_field.dart
│   └── features/                   # Modules fonctionnels (voir plus bas)
│       ├── auth/
│       ├── exam_viewer/
│       ├── home/
│       ├── library/
│       ├── onboarding/
│       ├── profile/
│       ├── quiz/
│       └── subjects/
├── assets/
│   ├── branding/app_icon.png        # Icône de l'app
│   └── subjects/                    # SVG par matière
│       ├── math.svg  physique.svg  svt.svg
│       ├── philosophie.svg  francais.svg  anglais.svg  histoire.svg
├── android/  ios/  linux/  macos/  web/  windows/   # Plates-formes
├── test/widget_test.dart            # Smoke test
├── .github/workflows/build.yml      # CI : build APK ARM64
├── pubspec.yaml                     # Dépendances + assets + launcher icons
├── analysis_options.yaml            # Lints (flutter_lints)
├── ARCHITECTURE.md                  # Document d'architecture (référence)
├── kilo.json / .mcp.json            # Config agents/MCP (Kilo, Supabase)
└── skills-lock.json                 # Skills Kilo verrouillées
```

### Détail des modules (`lib/features/`)

**`auth/`**
- `presentation/pages/login_page.dart` → `LoginPage` : création du profil élève (prénom, nom, **ville/commune de Guinée** via bottom sheet groupé par région, lycée). En-tête dégradé violet + Hero `app_icon.png`.
- `providers/auth_provider.dart` → `AuthNotifier` (`enum AuthStatus { loading, authenticated, unauthenticated }`, méthodes `loginMock`/`registerMock`/`logout`).

**`onboarding/`**
- `models/onboarding_data.dart` → `OnboardingData` (classe, série, objectifs).
- `presentation/pages/onboarding_page.dart` → `OnboardingPage` : 3 écrans (intro « Prépare ton Bac », choix du niveau `Terminale`, choix de la série) sur fond dégradé animé.
- `presentation/widgets/` → `IllustrationCircle`, `OnboardingIndicator` (points de progression).
- `providers/onboarding_provider.dart` → `onboardingProvider` + `isFirstLaunchProvider` (_retenu pour la redirection du splash_).

**`home/`**
- `presentation/pages/home_page.dart` → `HomePage` : `CustomScrollView` + `SliverAppBar` « BacNafa », avatar profil, section **Matières** (cartes horizontales avec barre de progression), section **Reprendre** (dernières consultations).

**`subjects/`** — Parcours hiérarchique
- Domain : `BacYear`, `Subject`, `ExamPaper`, `BacSeries` (+ `copyWith`).
- Interfaces : `SubjectRepository`, `ExamRepository`, `BacYearRepository`, `SeriesRepository`.
- Mocks : `MockSubjectRepository` (7 matières), `MockSeriesRepository` (4 filières), `MockBacYearRepository` (2023→2026), `MockExamRepository` (2 sujets, filtrage par `subjectId`/`seriesId`/`yearId`).
- Pages : `YearsPageAsYears` → `SeriesPageAsSeries` → `SubjectsPageAsSubjects` → `ExamPapersPage` (recherche + filtre corrigés).
- Providers : `subjectsListProvider`, `seriesListProvider`, `yearsListProvider`, `examPapersProvider`, `filteredExamsProvider` + notifiers de sélection.
- Widget : `InfoBadge`.

**`exam_viewer/`**
- `models/exam_content.dart` → `ExamContent` / `ExamSection` / `ExamExercise`.
- `data/mock_exam_content_repository.dart` → interface `ExamContentRepository` + `MockExamContentRepository`.
- `presentation/pages/exam_viewer_page.dart` → `ExamViewerPage` : affiche le sujet, � étoile de favori, ajout automatique à l'historique.
- `presentation/widgets/exam_widgets.dart` → `ExamHeaderCard`, `ExamSectionCard`, `ExerciseCard`.
- `providers/exam_providers.dart` → `examContentProvider` (FutureProvider.family).

**`library/`**
- `domain/models/library_models.dart` → `FavoriteItem`, `HistoryItem`, `enum FavoriteType`.
- `domain/repositories/library_repositories.dart` → interfaces `FavoriteRepository`, `RecentExamRepository`, `LocalStorageRepository` (placeholder SQLite/Hive).
- `data/mock_library_repositories.dart` → implémentations en mémoire (`MockRecentExamRepository` : historique max 20, réordonnancement au sommet).
- `presentation/pages/library_page.dart` → `LibraryPage` : favoris + historique, état vide.
- `providers/library_providers.dart` → `favoritesProvider`, `historyProvider`.

**`quiz/`**
- `domain/models/quiz_models.dart` → `Quiz`, `Question`, `Option`.
- `data/mock_quiz_repository.dart` → `MockQuizRepository` (1 quiz « Math Quiz »).
- `presentation/pages/quiz_page.dart` → `QuizPage` : player avec options lettrées (A/B/C), feedback vert/rouge, auto-avancement, résultat en bottom sheet (réussite ≥ 50 %).
- `providers/quiz_providers.dart` → `quizzesProvider`, `quizzesCountProvider`, `quizByIdProvider`.

**`profile/`**
- `presentation/pages/profile_screen.dart` → `ProfileScreen` : en-tête (avatar + badge série/année), stats (sujets vus / favoris / quiz), carte de progression animée, carte d'informations, bottom sheet de paramètres (Notifications, Sécurité, Aide, Déconnexion).

## Design System

L'application suit un **Design System strict** (fichier `lib/app/theme/` + `lib/core/design/`) pour garantir une cohérence visuelle « Premium ».

- **Tokens interdits de valeurs magiques** : toutes les couleurs, tailles, espacements et rayons proviennent des tokens.
- **Couleurs** (`AppColors`) : palette indigo/violet (`primary #4338CA`, `tertiary #7C3AED`), secondaire bleu, sémantiques (success/warning/error), surfaces Material 3, texte sur 4 niveaux. `lightColorScheme` exposé.
- **Typographies** (`AppTextStyles`) : Roboto, échelles `display/headline/title/body/label` + `buttonText`/`caption`.
- **Espacements** (`AppSpacing`) : `xs(4) sm(8) md(16) lg(24) xl(32) xxl(48) xxxl(64)` + paddings prêts (`screenPadding`, `cardPadding`…) + `spacerXs…spacerLg`.
- **Rayons** (`AppRadius`) : `small(8) medium(12) large(20) card(24) button(16) dialog(28) circular(999)`.
- **Dimensions** (`AppDimensions`) : hauteur bouton/champ 56, tailles d'icônes/avatars, épaisseurs de trait.
- **Ombres** (`AppShadows`) : `subtle → soft → medium → elevated → premium`.
- **Bordures** (`AppBorders`) : `subtle / medium / strong / focus / error / success`.
- **Transitions** (`AppPageTransitions`) : `fade`, `fadeThrough`, `slideUp`, `slideFromRight`, `scaleFade` (380 ms, `easeOutCubic`).
- **Thème** (`AppTheme.lightTheme`) : `ThemeData` Material 3 complet (AppBar, boutons, cartes, chips, NavigationBar, dialog, bottomSheet, snackBar, tabBar… ) + `lightStatusBar`.

## Gestion d'état (Riverpod)

- State management **exclusivement Riverpod** (pas de `setState` sauf UI locale).
- Providers globaux et `final`.
- `Notifier`/`NotifierProvider` pour la logique d'état complexe ; `FutureProvider.autoDispose` pour les chargements ; `Provider` pour les valeurs dérivées et l'injection de dépendances (repositories).
- **Sélecteurs** (`ref.watch(...select:)`) utilisés pour des compteurs performants (`favoritesCountProvider`, `historyCountProvider`).
- **Action coordinators** (`core/services/`) : encapsulent les effets croisant plusieurs features (ex. `toggleFavoriteActionProvider` qui agit sur `favoritesProvider`).

## Navigation & routes

Gérée par **GoRouter** (`lib/app/router.dart`). Routes centralisées, accès via `AppRoutes` (`lib/app/routes.dart`).

| Route | Destination |
|-------|-------------|
| `/splash` | `SplashPage` — animation + redirection (onboarding / login / home) après 2 s |
| `/onboarding` | `OnboardingPage` |
| `/login` | `LoginPage` (création de profil) |
| `/register` | `LoginPage` (transition slideUp) |
| **StatefulShellRoute** (bottom nav 4 onglets) | |
| ├ `/home` | `HomePage` (Accueil) |
| ├ `/subjects` | `YearsPageAsYears` (Sujets) |
| ├  `/subjects/:yearId/series` | `SeriesPageAsSeries` |
| ├  `/subjects/:yearId/series/:seriesId/subjects` | `SubjectsPageAsSubjects` |
| ├  `/exams` | `ExamPapersPage` |
| ├  `/exam/:id` | `ExamViewerPage` |
| ├  `/library` | `LibraryPage` |
| ├ `/quiz/:id` | `QuizPage` (onglet Quiz, via `_QuizPageWrapper`) |
| └ `/profile` | `ProfileScreen` (Profil) |

`MainScaffold` expose la `StatefulNavigationShell` et la `AppBottomNavigation` (Accueil / Sujets / Quiz / Profil).

## Couche de données (repositories & mocks)

Chaque repository est une **interface** (`abstract class`) implémentée par un **mock** en mémoire avec latence simulée (`Future.delayed` 100–500 ms).

| Feature | Interface(s) | Mock(s) | Méthodes clés |
|---------|--------------|---------|----------------|
| subjects | `SubjectRepository`, `ExamRepository`, `BacYearRepository`, `SeriesRepository` | `MockSubjectRepository`, `MockExamRepository`, `MockBacYearRepository`, `MockSeriesRepository` | `getSubjects()`, `getExams({subjectId, seriesId, yearId})`, `getYears()`, `getSeries()` |
| exam_viewer | `ExamContentRepository` | `MockExamContentRepository` | `getExamById(id)` |
| library | `FavoriteRepository`, `RecentExamRepository`, `LocalStorageRepository` | `MockFavoriteRepository`, `MockRecentExamRepository`, `MockLocalStorageRepository` | `addFavorite`, `removeFavorite`, `isFavorite`, `addToHistory`, `getHistory` |
| quiz | (classe concrète) | `MockQuizRepository` | `getQuizzes()` |
| auth | (via provider) | `AuthNotifier` (mock) | `loginMock`, `registerMock`, `logout` |

> 🔮 `LocalStorageRepository` / `MockLocalStorageRepository` est **déclaré mais inutilisé** — emplacement prévu pour la persistance future (SQLite/Hive).

### Données du domaine (révélées par les mocks)

- **Villes de Guinée** (login) : communes de Conakry + 8 régions administratives (Kindia, Boké, Mamou, Labé, Faranah, Kankan, N'Zérékoré).
- **Filières (4)** : Sciences Mathématiques (SM), Sciences Expérimentales (SE), Lettres & Arts, Sciences Sociales.
- **Matières (7)** : Mathématiques, Physique-Chimie, SVT, Philosophie, Français, Anglais, Histoire-Géographie — réparties en Sciences / Lettres / Sciences Humaines.
- **Années du Bac** : 2023, 2024, 2025, 2026.
- **Sessions** : Normale, Rattrapage ; durées « 4h / 3h » ; coefficient numérique ; indicateur `hasCorrection`.

## Modèles de domaine

| Modèle | Champs |
|--------|--------|
| `StudentProfile` | `id`, `name`, `bacSeries`, `bacYear` (int), `progress` (double) |
| `CoreSubject` | `id`, `name`, `description`, `icon`, `progress`, `color` |
| `BacYear` | `id`, `year` (int) |
| `Subject` | `id`, `name`, `description`, `icon`, `category`, `svgAsset`, `accentColor` |
| `ExamPaper` | `id`, `title`, `subjectId`, `seriesId`, `yearId`, `session`, `duration`, `coefficient`, `hasCorrection` |
| `BacSeries` | `id`, `name`, `description`, `icon`, `accentColor` |
| `ExamContent` | `id`, `title`, `subjectName`, `series`, `year`, `session`, `duration`, `coefficient`, `sections` |
| `ExamSection` | `id`, `title`, `content`, `order`, `exercises` |
| `ExamExercise` | `id`, `number`, `statement`, `points`, `attachments` |
| `Quiz` / `Question` / `Option` | `Quiz{id,title,description,questions}` · `Question{id,text,options}` · `Option{id,text,isCorrect}` |
| `FavoriteItem` / `HistoryItem` | `FavoriteItem{id,type,itemId,title,createdAt}` · `HistoryItem{itemId,title,subjectName,year,accessedAt}` |
| `OnboardingData` | `selectedClass`, `selectedSeries`, `selectedGoals` |

> ℹ️ Deux modèles `Subject` coexistent : `CoreSubject` (tableau de bord, avec `progress`) et `Subject` (entité domaine `subjects`, avec `svgAsset`/`accentColor`).

## Démarrage / Installation

### Prérequis
- **Flutter SDK** channel `stable` (Dart `^3.12.2`)
- Pour Android : JDK 17 + Android SDK (compile/target via Flutter, **minSdk forcé à 21** en CI)
- Pour iOS : Xcode (deployment target **13.0**)

### Installation
```bash
flutter pub get
flutter pub run flutter_launcher_icons   # génère l'icône (optionnel, déjà committée)
```

### Lancer l'application
```bash
flutter run -d <device>
flutter run -d chrome       # web
flutter run -d <emulator>   # Android / iOS
flutter run -d windows      # desktop
```

### Identifiants de build
- Android : `applicationId = com.bacnafa.app`
- iOS : `PRODUCT_BUNDLE_IDENTIFIER = com.example.bacNafa` (à personnaliser)

## Scripts & commandes utiles

```bash
flutter analyze               # analyse statique (lints flutter_lints)
flutter test                  # exécute les tests (test/widget_test.dart)
flutter build apk --release --target-platform android-arm64
flutter build ios --release  # nécessite macOS + Xcode
flutter build web --release
flutter pub upgrade           # montée de version des dépendances
```

## Tests

Actuellement un seul **smoke test** (`test/widget_test.dart`) : il monte `BacNafaApp` dans un `ProviderScope` et vérifie la présence du texte « BacNafa ».

```bash
flutter test
```

## Intégration continue (CI/CD)

Workflow GitHub Actions : [`.github/workflows/build.yml`](./.github/workflows/build.yml) — **« Build BacNafa APK »**.

Déclenchement : `push` sur `master`/`main` ou `workflow_dispatch`.

Étapes :
1. Checkout (submodules récursifs)
2. Setup Java 17 (Zulu) + Flutter `stable` (cache)
3. Installation Android SDK (platform 34, build-tools 34, CMake, NDK)
4. Configuration Android : `minSdk = 21`, flags Gradle, **génération locale d'un keystore de debug** (aucun secret GitHub requis)
5. Cache Gradle
6. `flutter pub get` → `flutter analyze` → `flutter test`
7. `flutter build apk --release --target-platform android-arm64`
8. Signature + alignement avec `zipalign`/`apksigner` (keystore debug local) → `BacNafa-v${run_number}.apk`
9. Upload de l'artefact **`BacNafa-ARM64`**

> 💡 Le workflow ne dépend d'**aucun secret** : le keystore de débug est généré à la volée.

## Génération de l'icône d'application

Configurée via `flutter_launcher_icons` dans `pubspec.yaml` :
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/branding/app_icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/branding/app_icon.png"
```
Régénération :
```bash
dart run flutter_launcher_icons
```

## Configuration & outillage agent

- `kilo.json` — déclare le MCP **dart** local (`dart mcp-server`) pour l'outillage Dart/Flutter (analyse, hot reload, LSP…).
- `.mcp.json` — déclare le serveur MCP **Supabase** (`https://mcp.supabase.com/mcp`) en prévision d'un backend.
- `skills-lock.json` — verrouille les **skills Kilo** (Dart & Flutter : tests, CLI, FFI, architectures, responsive, etc. ; Supabase / Postgres).
- `.agents/skills/` — cache local des skills.

## Plateformes supportées

Dossiers de plate-forme présents : **android, ios, linux, macos, web, windows**.

Cible de production courante : **Android (ARM64)** via la CI. iOS configuré mais non construit en CI.

## Licence & statut

- `publish_to: 'none'` — projet privé, non publié sur pub.dev.
- Version app : `1.0.0+1` (`pubspec.yaml`).
- Code source : voir l'historique Git.

---

<div align="center">

_Documentation générée à partir de l'état courant du dépôt._
Pour l'architecture détaillée, voir [`ARCHITECTURE.md`](./ARCHITECTURE.md).

</div>
