/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { withRouter, NavLink, Link } from 'react-router-dom'
import { observer } from 'mobx-react'
import schedules from '../../stores/schedules'
import Loading from '../loading'
import Teams from '../teams'

class AddTeams extends Component {
  componentWillMount() {
    schedules.fetch()
  }

  scheduleId() {
    let schedule_uuid
    const { match } = this.props
    if (match && match.params) {
      schedule_uuid = match.params.schedule_uuid
    }

    return schedule_uuid
  }

  schedule() {
    const scheduleId = this.scheduleId()
    if (!scheduleId) {
      return null
    }
    return schedules.find({ uuid: scheduleId })
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
          <NavLink to="/" activeClassName="button">Home</NavLink>
        </div>
      )
    }
    return (
      <div className="Schedule">
        <h3>Add your teams for: {schedule.get('name')}</h3>
        <Teams schedule={ schedule } />
        <Link to={{ pathname: `/schedule/${schedule.id}` }}>Back</Link>
      </div>
    )
  }
}

export default withRouter(observer(AddTeams))
