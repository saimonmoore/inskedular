/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { Redirect, withRouter } from 'react-router-dom'
import { observer } from 'mobx-react'
import schedules from '../../stores/schedules'

class AddTeams extends Component {
  constructor(props) {
    super(props)
    const { schedule_uuid } = props.location.state
    this.state = { schedule_uuid }
  }

  render() {
    const { schedule_uuid } = this.state
    return (
      <h3>Click to add a team to Schedule: {schedule_uuid}</h3>
    )
  }
}

export default observer(withRouter(AddTeams))
