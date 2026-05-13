import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

StyledRect {
    id: card

    required property string icon
    required property string title
    required property real usage
    required property real temperature
    required property color accentColor

    property real usageAnimated: 0
    property real tempAnimated: 0
    readonly property real tempProgress: Math.min(1, Math.max(0, temperature / 100))

    radius: Tokens.rounding.large
    color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 2)

    Component.onCompleted: {
        usageAnimated = usage;
        tempAnimated = tempProgress;
    }
    onUsageChanged: usageAnimated = usage
    onTempProgressChanged: tempAnimated = tempProgress

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - Tokens.padding.large * 2
        spacing: Tokens.spacing.small

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: card.icon
                color: card.accentColor
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                Layout.fillWidth: true
                text: card.title
                elide: Text.ElideRight
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                text: `${Math.round(card.usage * 100)}%`
                color: card.accentColor
                font.pointSize: Tokens.font.size.normal
                font.weight: Font.Medium
            }
        }

        StyledRect {
            Layout.fillWidth: true
            implicitHeight: 6
            radius: Tokens.rounding.full
            color: Qt.alpha(card.accentColor, 0.2)

            StyledRect {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * card.usageAnimated
                radius: Tokens.rounding.full
                color: card.accentColor
            }
        }

        Item { Layout.preferredHeight: Tokens.padding.large }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            StyledText {
                text: qsTr("Temperatura")
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Tokens.font.size.small
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: `${Math.round(card.temperature)}°C`
                color: card.accentColor
                font.pointSize: Tokens.font.size.small
                font.weight: Font.Medium
            }
        }

        StyledRect {
            Layout.fillWidth: true
            implicitHeight: 4
            radius: Tokens.rounding.full
            color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 2)

            StyledRect {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * card.tempAnimated
                radius: Tokens.rounding.full
                color: Qt.alpha(card.accentColor, 0.75)
            }
        }
    }

    Behavior on usageAnimated {
        Anim {
            type: Anim.StandardLarge
        }
    }

    Behavior on tempAnimated {
        Anim {
            type: Anim.StandardLarge
        }
    }
}
