import QtQuick
import Caelestia.Config
import qs.components.misc
import qs.services

Item {
    id: root

    anchors.fill: parent

    Ref {
        service: SystemUsage
    }

    PerformanceDetailCard {
        anchors.fill: parent
        anchors.margins: Tokens.padding.large
        icon: "memory"
        title: SystemUsage.cpuName || qsTr("CPU")
        usage: SystemUsage.cpuPerc
        temperature: SystemUsage.cpuTemp
        accentColor: Colours.palette.m3primary
    }
}
