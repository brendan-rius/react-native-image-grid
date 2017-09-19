/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';

import GridView from './GridView';

export default class SortableGrid extends Component {
  render() {
    return (
	<GridView style={{flex: 1}}>
<Text>Hello</Text>
</GridView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
});

AppRegistry.registerComponent('SortableGrid', () => SortableGrid);
