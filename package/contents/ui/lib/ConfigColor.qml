import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import ".."

RowLayout {
	id: configColor
	spacing: 2
	// Layout.fillWidth: true
	Layout.maximumWidth: 300

	property alias label: label.text
	property alias horizontalAlignment: label.horizontalAlignment

	property string configKey: ''
	property string value: configKey ? plasmoid.configuration[configKey] : "#000"
	onValueChanged: {
		if (!textField.activeFocus) {
			textField.text = configColor.value
		}
		if (configKey) {
			plasmoid.configuration[configKey] = value
		}
	}

	function setValue(newColor) {
		textField.text = newColor
	}

	Label {
		id: label
		text: "Label"
		Layout.fillWidth: horizontalAlignment == Text.AlignRight
		horizontalAlignment: Text.AlignLeft
	}

	MouseArea {
		// width: label.font.pixelSize
		// height: label.font.pixelSize
		width: textField.height
		height: textField.height
		hoverEnabled: true

		onClicked: dialog.open()

		Rectangle {
			anchors.fill: parent
			color: configColor.value
			border.width: 2
			border.color: parent.containsMouse ? theme.highlightColor : "#BB000000"
		}
	}

	TextField {
		id: textField
		placeholderText: "#AARRGGBB"
		Layout.fillWidth: label.horizontalAlignment == Text.AlignLeft
		onTextChanged: {
			// Make sure the text is:
			//   Empty (use default)
			//   or #123 or #112233 or #11223344 before applying the color.
			if (text.length === 0
				|| (text.indexOf('#') === 0 && (text.length == 4 || text.length == 7 || text.length == 9))
			) {
				configColor.value = text
			}
		}
	}

	ColorDialog {
		id: dialog
		visible: false
		modality: Qt.WindowModal
		title: configColor.label
		showAlphaChannel: true
		color: configColor.value
		onCurrentColorChanged: {
			if (visible && color != currentColor) {
				configColor.value = currentColor
			}
		}
	}
}
