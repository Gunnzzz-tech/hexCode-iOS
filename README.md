# 🎨 Hex Color Generator App

This is a Swift-based iOS application that allows users to generate and store hex color codes. The app supports both **online and offline** storage modes, and users can **scroll through a stack of generated color cards**. 

---

## 🚀 Features

- 🎲 Generate random hex color codes
- 🔤 Input your own hex codes manually (with format validation)
- ☁️ Store hex codes online using **Firebase Storage**
- 📦 Offline storage using **UserDefaults** (or local persistence)
- 📜 Scrollable list of color cards
- 🧹 Clean, minimal UI using **UIKit**

---

## 📦 Tech Stack

| Technology | Purpose |
|------------|---------|
| `Swift` | Core language for iOS development |
| `UIKit` | UI building framework |
| `Firebase Storage` | To store hex color codes online |
| `UserDefaults` / Local storage | For offline mode |
| `UITextField`, `UIButton`, `UIStackView`, `UIScrollView` | UI Components |

---

## 🧪 Functionality Overview

### ✅ Color Code Generator
- Taps a button to generate a valid random hex code.
- Each generated hex code is shown as a **card** with corresponding background color.

### ✍️ Manual Input
- Enter a custom hex code using a text field.
- Validates the format (`#RRGGBB`).
- If valid → adds to the list.
- If invalid → displays error message.

### ☁️ Online Sync
- All valid hex codes are uploaded to **Firebase Storage** for persistence.
- Firebase SDK integration is used for uploading/downloading the stored hex list.

### 📴 Offline Mode
- App uses local storage to save hex codes for offline use.
- Users can still view previously added colors without an internet connection.

---

## 📸 UI Overview

- **Scrollable stack view** containing color cards.
- Each card shows the hex code text.
- Color height is fixed (e.g., 40 pts), maintaining uniform design.
<img width="343" height="734" alt="Screenshot 2025-08-02 at 2 22 26 PM" src="https://github.com/user-attachments/assets/bf68269f-5a79-468d-b9d8-fe6e474d9f26" />
<img width="337" height="732" alt="Screenshot 2025-08-02 at 2 21 10 PM" src="https://github.com/user-attachments/assets/e3e19198-7884-4ad9-a84e-677d870bce68" />

---

## 🛠️ Installation & Setup

1. Clone the repo
