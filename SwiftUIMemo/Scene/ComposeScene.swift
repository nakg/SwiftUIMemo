//
//  ComposeScene.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/23.
//

import SwiftUI

struct ComposeScene: View {
	@EnvironmentObject var store: MemoStore
	@State private var content: String = "" // 입력한 속성을 바인딩할 때 사용하는 속성 선언. 이런 속성들은 주로 @State로 선언.
	@Binding var showComposer: Bool // 바인딩 속성 선언.
	
    var body: some View {
		NavigationView {
			VStack {
				TextField("", text: $content) // 이렇게하면 content속성과, textfield가 바인딩되고 텍스트필드에 문자를 입력하면 content 속성에 자동으로 저장된다. content 속성에 문자열을 저장하면 텍스트필드에도 반영된다. Swift UI는 이런 2-way 방식이 쉽다.
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.navigationBarTitle("새 메모", displayMode: .inline)
			.navigationBarItems(leading: DismissButton(show: $showComposer), trailing: SaveButton(show: $showComposer))
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
	var body: some View {
		Button {
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
    }
}
