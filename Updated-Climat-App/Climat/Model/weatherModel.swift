import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Double
    let conditionId: Int
    let windDirection: Int
    let windPower: Int
    let pressure: Int
    
    var temperatureString: String{
        return String(format: "%.0f", temperature)
    }
    
    var conditionType: String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return ""
        }
    }
    
    var directionWindType: String {
        switch windDirection {
        case 0:
            return "east wind"
        case 90:
            return "north wind"
        case 180:
            return "west wind"
        case 270:
            return "south wind"
        case 1...89:
            return "north-east wind"
        case 91...179:
            return "nort-west wind"
        case 181...269:
            return "south-west wind"
        case 271...359:
            return "south-east wind"
        default:
            return ""
        }
    }
}
