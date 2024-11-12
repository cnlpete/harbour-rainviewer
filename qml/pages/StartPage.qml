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

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            busy: loading
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
        }

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

        Item {
            id: mapItem
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: header.bottom
            anchors.margins: 10

            height: parent.height - header.height - bottom.height

            PositionSource {
                 id: positionSource
                 active: page.visible && settings.useGps

                 function update_map() {
                     map.updateSourcePoint("gps", positionSource.position.coordinate.latitude, positionSource.position.coordinate.longitude)

                     if (positionSource.position.longitudeValid && positionSource.position.latitudeValid) {
                         map.setPaintProperty("gps-case", "circle-color", "white")
                         if (settings.followGps) {
                             map.fitView([positionSource.position.coordinate])
                         }
                     }
                     else {
                         map.setPaintProperty("gps-case", "circle-color", "grey")
                     }

                     if (positionSource.position.horizontalAccuracyValid) {
                         map.setPaintProperty("gps-uncertainty", "circle-radius", positionSource.position.horizontalAccuracy / map.metersPerPixel)
                         map.setPaintProperty("gps-uncertainty", "circle-color", "#87cefa")
                         map.setPaintProperty("gps-uncertainty", "circle-opacity", 0.25)
                     }
                 }


                 onPositionChanged: {
                     update_map()
                 }

                 Component.onCompleted: {
                     map.updateSourcePoint("gps", positionSource.position.coordinate.latitude, positionSource.position.coordinate.longitude)

                     map.addLayer("gps-uncertainty", {"type": "circle", "source": "gps"}, "gps-case")
                     map.setPaintProperty("gps-uncertainty", "circle-radius", 0)

                     map.addLayer("gps-case", {"type": "circle", "source": "gps"})
                     map.setPaintProperty("gps-case", "circle-radius", 10)
                     map.setPaintProperty("gps-case", "circle-color", "grey")

                     map.fitView([positionSource.position.coordinate])
                 }
            }

            MapboxMap {
                id: map
                anchors.fill: parent

                center: QtPositioning.coordinate(60.170448, 24.942046) // Helsinki
                zoomLevel: 11.0
                metersPerPixelTolerance: 0.1
                minimumZoomLevel: 6
                maximumZoomLevel: 12
                pixelRatio: 1.0

                //pixelRatio: 3.0
                accessToken: settings.mapboxApiKey
                cacheDatabaseDefaultPath: true


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

                Component.onCompleted: {
                    setMargins(0.1, 0.1, 0.1, 0.1)

                    map.addSource("coverage", {"type": "raster",
                                      "tiles": ["https://tilecache.rainviewer.com/v2/coverage/0/" + settings.tileSize + "/{z}/{x}/{y}/0/0_0.png"],
                                      "maxzoom": 12
                                  })

                    map.addLayer("coverage",{"type": "raster", "source": "coverage", "paint": { "raster-opacity": 0.1 }})
                }
            }

            Connections {
                target: map
                onMetersPerPixelChanged: positionSource.update_map()
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
                running: valueKeeper.autoplayActive && model.count > 0
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
                width: parent.width - icon.width
            }

            Repeater {
                id: rep
                model: model
                delegate: Item {
                    Component.onCompleted: {
                        var smoothOpt = settings.antialiasing ? "1" : "0"
                        map.removeSource("tile_" + time);
                        map.addSource("tile_" + time, {"type": "raster",
                                          "tiles": [path + "/" + settings.tileSize + "/{z}/{x}/{y}/" + settings.rainColorScheme + "/" + smoothOpt + "_0.png"],
                                          "maxzoom": 12
                                      })
                    }
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
