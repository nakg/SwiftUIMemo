//
//  DetailScene.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/24.
//

import SwiftUI

struct DetailScene: View {
	@ObservedObject var memo: Memo // @Publish로 선언된 속성이 바뀔때마다 뷰를 자동으로 변환한다.
	@EnvironmentObject var store: MemoStore
	@EnvironmentObject var formatter: DateFormatter
	
	@State private var showEditSheet = false
	
    var body: some View {
		VStack { // VStack - ScrollView - Vstack -> 이렇게하면 화면벗어나면 자동으로 스크롤된다.
			ScrollView {
				VStack {
					HStack { // Text를 좌로 밀기위해... 가운데 안있게.
						Text(self.memo.content)
							.padding()
						
						Spacer()
					} // 기본 패딩 추가
					
					Text("\(self.memo.insertDate, formatter: formatter)")
						.padding()
						.font(.footnote)
						.foregroundColor(Color(UIColor.secondaryLabel))
				}
			}
			
			HStack {
				Button(action: {
					self.showEditSheet.toggle()
				}, label: {
					Image(systemName: "square.and.pencil")
				})
					.padding()
					.sheet(isPresented: self.$showEditSheet, content: {
						ComposeScene(showComposer: $showEditSheet, memo: memo)
							.environmentObject(self.store)
							.environmentObject(KeyboardObserver())
					})
			}
		}
		.navigationBarTitle("메모 보기")
    }
}

struct DetailScene_Previews: PreviewProvider {
    static var previews: some View {
        DetailScene(memo: Memo(content: "Dummy"))
			.environmentObject(MemoStore())
			.environmentObject(DateFormatter.memoDateFormatter)
			
    }
}
