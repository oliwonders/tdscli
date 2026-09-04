import Foundation
import FreeTDSKit
import Logging

let logger = Logger(label: "tdscli.main")

guard let configURL = Bundle.module.url(forResource: "Config", withExtension: "plist"),
      let config = NSDictionary(contentsOf: configURL),
      let server   = config["server"]   as? String,
      let username = config["username"] as? String,
      let password = config["password"] as? String,
      let database = config["database"] as? String
else {
    print("❌ Could not load Config.plist")
    exit(1)
}

let version = FreeTDSKit.getFreeTDSVersion()
print("building connection...")

do {
    print("FreeTDS version: \(version)")
    print("attempting to create TDSConnection to \(server)...")
    let connection = try TDSConnection(
        server: server,
        username: username,
        password: password,
        database: database
    )
    print("connection created")

    let query =
        "SELECT TOP 100 ProductID, ProductName, Quantity FROM dbo.Product ORDER BY ProductID"
    print("query is: \(query)")

    for try await row in connection.query(
        queryString: query,
        as: ProductRow.self
    ) {
        print("product #\(row.ProductID): \(row.ProductName) (qty \(row.Quantity))")
    }

    await connection.close()

} catch {
    print("❌ error: \(error)")
    dump(error)
    exit(1)
}
