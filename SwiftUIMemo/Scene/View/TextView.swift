//
//  TextView.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/23.
//

import UIKit
import SwiftUI

// Swift UI에서 UIKit을 사용하려면 아래 프로토콜을 사용해야 한다.
struct TextView: UIViewRepresentable {
	@Binding var text: String
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeUIView(context: Context) -> UITextView {
		let myTextView = UITextView()
		myTextView.delegate = context.coordinator
		
		return myTextView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		uiView.text = text
	}
	
	// Delegate를 처리할 코디네이터 클래스.
	class Coordinator: NSObject, UITextViewDelegate {
		var parent: TextView
		
		init(_ uiTextView: TextView) {
			self.parent = uiTextView
		}
		
		func textViewDidChange(_ textView: UITextView) {
			self.parent.text = textView.text
		}
	}
}
