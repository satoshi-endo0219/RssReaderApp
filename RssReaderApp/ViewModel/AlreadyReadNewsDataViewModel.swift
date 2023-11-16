//
//  AlreadyReadNewsDataViewModel.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/15.
//

import SwiftUI
import CoreData

class AlreadyReadNewsDataViewModel: ObservableObject {
    @Published var guid = ""
    @Published var id = UUID().uuidString
    private let request = NSFetchRequest<AlreadyReadNewsData>(entityName: "AlreadyReadNewsData")
    /// CoreDataへデータを書き込む
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func writeData(context: NSManagedObjectContext) {
        let alreadyReadNewsDatas = getAllData(context: context)
        let isAlreadyReadNews = alreadyReadNewsDatas.contains(where: { $0.guid == guid })
        if isAlreadyReadNews {
            return
        }
        insertData(context: context)
    }

    /// CoreDataへinsertを実行する処理
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func insertData(context: NSManagedObjectContext) {
        do {
            if !guid.isEmpty {
                let newAlreadyNewsData = AlreadyReadNewsData(context: context)
                newAlreadyNewsData.id = UUID().uuidString
                newAlreadyNewsData.guid = guid
                try context.save()
            }
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }


    /// CoreDataからデータを取得する
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func getAllData(context: NSManagedObjectContext) -> [AlreadyReadNewsData] {
        do {
            let fetchData = try context.fetch(request)
            return fetchData
        }
        catch {
            fatalError()
        }
    }
}
