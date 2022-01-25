//
//  ContentView.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/22.
//

import SwiftUI

struct MemoListScene: View {
	@EnvironmentObject var store: MemoStore // MemoStore 인스턴스를 커스텀 공유데이터로 등록을 했다.(SceneDelegate) 뷰가 생성되는 시점에 공유데이터 목록을 확인하고, 스토어속성과 동일한 형식을 가진 객체가 등록되어있다면 여기에 자동으로 저장해준다. Swift UI는 이러한 방식으로 하나의 데이터를 여러 View에서 공유한다.
	@EnvironmentObject var formatter: DateFormatter
	
	@State var showComposer: Bool = false // ComposeScene을 제어할 때 사용.
	
    var body: some View {
		// 배열에 저장되어있는 메모가, memo 파라미터로 전달된다.
		NavigationView { // push 화면 이동방식
			List {
				ForEach(store.list) { memo in
					NavigationLink(destination: DetailScene(memo: memo), label: {
						MemoCell(memo: memo)
					})
				}
				.onDelete(perform: store.delete)
			}
			.navigationBarTitle("내 메모")// Modifier를 이용해서 타이틀을 추가한다.
			.navigationBarItems(trailing: ModalButton(show: $showComposer)) // $를전달해야 값이 복사되는게 아니라 바인딩이 전달된다. 뷰 외부에있는 속성을 바꾸고싶다면, 이렇게 바인딩 형태로 전달해야한다. 파라미터로 전달할 때에는 달러 문자를 붙이고, 전달 받는쪽에서는 바인딩 형태로 선언하는 형태이다.
			.sheet(isPresented: $showComposer, content: { // +를 누르면 showComposer가 true로 바뀌고, Sheet연산자는 바인딩되어있는 속성에 true가 저장되면 content에 클로져를 호출하고 리턴된 형식을 모당 형식으로 호출한다.
				ComposeScene(showComposer: self.$showComposer).environmentObject(self.store)
			})
		}
	}
}

fileprivate struct ModalButton: View {
	@Binding var show: Bool // 바인딩 속성. 값을 가지기위한 속성이 아닌 다른곳에있는 것을 바꾸기 위한 속성.
	var body: some View {
		Button {
			self.show = true
		} label: {
			Image(systemName: "plus")
		}

	}
}

struct MemoListScene_Previews: PreviewProvider {
    static var previews: some View {
		MemoListScene()
			.environmentObject(MemoStore()) // 프리뷰에서 사용할 memostore를 커스텀 공유 데이터로 등록하겠다.
			.environmentObject(DateFormatter.memoDateFormatter) // 커스텀 데이터포매터를 프리뷰에 셋팅.
    }
}

