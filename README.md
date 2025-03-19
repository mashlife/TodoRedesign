# Todo App Redesign

A modern Flutter todo application with a rich feature set, built using Material Design 3 and Provider state management.


## About ME
I am Mushfiq, a mid level Mobile Application & Server Side developer. I have worked on many freelance project and still working on some. But day by day, I feel like I am not learning anything new. That's why I am looking for someone who can provide food to my learning hunger. Thanks for your time. 



## Features

- Material Design 3 UI with smooth animations and transitions
- Create, view, and manage todos with rich details
- Bulk selection mode for managing multiple todos
- Import todos from CSV and JSON files
- Persistent storage using SharedPreferences
- Cross-platform support (iOS, Android, Web, Desktop)

## Todo Data Structure

Each todo contains:
- `id`: Unique identifier (String)
- `title`: Task title (String)
- `description`: Task description (String)
- `note`: Additional notes with rich text support (String)
- `createdAt`: Timestamp of creation (String, milliseconds since epoch)
- `status`: Current state (TodoStatus enum: ready, pending, completed)

## Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Git

### Setup Instructions

1. Clone the repository:
```bash
git clone [repository-url]
cd todo_redesign
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage

### Basic Operations

1. **View Todos**: Launch the app to see your list of todos
2. **Create Todo**: Tap the blue floating action button ('+' icon)
3. **View Todo Details**: Tap on any todo to view its full details
4. **Delete Todo**: Long press a todo to show the menu popup, then select delete
5. **Bulk Operations**:
   - Long press to enter selection mode
   - Select multiple todos
   - Use the top bar actions for bulk delete
   - Use select all/deselect all options

### Importing Todos

The app supports importing todos from both CSV and JSON files:

1. Tap the import icon in the app bar
2. Choose between CSV or JSON import
3. Select your file using the system file picker

#### JSON Format
```json
{
  "id": "unique_id",
  "title": "Todo Title",
  "description": "Todo Description",
  "note": "Additional Notes",
  "createdAt": "1679222400000",
  "status": "ready"
}
```

#### CSV Format
The CSV file should have columns in the following order:
```
id,title,description,note(base64 encoded),createdAt,status
```

## Technical Details

The app uses:
- Provider for state management
- SharedPreferences for data persistence
- FilePicker for file imports
- intl package for date formatting
- Hero animations for smooth transitions
- Material 3 design system

## Project Structure

```
lib/
├── main.dart           # App entry point
└── src/
    ├── data/          # Data management
    ├── models/        # Data models
    ├── utils/         # Utility functions
    ├── views/         # UI screens
    └── widgets/       # Reusable widgets
```

## Platform Support

- iOS
- Android
- Web
- macOS
- Windows
- Linux

## License

This project is licensed under the MIT License - see the LICENSE file for details.
