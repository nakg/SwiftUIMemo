//
//  DataFormatter+Memo.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/23.
//

import Foundation

extension DateFormatter {
	static let memoDateFormatter: DateFormatter = { // 데이터포매터 초기화.
		let f = DateFormatter()
		f.dateStyle = .long
		f.timeStyle = .none
		f.locale = Locale(identifier: "Ko_kr")
		return f
	}()
}

extension DateFormatter: ObservableObject {
	
}
