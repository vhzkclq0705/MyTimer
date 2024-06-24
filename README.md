# MyTimer

It's a timer app created by adding various visual elements.   
The goal of this project is to launch on the App Store.   
It was written by code only. 
The code style applied https://github.com/airbnb/swift.

<br>

# Skills

- RxSwift
- SnapKit

<br>


# Key Feature

 - 🕒 Playback Timers

 - 📝 Section and Timer Management

  - 🔊 Custom Alert Sounds
    
- 📬 Background Push Notifications

<br>

# Architecture

- MVVM   
  ViewModelType

  ```Swift
    protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
    
  }
  ```

<br>

# Data Flow
![diagram](https://github.com/vhzkclq0705/MyTimer/assets/75382687/daa3d2cf-ae5a-4d2e-aa4a-6e782a96ea3c)


# Update log

### 2022.07.11 v1.1
- UI Enhancements
- Added Section Modifications
- Fixed Timer Deletion Bug
- Fixed Section Deletion Bug

### 2022.06.27 v1.0
- Released!

<br>

# App Store

- https://apps.apple.com/kr/app/%EB%A7%88%EC%9D%B4%ED%83%80%EC%9D%B4%EB%A8%B8/id1631776048
















