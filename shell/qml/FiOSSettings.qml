import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Pratham 1.0

Window {
    id: root
    width: 620
    height: 570
    minimumWidth: 560
    minimumHeight: 520
    visible: false
    color: "transparent"
    title: "FiOS Settings"
    flags: Qt.Window

    AppLauncher { id: apps }

    Rectangle {
        anchors.fill: parent
        radius: 25
        color: "#F0101B30"
        border.color: "#6655A5FF"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 26
            spacing: 18

            RowLayout {
                spacing: 14
                Rectangle {
                    Layout.preferredWidth: 52
                    Layout.preferredHeight: 52
                    radius: 16
                    color: "#2864E8"
                    Text { anchors.centerIn: parent; text: "Φ"; color: "white"; font.pixelSize: 34; font.weight: Font.DemiBold }
                }
                ColumnLayout {
                    spacing: 2
                    Text { text: "FiOS Settings"; color: "#F5F7FB"; font.pixelSize: 24; font.weight: Font.DemiBold }
                    Text { text: "Your system, under your control."; color: "#B8C3D4"; font.pixelSize: 12 }
                }
                Item { Layout.fillWidth: true }
                ToolButton { text: "✕"; onClicked: root.close() }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "#405A7294"
            }

            Text { text: "QUICK CONTROLS"; color: "#8FA4C2"; font.pixelSize: 10; font.letterSpacing: 2 }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                Repeater {
                    model: [
                        ["Wi-Fi On", "Enable wireless networking", "nmcli radio wifi on", "◉"],
                        ["Wi-Fi Off", "Disable wireless networking", "nmcli radio wifi off", "○"],
                        ["Volume Up", "Raise output volume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+", "＋"],
                        ["Volume Down", "Lower output volume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", "−"],
                        ["Mute Audio", "Toggle output mute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", "♪"],
                        ["Brightness Up", "Increase screen brightness", "brightnessctl set 5%+", "☼"],
                        ["Brightness Down", "Decrease screen brightness", "brightnessctl set 5%-", "☾"],
                        ["Bluetooth", "Open Bluetooth controls", "foot -e bluetoothctl", "ᛒ"]
                    ]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 68
                        radius: 13
                        color: actionMouse.containsMouse ? "#332864E8" : "#202B3F5D"
                        border.color: "#334F6D99"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 13
                            anchors.rightMargin: 10
                            spacing: 11
                            Text { text: modelData[3]; color: "#55A5FF"; font.pixelSize: 23; Layout.preferredWidth: 25; horizontalAlignment: Text.AlignHCenter }
                            ColumnLayout {
                                spacing: 2
                                Text { text: modelData[0]; color: "#F5F7FB"; font.pixelSize: 12; font.weight: Font.DemiBold }
                                Text { text: modelData[1]; color: "#B8C3D4"; font.pixelSize: 10 }
                            }
                            Item { Layout.fillWidth: true }
                            Text { text: "›"; color: "#8FA4C2"; font.pixelSize: 20 }
                        }
                        MouseArea {
                            id: actionMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: apps.launch(modelData[2])
                        }
                    }
                }
            }

            Text { text: "SYSTEM"; color: "#8FA4C2"; font.pixelSize: 10; font.letterSpacing: 2 }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                Repeater {
                    model: [
                        ["Appearance", "nwg-look"],
                        ["System Monitor", "foot -e btop"],
                        ["Update System", "foot -e sudo pacman -Syu"]
                    ]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        radius: 12
                        color: systemMouse.containsMouse ? "#332864E8" : "#202B3F5D"
                        Text { anchors.centerIn: parent; text: modelData[0]; color: "#F5F7FB"; font.pixelSize: 11 }
                        MouseArea { id: systemMouse; anchors.fill: parent; hoverEnabled: true; onClicked: apps.launch(modelData[1]) }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Text { text: "FiOS 0.1.0"; color: "#8FA4C2"; font.pixelSize: 10 }
                Item { Layout.fillWidth: true }
                Text { text: "By Pratham Tech."; color: "#8FA4C2"; font.pixelSize: 10 }
            }
        }
    }
}
