/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react'
import {
	AppRegistry,
	StyleSheet,
	View
} from 'react-native'

import GridView from './GridView'

const IMAGES = [
	'https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/16789259_785381361643204_9184021808481828864_n.jpg',
	'https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/16789259_785381361643204_9184021808481828864_n.jpg',
	'https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/16789259_785381361643204_9184021808481828864_n.jpg',
	'https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/16789259_785381361643204_9184021808481828864_n.jpg',
	'https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/16789259_785381361643204_9184021808481828864_n.jpg',
	'https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/16789259_785381361643204_9184021808481828864_n.jpg',
	'https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/16789259_785381361643204_9184021808481828864_n.jpg',
]

export default class SortableGrid extends Component {
	render() {
		return (
			<View style={{flex: 1}}>
				<GridView style={{flex: 1}} images={IMAGES} onOrderChange={console.log}/>
			</View>
		)
	}
}

const styles = StyleSheet.create({
	container: {
		flex           : 1,
		justifyContent : 'center',
		alignItems     : 'center',
		backgroundColor: '#F5FCFF',
	},
})

AppRegistry.registerComponent('SortableGrid', () => SortableGrid)
