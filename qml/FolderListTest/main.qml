// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0
import Qt.labs.folderlistmodel 1.0

Rectangle
{
    property string appParam: "file:///."
    id: baseView
    width: 640
    height: 360
    focus: baseView.state===""

 //   color: "black"

    Keys.onRightPressed: view.incrementCurrentIndex()
    Keys.onLeftPressed: view.decrementCurrentIndex()
    Keys.onDownPressed: { imageView.source = view.currentItem.source;imageView.prevState = "";baseView.state = "BigImage" }
    Keys.onEscapePressed: {Qt.quit()}

    FolderListModel {
        id: imageFolderModel
        nameFilters: [ "*.JPG", "*.jpg" ,"*.jpeg", "*.png"]
        folder: appParam
        showDirs: false
        sortField: FolderListModel.Name
    }

    ListView {
        id: view
        anchors.fill: parent
        opacity: (baseView.state==="")?1:0

        orientation: ListView.Horizontal
        highlightMoveDuration: 400
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: view.width/2 - view.currentItem.width/2
        preferredHighlightEnd: view.width/2 + view.currentItem.width/2
        snapMode: ListView.SnapToItemItem
        cacheBuffer: width * 4
        Binding {
             target: view; property: 'model'
             value: imageFolderModel; when: (baseView.state==="" && baseView.appParam!="")
        }

        delegate: Image {
            source: filePath
            width: (status != Image.Ready) ? view.width :paintedWidth
            height: view.height
            opacity: ListView.isCurrentItem ? 1: 0.8
            smooth: true
            sourceSize.height: view.height
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            MouseArea{
                anchors.fill: parent;
                acceptedButtons: { acceptedButtons: Qt.LeftButton | Qt.MiddleButton }
                onClicked: {
                    if(mouse.button === Qt.MiddleButton)
                        baseView.state = "GridView"

                }
                onDoubleClicked: {
                    if(mouse.button === Qt.LeftButton) {
                        imageView.source = filePath;
                        imageView.prevState = ""
                        baseView.state = "BigImage"
                    }
                }
            }
            Behavior on opacity{
                NumberAnimation { duration: 600 }
            }
        }
        Behavior on opacity{
            NumberAnimation { duration: 400 }
        }

    }
    GridView{
        id: gridView
        opacity: (baseView.state==="GridView")?1:0
        anchors.fill: parent
        Binding {
             target: gridView; property: 'model'
             value: imageFolderModel; when: (baseView.state==="GridView" && baseView.appParam!="")
        }

        cellWidth: 256; cellHeight: 256
        //cacheBuffer: width * height* 4
        delegate:
            Rectangle {
                width: gridView.cellWidth-4; height: gridView.cellHeight-4
                x:2; y:2
                border.color: "black"
                radius: 5
            Image {
                source: filePath
                anchors.fill: parent
                anchors.margins: 2
                smooth: true
                opacity: GridView.isCurrentItem ? 1: 0.8
                fillMode: Image.PreserveAspectFit
                sourceSize.height: gridView.cellHeight-8
                asynchronous: true
                MouseArea{
                    anchors.fill: parent;
                    acceptedButtons: { acceptedButtons: Qt.LeftButton | Qt.MiddleButton }
                    onDoubleClicked: {
                        if(mouse.button === Qt.LeftButton) {
                            imageView.source = filePath;
                            imageView.prevState = "GridView"
                            baseView.state = "BigImage"
                        }
                    }
                    onClicked: {
                        if(mouse.button === Qt.MiddleButton)
                            baseView.state = ""
                    }
                }
            }
        }
    }
    Rectangle {
        id:imageView
        property alias source: picture.source
        property string prevState: ""
        color: "black"
        visible: (baseView.state==="BigImage")?1:0

        anchors.fill: parent
        focus: baseView.state==="BigImage"

        Flickable {
            anchors.fill: parent

            contentWidth: Math.max(picture.width, width)
            contentHeight: Math.max(picture.height, height)
            contentX:contentWidth/2 - imageView.width/2
            contentY:contentHeight/2 - imageView.height/2

            Image {
                id: picture
                asynchronous: true
                smooth: true
                sourceSize.width: imageView.width
                x:parent.width/2 - picture.width/2
                y:parent.height/2 - picture.height/2
                MouseArea{
                    anchors.fill: parent;
                    onDoubleClicked: baseView.state = imageView.prevState
                }
            }

        }
        Keys.onLeftPressed: {
            picture.width = picture.width*0.95;
            picture.height = picture.height*0.95;
            event.accepted = true;
        }
        Keys.onRightPressed: {
            picture.width = picture.width*1.05;
            picture.height = picture.height*1.05;
            event.accepted = true
        }
        Keys.onEscapePressed: { baseView.state = imageView.prevState }
        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }
    }

    states: [
        State {
            name: "GridView"
        },
        State {
            name: "BigImage"
        }
    ]
    transitions: Transition {
        NumberAnimation {properties: "opacity"; duration: 400}
    }
}
