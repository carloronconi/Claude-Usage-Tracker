//
//  NSWindow+FullScreenSpaces.swift
//  Claude Usage
//
//  Created by Claude Code on 2026-08-18.
//

import Cocoa

// MARK: - Space Placement for Menu Bar Windows
extension NSWindow {
    /// Makes the window appear on every Space, including another app's full-screen Space.
    ///
    /// A status bar popover does not get this from AppKit: its backing window is created
    /// with `.ignoresCycle` only, which leaves the window manager free to keep the popover
    /// on the Space this accessory agent occupies — the desktop — so a click made while
    /// another app is full-screen appears to do nothing until the user switches back.
    ///
    /// The backing window exists only while the popover is showing, so this has to be
    /// called on `contentViewController?.view.window` after
    /// `show(relativeTo:of:preferredEdge:)`.
    ///
    /// Collection behavior outside the Spaces group is preserved, and repeated calls are
    /// a no-op. `.moveToActiveSpace` is cleared, since it conflicts with
    /// `.canJoinAllSpaces`.
    func enableDisplayOnFullScreenSpaces() {
        // AppKit raises on a window carrying two Spaces behaviors, so the conflicting one
        // has to be cleared before the new one is inserted.
        collectionBehavior.remove(.moveToActiveSpace)

        // `.canJoinAllSpaces` covers ordinary Spaces; a full-screen Space admits another
        // app's window only with `.fullScreenAuxiliary`, so both are required.
        collectionBehavior.insert([.canJoinAllSpaces, .fullScreenAuxiliary])
    }
}
