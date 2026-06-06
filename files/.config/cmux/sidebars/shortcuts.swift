VStack(alignment: .leading, spacing: 14) {
    Text("Shortcuts")
        .font(.headline)
    Divider()

    VStack(alignment: .leading, spacing: 6) {
        Text("Pane Focus")
            .font(.caption)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
        HStack { Text("⌥⌘ ← → ↑ ↓").monospaced().bold(); Spacer(); Text("Move focus").foregroundColor(.secondary) }
        HStack { Text("⌘ [ / ⌘ ]").monospaced().bold(); Spacer(); Text("History").foregroundColor(.secondary) }
    }

    VStack(alignment: .leading, spacing: 6) {
        Text("Splits")
            .font(.caption)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
        HStack { Text("⌘ D").monospaced().bold(); Spacer(); Text("Split right").foregroundColor(.secondary) }
        HStack { Text("⌘ ⇧ D").monospaced().bold(); Spacer(); Text("Split down").foregroundColor(.secondary) }
        HStack { Text("⌘ ⇧ ↩").monospaced().bold(); Spacer(); Text("Zoom toggle").foregroundColor(.secondary) }
        HStack { Text("⌃ ⌘ =").monospaced().bold(); Spacer(); Text("Equalize").foregroundColor(.secondary) }
    }

    VStack(alignment: .leading, spacing: 6) {
        Text("Tabs")
            .font(.caption)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
        HStack { Text("⌘ T").monospaced().bold(); Spacer(); Text("New tab").foregroundColor(.secondary) }
        HStack { Text("⌥ ⌘ T").monospaced().bold(); Spacer(); Text("Close others").foregroundColor(.secondary) }
        HStack { Text("⌘ ⇧ T").monospaced().bold(); Spacer(); Text("Reopen closed").foregroundColor(.secondary) }
    }

    Spacer()
}
.padding(10)
