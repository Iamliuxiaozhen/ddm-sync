import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 500
    minimumWidth: 480
    minimumHeight: 360
    title: "DDM-sync"
    color: "#f4f6f8"

    Rectangle {
        anchors.fill: parent
        color: "#f4f6f8"

        Rectangle {
            id: panel
            anchors.centerIn: parent
            width: Math.min(parent.width - 48, 560)
            height: content.implicitHeight + 64
            radius: 10
            color: "#ffffff"
            border.color: "#e1e6eb"
            border.width: 1

            Column {
                id: content
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: 32
                }
                spacing: 0

                Label {
                    text: "DDM-SYNC"
                    color: "#64748b"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    font.letterSpacing: 1.4
                }

                Label {
                    text: "Synchronize your display manager"
                    color: "#17212b"
                    font.pixelSize: 28
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                    width: parent.width
                    topPadding: 8
                }

                Label {
                    text: "Keep GDM3 and SDDM aligned with your desktop layout."
                    color: "#64748b"
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                    width: parent.width
                    topPadding: 8
                    bottomPadding: 28
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#edf0f2"
                }

                Item {
                    width: parent.width
                    height: 66

                    Rectangle {
                        id: statusDot
                        width: 9
                        height: 9
                        radius: 5
                        color: "#22a06b"
                        anchors {
                            left: parent.left
                            verticalCenter: syncButton.verticalCenter
                        }
                    }

                    Label {
                        id: statusLabel
                        text: "Ready to sync"
                        color: "#334155"
                        font.pixelSize: 14
                        anchors {
                            left: statusDot.right
                            leftMargin: 12
                            verticalCenter: syncButton.verticalCenter
                        }
                    }

                    Button {
                        id: syncButton
                        text: "Sync"
                        width: 112
                        height: 42
                        anchors {
                            right: parent.right
                            top: parent.top
                            topMargin: 24
                        }

                        contentItem: Text {
                            text: syncButton.text
                            color: syncButton.down ? "#ffffff" : "#ffffff"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            radius: 6
                            color: syncButton.down ? "#176b4a" : (syncButton.hovered ? "#21895d" : "#1d7f56")
                        }

                        onClicked: {
                            statusLabel.text = "Sync request sent"
                            console.log("Sync requested")
                        }
                    }
                }
            }
        }
    }
}
