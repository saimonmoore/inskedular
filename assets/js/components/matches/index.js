/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter, Link } from 'react-router-dom'
import matches from '../../stores/matches'
import schedules from '../../stores/schedules'
import teams from '../../stores/teams'
import Loading from '../loading'
import Match from '../match'

class Matches extends Component {
  constructor(props) {
    super(props)

    this.state = {
      filter: 'all',
    }

    this.filterPlayer = this.filterPlayer.bind(this)
  }

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

  filterPlayer(event) {
    const filter = event.target.value
    this.setState({ filter })
  }

  filterMatch(match, filter) {
    if (filter === 'all') return true
    return match.get('local_team_uuid') == filter || match.get('away_team_uuid') === filter
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
    const filter = this.state.filter

    return (
      <div className='Matches'>
        <h3>Matches for { schedule.get('name') }</h3>
        <span>Filter for: </span>
        <select id='filterPlayer' onChange={this.filterPlayer}>
          <option value="all">All players</option>
          {
            teams.models.map(team => (
              <option value="all" value={team.id} key={team.get('name')}>{team.get('name')}</option>
            ))
          }
        </select>
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
            this.filterMatch(match, filter) && <Match key={ match.id } match={ match } schedule={ schedule } teams={ teams } />
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
