import Cocoa
import FinderSync

/// Adds "New README.md" to the menu shown when right-clicking empty space in a Finder window.
final class FinderSync: FIFinderSync {
    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        guard menuKind == .contextualMenuForContainer else { return nil }
        let menu = NSMenu()
        menu.addItem(withTitle: "New README.md", action: #selector(createReadme(_:)), keyEquivalent: "")
        return menu
    }

    @objc func createReadme(_ sender: AnyObject?) {
        guard let dir = FIFinderSyncController.default().targetedURL() else { return }
        let file = dir.appendingPathComponent("README.md")
        // Never overwrite an existing README.
        guard !FileManager.default.fileExists(atPath: file.path) else { return }
        FileManager.default.createFile(atPath: file.path, contents: Data())
    }
}
