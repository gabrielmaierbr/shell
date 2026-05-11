import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.Services
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services

Item {
    id: root

    property var active: Players.active
    readonly property real playerProgress: {
        const current = root.active;
        return current?.length ? (current.position % current.length) / current.length : 0;
    }

    readonly property real ctrlFont: Math.round(Tokens.font.size.large)
    readonly property real ctrlFontLarge: Math.round(Tokens.font.size.large * 1.15)

    function lengthStr(length: int): string {
        if (length < 0)
            return "--:--";

        const hours = Math.floor(length / 3600);
        const mins = Math.floor((length % 3600) / 60);
        const secs = Math.floor(length % 60).toString().padStart(2, "0");
        return hours > 0 ? `${hours}:${mins.toString().padStart(2, "0")}:${secs}` : `${mins}:${secs}`;
    }

    anchors.fill: parent
    implicitWidth: 640
    implicitHeight: 220

    Timer {
        running: root.active?.isPlaying ?? false
        interval: GlobalConfig.dashboard.mediaUpdateInterval
        triggeredOnStart: true
        repeat: true
        onTriggered: root.active?.positionChanged()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Tokens.padding.large
        spacing: Tokens.spacing.large

        StyledClippingRect {
            id: albumArt

            Layout.preferredWidth: 172
            Layout.preferredHeight: 172
            Layout.alignment: Qt.AlignVCenter
            radius: Tokens.rounding.large
            color: Colours.tPalette.m3surfaceContainerHigh

            MaterialIcon {
                anchors.centerIn: parent
                grade: 200
                text: "art_track"
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: (parent.width * 0.32) || 1
            }

            Image {
                anchors.fill: parent
                source: Players.getArtUrl(root.active)
                asynchronous: true
                fillMode: Image.PreserveAspectCrop
                sourceSize: {
                    const dpr = (QsWindow.window as QsWindow)?.devicePixelRatio ?? 1;
                    return Qt.size(width * dpr, height * dpr);
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: albumArt.height
            Layout.alignment: Qt.AlignVCenter
            spacing: Tokens.spacing.smaller

            StyledText {
                Layout.fillWidth: true
                text: (root.active?.trackTitle ?? qsTr("Sem mídia")) || qsTr("Sem título")
                color: Colours.palette.m3primary
                font.pointSize: Tokens.font.size.normal
                font.weight: Font.Medium
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true
                text: (root.active?.trackArtist ?? qsTr("Desconhecido")) || qsTr("Desconhecido")
                color: Colours.palette.m3onSurface
                font.pointSize: Tokens.font.size.small
                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true
                text: (root.active?.trackAlbum ?? qsTr("Desconhecido")) || qsTr("Desconhecido")
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Tokens.font.size.small
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            StyledRect {
                Layout.fillWidth: true
                implicitHeight: 6
                radius: Tokens.rounding.full
                color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 2)

                StyledRect {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * root.playerProgress
                    radius: Tokens.rounding.full
                    color: Colours.palette.m3primary
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: -2

                StyledText {
                    text: root.lengthStr(root.active?.length ? root.active.position % root.active.length : -1)
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Tokens.font.size.small
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    text: root.lengthStr(root.active?.length ?? -1)
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Tokens.font.size.small
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: -2
                spacing: Tokens.spacing.small

                PanelPlayerControl {
                    type: IconButton.Text
                    icon: root.active?.shuffle ? "shuffle_on" : "shuffle"
                    font.pointSize: root.ctrlFont
                    disabled: !root.active?.shuffleSupported
                    onClicked: {
                        if (root.active)
                            root.active.shuffle = !root.active.shuffle;
                    }
                }

                PanelPlayerControl {
                    type: IconButton.Text
                    icon: "skip_previous"
                    font.pointSize: root.ctrlFontLarge
                    disabled: !root.active?.canGoPrevious
                    onClicked: root.active?.previous()
                }

                PanelPlayerControl {
                    icon: root.active?.isPlaying ? "pause" : "play_arrow"
                    label.animate: true
                    toggle: true
                    padding: Tokens.padding.small / 2
                    checked: root.active?.isPlaying ?? false
                    font.pointSize: root.ctrlFontLarge
                    disabled: !root.active?.canTogglePlaying
                    onClicked: root.active?.togglePlaying()
                }

                PanelPlayerControl {
                    type: IconButton.Text
                    icon: "skip_next"
                    font.pointSize: root.ctrlFontLarge
                    disabled: !root.active?.canGoNext
                    onClicked: root.active?.next()
                }

                PanelPlayerControl {
                    type: IconButton.Text
                    icon: "lyrics"
                    font.pointSize: root.ctrlFont
                    onClicked: LyricsService.toggleVisibility()
                }
            }
        }
    }

    component PanelPlayerControl: IconButton {
        Layout.preferredWidth: implicitWidth + (stateLayer.pressed ? Tokens.padding.large : internalChecked ? Tokens.padding.smaller : 0)
        radius: stateLayer.pressed ? Tokens.rounding.small / 2 : internalChecked ? Tokens.rounding.small : implicitHeight / 2
        radiusAnim.duration: Tokens.anim.durations.expressiveFastSpatial
        radiusAnim.easing: Tokens.anim.expressiveFastSpatial

        Behavior on Layout.preferredWidth {
            Anim {
                type: Anim.FastSpatial
            }
        }
    }
}
