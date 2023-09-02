import Foundation

struct PBTransactionsModel: Equatable, Sendable, Codable {
    let items: [TransactionModel]
}

public struct TransactionModel: Equatable, Identifiable, Sendable, Codable {
    public static func == (lhs: TransactionModel, rhs: TransactionModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: UUID
    let partnerDisplayName: String
    let category: Int?
    var transactionDetail: TransactionDetailModel?
    
    private enum CodingKeys: String, CodingKey {
        case partnerDisplayName
        case category
        case transactionDetail
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        partnerDisplayName = (try? container.decode(String.self, forKey: .partnerDisplayName)) ?? ""
        category = try? container.decode(Int.self, forKey: .category)
        transactionDetail = try? container.decode(TransactionDetailModel.self, forKey: .transactionDetail)
    }
}

public struct TransactionDetailModel: Sendable, Codable {
    public static func == (lhs: TransactionDetailModel, rhs: TransactionDetailModel) -> Bool {
        lhs.id == rhs.id
    }
    public let id: UUID
    var bookingDate: Date?
    var bookingFormatted: String?
    let bookingString: String?
    let description: String?
    let amount: AmountModel?
    
    private enum CodingKeys: String, CodingKey {
        case bookingDate
        case description
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        bookingString = try? container.decode(String.self, forKey: .bookingDate)
        description = try? container.decode(String.self, forKey: .description)
        amount = try? container.decode(AmountModel.self, forKey: .value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(bookingDate, forKey: .bookingDate)
        try? container.encode(description, forKey: .description)
        try? container.encode(amount, forKey: .value)
    }
    
}

public struct AmountModel: Sendable, Codable {
    public static func == (lhs: AmountModel, rhs: AmountModel) -> Bool {
        lhs.id == rhs.id
    }
    public let id: UUID
    let value: Decimal?
    let currency: String?
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        value = (try? container.decode(Decimal.self, forKey: .amount))
        currency = try? container.decode(String.self, forKey: .currency)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(value, forKey: .amount)
        try? container.encode(currency, forKey: .currency)
    }
}
