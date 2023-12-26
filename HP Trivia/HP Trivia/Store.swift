//
//  Store.swift
//  HP Trivia
//
//  Created by iM on 26/12/2023.
//

import Foundation
import StoreKit

enum BookStatus: Codable {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    
    @Published var products: [Product] = []
    @Published var purchasedIds = Set<String>()
    
    private var productIds = ["hp4", "hp5", "hp6", "hp7"]
    
    private var updates: Task<Void, Never>? = nil
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatus")
    
    init() {
        updates = watchForUpdates()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIds)
        }catch{
            print("Coudnt fetch the products")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificatioError):
                    print("Error on \(signedType) \(verificatioError)")
                    
                case .verified(let signedType):
                    purchasedIds.insert(signedType.productID)
                }
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        }catch{
            print("Coudnt purchase the product")
        }
    }
    
    func saveStatus() {
        do {
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data.")
        }
    }
    
    func loadStatus() {
        do {
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
        } catch {
            print("Unable to load book statuses.")
        }
    }
    
    func checkPurchased() async {
        for product in products {
            guard let state = await product.currentEntitlement else {return}
            switch state {
            case .unverified(let signedType, let verificatioError):
                print("Error on \(signedType) \(verificatioError)")
                
            case .verified(let signedType):
                if signedType.revocationDate == nil {
                    purchasedIds.insert(signedType.productID)
                }else {
                    purchasedIds.remove(signedType.productID)
                }
            }
        }
    }
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}
