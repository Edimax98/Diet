//
//  SubscriptionNetworkService.swift
//  Diet
//
//  Created by Даниил on 10/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//enum Result<T> {
//    case failure(SubscriptionServiceError)
//    case success(T)
//}

enum RecieptStatus: Int {
    case sandboxUsedInProduction = 21007
    case correctStatus = 0
}

enum SubscriptionServiceError {
    case internalError
    case missingAccountSecret
    case invalidSession
    case noActiveSubscription
    case wrongEnviroment
    case purchaseFailed
    case restoreFailed
    case other(Error)
}

typealias UploadReceiptCompletion = (_ result: Result<Session>) -> Void
typealias SessionId = String

class SubscriptionNetworkService {
    
    public static let shared = SubscriptionNetworkService()
    let simulatedStartDate: Date
    
    private var sessions = [SessionId: Session]()
    private var productionUrl = "https://buy.itunes.apple.com/verifyReceipt"
    private var sandboxUrl = "https://sandbox.itunes.apple.com/verifyReceipt"
    private var currentUrl: String = ""
    
    init() {
        let persistedDateKey = "SimulatedStartDate"
        currentUrl = productionUrl
        if let persistedDate = UserDefaults.standard.object(forKey: persistedDateKey) as? Date {
            simulatedStartDate = persistedDate
        } else {
            let date = Date().addingTimeInterval(-30) // 30 second difference to account for server/client drift.
            UserDefaults.standard.set(date, forKey: "SimulatedStartDate")
            simulatedStartDate = date
        }
    }
    
    public func upload(receipt data: Data, completion: @escaping UploadReceiptCompletion) {
        
//        let body = [
//            "receipt-data": data.base64EncodedString(),
//            "password": itcAccountSecret
//        ]
        let body = ["":""]
        
        request(currentUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
//            guard let responseValue = response.result.value else { completion(.failure(.internalError)); return }
//            switch response.result {
//            case .success(_):
//                
//                guard let json = JSON(responseValue).dictionaryObject else { completion(.failure(.internalError)); return }
//                let status = JSON(responseValue)["status"].intValue
//                guard let recieptStatus = RecieptStatus(rawValue: status) else { completion(.failure(.internalError)); return }
//                let session = Session(receiptData: data, parsedReceipt: json)
//                self.sessions[session.id] = session
//                
//                if JSON(responseValue)["latest_expired_receipt_info"]["is_trial_period"] == "true" {
//                    EventManager.subscriptionExpired(with: "TEST EVENT. User has canceled trial.")
//                }
//                
//                if recieptStatus == .correctStatus {
//                    completion(.success(session))
//                } else {
//                    self.currentUrl = self.sandboxUrl
//                    completion(.failure(.wrongEnviroment))
//                }
//                
//            case .failure(let error):
//                completion(.failure(.other(error)))
//            }
        }
    }
}
