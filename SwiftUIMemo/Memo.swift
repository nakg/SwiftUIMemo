//
//  SwiftUIView.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/22.
//

import SwiftUI

// Identifiable 프로토콜 -> 데이터 목록을 테이블뷰나 컬렉션뷰에 쉽게 바인딩 할 수 있다.
// ObservableObject -> 반응형 구현에 필요.
class Memo: Identifiable, ObservableObject {
	let id: UUID // Identifiable가 요구하는 속성이고, 메모를 유일하게 구분할 때 사용한다.
	@Published var content: String // 메모내용. @Published 특성을 추가하면, 새로운 값이 저장될때마다 바인딩되어있는 UI가 자동으로 업데이트 된다.
	let insertDate: Date // 메모를 생성한 날짜.
	
	// 생성자구현
	init(id: UUID = UUID(), content: String, insertDate: Date = Date()) {
		self.id = id
		self.content = content
		self.insertDate = insertDate
	}
}

extension Memo: Equatable {
	static func == (lhs: Memo, rhs: Memo) -> Bool {
		return lhs.id == rhs.id
	}
}
