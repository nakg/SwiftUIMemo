//
//  ComposeScene.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/23.
//

import SwiftUI

struct ComposeScene: View {
	@EnvironmentObject var keyboard: KeyboardObserver // 키보드 옵저벼 주입할 속성을 선언.
	@EnvironmentObject var store: MemoStore
	@State private var content: String = "" // 입력한 속성을 바인딩할 때 사용하는 속성 선언. 이런 속성들은 주로 @State로 선언.
	
	@Binding var showComposer: Bool // 바인딩 속성 선언.
	
	var memo: Memo? = nil // 편집을 위한 메모. 여기에 메모가 전달되면 편집모드로 간주한다. 없으면 쓰기모드로 간주한다.
	
    var body: some View {
		NavigationView {
			VStack {
				TextView(text: $content) // 이렇게하면 content속성과, textfield가 바인딩되고 텍스트필드에 문자를 입력하면 content 속성에 자동으로 저장된다. content 속성에 문자열을 저장하면 텍스트필드에도 반영된다. Swift UI는 이런 2-way 방식이 쉽다.
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(.bottom, keyboard.context.height) // context는 @Publisher 특성으로 선언한 속성이다. 이에 속성에 저장된 값이 업데이트되면 패딩도 함께 업데이트된다.
					.animation(.easeOut(duration: keyboard.context.animationDuration))
					.background(Color.yellow) 
				
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.navigationBarTitle(memo != nil ? "메모 편집" : "새 메모", displayMode: .inline)
			.navigationBarItems(leading: DismissButton(show: $showComposer), trailing: SaveButton(show: $showComposer, content: $content, memo: memo))
			
			
		}
		.onAppear { // 화면이 표시되는 시점에 초기화코드를 구현하고 싶을 때.
			self.content = self.memo?.content ?? ""
		}
    }
}

fileprivate struct DismissButton: View {
	@Binding var show: Bool // 바인딩 속성 선언.
	var body: some View {
		Button {
			self.show = false
		} label: {
			Text("취소")
		}
	}
}

fileprivate struct SaveButton: View {
	@Binding var show: Bool // 바인딩 속성 선언.
	
	@EnvironmentObject var store: MemoStore
	@Binding var content: String
	
	var memo: Memo? = nil
	
	var body: some View {
		Button {
			if let memo = self.memo {
				self.store.update(memo: memo, content: self.content)
			} else {
				// 입력한 메모 저장.
				self.store.insert(memo: self.content)
			}
			
			
			
			self.show = false
		} label: {
			Text("저장")
		}

	}
}

struct ComposeScene_Previews: PreviewProvider {
    static var previews: some View {
		ComposeScene(showComposer: .constant(false)) // 프리뷰에서 에러가 발생하지 않도록, 생성자로 속성을 전달. 그런데 여기로 전달할 수 있는 속성이 없다. 이럴떈 보통 constant binding을 전달한다.
			.environmentObject(MemoStore()) // MemoStore를 커스텀 데이터르로 등록
			.environmentObject(KeyboardObserver())
    }
}
