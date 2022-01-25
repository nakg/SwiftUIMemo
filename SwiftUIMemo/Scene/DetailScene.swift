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
	@State private var showDeleteAfter = false // 경고창
	
	@Environment(\.presentationMode) var presentationMode
	
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
					self.showDeleteAfter.toggle()
				}, label: {
					Image(systemName: "trash")
						.foregroundColor(Color(UIColor.systemRed))
				})
					.padding()
					.alert(isPresented: $showDeleteAfter, content: {
						Alert(title: Text("삭제 확인"), message: Text("메로를 삭제할까요?"),
							  primaryButton:
									.destructive(Text("삭제"), action: {
							self.store.delete(memo: self.memo)
							self.presentationMode.wrappedValue.dismiss() // 이전화면으로 돌아간다.
						}),
							  secondaryButton: .cancel())
					})
				
				Spacer()
				
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
			.padding(.leading)
			.padding(.trailing) // 너무 버튼이 좌우에 붙어서, 기본여백 추가함.
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
