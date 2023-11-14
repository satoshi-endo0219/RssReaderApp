//
//  FavoriteFeedDataViewModel.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/13.
//

import SwiftUI
import CoreData

class FavoriteFeedDataViewModel: ObservableObject {
    @Published var favoriteItem = NewsItem(title: "", link: "", guid: "", pubDate: "")
    @Published var deleteGuid: String = ""
    @Published var id = UUID().uuidString

    private let request = NSFetchRequest<FavoriteFeedData>(entityName: "FavoriteFeedData")

    @Environment(\.managedObjectContext)private var context

    /// CoreDataへデータを書き込む
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func writeData(context: NSManagedObjectContext) {
        insertData(context: context)
    }
    
    /// CoreDataへinsertを実行する処理
    /// - Parameter:
    ///   - context: レコードの操作を管理するマネージャー
    func insertData(context: NSManagedObjectContext) {
        do {
            if !favoriteItem.title.isEmpty {
                let newFavoriteFeedData = FavoriteFeedData(context: context)
                newFavoriteFeedData.id = UUID().uuidString
                newFavoriteFeedData.url = favoriteItem.link
                newFavoriteFeedData.title = favoriteItem.title
                newFavoriteFeedData.guid = favoriteItem.guid
                newFavoriteFeedData.pubDate = favoriteItem.pubDate
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
        let request = NSFetchRequest<FavoriteFeedData>(entityName: "FavoriteFeedData")
        request.predicate = NSPredicate(format: "guid = %@", deleteGuid)
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
    func getAllData(context: NSManagedObjectContext) -> [FavoriteFeedData] {
        do {
            let fetchData = try context.fetch(request)
            return fetchData
        }
        catch {
            fatalError()
        }
    }
}
