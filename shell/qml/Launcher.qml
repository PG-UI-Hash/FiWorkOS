import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Pratham 1.0

Rectangle {
    id: root
    signal requestClose()
    AppLauncher { id: appLauncher }
    width: 510
    height: 430
    radius: 25
    color: "#F0101B30"
    border.color: "#5555A5FF"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 17

        RowLayout {
            Text { text: "Applications"; color: "#F5F7FB"; font.pixelSize: 23; font.weight: Font.DemiBold }
            Item { Layout.fillWidth: true }
            ToolButton { text: "✕"; onClicked: root.requestClose() }
        }

        TextField {
            id: search
            Layout.fillWidth: true
            placeholderText: "Search applications"
            color: "#F5F7FB"
            placeholderTextColor: "#B8C3D4"
            background: Rectangle { radius: 12; color: "#252B3A4D"; border.color: "#4455A5FF" }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 12
            columnSpacing: 12

            Repeater {
                model: [
                    ["Terminal", ">_", "x-terminal-emulator"],
                    ["Files", "▤", "xdg-open /home"],
                    ["Web", "◎", "xdg-open https://www.google.com"],
                    ["System Monitor", "◷", "gnome-system-monitor"],
                    ["Settings", "⚙", "gnome-control-center"],
                    ["Software", "＋", "gnome-software"]
                ]
                delegate: Rectangle {
                    property bool match: modelData[0].toLowerCase().includes(search.text.toLowerCase())
                    Layout.fillWidth: true
                    Layout.preferredHeight: 91
                    radius: 15
                    color: "#182B3F5D"
                    visible: match
                    Text { anchors.centerIn: parent; text: modelData[1]; color: "#55A5FF"; font.pixelSize: 28 }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 10; text: modelData[0]; color: "#F5F7FB"; font.pixelSize: 12 }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (modelData[0] === "Files") appLauncher.openUrl("file:///home");
                            else if (modelData[0] === "Web") appLauncher.openUrl("https://www.google.com");
                            else appLauncher.launch(modelData[2])
                            root.requestClose()
                        }
                    }
                }
            }
        }
        Item { Layout.fillHeight: true }
        Text { text: "PRATHAMOS  •  PDS"; color: "#8FA4C2"; font.pixelSize: 10; font.letterSpacing: 2 }
    }
}