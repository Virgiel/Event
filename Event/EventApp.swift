import SwiftUI

@main
struct EventApp: App {
    let speakers = [
        People(name: "Belinda Chen", company: "Home SecurTech", role: "Product Manager", email: "belinda@email.com", phone: "(123) 456-7890", confirmed: false),
        People(name: "Bernard Casper", company: "Absolute Electric", role: "VP of customer success", email: "bernard@email.com", phone: "(123) 456-7890", confirmed: false)
    ]
    let attendes = [
        People(name: "Belinda Chen", company: "Home SecurTech", role: "Product Manager", email: "belinda@email.com", phone: "(123) 456-7890", confirmed: false),
        People(name: "Bernard Casper", company: "Absolute Electric", role: "VP of customer success", email: "bernard@email.com", phone: "(123) 456-7890", confirmed: false)
    ]
    var body: some Scene {
        WindowGroup {
            TabView {
                CarouselExample().tabItem {
                    Label("Program", systemImage: "calendar")
                }
                PeopleList(speakers: speakers, attendes: attendes)
                    .tabItem {
                    Label("Invites", systemImage: "person.3.fill")
                }
            }
        }
    }
}

struct PeopleList: View {
    let speakers: [People]
    let attendes: [People]
    var body: some View {
        List {
            Section {
                ForEach(speakers, id: \.name) { people in
                    PeopleView(people: people)
                }
            } header: {
                Text("Speakers")
            }
            
            Section {
                ForEach(attendes, id: \.name) { people in
                    PeopleView(people: people)
                }
            } header: {
                Text("Attendes")
            }
        }
    }
}

struct PeopleList_Preview: PreviewProvider {
    static let speakers = [
        People(name: "Belinda Chen", company: "Home SecurTech", role: "Product Manager", email: "belinda@email.com", phone: "(123) 456-7890", confirmed: false),
        People(name: "Bernard Casper", company: "Absolute Electric", role: "VP of customer success", email: "bernard@email.com", phone: "(123) 456-7890", confirmed: false)
    ]
    static let attendes = [
        People(name: "Belinda Chen", company: "Home SecurTech", role: "Product Manager", email: "belinda@email.com", phone: "(123) 456-7890", confirmed: false),
        People(name: "Bernard Casper", company: "Absolute Electric", role: "VP of customer success", email: "bernard@email.com", phone: "(123) 456-7890", confirmed: false)
    ]
    static var previews: some View {
        PeopleList(speakers: speakers, attendes: attendes)
    }
}

