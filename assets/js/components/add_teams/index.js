/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { withRouter, NavLink } from 'react-router-dom'
import { observer } from 'mobx-react'
import schedules from '../../stores/schedules'
import Loading from '../loading'
import Teams from '../teams'

class AddTeams extends Component {
  constructor(props) {
    super(props)

    if (!props.location.state) {
      return
    }
    const { schedule_uuid } = props.location.state
    this.state = { schedule_uuid }
  }

  componentWillMount() {
    schedules.fetch()
  }

  schedule() {
    const { schedule_uuid } = this.state
    if (!schedule_uuid) {
      return null
    }
    return schedules.find({ uuid: schedule_uuid })
  }

  render() {
    if (schedules.isRequest('fetching')) {
      return (<Loading label='schedule' />)
    }

    const schedule = this.schedule()
    if (!schedule) {
      return (
        <div className="Schedule">
          <h3>No schedule!</h3>
          <NavLink to="/new_schedule" activeClassName="button">New Schedule</NavLink>
        </div>
      )
    }
    return (
      <div className="Schedule">
        <Teams schedule={ schedule } />
      </div>
    )
  }
}

export default withRouter(observer(AddTeams))
