# MyTimer

It's a timer app created by adding various visual elements.   
The goal of this project is to launch on the App Store.   
It was written by code only. 
The code style applied https://github.com/airbnb/swift.

<br>

# Key Features


 - 🕒 Playback Timers

 - 📝 Section and Timer Management

  - 🔊 Custom Alert Sounds
- 📬 Background Push Notifications

<br>

# Update log

### 2022.07.11 v1.1
- UI Enhancements
- Added Section Modifications
- Fixed Timer Deletion Bug
- Fixed Section Deletion Bug

### 2022.06.27 v1.0
- Released!

<br>

# Language

- Swift

<br>

# Architecture

- MVVM   
  <details>
  <summary>Models</summary>
  <div markdown="6">

  ```Swift
    // Timer
    struct MyTimer: Codable, Equatable {
    var id: Int
    var title: String
    var min: Int
    var sec: Int
    }
    
    // Section
    struct Section: Codable, Equatable {
    var id: Int
    var title: String
    var timers = [MyTimer]()
    }
  ```

  </div>
  </details>

<br>

# Skills

- UIBezierPath()
  > Visually show the progress of the timer.   
  > The circular progress bar changes over time using `CABasicAnimation()`

- UIView.animate()
  > To show UI animation used it.   
  > When a button is tapped, the button is rotated or displayed one after another.

- UserDefaults
  > Store data inside the client.   

- UNUserNotificationCenter
  > It is used for push notifications when the app is progressing in the background and the timer is done.    
  > Request permission from the device.

- UISwipeActionsConfiguration
  > Swipe cells in TableView.   
  > Two UIContextualActions were used to set and delete timers.

<br>

# Library

- AVFoundation
  > Used for sound the alarm.   
  > There are a total of 12 alarm sounds.   
  > The set alarm sound is stored through UserDefaults.

- ExpyTableView
  > Used for implement foldable TableView easily.

- DropDown
  > Used for show a selection list of sections.

- SnapKit

<br>

# App Store

- https://apps.apple.com/kr/app/%EB%A7%88%EC%9D%B4%ED%83%80%EC%9D%B4%EB%A8%B8/id1631776048
















