import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    anchors.fill: parent
    anchors.margins: Tokens.padding.large

    Component.onCompleted: Weather.reload()

    RowLayout {
        anchors.fill: parent

        Item {
            Layout.fillWidth: true
        }

        Row {
            id: row

            Layout.alignment: Qt.AlignVCenter
            spacing: Tokens.spacing.large

            MaterialIcon {
                id: icon

                anchors.verticalCenter: parent.verticalCenter

                animate: true
                text: Weather.icon
                color: Colours.palette.m3secondary
                font.pointSize: Tokens.font.size.extraLarge * 2
            }

            Column {
                id: info

                anchors.verticalCenter: parent.verticalCenter
                spacing: Tokens.spacing.small

                StyledText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    animate: true
                    text: Weather.temp
                    color: Colours.palette.m3primary
                    font.pointSize: Tokens.font.size.extraLarge * 1.08
                    font.weight: 500
                }

                StyledText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    animate: true
                    text: Weather.description
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: Tokens.font.size.normal
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, root.width - root.anchors.margins * 2 - row.spacing - icon.width)
                }

                StyledText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    animate: true
                    text: Weather.city || qsTr("Cidade desconhecida")
                    horizontalAlignment: Text.AlignHCenter
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Tokens.font.size.small
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, root.width - root.anchors.margins * 2 - row.spacing - icon.width)
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }
    }
}
