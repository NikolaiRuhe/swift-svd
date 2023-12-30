import XCTest
import SVD

final class RP2040Tests: XCTestCase {
    func test_RP20402MMIO() throws {
        let device = try SVD.Device(contentsOf: PicoSDK.rp2040HardwareSVDURL)
        print(device.swiftDescription)
    }
}
