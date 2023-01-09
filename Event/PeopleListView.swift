import SwiftUI

/// List all people you can interact with during the event
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
        People(name: "Belinda Chen", company: "Home SecurTech", role: "Product Manager", email: "belinda@email.com", phone: "(123) 456-7890"),
        People(name: "Bernard Casper", company: "Absolute Electric", role: "VP of customer success", email: "bernard@email.com", phone: "(123) 456-7890")
    ]
    static let attendes = [
        People(name: "Belinda Chen", company: "Home SecurTech", role: "Product Manager", email: "belinda@email.com", phone: "(123) 456-7890"),
        People(name: "Bernard Casper", company: "Absolute Electric", role: "VP of customer success", email: "bernard@email.com", phone: "(123) 456-7890")
    ]
    static var previews: some View {
        PeopleList(speakers: speakers, attendes: attendes)
    }
}
