pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services

StyledRect {
    id: toggleRoot

    readonly property int cell: Math.round(Tokens.font.size.extraLarge * 2.1)

    implicitWidth: cell * 2 + Tokens.spacing.small + Tokens.padding.normal * 2
    implicitHeight: cell * 2 + Tokens.spacing.small + Tokens.padding.normal * 2

    radius: Tokens.rounding.large
    color: Colours.tPalette.m3surfaceContainer

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Tokens.spacing.small

        RowLayout {
            spacing: Tokens.spacing.small

            QuickToggle {
                icon: "wifi"
                checked: Nmcli.wifiEnabled
                onClicked: Nmcli.toggleWifi()
            }

            QuickToggle {
                icon: "bluetooth"
                checked: Bluetooth.defaultAdapter?.enabled ?? false // qmllint disable unresolved-type
                onClicked: {
                    const adapter = Bluetooth.defaultAdapter; // qmllint disable unresolved-type
                    if (adapter)
                        adapter.enabled = !adapter.enabled;
                }
            }
        }

        RowLayout {
            spacing: Tokens.spacing.small

            QuickToggle {
                icon: "mic"
                checked: !Audio.sourceMuted
                onClicked: {
                    const audio = Audio.source?.audio;
                    if (audio)
                        audio.muted = !audio.muted;
                }
            }

            QuickToggle {
                icon: "coffee"
                checked: IdleInhibitor.enabled
                onClicked: IdleInhibitor.enabled = !IdleInhibitor.enabled
            }
        }
    }

    component QuickToggle: IconButton {
        Layout.preferredWidth: toggleRoot.cell
        Layout.preferredHeight: toggleRoot.cell

        type: IconButton.Tonal
        toggle: true
        font.pointSize: Math.round(Tokens.font.size.large)
        radiusAnim.duration: Tokens.anim.durations.expressiveFastSpatial
        radiusAnim.easing: Tokens.anim.expressiveFastSpatial
    }
}
