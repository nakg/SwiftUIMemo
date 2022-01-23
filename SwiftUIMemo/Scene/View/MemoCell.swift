//
//  MemoCell.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/23.
//

import SwiftUI


struct MemoCell: View { // 필요한 데이터를 생성자로 전달해야한다는 점과, 환경같은걸 주입해야하지만 코드의 가독성이 높아지고 유지보수성이 높아진다. 그리고 뷰를 분리했다면, 별도의 파일로 옴기는 것이 더 좋다.
	@ObservedObject var memo: Memo // 앞에 memo 받을 생성자를 따로 추가로 코딩해준다. @ObservedObject를 추가하면, 메모객체가 업데이트 되는 시점마다 뷰가 새롭게 그려진다. 그래서 항상 최신데이터를 표시한다.
	@EnvironmentObject var formatter: DateFormatter
	
	var body: some View {
		VStack(alignment: .leading) { // VStack의 모든 뷰를 좌측정렬.
			Text(memo.content)
				.font(.body) // 기본 폰트.
				.lineLimit(1) // 메모내용을 1줄로만 표시하고, 내용이 길다면 뒷부분 생략.
			
			Text("\(memo.insertDate, formatter: self.formatter)")
				.font(.caption)
				.foregroundColor(Color(UIColor.secondaryLabel))
		}
	}
}

struct MemoCell_Previews: PreviewProvider {
    static var previews: some View {
        MemoCell(memo: Memo(content: "Test"))
			.environmentObject(DateFormatter.memoDateFormatter)
    }
}
