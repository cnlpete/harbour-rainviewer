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
import MapboxMap 1.0

import "../components"

Page {
    id: page

    allowedOrientations: Orientation.PortraitMask

    property bool loading: false

    readonly property string smoothOpt: settings.antialiasing ? "1" : "0"
    readonly property string snowOpt: settings.snow ? "1" : "0"
    readonly property string urlPostFix: settings.tileSize + "/{z}/{x}/{y}/" + settings.rainColorScheme + "/" + smoothOpt + "_" + snowOpt + ".png"
    onUrlPostFixChanged: {
        console.log("url-postfix changed")
        loader.reload()
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            busy: loading
            MenuItem {
                text: qsTr("Clear Map Cache")
                onClicked: {
                    remorse.execute(qsTr("Clearing map cache"), function() {
                        map.clearCache()
                    })
                }
            }
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: qsTr("Color legend")
                onClicked: pageStack.push(Qt.resolvedUrl("ColorLegend.qml"))
            }
        }

        RemorsePopup { id: remorse }

        PageHeader {
            title: qsTr("Rainviewer")
            id: header

            Component.onCompleted: {
               var apiRequest = new XMLHttpRequest();
                    apiRequest.open("GET", "https://api.rainviewer.com/public/weather-maps.json", true);
                    apiRequest.onload = function(e) {

                        apiData = JSON.parse(apiRequest.response);
                        //initialize(apiData, optionKind);
                        console.log(apiData)
                    };
                    apiRequest.send();

            }
        }

        Loader {
            id: loader
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: header.bottom
            anchors.bottom: parent.bottom

            sourceComponent: mapComp

            function reload() {
                active = !active
                active = !active
            }
        }

        Timer {
            function restart() {
                running = false
                running = true
            }

            id: delayedValue
            interval: 500
            repeat: false
            onTriggered: {
                settings.lastLat = delayedValue.lat
                settings.lastLng = delayedValue.lng
            }

            property real lat: settings.lastLat
            onLatChanged: restart()
            property real lng: settings.lastLng
            onLngChanged: restart()
            property real zoom: 11.0
        }

        Component {
            id: mapComp

            Item {
                anchors.fill: parent

                Item {
                    id: mapItem
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: 10

                    height: parent.height - bottom.height

                    MapboxMap {
                        id: map
                        anchors.fill: parent

                        center: QtPositioning.coordinate(settings.lastLat, settings.lastLng)
                        zoomLevel: delayedValue.zoom
                        metersPerPixelTolerance: 0.1
                        minimumZoomLevel: 6
                        maximumZoomLevel: 12
                        pixelRatio: 1.0

                        //pixelRatio: 3.0
                        accessToken: settings.mapboxApiKey
                        cacheDatabaseDefaultPath: true

                        onCenterChanged: {
                            delayedValue.lat = center.latitude
                            delayedValue.lng = center.longitude
                        }
                        onZoomLevelChanged: {
                            delayedValue.zoom = zoomLevel
                        }

                        Behavior on center {
                            CoordinateAnimation {
                                duration: 500
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on margins {
                            PropertyAnimation {
                                duration:500
                                easing.type: Easing.InOutQuad
                            }
                        }

                        styleUrl: settings.mapstyle

                        urlDebug: false

                        MapboxMapGestureArea {
                            id: mouseArea
                            map: map
                            activeClickedGeo: false
                            activeDoubleClickedGeo: false
                        }

                        Item {
                            id: urlObject
                            readonly property string url: "https://tilecache.rainviewer.com/v2/coverage/0/" + settings.tileSize + "/{z}/{x}/{y}/0/0_0.png"
                        }

                        Component.onCompleted: {
                            setMargins(0.1, 0.1, 0.1, 0.1)

                            map.addSource("coverage", { "type": "raster", "tiles": [urlObject.url], "maxzoom": 12 })

                            map.addLayer("coverage", { "type": "raster", "source": "coverage", "paint": { "raster-opacity": 0.1 }})
                        }
                    }

                    Connections {
                        target: map
                        onMetersPerPixelChanged: gpsButton.update_map()
                    }

                    Label {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        color: "black"
                        text: qsTr("Scale: %0 m/pixel ; zoom: %1").arg(map.metersPerPixel.toFixed(2)).arg(map.zoomLevel)
                    }
                }

                Row {
                    id: bottom
                    height: header.height
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: Theme.horizontalPageMargin
                    anchors.rightMargin: Theme.horizontalPageMargin

                    QtObject {
                        id: valueKeeper

                        property bool autoplayActive: false

                        property int index: -1
                        property int oldTime: -1
                        onIndexChanged: {
                            var toRemove = oldTime
                            if ( index >= 0 ) {
                                oldTime = model.get(index).time
                                console.log("add layer ", "tile_" + oldTime)
                                map.addLayer("tile_" + oldTime, {"type": "raster", "source": "tile_" + oldTime, "paint": { "raster-opacity": 0.5 }})
                            }
                            if (toRemove !== -1) {
                                console.log("removeLayer ", "tile_" + toRemove)
                                map.removeLayer("tile_" + toRemove)
                            }
                        }
                    }

                    Timer {
                        interval: 2500
                        running: valueKeeper.autoplayActive && model.count > 0 && page.visible
                        repeat: true
                        onTriggered: {
                            slider.value = slider.value + 1 > slider.maximumValue ? slider.minimumValue : slider.value + 1
                        }
                    }
                    IconButton {
                        id: icon
                        height: Theme.iconSizeMedium
                        width: height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Theme.horizontalPageMargin
                        enabled: model.count > 0

                        onClicked: {
                            valueKeeper.autoplayActive = !valueKeeper.autoplayActive
                        }

                        readonly property string play_pause : valueKeeper.autoplayActive ? "pause" : "play"
                        readonly property string color: pressed
                                                        ? Theme.highlightColor
                                                        : Theme.primaryColor
                        icon.source: "image://theme/icon-m-" + play_pause + "?" + color
                    }

                    Slider {
                        id: slider
                        minimumValue: 0
                        maximumValue: model.count
                        value: model.mostCurrentIndex
                        enabled: model.count > 0

                        stepSize: 1
                        valueText: model.count > 0 ?
                                       new Date(model.get(value).time*1000).toLocaleTimeString(Qt.locale(), Locale.ShortFormat) :
                                       ""

                        onDownChanged: {
                            if (!down && !settings.immediateSlider) {
                                valueKeeper.index = value
                            }
                        }
                        onValueChanged: {
                            if (settings.immediateSlider) {
                                valueKeeper.index = value
                            }
                        }

                        height: parent.height
                        width: parent.width - icon.width - gpsButton.width
                    }

                    GPSButton {
                        id: gpsButton
                        height: Theme.iconSizeMedium
                        width: height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Theme.horizontalPageMargin

                        onClicked: {
                            map.center = position.coordinate
                        }

                        onFollowGpsChanged: {
                            if (followGps) {
                                map.fitView([position.coordinate])
                            }
                        }

                        onPositionChanged: {
                            if (followGps) {
                                map.fitView([position.coordinate])
                            }

                            update_map()
                        }

                        function update_map() {
                            map.updateSourcePoint("gps", position.coordinate.latitude, position.coordinate.longitude)

                            if (position.horizontalAccuracyValid) {
                                map.setPaintProperty("gps-case", "circle-color", "white")
                            }
                            else {
                                map.setPaintProperty("gps-case", "circle-color", "grey")
                            }

                            if (position.horizontalAccuracyValid) {
                                map.setPaintProperty("gps-uncertainty", "circle-radius", position.horizontalAccuracy / map.metersPerPixel)
                                map.setPaintProperty("gps-uncertainty", "circle-color", "#87cefa")
                                map.setPaintProperty("gps-uncertainty", "circle-opacity", 0.25)
                            }
                        }

                        Component.onCompleted: {
                            map.updateSourcePoint("gps", position.coordinate.latitude, position.coordinate.longitude)

                            map.addLayer("gps-uncertainty", {"type": "circle", "source": "gps"}, "gps-case")
                            map.setPaintProperty("gps-uncertainty", "circle-radius", 0)

                            map.addLayer("gps-case", {"type": "circle", "source": "gps"})
                            map.setPaintProperty("gps-case", "circle-radius", 10)
                            map.setPaintProperty("gps-case", "circle-color", "grey")
                        }
                    }

                    Repeater {
                        id: rep
                        model: model
                        delegate: Item {
                            readonly property string renderedPath: path + "/" + urlPostFix

                            Component.onCompleted: {
                                map.addSource("tile_" + time, { "type": "raster", "tiles": [renderedPath], "maxzoom": 12 })
                            }
                            Component.onDestruction: {
                                map.removeSource("tile_" + time);
                            }
                        }
                    }

                    RainModel {
                        id: model

                        Component.onCompleted: {
                            reload();
                        }
                    }
                }

            }
        }
    }
}
