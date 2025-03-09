import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.0

import "./components"

Rectangle {
    id: root

    height: Screen.height
    width: Screen.width

    // Cursor visibility control
    MouseArea {
        id: cursorArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.BlankCursor

        onPositionChanged: {
            cursorShape = Qt.ArrowCursor
            cursorTimer.restart()
        }

        Timer {
            id: cursorTimer
            interval: 500
            onTriggered: cursorArea.cursorShape = Qt.BlankCursor
        }
    }

    // Original background image
    Image {
        id: background
        anchors.fill: parent
        source: config.BgSource
        fillMode: Image.PreserveAspectCrop
        clip: true
        visible: true
    }

    // Your existing UI components
    Item {
        anchors {
            fill: parent
            margins: config.Padding
        }

        DateTimePanel {
            anchors {
                top: parent.top
                right: parent.right
            }
        }

        LoginPanel {
            anchors { fill: parent }
        }
    }
}
