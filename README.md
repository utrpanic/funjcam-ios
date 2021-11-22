# funjcam-ios
Searching for images.

## Requirements
* iOS 15
* xcode 13
* Swift 5

## Getting Started
``` 
git clone https://github.com/utrpanic/funjcam-ios
cd funjcam-ios
brew bundle
open FunJCam.xcodeproj
```

## 특징
- RIBs의 의존성 주입을 ViewController 중심으로 MVC로 구현해보려는 시도.
- Router가 정말 따로 필요해요?라는 의문에서 시작.
- RIBs는 Router로 tree를 구현했기 때문에, listener가 필수.
- Tree를 별도로 그리지 않고, ViewController를 중심으로 꾸리면 detach를 명시적으로 구현하지 않을 수 있다.
- 그러다보니 결국 Controller = Builder + Interactor + Router -> 그래도 할만 한가. 너무 크진 않은가.
- didBecomeActive는 어쩔 수 없음. ViewController가 직접 결정하게 두자.
- Controllable의 인터페이스는 능동태로 작성. ViewController에게 조금 더 부담을 주자.
- request prefix로 위임 느낌을 조금이라도 줘볼까 하는 부질없는 시도. 
- Template이 함께 필요함. 요소가 너무 많다.
