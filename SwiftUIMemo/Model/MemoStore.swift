//
//  MemoStore.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/22.
//
// Memo 목록 저장하는 클래스.

import Foundation

class MemoStore: ObservableObject {
	@Published var list: [Memo] // @Published를 추가하여 여기 데이터가 업데이트될때마다, 바인딩된 UI가 변경되도록 한다.
	
	init() {
		list = [
			Memo(content: "Lorem Ipsum 1"),
			Memo(content: "Lorem Ipsum 2"),
			Memo(content: "Lorem Ipsum 3"),
		]
	}
	
	// 입력한 메모를 파라미터로 받은 다음, 리스트 배열에 저장.
	
	func insert(memo: String) {
		list.insert(Memo(content: memo), at: 0)
	}
	
	func update(memo: Memo?, content: String) {
		guard let memo = memo else {
			return
		}
		memo.content = content
	}
	
	func delete(memo: Memo) {
		DispatchQueue.main.async {
			self.list.removeAll { $0 == memo }
		}
	}
	
	func delete(set: IndexSet) {
		for index in set {
			self.list.remove(at: index)
		}
	}
}
