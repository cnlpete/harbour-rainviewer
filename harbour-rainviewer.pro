# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-rainviewer

CONFIG += sailfishapp_qml

DISTFILES += \
    #qml/harbour-rainviewer.qml \
    qml/components/Constants.qml \
    qml/components/GPSButton.qml \
    qml/components/RainModel.qml \
    qml/components/NetworkCall.js \
    qml/cover/CoverPage.qml \
    qml/pages/About.qml \
    qml/pages/Settings.qml \
    translations/harbour-rainviewer.ts \
    translations/harbour-rainviewer-de_DE.ts \
    rpm/harbour-rainviewer.spec \
    rpm/harbour-rainviewer.changes \

OTHER_FILES += \
    harbour-rainviewer.desktop


# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-rainviewer-de_DE.ts

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172
