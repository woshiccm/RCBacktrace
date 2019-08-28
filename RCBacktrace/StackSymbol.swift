//
//  StackFrame.swift
//  RCBacktrace
//
//  Created by roy.cao on 2019/8/27.
//  Copyright © 2019 roy. All rights reserved.
//

import Foundation

public class StackSymbol: NSObject {
    public let symbol: String
    public let file: String
    public let address: UInt
    public let symbolAddress: UInt
    public let demangledSymbol: String
    public let image: String
    public let offset: Int
    public let index: Int

    public init(symbol: String, file: String, address: UInt, symbolAddress: UInt, image: String, offset: Int, index: Int) {
        self.symbol = symbol
        self.file = file
        self.address = address
        self.symbolAddress = symbolAddress
        self.demangledSymbol = _stdlib_demangleName(symbol)
        self.image = image
        self.offset = offset
        self.index = index
    }

    public override var description: String {
        return formattedDescription()
    }

    /// - parameter index: the stack frame index
    /// - returns: a formatted string matching that used by NSThread.callStackSymbols
    private func formattedDescription() -> String {
        return image.utf8CString.withUnsafeBufferPointer { (imageBuffer: UnsafeBufferPointer<CChar>) -> String in
            #if arch(x86_64) || arch(arm64)
            return String(format: "%-4ld%-35s 0x%016llx %@ + %ld", index, UInt(bitPattern: imageBuffer.baseAddress), address, demangledSymbol, offset)
            #else
            return String(format: "%-4d%-35s 0x%08lx %@ + %d", index, UInt(bitPattern: imageBuffer.baseAddress), address, demangledSymbol, offset)
            #endif
        }
    }
}

class StackSymbolFactory {

    /// Address for which this struct was constructed
    static func  create(address: UInt, index: Int) -> StackSymbol {
        var info = dl_info()
        dladdr(UnsafeRawPointer(bitPattern: address), &info)

        let stackSymbol = StackSymbol(symbol: symbol(info: info),
                                      file: String(cString: info.dli_fname),
                                      address: address,
                                      symbolAddress: unsafeBitCast(info.dli_saddr, to: UInt.self),
                                      image: image(info: info),
                                      offset: offset(info: info, address: address),
                                      index: index)
        return stackSymbol
    }

    /// thanks to https://github.com/mattgallagher/CwlUtils/blob/master/Sources/CwlUtils/CwlAddressInfo.swift
    /// returns: the "image" (shared object pathname) for the instruction
    private static func image(info: dl_info) -> String {
        if let dli_fname = info.dli_fname, let fname = String(validatingUTF8: dli_fname), let _ = fname.range(of: "/", options: .backwards, range: nil, locale: nil) {
            return (fname as NSString).lastPathComponent
        } else {
            return "???"
        }
    }

    /// returns: the symbol nearest the address
    private static func symbol(info: dl_info) -> String {
        if let dli_sname = info.dli_sname, let sname = String(validatingUTF8: dli_sname) {
            return sname
        } else if let dli_fname = info.dli_fname, let _ = String(validatingUTF8: dli_fname) {
            return image(info: info)
        } else {
            return String(format: "0x%1x", UInt(bitPattern: info.dli_saddr))
        }
    }

    /// returns: the address' offset relative to the nearest symbol
    private static func offset(info: dl_info, address: UInt) -> Int {
        if let dli_sname = info.dli_sname, let _ = String(validatingUTF8: dli_sname) {
            return Int(address - UInt(bitPattern: info.dli_saddr))
        } else if let dli_fname = info.dli_fname, let _ = String(validatingUTF8: dli_fname) {
            return Int(address - UInt(bitPattern: info.dli_fbase))
        } else {
            return Int(address - UInt(bitPattern: info.dli_saddr))
        }
    }
}
