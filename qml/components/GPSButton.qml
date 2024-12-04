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

import QtPositioning 5.4

Item {
    id: button

    height: Theme.iconSizeMedium
    width: height

    property bool enabled: settings.useGps && positionSource.valid
    readonly property bool followGps: icon.followGps
    readonly property alias position: positionSource.position
    signal clicked

    IconButton {
        id: icon
        anchors.fill: parent
        enabled: button.enabled && button.position.latitudeValid && button.position.longitudeValid
        onEnabledChanged: if (!enabled) { followGps = false; }

        property bool followGps: false

        onClicked: {
            if (followGps) {
                followGps = false
            }
            else {
                button.clicked()
            }
        }
        onDoubleClicked: {
            followGps = !followGps
        }

        readonly property string color: pressed
                                        ? Theme.highlightColor
                                        : Theme.primaryColor
        readonly property string iconstring: followGps
                                               ? "call-recording-off"
                                               : "call-recording-on-dark"
        icon.source: "image://theme/icon-m-" + iconstring + "?" + color
    }

    PositionSource {
         id: positionSource
         active: button.visible && button.enabled
    }
}

