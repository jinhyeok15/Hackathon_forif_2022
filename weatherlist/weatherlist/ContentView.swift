//
//  ContentView.swift
//  weatherlist
//
//  Created by Jiwon Park on 2022/06/25.
//

import SwiftUI

struct ContentView: View {
    struct EventDetailView: View {
        var event: Event
        
        var body: some View {
            Text(event.name)
            Text(event.date, style: .date)
        }
    }
    
    struct Event: Identifiable {
        var id = UUID()
        var name: String
        var date: Date
    }
    
    private var events = [
        Event(name: "서울 재즈페스티벌", date: Calendar.current.date(from:DateComponents(year: 2022, month: 05, day: 14))!),
        Event(name: "The Airhouse in Gapyeong", date: Date()),
        Event(name: "Surf! - 소란 여름콘서트", date: Date())
    ]
    
    @State private var multiSelection = Set<UUID>();
    @State private var showingTodoInput = false;
    
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
                        Button(
                            action: {
                                showingTodoInput = true
                            },
                            label: {
                            Image(systemName: "plus")
                        })
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
