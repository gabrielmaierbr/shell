import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.misc
import qs.services

Item {
    id: root

    anchors.fill: parent
    implicitWidth: 360

    Ref {
        service: SystemUsage
    }

    readonly property var disk0: {
        for (let i = 0; i < SystemUsage.disks.length; i++) {
            const d = SystemUsage.disks[i];
            if (d.device && d.device.indexOf("nvme0n1") !== -1) return d;
        }
        return SystemUsage.disks.length > 0 ? SystemUsage.disks[0] : null;
    }

    readonly property var disk1: {
        for (let i = 0; i < SystemUsage.disks.length; i++) {
            const d = SystemUsage.disks[i];
            if (d.device && d.device.indexOf("nvme1n1") !== -1) return d;
        }
        return SystemUsage.disks.length > 1 ? SystemUsage.disks[1] : null;
    }

    function formatPair(used: real, free: real): string {
        const usedFmt = SystemUsage.formatKib(used);
        const freeFmt = SystemUsage.formatKib(free);
        return `${usedFmt.value.toFixed(1)} ${usedFmt.unit} ${qsTr("usado")} · ${freeFmt.value.toFixed(1)} ${freeFmt.unit} ${qsTr("livre")}`;
    }

    function diskPerc(disk: var): real {
        if (!disk) return 0;
        const total = disk.used + disk.free;
        return total > 0 ? disk.used / total : 0;
    }

    Column {
        anchors.centerIn: parent
        width: parent.width - Tokens.padding.large * 2
        spacing: Tokens.spacing.normal

        ResourceLine {
            icon: "memory_alt"
            name: qsTr("Memória")
            value: SystemUsage.memPerc
            colour: Colours.palette.m3secondary
            detail: root.formatPair(SystemUsage.memUsed, Math.max(0, SystemUsage.memTotal - SystemUsage.memUsed))
        }

        ResourceLine {
            icon: "hard_disk"
            name: qsTr("nvme0n1")
            value: root.diskPerc(root.disk0)
            colour: Colours.palette.m3tertiary
            detail: root.disk0 ? root.formatPair(root.disk0.used, root.disk0.free) : qsTr("Coletando dados...")
        }

        ResourceLine {
            icon: "hard_disk"
            name: qsTr("nvme1n1")
            value: root.diskPerc(root.disk1)
            colour: Colours.palette.m3primary
            detail: root.disk1 ? root.formatPair(root.disk1.used, root.disk1.free) : qsTr("Não disponível")
            visible: root.disk1 !== null
        }
    }

    component ResourceLine: Item {
        required property string icon
        id: res

        required property string name
        required property real value
        required property color colour
        required property string detail
        property real animatedValue: 0

        implicitHeight: 64
        implicitWidth: parent ? parent.width : 320
        Component.onCompleted: animatedValue = value
        onValueChanged: animatedValue = value

        Column {
            anchors.fill: parent
            spacing: Tokens.spacing.small

            RowLayout {
                width: parent.width
                spacing: Tokens.spacing.small

                MaterialIcon {
                    text: res.icon
                    color: res.colour
                    font.pointSize: Tokens.font.size.normal
                }

                StyledText {
                    text: res.name
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Tokens.font.size.small
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    id: percentText
                    text: `${Math.round(res.value * 100)}%`
                    color: res.colour
                    font.pointSize: Tokens.font.size.small
                    font.weight: Font.Medium
                }
            }

            StyledRect {
                width: parent.width
                implicitHeight: 5
                radius: Tokens.rounding.full
                color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 2)

                StyledRect {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * res.animatedValue
                    radius: Tokens.rounding.full
                    color: res.colour
                }
            }

            StyledText {
                text: res.detail
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Tokens.font.size.smaller
                elide: Text.ElideRight
                width: parent.width
            }
        }

        Behavior on animatedValue {
            Anim {
                type: Anim.StandardLarge
            }
        }
    }
}
