pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    anchors.fill: parent
    implicitWidth: Tokens.sizes.dashboard.dateTimeWidth

    RowLayout {
        anchors.centerIn: parent
        spacing: Tokens.spacing.small

        StyledText {
            text: Time.hourStr
            color: Colours.palette.m3secondary
            font.pointSize: Tokens.font.size.extraLarge
            font.family: Tokens.font.family.clock
            font.weight: 600
        }

        StyledText {
            text: ":"
            color: Colours.palette.m3primary
            font.pointSize: Tokens.font.size.extraLarge * 0.9
            font.family: Tokens.font.family.clock
            font.weight: 600
        }

        StyledText {
            text: Time.minuteStr
            color: Colours.palette.m3secondary
            font.pointSize: Tokens.font.size.extraLarge
            font.family: Tokens.font.family.clock
            font.weight: 600
        }

        Loader {
            asynchronous: true
            Layout.leftMargin: Tokens.spacing.small

            active: GlobalConfig.services.useTwelveHourClock
            visible: active

            sourceComponent: StyledText {
                text: Time.amPmStr
                color: Colours.palette.m3primary
                font.pointSize: Tokens.font.size.large
                font.family: Tokens.font.family.clock
                font.weight: 600
            }
        }
    }
}
