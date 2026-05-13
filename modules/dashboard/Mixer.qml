import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Caelestia.Services
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services

Item {
    id: root

    implicitWidth: Math.max(1000, content.implicitWidth)
    implicitHeight: content.implicitHeight

    ButtonGroup {
        id: sinksGroup
    }

    ButtonGroup {
        id: sourcesGroup
    }

    ColumnLayout {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Tokens.spacing.normal

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            StyledRect {
                Layout.fillWidth: true
                Layout.preferredWidth: 60
                Layout.fillHeight: true
                implicitHeight: devicesColumn.implicitHeight + Tokens.padding.large * 2

                radius: Tokens.rounding.large
                color: Colours.tPalette.m3surfaceContainer

                ColumnLayout {
                    id: devicesColumn
                    anchors.fill: parent
                    anchors.margins: Tokens.padding.large
                    spacing: Tokens.spacing.normal

                    StyledText {
                        text: qsTr("Dispositivo de Saída")
                        font.weight: Font.Medium
                        color: Colours.palette.m3onSurface
                    }

                    Repeater {
                        model: Audio.sinks

                        StyledRadioButton {
                            required property var modelData

                            ButtonGroup.group: sinksGroup
                            checked: Audio.sink?.id === modelData.id
                            onClicked: Audio.setAudioSink(modelData)
                            text: modelData.description || qsTr("Desconhecido")
                        }
                    }

                    StyledText {
                        Layout.topMargin: Tokens.spacing.small
                        text: qsTr("Dispositivo de Entrada")
                        font.weight: Font.Medium
                        color: Colours.palette.m3onSurface
                    }

                    Repeater {
                        model: Audio.sources

                        StyledRadioButton {
                            required property var modelData

                            ButtonGroup.group: sourcesGroup
                            checked: Audio.source?.id === modelData.id
                            onClicked: Audio.setAudioSource(modelData)
                            text: modelData.description || qsTr("Desconhecido")
                        }
                    }
                    
                    Item { Layout.fillHeight: true }
                }
            }

            StyledRect {
                Layout.fillWidth: true
                Layout.preferredWidth: 40
                Layout.fillHeight: true
                implicitHeight: volumesColumn.implicitHeight + Tokens.padding.large * 4

                radius: Tokens.rounding.large
                color: Colours.tPalette.m3surfaceContainer

                ColumnLayout {
                    id: volumesColumn
                    anchors.centerIn: parent
                    width: parent.width - Tokens.padding.large * 4
                    spacing: Tokens.spacing.normal

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Tokens.spacing.small

                        MaterialIcon {
                            text: Audio.muted ? "volume_off" : "volume_up"
                            font.pointSize: Tokens.font.size.large
                            color: Colours.palette.m3onSurface
                        }

                        StyledText {
                            text: qsTr("Sistema")
                            font.weight: Font.Medium
                            color: Colours.palette.m3onSurface
                        }

                        Item { Layout.fillWidth: true }

                        StyledText {
                            text: `${Math.round(Audio.volume * 100)}%`
                            font.weight: Font.Medium
                            color: Colours.palette.m3primary
                        }
                    }

                    StyledSlider {
                        Layout.fillWidth: true
                        implicitHeight: Tokens.padding.normal * 3
                        value: Audio.volume
                        onMoved: Audio.setVolume(value)
                    }

                    Item { Layout.preferredHeight: Tokens.spacing.large }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Tokens.spacing.small

                        MaterialIcon {
                            text: Audio.sourceMuted ? "mic_off" : "mic"
                            font.pointSize: Tokens.font.size.large
                            color: Colours.palette.m3onSurface
                        }

                        StyledText {
                            text: qsTr("Microfone")
                            font.weight: Font.Medium
                            color: Colours.palette.m3onSurface
                        }

                        Item { Layout.fillWidth: true }

                        StyledText {
                            text: `${Math.round(Audio.sourceVolume * 100)}%`
                            font.weight: Font.Medium
                            color: Colours.palette.m3primary
                        }
                    }

                    StyledSlider {
                        Layout.fillWidth: true
                        implicitHeight: Tokens.padding.normal * 3
                        value: Audio.sourceVolume
                        onMoved: Audio.setSourceVolume(value)
                    }
                }
            }
        }

        StyledRect {
            Layout.fillWidth: true
            radius: Tokens.rounding.large
            color: Colours.tPalette.m3surfaceContainer
            implicitHeight: mixerColumn.implicitHeight + Tokens.padding.large * 2

            ColumnLayout {
                id: mixerColumn
                anchors.fill: parent
                anchors.margins: Tokens.padding.large
                spacing: Tokens.spacing.normal

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Tokens.spacing.small

                    MaterialIcon {
                        text: "equalizer"
                        color: Colours.palette.m3primary
                        font.pointSize: Tokens.font.size.large
                    }

                    StyledText {
                        text: qsTr("Mixer de Áudio")
                        font.pointSize: Tokens.font.size.large
                        font.weight: Font.Medium
                        color: Colours.palette.m3onSurface
                    }

                    Item { Layout.fillWidth: true }
                }

                Repeater {
                    model: Audio.streams

                    delegate: ColumnLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: Tokens.spacing.smaller

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Tokens.spacing.normal

                            MaterialIcon {
                                text: "apps"
                                font.pointSize: Tokens.font.size.normal
                                color: Colours.palette.m3secondary
                            }

                            StyledText {
                                Layout.fillWidth: true
                                text: Audio.getStreamName(modelData)
                                font.pointSize: Tokens.font.size.normal
                                elide: Text.ElideRight
                            }

                            StyledText {
                                text: `${Math.round(Audio.getStreamVolume(modelData) * 100)}%`
                                color: Colours.palette.m3primary
                                font.pointSize: Tokens.font.size.normal
                                font.weight: Font.Medium
                            }

                            IconButton {
                                icon: Audio.getStreamMuted(modelData) ? "volume_off" : "volume_up"
                                color: Audio.getStreamMuted(modelData) ? Colours.palette.m3error : Colours.palette.m3primary
                                onClicked: Audio.setStreamMuted(modelData, !Audio.getStreamMuted(modelData))
                            }
                        }

                        StyledSlider {
                            id: appSlider
                            Layout.fillWidth: true
                            implicitHeight: Tokens.padding.normal * 3
                            value: Audio.getStreamVolume(modelData)
                            enabled: !Audio.getStreamMuted(modelData)
                            opacity: enabled ? 1 : 0.5
                            onMoved: Audio.setStreamVolume(modelData, value)

                            Connections {
                                target: modelData.audio
                                function onVolumeChanged() {
                                    if (modelData && modelData.audio) {
                                        appSlider.value = modelData.audio.volume;
                                    }
                                }
                            }
                        }
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    visible: Audio.streams.length === 0
                    text: qsTr("Nenhum aplicativo reproduzindo áudio")
                    color: Colours.palette.m3onSurfaceVariant
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: Tokens.font.size.normal
                }
            }
        }
    }
}
