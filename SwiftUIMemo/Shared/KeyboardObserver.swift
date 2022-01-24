//
//  KeyboardObserver.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/24.
//

// 키보드 노티피케이션을 처리하는 객체를 구현한다. with Combine.

import UIKit
import Combine

class KeyboardObserver: ObservableObject {
	struct Context {
		let animationDuration: TimeInterval
		let height: CGFloat
		
		// 키보드가 숨겨진 상태의 기본값을 타입프로퍼티로 저장.
		static let hide = Self(animationDuration: 0.25, height: 0)
	}
	// 바인딩에 사용하는 속성을 선언. @Published를 사용하면 연관되어있는 뷰가 자동으로 업데이트.
	@Published var context = Context.hide
	
	// 메모리 관리에 사용되는 속성 선언.
	private var cancellables = Set<AnyCancellable>()
	
	// 생성자. 콤바인으로 해보자.
	init() {
		// 노티피케이션 퍼블리셔를 상수에 저장.
		let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
		let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
		
		// 두 publisher를 merge 연산자로 합친다.
		willShow.merge(with: willHide)
		
		// 노티피케이션에서 필요한 데이터를 추출한 다음에, compact map연산자를 활용해서 context 형식으로 변환.
			.compactMap(parse)
			.assign(to: \.context, on: self) // assign연산자를 추가하고, 변환된 context 인스턴스를 context 속성에 바인딩.
			.store(in: &cancellables)
		
		// -> 이제 키보드 willShow와 willHide노티가 전달되면, parse가 실행되고 이 메서드가 리턴하는 결과가 context속성에 자동으로 저장된다. 그리고 키보드 옵져버 객체가 사라지면 관련된 객체가 자동으로 사라지게 된다.
	}

	//parse 메서드.
	func parse(notification: Notification) -> Context? {
		// 노티피케이션에서 키보드 높이를 꺼낸다.
		guard let userInfo = notification.userInfo else { return nil } // userinfo 저장
		let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets // safeareaindset을 상수에 저장
		let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25 // 애니메이션 시간도 상수에 저장.
		
		var height: CGFloat = 0 // 높이를 저장할 변수 초기화.
		
		if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let frame = value.cgRectValue
			
			if frame.origin.y < UIScreen.main.bounds.height { // 키보드가 표시되는 시점이라면
				height = frame.height - (safeAreaInsets?.bottom ?? 0)
			}
		} // userinfo에서 프레임값을 꺼낸다.
		
		
		return Context(animationDuration: animationDuration, height: height)
	}
}

