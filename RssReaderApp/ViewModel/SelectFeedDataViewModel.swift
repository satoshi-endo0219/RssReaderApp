//
//  SelectFeedDataViewModel.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/08.
//

import SwiftUI
import CoreData

class SelectFeedDataViewModel: ObservableObject {
    @Published var url = ""
    @Published var id = UUID().uuidString

    private let request = NSFetchRequest<SelectFeedData>(entityName: "SelectFeedData")

    @Environment(\.managedObjectContext)private var context
    /// CoreDataへデータを書き込む
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func writeData(context: NSManagedObjectContext) {
        let feedDatas = getData(context: context)
        if feedDatas.isEmpty {
            insertData(context: context)
            return
        }
        updateData(context: context)
    }

    /// CoreDataへinsertを実行する処理
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    private func insertData(context: NSManagedObjectContext) {
        do {
            if !url.isEmpty {
                let newSelectFeedData = SelectFeedData(context: context)
                newSelectFeedData.id = UUID().uuidString
                newSelectFeedData.url = url
                try context.save()
            }
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }

    /// CoreDataへupDateを実行する処理
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    private func updateData(context: NSManagedObjectContext) {
        let feedDatas = getData(context: context)
        if let upDateId = getUpdateId(feedDatas: feedDatas) {
            let request = NSFetchRequest<SelectFeedData>(entityName: "SelectFeedData")
            request.predicate = NSPredicate(format: "id = %@", upDateId)
            do {
                if !url.isEmpty {
                    let myResults = try context.fetch(request)

                    for myData in myResults {
                        myData.setValue(url, forKeyPath: "url")
                    }
                    try context.save()
                }
            } catch let error as NSError {
                print("\(error), \(error.userInfo)")
            }
        }
    }

    /// updateを実行するidを取得する
    /// - Parameter:
    ///   - feedDatas: CoreDataから取得したデータ
    private func getUpdateId(feedDatas: [SelectFeedData]) -> String? {
        for feedData in feedDatas {
            return feedData.id
        }
        return nil
    }

    /// CoreDataからデータを取得する
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func getData(context: NSManagedObjectContext) -> [SelectFeedData] {
        do {
            let fetchData = try context.fetch(request)
            return fetchData
        }
        catch {
            fatalError()
        }
    }
    /// CoreDataから保存されているURLを取得する
    /// - Parameter:
    ///   - feedDatas: CoreDataから取得したデータ
    func getUrlFromCoreData(feedDatas: [SelectFeedData]) -> String? {
        for feedData in feedDatas {
            return feedData.url
        }
        return nil
    }
}

