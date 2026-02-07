## General Description

The application will have the following screens:

1. **Authentication Screen**: FaceID/TouchID to unlock the app
2. **Diary Entry List**: List of all entries with an "Add" button
3. **Entry Editor**: Create/edit entries with title, message, location, and photo
4. **Location Search**: Search for addresses and select location
5. **Entry Detail**: View saved entry with directions button

---

## 2.1 Initial Setup (5 points)

### Requirements
- [ ] Configure the project to use **programmatic UIKit**
- [ ] Configure `SceneDelegate` to start the app programmatically
- [ ] Add required permissions in `Info.plist`:
  - Location usage description
  - Camera usage description
  - Photo library usage description
  - FaceID usage description
- [ ] Add Lottie dependency using Swift Package Manager

---

## 2.2 Data Models (15 points)

### Requirements
- [ ] Create the `DiaryEntry` model
- [ ] All models must conform to `Codable`
- [ ] Create a `DiaryDataService` to handle:
  - Loading entries from file
  - Saving entries to file
  - File must be saved in Documents directory (NOT UserDefaults)

---

## 2.3 Authentication Screen (15 points)

### Requirements
- [ ] Create `AuthenticationViewController` programmatically
- [ ] Create `AuthenticationViewModel` to handle FaceID/TouchID logic
- [ ] Display:
  - App logo or welcome message
  - "Authenticate" button
- [ ] After successful authentication, dismiss and show the entry list
- [ ] The app must "lock" when it receives `willResignActiveNotification`
- [ ] When the app becomes active again after being locked, show authentication

---

## 2.4 Diary Entry List (20 points)

### Requirements
- [ ] Create `DiaryListTableViewController`
- [ ] Create `DiaryListViewModel`
- [ ] Each cell must show:
  - Entry title
  - Entry date
  - **Draft indicator** if it's a draft (use different color, badge, or icon)
- [ ] Add a "+" button in the navigation bar to create new entries
- [ ] When selecting an entry:
  - If draft: open editor to continue editing
  - If not draft: open detail view
- [ ] Entries should be sorted by date (newest first)

---

## 2.5 Entry Editor (25 points)

### Requirements
- [ ] Create `EntryEditorViewController` programmatically
- [ ] Create `EntryEditorViewModel`
- [ ] The editor must have:
  - `UITextField` for title
  - `UITextView` for message
  - Button to add photo (with action sheet: Camera or Gallery)
  - Button to add/change location
  - Preview of selected photo (if any)
  - Preview of selected location (if any)
  - "Save" button
- [ ] **Draft functionality**:
  - Listen to `UIApplication.willResignActiveNotification`
  - When received: save current entry as draft
  - Pop back to the list (the list should show FaceID when app becomes active)
- [ ] Photos must be saved as separate files in Documents directory

### Hints
- To save an image to Documents:
  ```swift
  guard let data = image.jpegData(compressionQuality: 0.8),
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  else { return nil }
  
  let imageName = UUID().uuidString
  let imageURL = documentsURL.appendingPathComponent("\(imageName).jpg")
  try? data.write(to: imageURL)
  ```

---

## 2.6 Location Search (20 points)

### Requirements
- [ ] Create `LocationSearchViewController` programmatically
- [ ] Create `LocationSearchViewModel`
- [ ] The screen must have:
  - `UISearchBar` for typing addresses
  - `UITableView` to display search results
  - Cancel button
- [ ] As the user types, show address suggestions
- [ ] When selecting a result, get coordinates and pass back to editor screen
- [ ] Use delegate pattern to communicate with the editor screen

### Hints
- Use `MKLocalSearchCompleter` for address autocomplete
- Use `MKLocalSearch.Request(completion:)` to get coordinates from a selected result

---

## 2.7 Entry Detail View (20 points)

### Requirements
- [ ] Create `EntryDetailViewController` programmatically
- [ ] Create `EntryDetailViewModel`
- [ ] Display:
  - Entry title
  - Entry message
  - Entry date
  - Photo (if available)
  - Location address (if available)
  - **"Get Directions" button** (only if location exists)
  - **`UISegmentedControl`** to choose between walking or driving directions
  - **Lottie animation** (decorative, your choice)
- [ ] "Get Directions" button should show route from user's current location to entry location
- [ ] The route type must change based on the segmented control selection (walking vs driving)
- [ ] The route should be displayed on a map (can be embedded or presented modally)

---

## 2.8 Photo Capture with Action Sheet (10 points)

### Requirements
- [ ] When tapping the photo button, show an action sheet with options:
  - "Take Photo" (only on device)
  - "Choose from Gallery"
  - "Cancel"
- [ ] Handle camera on device using `UIImagePickerController`
- [ ] Handle gallery using `PHPickerViewController`
- [ ] Update the preview in the editor when a photo is selected

---

## Suggested Project Structure

```
MiPrimerDiario/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Models/
│   ├── DiaryEntry.swift YA
│   └── Location.swift YA
├── Services/
│   └── DiaryDataService.swift YA
├── Authentication/
│   ├── AuthenticationViewController.swift YA
│   └── AuthenticationViewModel.swift YA
├── DiaryList/
│   ├── DiaryListTableViewController.swift YA
│   └── DiaryListViewModel.swift YA
├── EntryEditor/
│   ├── EntryEditorViewController.swift YA
│   └── EntryEditorViewModel.swift YA
├── LocationSearch/
│   ├── LocationSearchViewController.swift YA
│   └── LocationSearchViewModel.swift YA
├── EntryDetail/
│   ├── EntryDetailViewController.swift YA
│   └── EntryDetailViewModel.swift YA
├── Resources/
│   └── (Lottie animation files)
└── Info.plist
```
