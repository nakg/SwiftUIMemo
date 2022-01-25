//
//  CoreDataManager.swift
//  SwiftUIMemo
//
//  Created by 60067670 on 2022/01/25.
//

import CoreData
import SwiftUI

class CoreDataManager: ObservableObject {
	static let shared = CoreDataManager() // 이 클래스를 싱글톤으로 만든다.
	private init() {
		
	}
	
	// 메모를 저장하는 코드
	func addMemo(content: String) {
		// 새로운 메모 entity추가하고 속성을 채운다.
		let newMemo = MemoEntity(context: Self.mainContext)
		
		newMemo.id = UUID()
		newMemo.content = content
		newMemo.insertDate = Date()
		
		saveContext()
	}
	
	// 메모를 읽어오는 코드. Swift UI에서는 쉽게 가능. 속성이 초기화되는 시점에 데이터를 읽어와서 이 속성에 자동으로 저장하고 데이터가 업데이트되면 배열에있는 데이터도 함께 업데이트된다. 그리고 화면에서 리스트와 함께 바인딩하면 리스트도 항상 최신 리스트로 반영된다.
	@FetchRequest(entity: MemoEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \MemoEntity.insertDate, ascending: false)])
	var memoList: FetchedResults<MemoEntity>
	
	// 업데이트 메서드.
	func update(memo: MemoEntity?, content: String) {
		memo?.content = content
		saveContext()
	}
	
	// delete
	func delete(memo: MemoEntity?) {
		if let memo = memo {
			Self.mainContext.delete(memo)
			saveContext()
		}
	}
	
	static var mainContext: NSManagedObjectContext { // Context에 쉽게 접근할 수 있도록 만듬.
		return persistentContainer.viewContext
	}
	
	// MARK: - Core Data stack
	static var persistentContainer: NSPersistentContainer = {

		let container = NSPersistentContainer(name: "SwiftUIMemo")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	// MARK: - Core Data Saving support
	func saveContext () {
		let context = Self.persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
