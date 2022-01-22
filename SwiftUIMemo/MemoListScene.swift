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
	
    var body: some View {
		// 배열에 저장되어있는 메모가, memo 파라미터로 전달된다.
		NavigationView {
			List(store.list) { memo in
				VStack(alignment: .leading) { // VStack의 모든 뷰를 좌측정렬.
					Text(memo.content)
						.font(.body) // 기본 폰트.
						.lineLimit(1) // 메모내용을 1줄로만 표시하고, 내용이 길다면 뒷부분 생략.
					
					Text("\(memo.insertDate, formatter: self.formatter)")
						.font(.caption)
						.foregroundColor(Color(UIColor.secondaryLabel))
				}
			}
			.navigationTitle("내 메모") // Modifier를 이용해서 타이틀을 추가한다.
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
