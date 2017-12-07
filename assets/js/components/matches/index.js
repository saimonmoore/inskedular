/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter, Link } from 'react-router-dom'
import matches from '../../stores/matches'
import schedules from '../../stores/schedules'
import teams from '../../stores/teams'
import Loading from '../loading'
import Match from '../Match'

class Matches extends Component {
  componentWillMount() {
    const schedule_uuid = this.scheduleId()
    if (schedule_uuid) {
      matches.fetch({ data: { schedule_uuid } })
      teams.fetch({ data: { schedule_uuid } })
      schedules.fetch()
    }
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
    const schedule_uuid = this.scheduleId()
    return schedules.get(schedule_uuid)
  }

  render() {
    if (matches.isRequest('fetching')) {
      return <Loading label='matches' />
    }

    if (schedules.isRequest('fetching')) {
      return <Loading label='schedules' />
    }

    if (teams.isRequest('fetching')) {
      return <Loading label='teams' />
    }

    const schedule_uuid = this.scheduleId()

    if (!schedule_uuid) {
      return (
        <h3>Schedule 404</h3>
      )
    }

    const schedule = this.schedule()

    return (
      <div className='Matches'>
        <h3>Matches for { schedule.get('name') }</h3>
        <table>
          <thead>
            <tr>
              <td>Number</td>
              <td>Local</td>
              <td>Away</td>
              <td>Status</td>
              <td>Result</td>
              <td>Action</td>
            </tr>
          </thead>
          <tbody>
        {
          matches.models.map(match => (
            <Match key={ match.id } match={ match } schedule={ schedule } teams={ teams } />
          ))
        }
          </tbody>
        </table>
        <Link to={{ pathname: '/' }}>Back</Link>
      </div>
    )
  }
}

export default withRouter(observer(Matches))
