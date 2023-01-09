import Foundation
import SwiftUI

/* ----- Model Types ----- */

struct Schedule: Codable{
    let activity: String
    let type: String
    let start: Date
    let end : Date
    let location: String
    let speakers: [String]?
    let note: String?
    
    enum CodingKeys: String, CodingKey {
        case activity = "Activity"
        case type = "Type"
        case start = "Start"
        case end = "End"
        case location = "Location"
        case speakers = "Speaker(s)"
        case note = "Notes"
    }
}

struct People: Codable{
    let name: String
    let company: String
    let role: String
    let email: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case company = "Company"
        case role = "Role"
        case email = "Email"
        case phone = "Phone"
    }
}

struct Budget: Codable{
    let Item: String
    var Estimated = ""
    var Actual = ""
    var Quantity = ""
    var Notes = ""
    var Total_budget = ""
    var Under_budget = ""
    var Total_cost = ""
}

/* ----- AirTable extraction ------ */

private struct Record<T: Codable>: Codable {
    let id: String
    let createdTime: String
    let fields: T
}

private struct Table<T: Codable>: Codable {
    let records: [Record<T>]
}

private let table_schedule = URL(string: "https://api.airtable.com/v0/appLxCaCuYWnjaSKB/%F0%9F%93%86%20Schedule")!
private let table_speakers = URL(string: "https://api.airtable.com/v0/appLxCaCuYWnjaSKB/%F0%9F%8E%A4%20Speakers")!
private let table_attendees = URL(string: "https://api.airtable.com/v0/appLxCaCuYWnjaSKB/%F0%9F%AA%91%20Attendees")!
private let table_budget = URL(string: "https://api.airtable.com/v0/appLxCaCuYWnjaSKB/%F0%9F%92%B0%20Budget")!

/// Create an properly configured and authenticated airtable request from an URL
private func airTableRequest(url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.timeoutInterval = 100
    request.httpMethod = "GET"
    let accessToken = "keymaCPSexfxC2hF9"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    return request
}

/// Get all elements of n Air Table
private func getAirTable<T: Codable>(url: URL) async throws -> [String:T] {
    let request = airTableRequest(url: url);
    let (data, response) = try await URLSession.shared.data(for: request)
    // TODO error message
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({decoder in
        let dateStr = try decoder.singleValueContainer().decode(String.self)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = dateFormatter.date(from: dateStr) {
            return date
        }
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: decoder.codingPath,
                                  debugDescription: "Invalid date"))})
    let decoded =  try decoder.decode(Table<T>.self, from: data)
    return decoded.records.reduce(into: [String: T]()) {
        $0[$1.id] = $1.fields
    }
}

func getSchedule() async throws ->  [String:Schedule] {
    return try await getAirTable(url: table_schedule)
}

func getSpeakers() async throws -> [String:People] {
    return try await getAirTable(url: table_speakers)
}

func getAttendes() async throws -> [String:People] {
    return try await getAirTable(url: table_attendees)
}

// TODO other get

/* ----- View Model ----- */

class ViewModel: ObservableObject {
    @Published var loaded = false
    @Published var err: Error? = nil
    @Published var schedules: [String:Schedule] = [:]
    @Published var speakers: [String:People] = [:]
    @Published var attendes: [String:People] = [:]
    @Published var analysis: ScheduleAnalysis = ScheduleAnalysis(schedules: [])

    @MainActor
    func load() async {
        do {
            schedules = try await getSchedule()
            speakers = try await getSpeakers()
            attendes = try await getAttendes()
            analysis =  ScheduleAnalysis(schedules: schedules.values.map({$0}));
            // TODO get the rest
            loaded = true
        } catch {
            print(error)
            err = error
        }
    }
}

let scheduleColor = [
    "Meal" : Color.yellow,
    "Panel" : Color.blue,
    "Keynote" : Color.red,
    "Workshop" : Color.pink,
    "Breakout session": Color.purple,
    "Networking": Color.cyan
]
