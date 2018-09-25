/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter, Link } from 'react-router-dom'
import matches from '../../stores/matches'
import schedules from '../../stores/schedules'
import teams from '../../stores/teams'
import Loading from '../loading'
import Match from '../match'

const styles = {
  filters: {
    display: 'flex',
  },
  filter: {
    marginLeft: '5px',
    marginRight: '10px',
  }
}

class Matches extends Component {
  constructor(props) {
    super(props)

    this.state = {
      filters: {
        player: 'all',
        opponent: 'all',
      }
    }

    this.filterPlayer = this.filterPlayer.bind(this)
    this.filterOpponent = this.filterOpponent.bind(this)
    this.players = this.players.bind(this)
    this.opponents = this.opponents.bind(this)
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
    const playerFilter = event.target.value
    const { filters } = this.state || {}
    filters.player = playerFilter

    this.setState({ filters })
  }

  filterOpponent(event) {
    const opponentFilter = event.target.value
    const { filters } = this.state || {}
    filters.opponent = opponentFilter

    this.setState({ filters })
  }

  filterMatch(match) {
    const { filters } = this.state || {}
    const { player: playerFilter, opponent: opponentFilter } = filters

    if (playerFilter === 'all') return true

    if (playerFilter && !opponentFilter) {
      return match.get('local_team_uuid') == playerFilter || match.get('away_team_uuid') === playerFilter
    }

    if (playerFilter && opponentFilter) {
      if (opponentFilter === 'all') return match.get('local_team_uuid') == playerFilter || match.get('away_team_uuid') === playerFilter

      return (match.get('local_team_uuid') == playerFilter && match.get('away_team_uuid') === opponentFilter)
      || (match.get('local_team_uuid') == opponentFilter && match.get('away_team_uuid') === playerFilter)
    }
  }

  players() {
    return teams.models
  }

  opponents() {
    const { filters } = this.state
    const { player: playerFilter } = filters

    if (!playerFilter) return this.players()

    return this.players().filter((player) => ( player.get('uuid') !== playerFilter))
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
    const players = this.players()
    const opponents = this.opponents()

    return (
      <div className='Matches'>
        <h3>Matches for { schedule.get('name') }</h3>
        <div style={styles.filters}>
          <span>Filter by: </span>
          <div style={styles.filter}>
            <select id='filterPlayer' onChange={this.filterPlayer}>
              <option value="all">All players</option>
              {
                players.map(team => (
                  <option value={team.id} key={team.get('name')}>{team.get('name')}</option>
                ))
              }
            </select>
          </div>
          <div style={styles.filter}>
            <select id='filterOpponent' onChange={this.filterOpponent}>
              <option value="all">All opponents</option>
              {
                opponents.map(team => (
                  <option value={team.id} key={team.get('name')}>{team.get('name')}</option>
                ))
              }
            </select>
          </div>
        </div>
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
                this.filterMatch(match) && <Match key={ match.id } match={ match } schedule={ schedule } teams={ teams } />
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
