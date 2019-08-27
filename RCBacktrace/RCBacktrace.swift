//
//  RCBacktrace.swift
//  RCBackTrace
//
//  Created by roy.cao on 2019/8/27.
//  Copyright © 2019 roy. All rights reserved.
//

import Foundation

@_silgen_name("mach_backtrace")
public func backtrace(_ thread: thread_t, stack: UnsafeMutablePointer<UnsafeMutableRawPointer?>!, _ maxSymbols: Int32) -> Int32

@objc public class RCBacktrace: NSObject {

    public static var main_thread_t: mach_port_t?

    /// should call this method in main thread first
    public static func setup() {
        main_thread_t = mach_thread_self()
    }

    @objc public static func callstack(_ thread: Thread) -> [StackSymbol] {
        let mthread = machThread(from: thread)
        return mach_callstack(mthread)
    }

    @objc public static func mach_callstack(_ thread: thread_t) -> [StackSymbol] {
        guard main_thread_t != nil else {
            print("❌ [Error]: should setup in main thread first")
            return []
        }

        var symbols = [StackSymbol]()
        let stackSize: UInt32 = 128
        let addrs = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: Int(stackSize))
        defer { addrs.deallocate() }
        let frameCount = backtrace(thread, stack: addrs, Int32(stackSize))
        let buf = UnsafeBufferPointer(start: addrs, count: Int(frameCount))

        for (index, addr) in buf.enumerated() {
            guard let addr = addr else { continue }
            let addrValue = UInt(bitPattern: addr)
            let symbol = StackSymbolFactory.create(address: addrValue, index: index)
            symbols.append(symbol)
        }
        return symbols
    }
}

extension RCBacktrace {

    static func machThread(from thread: Thread) -> thread_t {
        var name: [Int8] = [Int8]()
        var count: mach_msg_type_number_t = 0
        var threads: thread_act_array_t!

        guard task_threads(mach_task_self_, &(threads), &count) == KERN_SUCCESS else {
            return mach_thread_self()
        }

        if thread.isMainThread {
            return main_thread_t ?? mach_thread_self()
        }

        let originName = thread.name

        for i in 0..<count {
            let index = Int(i)
            if let p_thread = pthread_from_mach_thread_np((threads[index])) {
                name.append(Int8(Character.init("\0").ascii!))
                pthread_getname_np(p_thread, &name, MemoryLayout<Int8>.size * 256)
                if (strcmp(&name, (thread.name!.ascii)) == 0) {
                    thread.name = originName
                    return threads[index]
                }
            }
        }

        thread.name = originName
        return mach_thread_self()
    }
}

extension Character {
    var isAscii: Bool {
        return unicodeScalars.allSatisfy { $0.isASCII }
    }
    var ascii: UInt32? {
        return isAscii ? unicodeScalars.first?.value : nil
    }
}

extension String {
    var ascii : [Int8] {
        var unicodeValues = [Int8]()
        for code in unicodeScalars {
            unicodeValues.append(Int8(code.value))
        }
        return unicodeValues
    }
}
