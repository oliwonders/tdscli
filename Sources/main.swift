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
    print("attempting to create TDSConnection…")
    let connection = try TDSConnection(
        server: server,
        username: username,
        password: password,
        database: database
    )
    print("connection created")

    let query =
        "SELECT top 100 SpatialPolygon.STAsText() AS SpatialPolygon, zip as Zip FROM SpatialAdGeo.ZipCode_Import"
    print("query is: \(query)")
  //  let result = try await connection.execute(query: query)
  //  print("we have \(result.affectedRows) rows")

    for try await row in connection.query(
        queryString: query,
        as: SpatialRow.self
    ) {
        print("zip \(row.Zip)")
    }
    await connection.close()

} catch {
    print("❌ error: \(error)")
       dump(error)

}
