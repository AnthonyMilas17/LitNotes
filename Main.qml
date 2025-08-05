import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 800
    height: 600
    visible: true
    title: "LitNotes"

    TextArea {
        id: noteEditor
        anchors.fill: parent
        wrapMode: TextArea.Wrap
        placeholderText: "Start typing your note here..."
        font.pixelSize: 18
        padding: 12
        z: 0
    }

    Canvas {
        id: drawCanvas
        anchors.fill: parent
        z: 1

        property bool drawing: false
        property var lastPoint: undefined

        onPaint: {
            // Only used for initialization
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onPressed: (mouse) => {
                drawCanvas.drawing = true;
                drawCanvas.lastPoint = { x: mouse.x, y: mouse.y };
            }

            onPositionChanged: (mouse) => {
                if (drawCanvas.drawing && drawCanvas.lastPoint) {
                    const ctx = drawCanvas.getContext("2d");
                    ctx.lineWidth = 2;
                    ctx.strokeStyle = "red";
                    ctx.lineCap = "round";
                    ctx.lineJoin = "round";

                    ctx.beginPath();
                    ctx.moveTo(drawCanvas.lastPoint.x, drawCanvas.lastPoint.y);
                    ctx.lineTo(mouse.x, mouse.y);
                    ctx.stroke();

                    drawCanvas.lastPoint = { x: mouse.x, y: mouse.y };
                    drawCanvas.markDirty();  // tells Qt this region changed
                }
            }

            onReleased: () => {
                drawCanvas.drawing = false;
                drawCanvas.lastPoint = undefined;
            }
        }

        Component.onCompleted: {
            drawCanvas.requestPaint();  // Initializes backing store
        }
    }

    Button {
        text: "Clear Drawing"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 12
        z: 2

        onClicked: {
            const ctx = drawCanvas.getContext("2d");
            ctx.clearRect(0, 0, drawCanvas.width, drawCanvas.height);
            drawCanvas.lastPoint = undefined;
            drawCanvas.requestPaint();
        }
    }
}
