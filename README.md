# MyTimer

It's a timer app created by adding various visual elements.    
It was written by code only.   
The code style applied https://github.com/airbnb/swift.

# Preview

![Preview](https://user-images.githubusercontent.com/75382687/178198393-682c5195-dc91-44fc-8bd5-59e89c83e510.gif)


<br>

# Features

<details>
  <summary> Timer playback </summary>
  <div markdown="0">

 | Timer playback |
 | --- |
 | ![TimerPlayback](https://user-images.githubusercontent.com/75382687/178198437-c8f53404-085e-48e4-a90b-db4b44575f12.gif) |

  </div>
</details>

<details>
  <summary> Button animation </summary>
  <div markdown="1">

 | Button animation |
 | --- |
 | ![ButtonAnimation](https://user-images.githubusercontent.com/75382687/178198483-f1b46354-bf28-4a81-992e-ae79b821dbc3.gif) |

  </div>
</details>

<details>
  <summary> Add section </summary>
  <div markdown="2">

 | Add section |
 | --- |
 | ![AddSection](https://user-images.githubusercontent.com/75382687/178198503-248ea3ab-db7c-4588-87f0-53d3e291b3bd.gif) |

  </div>
</details>

<details>
  <summary> Set&Delete section </summary>
  <div markdown="3">

 | Set&Delete section |
 | --- |
 | ![Set_DeleteSection](https://user-images.githubusercontent.com/75382687/178199149-bcbf0e88-902c-4d12-9ac5-8d5f33b9dc0f.gif) |

  </div>
</details>

<details>
  <summary> Add timer </summary>
  <div markdown="2">

 | Add timer |
 | --- |
 | ![AddTimer](https://user-images.githubusercontent.com/75382687/178198563-43178784-35fe-41d0-8390-6d116c9c24b9.gif) |

  </div>
</details>

<details>
  <summary> Set&Delete timer </summary>
  <div markdown="3">

 | Set&Delete timer |
 | --- |
 | ![Set_DeleteTimer](https://user-images.githubusercontent.com/75382687/178198615-c8ea2d1a-eae5-41f8-a059-67b1384a25ab.gif) |

  </div>
</details>

<details>
  <summary> Settings </summary>
  <div markdown="4">

 | Settings |
 | --- |
 | ![Settings](https://user-images.githubusercontent.com/75382687/178198652-a4c0dd7c-ab92-4553-83d7-ee3438b7a09c.gif) |

  </div>
</details>

<details>
  <summary> Background push </summary>
  <div markdown="5">

 | Background push |
 | --- |
 | ![Background](https://user-images.githubusercontent.com/75382687/178198690-17eeadfe-827a-4f76-890b-46099d04c90f.gif) |


  </div>
</details>

<br>

# Update log

### 2022.07.11 v1.1
- Improve the UI
- Add section modifications
- Fixed a bug that the same timer deletes.
- Fixed a bug that the same section deletes.

### 2022.06.27 v1.0
- Release!


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
















