/*
 * This file is part of harbour-rainviewer.
 * Copyright (C) 2024 <cnlpete.de> Hauke Schade
 *
 * harbour-rainviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * harbour-rainviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with harbour-rainviewer.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    allowedOrientations: Orientation.PortraitMask

    SilicaFlickable {
        contentHeight: aboutColumn.height
        contentWidth: parent.width
        anchors.fill: parent

        Column {
            id: aboutColumn
            width: parent.width - 2 * Theme.horizontalPageMargin
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.horizontalPageMargin
            }
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Rainviewer %1").arg(constant.version)
            }

            Image {
                width: 128
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                source: "/usr/share/icons/hicolor/128x128/apps/harbour-rainviewer.png"
                smooth: true
                asynchronous: true
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                color: Theme.primaryColor
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                text: qsTr("Simple map to display rainmaps from %1").arg("<a href=\"https://rainviewer.com\">rainviewer.com</a>")
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text:  qsTr("© %1 %2").arg(2024).arg("Hauke Schade")
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("This program is FOSS software licensed GNU General Public License v3.")
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                text: qsTr("Source: %1").arg("<a href=\"" + constant.sourceRepoSite + "\">Github</a>")
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }

            Label {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                color: Theme.secondaryColor
                textFormat: Text.StyledText
                linkColor: Theme.highlightColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("If you encounter bugs or have feature requests, please file tickets in the Issue Tracker: %1")
                    .arg("<a href=\"" + constant.issueTrackerUrl + "\">Issues@Github</a>")
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }

            Row {
                width: parent.width - 2 * Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingMedium
                Button {
                    width: Math.floor(parent.width / 2) - Theme.paddingMedium
                    text: qsTr("Buy me a beer")
                    onClicked: {
                        Qt.openUrlExternally(constant.donateUrl)
                    }
                }
                Button {
                    width: Math.floor(parent.width / 2) - Theme.paddingMedium
                    text: qsTr("Homepage")
                    onClicked: {
                        Qt.openUrlExternally(constant.website)
                    }
                }
            }
        }

    }
}
