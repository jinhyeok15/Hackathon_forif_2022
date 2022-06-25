//
//  ContentView.swift
//  weatherlist
//
//  Created by Jiwon Park on 2022/06/25.
//

import SwiftUI

struct ContentView: View {

    struct Event: Identifiable {
        var id = UUID()
        var name: String
        var date: Date
        var location: String
        var description: String = ""
        var weather: Weather?
    }

    struct EventInputForm: View {
        @State var eventName: String = "";
        @State var eventDate: Date = Date();
        @State var eventLocation: String = "";
        @State var eventDescription: String = "";

        @Environment(\.presentationMode) var presentationMode

        // events data reference
        @Binding var events: [Event]

        var body: some View {
            // input event info
            NavigationView {
                Form {
                    Section {
                        TextField("Name", text: $eventName)
                        DatePicker("Date", selection: $eventDate)
                        TextField("Location", text: $eventLocation)
                        TextField("Description", text: $eventDescription)
                    }
                    Section {
                        Button("Add Event") {
                            if (self.eventName == "") { return }
                            // add event to events var
                            self.events.append(Event(
                                name: self.eventName,
                                date: self.eventDate,
                                location: self.eventLocation,
                                description: self.eventDescription
                            ))
                            // clear state
                            self.eventName = "";
                            self.eventDate = Date();
                            self.eventLocation = "";
                            self.eventDescription = "";

                            // close current view
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Add Event")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                    }
                }
            }
        }
    }
    
    struct EventDetailView: View {
        @State private var weather: Weather? = nil;
        @State private var isLoading: Bool = true;

        var event: Event
        
        var body: some View {
            // fetch and print weather
            WeatherFetcher.fetchWeather(city: event.location) { weatherInfo in
                guard let weatherInfo = weatherInfo else { return }
                self.weather = weatherInfo.weather.first
                self.isLoading = false
            }
            return NavigationView {
                VStack(spacing: 20) {
                    Text(event.name).font(.system(size: 48, weight: .bold))
                    HStack(spacing: 0) {
                        Text(event.date, style: .date).font(.system(size: 18, weight: .bold))
                        Text(", "+event.location).font(.system(size: 18, weight: .bold))
                    }
                    Text(event.description).font(.system(size: 24, weight: .bold))
                    if (self.isLoading) {
                        Text("Loading...").font(.system(size: 18, weight: .bold))
                    } else if (self.weather != nil) {
                        if (self.weather!.description == "clear sky") {
                            Image("clear sky").resizable()
                        }
                        else if (self.weather!.description == "few clouds") {
                            Image("few clouds").resizable()
                        }
                        else if (self.weather!.description == "scattered clouds") {
                            Image("scattered").resizable()
                        }
                        else if (self.weather!.description == "broken clouds") {
                            Image("broken clouds").resizable()
                        }
                        else if (self.weather!.description == "shower rain") {
                            Image("rain").resizable()
                        }
                        else if (self.weather!.description == "rain") {
                            Image("rain").resizable()
                        }
                        else if (self.weather!.description == "thunderstorm") {
                            Image("thunder storm").resizable()
                        }
                        else if (self.weather!.description == "snow") {
                            Image("snow").resizable()
                        }
                        else if (self.weather!.description == "mist") {
                            Image("mist").resizable()
                        }
                        Text(self.weather!.description).font(.system(size: 22, weight: .bold))

                    } else {
                        Text("No weather data").font(.system(size: 22, weight: .bold))
                    }
                }
            }
        }
        
    }
    
    @State private var multiSelection = Set<UUID>();
    @State private var showingTodoInput = false;
    @State private var events = [Event]();
    
    var body: some View {
        NavigationView {
            VStack {
                List(events, selection: $multiSelection) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        VStack(alignment: .leading) {
                            Text(event.name).font(.system(size: 18))
                            Text(event.date, style: .date).font(.system(size: 18))
                        }
                    }
                }
                
                .navigationTitle("Events")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        NavigationLink(destination: EventInputForm(events: 
                            $events)) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
