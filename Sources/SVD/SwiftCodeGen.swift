import Foundation

extension Device {

    public var swiftDescription: String {
        var output = ""

        print("""
        // RP2040 System View Description

        import MMIO

        """, to: &output)

        for peripheral in peripherals {
            print("\n// MARK: - \(peripheral.name)\n", to: &output)
            print(peripheral.swiftDescription, to: &output)
        }

        return output
    }
}

extension Peripheral {
    public var swiftDescription: String {
        """
        \(description?.docComment(indentation: 0) ?? "")@RegisterBank
        struct \(name) {

        \(registers.map {
            $0.swiftRegisterBankDescription(in: name.rawValue) + "\n\n"
            + $0.swiftDescription(in: name.rawValue)
        }.joined(separator: "\n\n"))
        }
        """
    }
}

extension Register {
    public func swiftRegisterBankDescription(in parentName: String) -> String {
        """
        \(description?.docComment(indentation: 1) ?? "")    @RegisterBank(offset: \(addressOffset))
            var \(name.rawValue.lowercased()): Register<\(name)>
        """
    }

    public func swiftDescription(in parentName: String) -> String {
        """
            @Register(bitWidth: \(size.value))
            struct \(name) {\(fields.isEmpty ? "" : "\n\(fields.map { $0.swiftDescription }.joined(separator: "\n\n"))\n")    }
        """
    }
}

extension Register.Field {
    public var swiftDescription: String {
        """
        \(description?.docComment(indentation: 2) ?? "")        @\(access?.swiftDescription ?? "ReadWrite")(bits: \(bitRange.swiftDescription)\(bitRange.msb == bitRange.lsb ? ", as: Bool.self" : ""))
                var \(name.rawValue.lowercased()): \(name.rawValue)
        """
    }
}


extension BitRange {
    public var swiftDescription: String {
        "\(lsb)..<\(msb + 1)"
    }
}

extension Access {
    var swiftDescription: String {
        switch self {
        case .readOnly: return "ReadOnly"
        case .writeOnly: return "WriteOnly"
        case .readWrite: return "ReadWrite"
        default: return "ReadWrite"
        }
    }
}

extension String {
    func docComment(indentation: Int = 0) -> String {
        self
            .split(separator: "\n")
            .map { String(repeating: "    ", count: indentation) + "/// " + $0.trimmingCharacters(in: .whitespaces) + "\n" }
            .joined()
    }
}
