# ProjectManager

### ✧ 소개
* 프로젝트 기간: 2023.07 ~ 2023.10 (4개월)
CoreData를 활용한 일정 관리 iPad 앱 프로젝트 입니다.

### 💻 개발환경

| 항목 | 사용기술 |
| :--------: | :--------: |
| Architecture | MVVM, Clean Architecture |
| UI | UIKit |
| Reactive / Concurrency | RxSwift |
| Local Storage | CoreData |

</br>

## 📝 목차
1. [타임라인](#-타임라인)
2. [프로젝트 구조](#-프로젝트-구조)
3. [실행화면](#-실행화면)
4. [트러블 슈팅](#-트러블-슈팅)
5. [팀 회고](#-팀-회고)
6. [참고 링크](#-참고-링크)

</br>

# 📆 타임라인 
- 23.07.12 ~ 23.08.24: MVVM 아키텍처로 뷰 구현 및 RxSwift, RxCocoa 학습
- 23.08.25 ~ 23.09.14: Clean Architecture 학습 및 적용, CoreData 저장소 구현
- 23.09.15 ~ 23.09.20: ViewController의 화면전환 기능 분리(Navigator)
- 23.09.21 ~ 23.09.23: RxDataSource 적용
- 23.09.24 ~ 23.10.17: Popover view 구현 및 일정 상태 변경 기능 추가

</br>

# 🗂️ 프로젝트 구조
<img src="https://github.com/Tediousday93/ios-project-manager/blob/main/ProjectManager_Screenshot/ProjectManager_UML.png?raw=true" width="550">

</br>

# 📱 실행화면
| 메인 화면 | 할 일 추가(입력 전) |
| :--------: | :--------: |
| <img src="https://github.com/Tediousday93/ios-project-manager/blob/develop/ProjectManager_Screenshot/ProjectManager_main_screenshot.png?raw=true" width="700"> | <img src="https://github.com/Tediousday93/ios-project-manager/blob/develop/ProjectManager_Screenshot/ProjectManager_create_disabledButton_screenshot.png?raw=true" width="700"> |
| **할 일 추가(입력 후)** | **할 일 수정** |
| <img src="https://github.com/Tediousday93/ios-project-manager/blob/develop/ProjectManager_Screenshot/ProjectManager_create_enableButton_screenshot.png?raw=true" width="700"> | <img src="https://github.com/Tediousday93/ios-project-manager/blob/develop/ProjectManager_Screenshot/ProjectManager_editFeature_Capture.gif?raw=true" width="700"> |
| **상태 변경 기능** | **할 일 삭제** |
| <img src="https://github.com/Tediousday93/ios-project-manager/blob/develop/ProjectManager_Screenshot/ProjectManager_ChangeStateFeature_Capture.gif?raw=true" width="700"> | <img src="https://github.com/Tediousday93/ios-project-manager/blob/develop/ProjectManager_Screenshot/ProjectManager_delete_capture.gif?raw=true" width="700"> |

</br>

# 🚀 트러블 슈팅
## 1️⃣ 뷰 재사용
### 🔍 문제점
| 할 일 추가 | 할 일 수정 |
| :----: | :----: |
| <img src="https://github.com/Tediousday93/ios-project-manager/blob/main/ProjectManager_Screenshot/CreateProjectView_screenshot.png?raw=true" width="700"> | <img src="https://github.com/Tediousday93/ios-project-manager/blob/main/ProjectManager_Screenshot/UpdateProjectView_screenshot.png?raw=true" width="700"> |

위의 두 View는 기능만 다르고 완전히 같은 형태를 띄고 있습니다.
이 때, ViewController의 viewModel이 추상화가 되어 있지 않았기 때문에 view model을 교체하며 view를 재사용하기 어려웠습니다.

```swift
final class EditViewController: UIViewController {

    private let viewModel: EditViewModel 
    // 추상화 되지 않은 구체 타입
    // 바인딩 코드가 다른 뷰 모델 간의 교체가 불가
}
```
</br>

ViewModel에 꼭 필요한 `Input`/`Output` 타입 및 `transform` 메서드를 강제하기 위한 프로토콜은 아래와 같습니다.

```swift
protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
```

해당 프로토콜은 associatedtype을 갖기 때문에 타입으로써 사용하게 될 경우 `any ViewModelType`의 boxed protocol type이 되어 Input 타입을 컴파일러가 특정할 수 없기 때문에 바인딩을 작성할 수 없습니다.

</br>

### ⚒️ 해결방안
ViewModel을 추상화하여 교체할 수 있도록 Class의 상속을 이용하기로 했습니다. 같은 Input/Output을 갖고 transform 메서드만 재정의될 수 있도록 추상 클래스 AbstractEditViewModel 타입을 만들고 해당 클래스를 상속받는 CreateProjectViewModel, UpdateProjectViewModel을 정의했습니다.

<details>
    <summary>소스코드</summary>
    
```swift
class AbstractEditViewModel: ViewModelType {
    struct Input {
        let title: Driver<String>
        let date: Driver<Date>
        let body: Driver<String>
        let rightBarButtonTapped: Driver<Void>
        let leftBarButtonTapped: Driver<Void>
    }
    
    struct Output {
        let canSave: Driver<Bool>
        let projectSave: Observable<Void>
        let canEdit: Driver<Bool>
        let dismiss: Driver<Void>
    }
    
    // 프로퍼티 및 이니셜라이저 생략
    
    func transform(_ input: Input) -> Output {
        fatalError("Do not use abstract method.")
    }
}

final class CreateProjectViewModel: AbstractEditViewModel {
    override func transform(_ input: Input) -> Output {
        // Input 가공 로직
    }
}

final class UpdateProjectViewModel: AbstractEditViewModel {
    override func transform(_ input: Input) -> Output {         
        // Input 가공 로직
    }
}
```
    
</details>

</br>
    
## 2️⃣ Popover
### 🔍 문제점
<img src="https://github.com/Tediousday93/ios-project-manager/blob/develop/ProjectManager_Screenshot/ProjectManager_ChangeStateFeature_Capture.gif?raw=true" width="500">

tableViewCell을 longPress하면 할 일의 상태를 바꿀 수 있는 popover view를 보여줘야 합니다.
현재 화면전환 로직은 `Navigator`라는 객체를 통해 관리하고 있으며 해당 객체의 인터페이스를 ViewModel이 참조하여 화면전환 메서드를 ViewModel 내부에서 호출하고 있습니다.
popover는 `presentingViewController`와 `sourceView`에 대한 참조를 전달해야 정상적으로 화면에 표시됩니다. 이 때, popover에 대한 navigator를 정의하게 되면 이러한 참조를 ViewModel에 전달하기 위해 ViewModel에서 `UIKit`을 import하게 되는 문제가 있었습니다.

### ⚒️ 해결방안
Popover는 NavigationController에 의해 표시되는 것이 아니었기 때문에 PopoverBuilder를 정의해 popover가 필요한 ViewController에서 직접 present 할 수 있게 만들었습니다.

<details>
    <summary>소스코드</summary>
    
```swift
protocol PopoverViewType: UIViewController {
    associatedtype ViewModel: ViewModelType
    
    init(viewModel: ViewModel)
}
    
enum PopoverBuilderError: Error {
    case propertiesNotConfigured
}

final class PopoverBuilder<PopoverView: PopoverViewType> {
    struct PopoverProperties {
        var sourceView: UIView?
        var permittedArrowDirections: UIPopoverArrowDirection?
        var preferredContentSize: CGSize?
    }
    
    private let presentingViewController: UIViewController
    private var popoverProperties: PopoverProperties = .init()
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func withSourceView(_ view: UIView?) -> PopoverBuilder {
        popoverProperties.sourceView = view
        return self
    }
    
    func arrowDirections(_ directions: UIPopoverArrowDirection) -> PopoverBuilder {
        popoverProperties.permittedArrowDirections = directions
        return self
    }
    
    func preferredContentSize(_ size: CGSize) -> PopoverBuilder {
        popoverProperties.preferredContentSize = size
        return self
    }
    
    func show(with viewModel: PopoverView.ViewModel) throws {
        guard let sourceView = popoverProperties.sourceView,
              let arrowDirections = popoverProperties.permittedArrowDirections,
              let preferredContentsSize = popoverProperties.preferredContentSize else {
            throw PopoverBuilderError.propertiesNotConfigured
        }
        
        let sourceRect = CGRect(origin: CGPoint(x: sourceView.bounds.midX,
                                                y: sourceView.bounds.midY),
                                size: .zero)
        
        let popoverView = PopoverView(viewModel: viewModel)
        popoverView.modalPresentationStyle = .popover
        popoverView.preferredContentSize = preferredContentsSize
        popoverView.popoverPresentationController?.sourceView = popoverProperties.sourceView
        popoverView.popoverPresentationController?.sourceRect = sourceRect
        popoverView.popoverPresentationController?.permittedArrowDirections = arrowDirections
        
        presentingViewController.present(popoverView, animated: true)
    }
}
```
    
```swift
// Popover로 사용할 ViewController
final class ChangeStateViewController: UIViewController, PopoverViewType {
    typealias ViewModel = ChangeStateViewModel

    // implementations...
}

// Popover present stream
output.changeStateViewModel
    .observe(on: MainScheduler.instance)
    .subscribe(with: self, onNext: { owner, changeStateViewModel in
        try? PopoverBuilder<ChangeStateViewController>(presentingViewController: owner)
            .withSourceView(owner.longPressedCell)
            .arrowDirections(.up)
            .preferredContentSize(CGSize(width: 300, height: 120))
            .show(with: changeStateViewModel)
    })
    .disposed(by: disposeBag)
    
```
    
</details>

</br>
    
## 3️⃣ Clean Architecture
### 🔍 문제점
프로젝트 Architecture에 Clean Architecture를 적용하기로 결정한 것은 필요에 의해서가 아니었습니다. Clean architecture를 사용하는 프로젝트에 투입되었을 때를 위해 적용을 시도해보고 서적을 통해 알게 된 내용들이 실제 어떻게 응용되는지 알아보고 싶었습니다.
    
### 💭 느낀점
* 규모가 작은 프로젝트에서 적용할 경우 코드가 오히려 복잡해진다.
* 모듈화를 직접 구현하지는 못했지만 모듈화를 가정해 코드를 작성하였고, 모듈 간 의존성 역전을 프로토콜을 통해 구현한다는 것을 알게 되었다.
* 모듈 간 의존성을 떨어뜨려 놓으니 코드를 수정할 때 인터페이스를 바꾸지 않는 이상 수정할 부분이 적어짐을 느꼈다.
* 이러한 이점으로 규모가 큰 프로젝트에서 팀 단위 분업에 용이할 것이라고 생각했다.
* 인터페이스를 자주 수정하지 않기 위해서 Domain을 명확히 정의하는 것이 얼마나 중요한지 알게 되었다.
* 비즈니스 로직이란 무엇인지 다시 한 번 생각해보는 기회가 되었다.
    * 어플리케이션 비즈니스 로직 - Domain layer에서 정의하는 UseCase의 구현체. 원하는 서비스나 API를 이용해 뷰에 연결하는 부분이 어플리케이션에 특화된 비즈니스 로직이라고 생각했다.
    * 회사의 비즈니스 로직 - 어떤 플랫폼에서 구현하든 변하지 않는 회사 서비스의 핵심적인 로직. 예를 들면 안드로이드, iOS, 웹 등 여러 플랫폼에서 공통적으로 사용할 수 있는 백엔드 API를 구성하고 있는 로직이라고 생각했다.
    
---

# 📚 참고 문서
* [Apple Developer Documentation - CoreData](https://developer.apple.com/documentation/coredata)
* [Swift Programming Language Guide - Opaque and Boxed Types
](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes)
* [ReactiveX Document](https://reactivex.io/documentation/observable.html)
* [RxSwift 공식문서 번역 및 Operator 정리](https://heavy-rosehip-0fb.notion.site/5272729d82e9480c8784de856a480aac?v=5aca0fe79aa344f7b7ed620449cf2800&pvs=74)
* [RxSwift GitHub Repository](https://github.com/ReactiveX/RxSwift)
* [sergdort GitHub Repository](https://github.com/sergdort/CleanArchitectureRxSwift)
* [개구리 발자국 Velog - [Swift/디자인패턴] Builder Pattern](https://velog.io/@qwer15417/iOS%EB%94%94%EC%9E%90%EC%9D%B8%ED%8C%A8%ED%84%B4-Builder-Pattern)
* [saebyuck_choom Velog - [iOS] Rx-MVVM의 올바른 사용법](https://velog.io/@dawn_dancer/iOS-Rx-MVVM%EC%9D%98-%EC%98%AC%EB%B0%94%EB%A5%B8-%EC%82%AC%EC%9A%A9%EB%B2%95-saebyuckchoom)
* [클린 아키텍처: 소프트웨어 구조와 설계의 원칙 - 송준이(번역)]
