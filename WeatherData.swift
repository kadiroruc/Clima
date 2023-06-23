import Foundation
import CoreLocation

struct WeatherData:Codable {//Dış bir gösterimden örneğin JSON formatından bir veriyi kendi kendine
                                //decode edebilen bir type.
    let name:String
    let main:Main
    let weather:[Weather]
    let coord:Coord
}

struct Main:Codable{
    let temp:Double
}
struct Weather:Codable{
    let description:String
    let id:Int
}
struct Coord:Codable{
    let lon:CLLocationDegrees
    let lat:CLLocationDegrees
}

