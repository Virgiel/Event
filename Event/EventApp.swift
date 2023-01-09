import SwiftUI

@main
struct EventApp: App {
    @StateObject var model = ViewModel()
    var body: some Scene {
        WindowGroup {
            VStack {
                if model.loaded {
                    TabView {
                        ScheduleView(model: model).tabItem {
                            Label("Program", systemImage: "calendar")
                        }
                        PeopleList(speakers: model.speakers.values.map({$0}), attendes: model.attendes.values.map({$0}))
                            .tabItem {
                                Label("Invites", systemImage: "person.3.fill")
                            }
                    }
                } else if model.err != nil {
                    Text("Houston we have a problem")
                    Text(model.err!.localizedDescription)
                } else {
                    Text("Loading")
                }
            }.task {
                await model.load()
            }
        }
    }
}

