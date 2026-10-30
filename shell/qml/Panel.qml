import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    width: Screen.width
    height: 38
    x: 0
    y: 0
    visible: true
    color: "transparent"
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

    Rectangle {
        anchors.fill: parent
        color: "#E8101B30"
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            Text { text: "FiOS"; color: "#F5F7FB"; font.pixelSize: 13; font.weight: Font.DemiBold }
            Text { text: "Activities"; color: "#B8C3D4"; font.pixelSize: 12 }
            Item { Layout.fillWidth: true }
            Text { text: Qt.formatDateTime(new Date(), "ddd  dd MMM"); color: "#B8C3D4"; font.pixelSize: 12 }
            Text { text: Qt.formatTime(new Date(), "hh:mm"); color: "#F5F7FB"; font.pixelSize: 13; font.weight: Font.DemiBold }
            Text { text: "  ◉  ◖  ▰"; color: "#B8C3D4"; font.pixelSize: 12 }
        }
    }
}
