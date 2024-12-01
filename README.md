![Artboard](https://github.com/leminlimez/Nugget-Mobile/blob/1881fdc2b721fd2675a2909e7fbc24769d11bb53/readme-images/icon.png)

# Nugget (mobile)
Unlock your device's full potential! Should work on all versions iOS 16.0 - 18.2 developer beta 2 (public beta 1).

This will not work on iOS 18.2 beta 2 or newer. Please do not make issues about this, it will not be fixed. You will have to use the [pc version of Nugget](https://github.com/leminlimez/Nugget) unless a fix comes in the future.

A `.mobiledevicepairing` file and wireguard are required in order to use this. Read the [sections](#getting-your-mobiledevicepairing-file) below to see how to get those.

If you are having issues with minimuxer, see the [Solving Minimuxer Issues](#solving-minimuxer-issues) thread.

This uses the sparserestore exploit to write to files outside of the intended restore location, like mobilegestalt.

Note: I am not responsible if your device bootloops, use this software with caution. Please back up your data before using!

## Getting Your mobiledevicepairing File
To get the pairing file, use the following steps:
1. Download `jitterbugpair` for your system from here: <https://github.com/osy/Jitterbug/releases/latest>
    - **Note:** On mac or linux, you may have to run the terminal command `chmod +x ./jitterbugpair` in the same directory.
2. Run the program by either double clicking it or using terminal/powershell
3. Share the `.mobiledevicepairing` file to your iOS device
4. Open the app and select the pairing file

You should only have to do this once unless you lose the file and delete the app's data.

## Setting Up WireGuard
1. Download [WireGuard](<https://apps.apple.com/us/app/wireguard/id1441195209>) on the iOS App Store.
2. Download [SideStore's config file](https://github.com/sidestore/sidestore/releases/download/0.1.1/sidestore.conf) on your iOS device
3. Share the config file to WireGuard using the share menu
4. Enable it and run Nugget

## Solving Minimuxer Issues
If you have used Cowabunga Lite before, you may experience issues with minimuxer. This is due to how it skipped the setup process.
These steps should solve the problem, however it is not an end-all be-all solution.
1. Download [Nugget Python](https://github.com/leminlimez/Nugget) and follow the steps in the readme to install python and the requirements
2. Connect your device and (in terminal) type `python3 fix-minimuxer.py` (or `python fix-minimuxer.py` if it doesn't work)

Your device should reboot. After it reboots, try Nugget mobile now. If it still doesn't work, follow the steps below:

3. After your device reboots, go to `[Settings] -> General -> Transfer or Reset iPhone`
4. Tap `Reset` and then `Reset Location & Privacy`
5. Nugget mobile should work now. If it doesn't, try getting a new pairing file.

If the steps above don't work for you, try using `Cowabunga Lite` and clicking the `Deep Clean` button, then try the steps again.
If not even that works, the only solution I know is to wipe the device (not ideal). I would recommend using [Nugget Python](https://github.com/leminlimez/Nugget) instead in this case.

## Credits
- [JJTech](https://github.com/JJTech0130) for Sparserestore/[TrollRestore](https://github.com/JJTech0130/TrollRestore)
- khanhduytran for [Sparsebox](https://github.com/khanhduytran0/SparseBox)
- [pymobiledevice3](https://github.com/doronz88/pymobiledevice3)
- [disfordottie](https://x.com/disfordottie) for some global flag features
- f1shy-dev for the old [AI Enabler](https://gist.github.com/f1shy-dev/23b4a78dc283edd30ae2b2e6429129b5#file-eligibility-plist)
- [SideStore](https://sidestore.io/) for em_proxy and minimuxer
- [libimobiledevice](https://libimobiledevice.org) for the restore library
