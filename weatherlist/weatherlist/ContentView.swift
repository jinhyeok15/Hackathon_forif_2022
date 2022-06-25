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

    // private var events = [
    //     Event(
    //         name: "서울 재즈페스티벌",
    //         date: Calendar.current.date(from:DateComponents(year: 2022, month: 05, day: 14))!,
    //         location: "서울시 중구 을지로대로 삼거리",
    //         description: "서울시 중구 을지로대로 삼거리에서 재즈페스티벌을 진행합니다."
    //         ),
    //     Event(
    //         name: "The Airhouse in Gapyeong",
    //         date: Calendar.current.date(from:DateComponents(year: 2022, month: 05, day: 15))!,
    //         location: "강원도 가평군 가평읍 가평리",
    //         description: "강원도 가평군 가평읍 가평리에서 The Airhouse를 진행합니다."
    //         ),
    //     Event(
    //         name: "Surf! - 소란 여름콘서트",
    //         date: Calendar.current.date(from:DateComponents(year: 2022, month: 05, day: 16))!,
    //         location: "노들섬",
    //         description: "노들섬에서 Surf! 소란 여름콘서트를 진행합니다."
    //         ),
    // ]

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
                .navigationBarTitle("Add Event")
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
                VStack {
                    Text(event.name)
                    Text(event.date, style: .date)
                    Text(event.location)
                    Text(event.description)
                    if (self.isLoading) {
                        Text("Loading...")
                    } else if (self.weather != nil) {
                        Text(self.weather!.description)
                    } else {
                        Text("No weather data")
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
                            Text(event.name)
                            Text(event.date, style: .date)
                        }
                    }
                }
                .navigationTitle("Events")
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
