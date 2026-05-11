import "dash"
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.filedialog
import qs.services

ColumnLayout {
    id: root

    required property DrawerVisibilities visibilities
    required property DashboardState dashState
    required property FileDialog facePicker

    readonly property int topCardHeight: 176
    readonly property int midRowHeight: 230
    readonly property int perfCardHeight: 200
    readonly property real weatherMinWidth: Tokens.sizes.dashboard.weatherWidth + Tokens.sizes.dashboard.dateTimeWidth + Tokens.spacing.normal

    spacing: Tokens.spacing.normal
    implicitWidth: Math.max(topRow.implicitWidth, bottomRow.implicitWidth, perfRow.implicitWidth)
    implicitHeight: topRow.implicitHeight + bottomRow.implicitHeight + perfRow.implicitHeight + spacing * 2

    RowLayout {
        id: topRow

        Layout.fillWidth: true
        spacing: Tokens.spacing.normal

        Rect {
            Layout.preferredWidth: user.implicitWidth + Tokens.padding.large * 2
            Layout.preferredHeight: root.topCardHeight

            radius: Tokens.rounding.large

            User {
                id: user

                anchors.centerIn: parent
                visibilities: root.visibilities
                facePicker: root.facePicker
            }
        }

        Rect {
            Layout.fillWidth: true
            Layout.minimumWidth: root.weatherMinWidth
            Layout.preferredHeight: root.topCardHeight
            

            radius: Tokens.rounding.large * 1.2

            SmallWeather {
            }
        }

        Rect {
            Layout.preferredWidth: dashQuick.implicitWidth + Tokens.padding.normal * 2
            Layout.preferredHeight: root.topCardHeight

            radius: Tokens.rounding.large

            DashboardQuickToggles {
                id: dashQuick

                anchors.centerIn: parent
            }
        }

        Rect {
            Layout.preferredWidth: Math.max(200, dateTime.implicitWidth + Tokens.padding.large * 2)
            Layout.preferredHeight: root.topCardHeight

            radius: Tokens.rounding.large

            DateTime {
                id: dateTime
            }
        }
    }

    RowLayout {
        id: bottomRow

        Layout.fillWidth: true
        spacing: Tokens.spacing.normal

        Rect {
            Layout.fillWidth: true
            Layout.minimumWidth: 280
            Layout.preferredHeight: root.midRowHeight

            radius: Tokens.rounding.large

            MediaMinimal {}
        }

        Rect {
            Layout.preferredWidth: 320
            Layout.preferredHeight: root.midRowHeight

            radius: Tokens.rounding.large

            Resources {
                id: resources
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
            }
        }

        Rect {
            Layout.fillWidth: true
            Layout.minimumWidth: 160
            Layout.preferredHeight: root.midRowHeight

            radius: Tokens.rounding.large

            DashboardNetworkCard {
                id: dashNetwork

                anchors.fill: parent
            }
        }
    }

    RowLayout {
        id: perfRow

        Layout.fillWidth: true
        Layout.preferredHeight: root.perfCardHeight
        spacing: Tokens.spacing.normal

        Rect {
            Layout.fillWidth: true
            Layout.preferredHeight: root.perfCardHeight
            radius: Tokens.rounding.large

            CpuPerformanceCard {
                anchors.fill: parent
            }
        }

        Rect {
            Layout.fillWidth: true
            Layout.preferredHeight: root.perfCardHeight
            visible: SystemUsage.gpuType !== "NONE"
            radius: Tokens.rounding.large

            GpuPerformanceCard {
                anchors.fill: parent
            }
        }
    }

    component Rect: StyledRect {
        color: Colours.tPalette.m3surfaceContainer
    }
}
