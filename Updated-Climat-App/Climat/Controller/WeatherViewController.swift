import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    //API key 47eb4dba4f8be9357cce33ffba786fb1
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var switcherForTemp: UISwitch!
    @IBOutlet weak var celOrFar: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    var WeatherControl = weatherControl()
    let userLocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherControl.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationTap(_ sender: UIButton) {
        userLocation.delegate = self
        userLocation.requestWhenInUseAuthorization()
        userLocation.requestLocation()
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        let tempFloat = Double(temperatureLabel.text!)
        if sender.isOn {
            celOrFar.text = "C"
            let temp = Double(temperatureLabel.text!)
            let inCelcius = Double((temp! - 32)/1.8)
            temperatureLabel.text = String(Int(round(inCelcius)))
        } else {
            celOrFar.text = "F"
            let inFarenheit = Double((tempFloat! * 1.8) + 32)
            temperatureLabel.text = String(Int(round(inFarenheit)))
        }
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchTap(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            searchTextField.placeholder = "Type city"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            WeatherControl.getWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - weatherControlDelegate

extension WeatherViewController: weatherControlDelegate {
    
    func didUpdateWeather(_ weatherControl: weatherControl, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImage.image = UIImage(systemName: weather.conditionType)
            self.cityLabel.text = weather.cityName
            self.pressureLabel.text = String("\(weather.pressure) mm Hg")
            self.windLabel.text = ("\(weather.directionWindType), speed \(weather.windPower) m/s")
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            userLocation.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            WeatherControl.getWeather(latitude: lat, longitude: lon)
        }
        print("get location data")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
