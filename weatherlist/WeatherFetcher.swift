//
//  WeatherFetcher.swift
//  weatherlist
//
//  Created by Jiwon Park on 2022/06/25.
//

import UIKit

class WeatherFetcher {
    static func fetchWeather(city: String, completion: @escaping (WeatherInformation?) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=6949a3ca522322494cdcc85fc6060ddc&units=metric")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherInformation.self, from: data)
                completion(weather)
            } catch {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
}
