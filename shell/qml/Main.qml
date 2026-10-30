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
    title: "FiOS Dock"

    Pds { id: pds }
    AppLauncher { id: appLauncher }
    Panel { }

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
                    text: "Φ"
                    color: "white"
                    font.pixelSize: 30
                    font.weight: Font.DemiBold
                }
                MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; onClicked: launcher.visible = !launcher.visible }
                ToolTip.visible: ma.containsMouse
                ToolTip.text: "FiOS Launcher"
            }

            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 35; color: "#405A7294" }

            Repeater {
                model: [
                    { label: "Terminal", glyph: ">_", command: "foot" },
                    { label: "Files", glyph: "▤", command: "thunar" },
                    { label: "Browser", glyph: "◎", command: "firefox" },
                    { label: "Settings", glyph: "⚙", command: "nwg-look" }
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
                        onClicked: appLauncher.launch(modelData.command)
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
                Text { anchors.centerIn: parent; text: "Φ"; color: pds.electric; font.pixelSize: 25 }
                MouseArea { id: shortcutMouse; anchors.fill: parent; hoverEnabled: true; onClicked: launcher.visible = !launcher.visible }
                ToolTip.visible: shortcutMouse.containsMouse
                ToolTip.text: "Applications"
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
