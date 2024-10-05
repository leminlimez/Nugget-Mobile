import Foundation
import MobileDevice

class MobileDevice {
    public static func deviceList() -> [String] {
        var deviceList: idevice_t? = nil
        var udidList: [String] = []

        idevice_get_device_list_extended(&deviceList, nil)
        guard let deviceList = deviceList else { return [] }

        for i in 0..<Int(CFArrayGetCount(deviceList)) {
            let udidObject = CFArrayGetValueAtIndex(deviceList, i)!
            let udidUnmanaged = Unmanaged<CFString>.fromOpaque(udidObject)
            let udidCFString = udidUnmanaged.takeUnretainedValue() as CFString
            if let udid = udidCFString as String? {
                udidList.append(udid)
            }
        }
        idevice_device_list_free(deviceList)
        return udidList
    }

    public static func rebootDevice(udid: String) {
        guard let device = idevice_new() else { return }
        idevice_set_udid(device, udid as CFString)

        idevice_reboot(device)
        idevice_free(device)

    }

}
