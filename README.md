# MyTimer

It's a timer app created by adding various visual elements.   
The goal is to launch in the App Store.   
It was written only code.   
The code style applied https://github.com/airbnb/swift.

## Preview

![Preview](https://user-images.githubusercontent.com/75382687/175110042-4219529e-4ff5-4e5d-b612-efe5c64cf1da.gif)


<br>

## Features

<details>
  <summary> Timer Playback </summary>
  <div markdown="0">

 | Timer Playback |
 | --- |
 | ![TimerPlayback](https://user-images.githubusercontent.com/75382687/175099768-c84c70ee-c127-4ac7-8b5c-746567579afc.gif) |

  </div>
</details>

<details>
  <summary> Button Animation </summary>
  <div markdown="1">

 | Button Animation |
 | --- |
 | ![ButtonAnimation](https://user-images.githubusercontent.com/75382687/175100330-4e27cb93-aa82-4b87-803b-d51d210efda2.gif) |

  </div>
</details>

<details>
  <summary> Add Section&Timer </summary>
  <div markdown="2">

 | Add Section&Timer |
 | --- |
 | ![Add_Section Timer](https://user-images.githubusercontent.com/75382687/175100353-11cb9f54-b13e-463f-9cce-308e3ad8862a.gif) |

  </div>
</details>

<details>
  <summary> Delete&Set Timer </summary>
  <div markdown="3">

 | Delete&Set Timer |
 | --- |
 | ![Delete Set_Timer](https://user-images.githubusercontent.com/75382687/175100366-47964d54-2d3c-4f06-9f72-f48f4183be15.gif) |

  </div>
</details>

<details>
  <summary> Select Sound </summary>
  <div markdown="4">

 | Select Sound |
 | --- |
 | ![SelectSound](https://user-images.githubusercontent.com/75382687/175100378-db26cf3f-5cef-418d-9baa-b2ad6c3ab6ad.gif) |

  </div>
</details>

<details>
  <summary> Background Push </summary>
  <div markdown="5">

 | Background Push |
 | --- |
 | ![BackgroundPush](https://user-images.githubusercontent.com/75382687/175100424-a8648c2d-ecd2-4f4e-bedf-e1e325b8ac34.gif) |

  </div>
</details>

<br>

## Language

- Swift

<br>

## Architecture

- MVVM   
  <details>
  <summary>Models</summary>
  <div markdown="6">

  ```Swift
    // Timer
    struct MyTimer: Codable, Equatable {
    var title: String
    var min: Int
    var sec: Int
    }
    
    // Section
    struct Section: Codable, Equatable {
    var title: String
    var timers = [MyTimer]()
    }
  ```

  </div>
  </details>

<br>

## Skills

- UIBezierPath()
  > Used to visually show the progress of the timer.   
  > The circular progress bar changes over time using `CABasicAnimation()`

- UIView.animate()
  > Used to UI animation.   
  > When a button is tapped, the button is rotated or displayed one after another.

- UserDefaults
  > Used to store data inside the client.   

- UNUserNotificationCenter
  > When the app is in the background and the timer is done, it is used to push notifications.   
  > Request permission from the device.

- UISwipeActionsConfiguration
  > Used to swipe cells in TableView.   
  > Two UIContextualActions were used to set and delete timers.

<br>

## Library

- AVFoundation
  > Used to sound the alarm.   
  > There are a total of 12 alarm sounds.   
  > The set alarm sound is stored through UserDefaults.

- ExpyTableView
  > Used to implement foldable TableView easily.

- DropDown
  > Used to show a selection list of sections.

- SnapKit

<br>

## App Store

- COMING SOON!
















