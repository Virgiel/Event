import SwiftUI

struct PeopleView: View {
    let people: People
    @State var isExpanded = false
    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 4, verticalSpacing: 2) {
            Text(people.name).bold()
            Text(people.company)
            if isExpanded {
                GridRow {
                    Image(systemName: "mail.fill")
                    Text(people.role)
                }.padding(Edge.Set(.top), 6)
                GridRow {
                    Image(systemName: "envelope.fill")
                    Text(people.email)
                }
                GridRow {
                    Image(systemName: "phone.fill")
                    Text(people.phone)
                }
            }
        }
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}

struct People_Previews: PreviewProvider {
    static let peoples = [
        People(name: "Belinda Chen", company: "Home SecurTech", role: "Product Manager", email: "belinda@email.com", phone: "(123) 456-7890"),
        People(name: "Bernard Casper", company: "Absolute Electric", role: "VP of customer success", email: "bernard@email.com", phone: "(123) 456-7890")
    ]
    static var previews: some View {
        List {
            ForEach(peoples, id: \.name) { people in
                PeopleView(people: people)
            }
        }
    }
}
