import React from 'react'
import PropTypes from 'prop-types'
import {requireNativeComponent} from 'react-native'

const GridViewNative = requireNativeComponent('GridView', GridView)


export default class GridView extends React.Component {
	static propTypes = {
		style        : PropTypes.any,
		images       : PropTypes.arrayOf(PropTypes.string),
		onOrderChange: PropTypes.func,
	}

	static defaultProps = {
		onOrderChange: () => null
	}

	_orderChangeHandler() {
		return evt => this.props.onOrderChange(evt.nativeEvent.urls)
	}

	render() {
		return <GridViewNative style={this.props.style}
		                       urls={this.props.images}
		                       onOrderChange={this._orderChangeHandler()}/>
	}
}
