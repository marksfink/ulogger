/*
* Copyright (c) 2025 Mark Fink
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this program; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
*/

import Foundation
import ArgumentParser
import os.log

@main
struct Ulogger: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ulogger",
        abstract: "Write messages to the Mac's unified logging system.")

    @Option(
        name: [.short, .customLong("subsystem")],
        help: "Specify the subsystem.")
    var subsystem: String = ""

    @Option(
        name: [.short, .customLong("category")],
        help: "Specify the category.")
    var category: String = ""

    @Option(
        name: [.short, .customLong("type")],
        help: "Must be one of: default, info, error, fault.")
    var type: String = "default"

    @Argument var message: String = String()

    mutating func run() throws {
        if message.isEmpty {
            while let line = readLine() {
                message = line
                ulogger()
            }
        }
        else {
            ulogger()
        }
    }

    func ulogger() {
        var oslog = OSLog.default

        if !(self.subsystem == "" && self.category == "") {
            oslog = OSLog(subsystem: self.subsystem, category: self.category)
        }

        switch self.type {
            case "info": os_log("%{public}s", log: oslog, type: .info, message)
            case "error": os_log("%{public}s", log: oslog, type: .error, message)
            case "fault": os_log("%{public}s", log: oslog, type: .fault, message)
            default: os_log("%{public}s", log: oslog, type: .default, message)
        }
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
