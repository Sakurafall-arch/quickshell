import QtQuick
import QtQuick.Effects

/**
 * Blur effect overlay. Wrap it around an item to blur what's behind it.
 * Set the 'source' to the item whose content should be blurred.
 */
MultiEffect {
    id: root

    property alias blurSource: root.source

    anchors.fill: parent
    saturation: 0.2
    blurEnabled: true
    blurMax: 100
    blur: 1

    // Set source to the background content
    source: parent
}
