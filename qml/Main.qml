import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 500
    minimumWidth: 480
    minimumHeight: 360
    title: "DDM-sync"
    color: "#f4f6f8"

    property string statusMode: "ready"
    property string dialogTitle: ""
    property string dialogMessage: ""

    Rectangle {
        anchors.fill: parent
        color: "#f4f6f8"

        Rectangle {
            id: panel
            anchors.centerIn: parent
            width: Math.min(parent.width - 48, 560)
            height: Math.min(parent.height - 48, content.implicitHeight + 64)
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
                    bottom: parent.bottom
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
                        color: window.statusMode === "error" ? "#c2410c" : (window.statusMode === "success" ? "#15803d" : "#64748b")
                        anchors {
                            left: parent.left
                            verticalCenter: syncButton.verticalCenter
                        }
                    }

                    Label {
                        id: statusLabel
                        text: "Ready to sync"
                        color: window.statusMode === "error" ? "#9a3412" : "#334155"
                        font.pixelSize: 14
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        anchors {
                            left: statusDot.right
                            leftMargin: 12
                            right: syncButton.left
                            rightMargin: 20
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
                            syncButton.enabled = false
                            statusLabel.text = "Waiting for authorization"
                            window.statusMode = "ready"

                            var rawResult = backend.sync()
                            var failed = rawResult.indexOf("ERROR|") === 0
                            var result = rawResult.replace(/^OK\|/, "").replace(/^ERROR\|/, "")

                            statusLabel.text = failed ? "Sync failed" : "Sync completed"
                            window.statusMode = failed ? "error" : "success"
                            syncButton.enabled = true

                            window.dialogTitle = failed ? "Sync failed" : "Sync completed"
                            window.dialogMessage = result
                            resultDialog.open()
                        }
                    }
                }

                Label {
                    id: detailLabel
                    text: statusLabel.text === "Ready to sync" ? "" : statusLabel.text
                    visible: text.length > 0
                    width: parent.width
                    color: window.statusMode === "error" ? "#9a3412" : "#475569"
                    font.pixelSize: 13
                    wrapMode: Text.WordWrap
                    topPadding: 2
                }
            }
        }
    }

    Dialog {
        id: resultDialog
        modal: true
        title: window.dialogTitle
        standardButtons: Dialog.Ok
        anchors.centerIn: parent
        width: Math.min(parent.width - 48, 460)

        contentItem: Label {
            text: window.dialogMessage
            color: window.statusMode === "error" ? "#9a3412" : "#334155"
            font.pixelSize: 14
            wrapMode: Text.WordWrap
            width: parent.width
        }
    }
}
