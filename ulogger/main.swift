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
import SPMUtility

do
{
    let parser = ArgumentParser(commandName: "ulogger",
                 usage: "[-s subsystem] [-c category] [-t type] message",
                 overview: "Write messages to the Mac's unified logging system.",
                 seeAlso: "log(1), os_log(3)")

    let subsystemArg = parser.add(option: "--subsystem",
                       shortName: "-s",
                       kind: String.self,
                       usage: "Specify the subsystem.")

    let categoryArg = parser.add(option: "--category",
                      shortName: "-c",
                      kind: String.self,
                      usage: "Specify the category.")

    let typeArg = parser.add(option: "--type",
                  shortName: "-t",
                  kind: String.self,
                  usage: "Must be one of: default, info, debug, error, fault.  If\n" +
                         "                    omitted or the provided value is invalid, " +
                         "then default is\n                    used.")

    let messageArg = parser.add(positional: "message",
                     kind: String.self,
                     optional: true,
                     usage: "Message to be logged.  If omitted, stdin is logged.")

    let argsv = Array(CommandLine.arguments.dropFirst())
    let pargs = try parser.parse(argsv)
    var ulogger = Ulogger(pargs.get(subsystemArg), pargs.get(categoryArg),
                          pargs.get(typeArg), pargs.get(messageArg))

    if ulogger.message == nil
    {
        while let line = readLine()
        {
            ulogger.message = line
            ulogger.os_log_public()
        }
    }
    else
    {
        ulogger.os_log_public()
    }
} catch ArgumentParserError.expectedValue(let value)
{
    print("Missing value for argument \(value).")
    exit(EXIT_FAILURE)
} catch ArgumentParserError.expectedArguments(_, let stringArray)
{
    print("Missing arguments: \(stringArray.joined()).")
    exit(EXIT_FAILURE)
} catch
{
    print(error.localizedDescription)
    exit(EXIT_FAILURE)
}
