import QtQuick
import Caelestia.Config
import qs.components.misc
import qs.services

Item {
    id: root

    anchors.fill: parent
    visible: SystemUsage.gpuType !== "NONE"

    Ref {
        service: SystemUsage
    }

    PerformanceDetailCard {
        anchors.fill: parent
        anchors.margins: Tokens.padding.large
        icon: "desktop_windows"
        title: SystemUsage.gpuName || qsTr("GPU")
        usage: SystemUsage.gpuPerc
        temperature: SystemUsage.gpuTemp
        accentColor: Colours.palette.m3secondary
    }
}
