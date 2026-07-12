# Architecture BacNafa

## Vue générale

**BacNafa** est une application EdTech conçue pour accompagner les élèves dans la préparation du Baccalauréat. L'objectif est de fournir un accès simplifié aux ressources pédagogiques, aux examens passés et un assistant IA pour un apprentissage personnalisé.

### Architecture Flutter
Le projet utilise l'architecture **Feature-First**, qui organise le code par fonctionnalités plutôt que par couches techniques globales. Cela permet une meilleure scalabilité et facilite la maintenance.

### Principes techniques
- **Immuabilité**: Utilisation de classes immuables pour les modèles de données.
- **Séparation des responsabilités**: Distinction nette entre l'UI, la logique métier et l'accès aux données.
- **Découplage**: Utilisation d'interfaces (contrats) pour les repositories afin de pouvoir changer la source de données (Mock $\rightarrow$ API) sans impacter l'UI.

---

## Organisation des dossiers

`lib/`
- `app/`: Configuration globale (Router, Thème, Main Scaffold).
- `core/`: Éléments transverses (Design System, Widgets génériques, Modèles globaux, Utilitaires).
- `features/`: Modules fonctionnels. Chaque feature suit la structure suivante :
    - `data/`: Implémentations concrètes des repositories et sources de données (API, Local DB).
    - `domain/`: Modèles de données et définitions d'interfaces (contrats) des repositories.
    - `presentation/`: UI (Pages, Widgets) et gestion d'état (Providers).
- `shared/`: Widgets et utilitaires partagés entre plusieurs features.

---

## Gestion d'état

L'application utilise **Riverpod** pour la gestion d'état.

### Règles pour les providers
- Les providers doivent être déclarés comme `final` et être globaux.
- Utiliser `NotifierProvider` ou `AsyncNotifierProvider` pour la logique complexe.
- **Interdiction stricte**: Aucune logique métier ne doit être écrite directement dans les widgets. Les widgets appellent des méthodes du provider.

---

## Navigation

La navigation est gérée par **GoRouter**.
- Les routes sont centralisées dans `lib/app/router.dart`.
- Utilisation de `ShellRoute` pour les interfaces avec navigation persistante (Bottom Navigation).

---

## Design System

L'application suit un Design System strict pour garantir une cohérence visuelle "Premium".
- **Tokens**: Utilisation obligatoire de `AppSpacing`, `AppRadius`, `AppShadows`, et `AppDimensions`.
- **Interdiction**: Aucune valeur "magique" (hardcoded) pour les couleurs, tailles ou espacements.
- **Composants**: Créer des widgets atomiques dans `core/widgets/` avant de les assembler dans les pages.

---

## Data Layer

L'accès aux données suit un flux unidirectionnel :

**UI** $\rightarrow$ **Providers Riverpod** $\rightarrow$ **Repositories (Interfaces)** $\rightarrow$ **Data Sources**

1. **UI**: Observe l'état et déclenche des actions.
2. **Providers**: Gèrent l'état de la vue et appellent le repository.
3. **Repositories**: Agissent comme médiateurs. L'UI ne connaît que l'interface du repository.
4. **Data Sources**: Gèrent la récupération brute des données (API REST, Firebase, JSON local).

---

## Règles de développement

1. **Analyse**: Toujours exécuter `flutter analyze` et utiliser les outils LSP avant toute modification.
2. **Réutilisation**: Rechercher un composant existant avant d'en créer un nouveau.
3. **Mobile First**: Concevoir pour Android (5.5" - 7"), utiliser `SafeArea`, éviter les hauteurs fixes.
4. **Validation**: Passage obligatoire par le cycle de validation Flutter MCP (`analyze_files` $\rightarrow$ `get_runtime_errors` $\rightarrow$ `hot_reload`).
