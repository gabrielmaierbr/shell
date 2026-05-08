import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Caelestia.Config
import qs.components
import qs.services

ColumnLayout {
    id: root

    required property HyprlandToplevel client

    anchors.fill: parent
    spacing: Tokens.spacing.small

    Label {
        Layout.topMargin: Tokens.padding.large * 2

        text: root.client?.title ?? qsTr("Nenhuma janela aberta")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        font.pointSize: Tokens.font.size.large
        font.weight: 500
    }

    Label {
        text: root.client?.lastIpcObject.class ?? qsTr("Nenhuma janela aberta")
        color: Colours.palette.m3tertiary

        font.pointSize: Tokens.font.size.larger
    }

    StyledRect {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        Layout.leftMargin: Tokens.padding.large * 2
        Layout.rightMargin: Tokens.padding.large * 2
        Layout.topMargin: Tokens.spacing.normal
        Layout.bottomMargin: Tokens.spacing.large

        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "location_on"
        text: qsTr("Endereço: %1").arg(`0x${root.client?.address}` ?? "desconhecido")
        color: Colours.palette.m3primary
    }

    Detail {
        icon: "location_searching"
        text: qsTr("Posição: %1, %2").arg(root.client?.lastIpcObject.at[0] ?? -1).arg(root.client?.lastIpcObject.at[1] ?? -1)
    }

    Detail {
        icon: "resize"
        text: qsTr("Tamanho: %1 x %2").arg(root.client?.lastIpcObject.size[0] ?? -1).arg(root.client?.lastIpcObject.size[1] ?? -1)
        color: Colours.palette.m3tertiary
    }

    Detail {
        icon: "workspaces"
        text: qsTr("Workspace: %1 (%2)").arg(root.client?.workspace.name ?? -1).arg(root.client?.workspace.id ?? -1)
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "desktop_windows"
        text: {
            const mon = root.client?.monitor;
            if (mon)
                return qsTr("Monitor: %1 (%2) em %3, %4").arg(mon.name).arg(mon.id).arg(mon.x).arg(mon.y);
            return qsTr("Monitor: unknown");
        }
    }

    Detail {
        icon: "page_header"
        text: qsTr("Título inicial: %1").arg(root.client?.lastIpcObject.initialTitle ?? "desconhecido")
        color: Colours.palette.m3tertiary
    }

    Detail {
        icon: "category"
        text: qsTr("Categoria inicial: %1").arg(root.client?.lastIpcObject.initialClass ?? "desconhecido")
    }

    Detail {
        icon: "account_tree"
        text: qsTr("ID do Processo: %1").arg(root.client?.lastIpcObject.pid ?? -1)
        color: Colours.palette.m3primary
    }

    Detail {
        icon: "picture_in_picture_center"
        text: qsTr("Flutuante: %1").arg(root.client?.lastIpcObject.floating ? "sim" : "não")
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "gradient"
        text: qsTr("Xwayland: %1").arg(root.client?.lastIpcObject.xwayland ? "sim" : "não")
    }

    Detail {
        icon: "keep"
        text: qsTr("Fixado: %1").arg(root.client?.lastIpcObject.pinned ? "sim" : "não")
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "fullscreen"
        text: {
            const fs = root.client?.lastIpcObject.fullscreen;
            if (fs)
                return qsTr("Estado Tela inteira: %1").arg(fs == 0 ? "desligado" : fs == 1 ? "maximizado" : "ligado");
            return qsTr("Estado Tela inteira: desconhecido");
        }
        color: Colours.palette.m3tertiary
    }

    Item {
        Layout.fillHeight: true
    }

    component Detail: RowLayout {
        id: detail

        required property string icon
        required property string text
        property alias color: icon.color

        Layout.leftMargin: Tokens.padding.large
        Layout.rightMargin: Tokens.padding.large
        Layout.fillWidth: true

        spacing: Tokens.spacing.smaller

        MaterialIcon {
            id: icon

            Layout.alignment: Qt.AlignVCenter
            text: detail.icon
        }

        StyledText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            text: detail.text
            elide: Text.ElideRight
            font.pointSize: Tokens.font.size.normal
        }
    }

    component Label: StyledText {
        Layout.leftMargin: Tokens.padding.large
        Layout.rightMargin: Tokens.padding.large
        Layout.fillWidth: true
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        animate: true
    }
}
