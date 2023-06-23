import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ WeatherManager : WeatherManager, weather : WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=9ade68b8798a138088faa43680f1da0a&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with : urlString)
        
    }
    
    func fetchWeather(lat:CLLocationDegrees,lon:CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString : String){
        //1.Create an URL
        //String olarak verilen url hatalı olabileceği için URL sınıfı optional obje verir. Bu yüzden if let.
        if let url = URL(string: urlString){
            //2.Create an URLSession
            //Tarayıcının yaptığı gibi ağ üzerinde etkin bir şekilde çalışacak nesne
            let session = URLSession(configuration: .default)
            //3.Give the session a task
            //Tıpkı tarayıcıda arama kısmına url girdiğimiz gibi URLSession a görev veriyoruz.
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                if let safeData = data{
                    //let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4.Start the task 
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder() //JSON u decode edebilen bir nesne
        /*
         decode fonksiyonu bir decode edilmiş nesne gönderir.
         WeatherData.self i yazmamızın sebebi: decode fonksiyonunun bir type argümanını istiyor olmasıdır. WeatherData.self dediğimiz zaman Bu sınıfın tipine bir referans gösterebiliyoruz.
         */
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionId = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let latitude = decodedData.coord.lat
            let longitude = decodedData.coord.lon
            
            let weather = WeatherModel(conditionId: conditionId, cityName: cityName, temperature: temperature,latitude: latitude,longitude: longitude)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
