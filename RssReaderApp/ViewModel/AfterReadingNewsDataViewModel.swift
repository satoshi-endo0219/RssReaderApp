//
//  AfterReadingNewsDataViewModel.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/16.
//

import Foundation
import CoreData

class AfterReadingNewsDataViewModel: ObservableObject {
    @Published var newsItem = NewsItem(title: "", link: "", guid: "", pubDate: "")
    @Published var id = UUID().uuidString

    private let request = NSFetchRequest<AfterReadingNewsData>(entityName: "AfterReadingNewsData")

    /// CoreDataへデータを書き込む
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func writeData(context: NSManagedObjectContext) {
        let afterReadingNewsData = getAllData(context: context)
        // FavoriteFeedDatas内にnewsItem.guidが存在している場合、CoreDataからnewsItem.guidのデータを削除
        let isAfterReading = afterReadingNewsData.contains(where: { $0.guid == newsItem.guid })
        if isAfterReading {
            deleteData(context: context)
            return
        }
        // FavoriteFeedDatas内にnewsItem.guidが存在していない場合、CoreDataへnewsItemを登録
        insertData(context: context)
    }

    /// CoreDataへinsertを実行する処理
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func insertData(context: NSManagedObjectContext) {
        do {
            if !newsItem.title.isEmpty {
                let newAfterReadingNewData = AfterReadingNewsData(context: context)
                newAfterReadingNewData.id = UUID().uuidString
                newAfterReadingNewData.url = newsItem.link
                newAfterReadingNewData.title = newsItem.title
                newAfterReadingNewData.guid = newsItem.guid
                newAfterReadingNewData.pubDate = newsItem.pubDate
                try context.save()
            }
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }

    /// CoreDataへdeleteDataを実行する処理
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func deleteData(context: NSManagedObjectContext) {
        let request = NSFetchRequest<AfterReadingNewsData>(entityName: "AfterReadingNewsData")
        request.predicate = NSPredicate(format: "guid = %@", newsItem.guid)
        do {
            let myResults = try context.fetch(request)

            for myData in myResults {
                context.delete(myData)
            }
            try context.save()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }

    /// CoreDataからデータを取得する
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func getAllData(context: NSManagedObjectContext) -> [AfterReadingNewsData] {
        do {
            let fetchData = try context.fetch(request)
            return fetchData
        }
        catch {
            fatalError()
        }
    }
}
