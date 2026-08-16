import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 500
    title: "DDM-sync"

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Welcome to the ddm-sync synchronizer."
            font.pixelSize: 32
        }

        Button {
            text: "点击我"

            onClicked: {
                console.log("Hello from QML!")
            }
        }
    }
}