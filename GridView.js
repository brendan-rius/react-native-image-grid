import React from 'react';
import { requireNativeComponent } from 'react-native';

const GridViewNative = requireNativeComponent('GridView', GridView);
export default class GridView extends React.Component {
	render() {
return <GridViewNative style={this.props.style}/>
}
}
