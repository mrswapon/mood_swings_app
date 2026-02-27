# Mood Swings App

A comprehensive Flutter-based mood tracking application that helps users track their daily emotions, identify patterns, and build better self-awareness through a clean, responsive, and user-friendly interface.

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **Provider** - State management
- **SharedPreferences** - Local data persistence
- **fl_chart** - Interactive charts and visualizations
- **table_calendar** - Calendar widget with custom day builders
- **Google Fonts** - Poppins & Nunito typography
- **Material 3** - Modern design system with light & dark themes

## Features

### Mood Logging
- Log your mood with a single tap using an **animated emoji picker** with 5 mood levels:
  - Very Sad, Sad, Neutral, Happy, Very Happy
- Each mood has a **distinct color** and **emoji** for instant visual recognition
- Add an **optional text note** (up to 500 characters) to describe what made you feel that way
- Tag entries with **activities** from 15 built-in options: Work, Exercise, Family, Friends, Reading, Music, Gaming, Cooking, Travel, Shopping, Meditation, Study, Nature, Movies, Sleep
- Supports both **creating new entries** and **editing existing entries**

### Home Screen
- **Time-aware greeting** that changes based on the time of day (Good Morning / Good Afternoon / Good Evening)
- **Today's mood banner** - displays your current mood for the day with a gradient background in the mood's color
- **Quick log prompt** - if no mood is logged for today, a tap-to-log card is shown
- **Recent entries list** - shows the last 7 mood entries with full details
- **Edit and delete** any entry directly from the home screen with a confirmation dialog

### Calendar View
- **Monthly calendar** with color-coded days based on the mood logged that day
- **Today indicator** with a highlighted border ring
- Tap any day to see **all entries for that date** in a scrollable list below the calendar
- Navigate between months with swipe gestures
- **Entry count** displayed for the selected day
- Edit or delete entries directly from the calendar detail view

### Statistics & Insights
- **Period selector** to filter data by Week (7 days), Month (30 days), or All Time (365 days)
- **Mood trend line chart** - smooth curved line showing daily mood averages over the selected period, with:
  - Mood emoji labels on the Y-axis (1-5 scale)
  - Date labels on the X-axis
  - Color-coded dots at each data point matching the mood color
  - Gradient fill below the line
  - Touch tooltips showing mood and date details
- **Summary cards** displaying:
  - **Current streak** - consecutive days with at least one logged entry
  - **Most common mood** - the mood logged most frequently (with emoji)
  - **Total entries** - lifetime count of all mood logs
- **Mood distribution pie chart** - interactive pie chart showing the percentage breakdown of each mood type, with:
  - Touch-to-expand interaction on sections
  - Color-coded legend with emoji and count
  - Percentage labels on each section

### Settings
- **Dark mode toggle** - switch between light and dark themes, preference is persisted across sessions
- **Clear all data** - permanently delete all mood entries with a confirmation dialog
- **About dialog** - app version and description

### Data Persistence
- All mood entries are **saved locally** using SharedPreferences
- Data persists across app restarts
- Entries are stored as JSON-encoded strings
- Theme preference (dark/light) is also persisted

### UI & Design
- **Calming lavender/purple** primary color palette with pastel mood colors
- **Material 3** design system with rounded cards (16px radius)
- **Google Fonts** - Poppins for headings, Nunito for body text
- **Responsive layout** that adapts to different screen sizes
- **Animated interactions** - mood selector scales up on selection with spring animation
- **Empty states** with helpful prompts when no data exists
- **Bottom navigation bar** with 4 tabs: Home, Calendar, Stats, Settings
- **Floating action button** for quick mood logging from any screen
- Full **light and dark theme** support with smooth transitions

## Project Structure

```
lib/
  main.dart                          # App entry point, provider bootstrap
  app.dart                           # MaterialApp with theme wiring
  constants/
    app_constants.dart               # App name, storage keys, default activities
    mood_constants.dart              # MoodType enum with emoji, color, label extensions
  theme/
    app_colors.dart                  # Color palette (primary, surface, mood colors)
    app_text_styles.dart             # Typography (Poppins headings, Nunito body)
    app_theme.dart                   # Light + dark ThemeData definitions
  models/
    mood_entry.dart                  # MoodEntry data class with JSON serialization
  services/
    storage_service.dart             # Abstract storage interface
    local_storage_service.dart       # SharedPreferences implementation
  providers/
    mood_provider.dart               # Mood CRUD, stats, streaks, chart data
    theme_provider.dart              # Dark/light mode toggle with persistence
  screens/
    shell_screen.dart                # Bottom navigation + IndexedStack + FAB
    home/
      home_screen.dart               # Greeting, today's mood, recent entries
    entry/
      mood_entry_screen.dart         # Mood logging form (add + edit modes)
    calendar/
      calendar_screen.dart           # Monthly calendar + day detail list
    stats/
      stats_screen.dart              # Charts, summary cards, distribution
    settings/
      settings_screen.dart           # Theme toggle, clear data, about
  widgets/
    mood_selector.dart               # Animated horizontal emoji picker
    mood_card.dart                   # Entry display card with actions menu
    mood_chart.dart                  # fl_chart line chart for mood trends
    mood_pie_chart.dart              # fl_chart pie chart for mood distribution
    calendar_widget.dart             # table_calendar with mood-colored days
    activity_chip.dart               # Selectable FilterChip for activity tags
    stat_summary_card.dart           # Single-stat display card
    empty_state.dart                 # Placeholder for empty data screens
  utils/
    date_utils.dart                  # Date formatting, comparison, greeting
    id_generator.dart                # UUID v4 generator
```

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or later
- Dart SDK 3.9.2 or later

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/mood_swings_app.git
   cd mood_swings_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Build

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

## Architecture

The app follows a **clean layered architecture**:

- **Models** - Pure data classes with JSON serialization
- **Services** - Abstract storage interface with a SharedPreferences implementation (swappable to sqflite or any backend)
- **Providers** - ChangeNotifier-based state management for mood entries and theme
- **Widgets** - Reusable, composable UI components
- **Screens** - Feature screens that consume providers and compose widgets

State flows top-down from `MultiProvider` in `main.dart`, with data pre-loaded before `runApp` to avoid loading spinners on startup.

## Dependencies

| Package | Purpose |
|---------|---------|
| provider | State management (ChangeNotifier) |
| shared_preferences | Local key-value storage |
| fl_chart | Line and pie chart visualizations |
| table_calendar | Monthly calendar with custom day builders |
| google_fonts | Poppins and Nunito typography |
| intl | Date and time formatting |
| uuid | Unique ID generation for entries |
| cupertino_icons | iOS-style icons |

## License

This project is open source and available under the [MIT License](LICENSE).
