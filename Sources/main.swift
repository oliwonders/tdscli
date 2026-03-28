import Foundation
import FreeTDSKit
import Logging

//struct SpatialRow: Decodable, Equatable {
//    let SpatialColumn: String
//}

let logger = Logger(label: "tdscli.main")

let version = FreeTDSKit.getFreeTDSVersion()
print("building connection...")

do {
    print("FreeTDS version: \(version)")
    print("attempting to create TDSConnection…")
    let connection = try TDSConnection(
        server: "127.0.0.1",
        username: "sa",
        password: "YourStr0ngP@ss",
        database: "AdGeo3_Staging"
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
