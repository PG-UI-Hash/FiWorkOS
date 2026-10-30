import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Pratham 1.0

Window {
    id: dockWindow
    width: 690
    height: 104
    x: (Screen.width - width) / 2
    y: Screen.height - height - 18
    visible: true
    color: "transparent"
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    title: "PrathamOS Dock"

    Pds { id: pds }
    AppLauncher { id: appLauncher }
    Panel { }

    function launch(command) { appLauncher.launch(command) }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 7
        radius: 25
        color: "#E8101B30"
        border.color: "#4455A5FF"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 17
            anchors.rightMargin: 17
            spacing: 11

            Rectangle {
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                radius: 15
                color: pds.blue
                Text {
                    anchors.centerIn: parent
                    text: "P"
                    color: "white"
                    font.pixelSize: 29
                    font.weight: Font.DemiBold
                }
                MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; onClicked: launcher.visible = !launcher.visible }
                ToolTip.visible: ma.containsMouse
                ToolTip.text: "Pratham Launcher"
            }

            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 35; color: "#405A7294" }

            Repeater {
                model: [
                    { label: "Terminal", glyph: ">_", command: "x-terminal-emulator" },
                    { label: "Files", glyph: "▤", command: "xdg-open ~" },
                    { label: "Browser", glyph: "◎", command: "xdg-open https://www.google.com" },
                    { label: "Settings", glyph: "⚙", command: "gnome-control-center" }
                ]
                delegate: Rectangle {
                    Layout.preferredWidth: 53
                    Layout.preferredHeight: 58
                    radius: 14
                    color: mouse.containsMouse ? "#332864E8" : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: modelData.glyph
                        color: pds.cloud
                        font.pixelSize: 25
                        font.family: "Inter"
                    }
                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (modelData.label === "Files") appLauncher.openUrl("file:///home");
                            else if (modelData.label === "Browser") appLauncher.openUrl("https://www.google.com");
                            else appLauncher.launch(modelData.command)
                        }
                    }
                    ToolTip.visible: mouse.containsMouse
                    ToolTip.text: modelData.label
                }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                Layout.preferredWidth: 46
                Layout.preferredHeight: 46
                radius: 14
                color: "#222864E8"
                Text { anchors.centerIn: parent; text: "⌘"; color: pds.electric; font.pixelSize: 23 }
                MouseArea { anchors.fill: parent; onClicked: launcher.visible = !launcher.visible }
                ToolTip.visible: shortcutMouse.containsMouse
                ToolTip.text: "Applications"
                MouseArea { id: shortcutMouse; anchors.fill: parent; hoverEnabled: true; onClicked: launcher.visible = !launcher.visible }
            }
        }
    }

    Launcher {
        id: launcher
        x: (dockWindow.width - width) / 2
        y: -height - 12
        visible: false
        onRequestClose: visible = false
    }
}