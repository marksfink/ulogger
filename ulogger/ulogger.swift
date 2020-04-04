/*
* Copyright (c) 2020 Mark Fink
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
import os.log

struct Ulogger
{
    enum LogType: String
    {
        case info
        case debug
        case error
        case fault
        case `default`
        
        init(value: String!)
        {
            switch value
            {
                case "info": self = .info
                case "debug": self = .debug
                case "error": self = .error
                case "fault": self = .fault
                default: self = .default
            }
        }
    }
    
    let subsystem: String
    let category: String
    let type: LogType
    var message: String?

    func os_log_public()
    {
        var oslog = OSLog.default
        if !(self.subsystem.isEmpty && self.category.isEmpty)
        {
            oslog = OSLog(subsystem: self.subsystem, category: self.category)
        }
        if let msg: String = self.message
        {
            switch self.type
            {
                case .info: os_log("%{public}s", log: oslog, type: .info, msg)
                case .debug: os_log("%{public}s", log: oslog, type: .debug, msg)
                case .error: os_log("%{public}s", log: oslog, type: .error, msg)
                case .fault: os_log("%{public}s", log: oslog, type: .fault, msg)
                default: os_log("%{public}s", log: oslog, type: .default, msg)
            }
        }
    }

    init(_ subsystemStr: String?, _ categoryStr: String?,
         _ typeStr: String?, _ messageStr: String?)
    {
        self.subsystem = subsystemStr ?? ""
        self.category = categoryStr ?? ""
        self.type = LogType(value: typeStr)
        self.message = messageStr
    }
}
