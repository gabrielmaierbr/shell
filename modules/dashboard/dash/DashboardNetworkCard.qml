import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import Caelestia.Internal
import qs.components
import qs.components.misc
import qs.services

StyledRect {
    id: networkCard

    implicitWidth: 260

    property color accentColor: Colours.palette.m3primary

    color: Colours.tPalette.m3surfaceContainer
    radius: Tokens.rounding.large
    clip: true

    Ref {
        service: NetworkUsage
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Tokens.padding.large
        spacing: Tokens.spacing.small

        CardHeader {
            icon: "swap_vert"
            title: qsTr("Rede de Internet")
            accentColor: networkCard.accentColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 56

            SparklineItem {
                id: sparkline

                property real targetMax: 1024
                property real smoothMax: targetMax

                anchors.fill: parent
                line1: NetworkUsage.uploadBuffer // qmllint disable missing-type
                line1Color: Colours.palette.m3secondary
                line1FillAlpha: 0.15
                line2: NetworkUsage.downloadBuffer // qmllint disable missing-type
                line2Color: Colours.palette.m3tertiary
                line2FillAlpha: 0.2
                maxValue: smoothMax
                historyLength: NetworkUsage.historyLength

                Connections {
                    function onValuesChanged(): void {
                        sparkline.targetMax = Math.max(NetworkUsage.downloadBuffer.maximum, NetworkUsage.uploadBuffer.maximum, 1024);
                        slideAnim.restart();
                    }

                    target: NetworkUsage.downloadBuffer
                }

                NumberAnimation {
                    id: slideAnim

                    target: sparkline
                    property: "slideProgress"
                    from: 0
                    to: 1
                    duration: GlobalConfig.dashboard.resourceUpdateInterval
                }

                Behavior on smoothMax {
                    Anim {
                        type: Anim.StandardLarge
                    }
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: qsTr("Coletando dados...")
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
                visible: NetworkUsage.downloadBuffer.count < 2
                opacity: 0.6
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            MaterialIcon {
                text: "download"
                color: Colours.palette.m3tertiary
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                text: qsTr("Download")
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: {
                    const fmt = NetworkUsage.formatBytes(NetworkUsage.downloadSpeed ?? 0);
                    return fmt ? `${fmt.value.toFixed(1)} ${fmt.unit}` : "0.0 B/s";
                }
                font.pointSize: Tokens.font.size.normal
                font.weight: Font.Medium
                color: Colours.palette.m3tertiary
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            MaterialIcon {
                text: "upload"
                color: Colours.palette.m3secondary
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                text: qsTr("Upload")
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: {
                    const fmt = NetworkUsage.formatBytes(NetworkUsage.uploadSpeed ?? 0);
                    return fmt ? `${fmt.value.toFixed(1)} ${fmt.unit}` : "0.0 B/s";
                }
                font.pointSize: Tokens.font.size.normal
                font.weight: Font.Medium
                color: Colours.palette.m3secondary
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            MaterialIcon {
                text: "history"
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                text: qsTr("Total")
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: {
                    const down = NetworkUsage.formatBytesTotal(NetworkUsage.downloadTotal ?? 0);
                    const up = NetworkUsage.formatBytesTotal(NetworkUsage.uploadTotal ?? 0);
                    return (down && up) ? `↓${down.value.toFixed(1)}${down.unit} ↑${up.value.toFixed(1)}${up.unit}` : "↓0.0B ↑0.0B";
                }
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }
        }
    }

    component CardHeader: RowLayout {
        property string icon
        property string title
        property color accentColor: Colours.palette.m3primary

        Layout.fillWidth: true
        spacing: Tokens.spacing.small

        MaterialIcon {
            text: parent.icon
            fill: 1
            color: parent.accentColor
            font.pointSize: Tokens.spacing.large
        }

        StyledText {
            Layout.fillWidth: true
            text: parent.title
            font.pointSize: Tokens.font.size.normal
            elide: Text.ElideRight
        }
    }
}
