/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter, Link } from 'react-router-dom'
import matches from '../../stores/matches'
import schedules from '../../stores/schedules'
import teams from '../../stores/teams'
import Loading from '../loading'

class Stats extends Component {
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

  calculateStats() {
    const overallStats = teams.models.reduce((unorderedStats, team) => {
      const statsForTeam = { played: 0, wins: 0, draws: 0, losses: 0, points: 0 }
      const stats = {}

      matches.models.reduce((teamStats, match) => {
        const isPlayed = this.isPlayed(match, team)
        const isWin = this.isWin(match, team)
        const isLoss = this.isLoss(match, team)
        const isDraw = this.isDraw(match, team)
        if (isPlayed) teamStats.played += 1
        if (isWin) {
          teamStats.wins += 1
          teamStats.points += 3
        }
        if (isLoss) teamStats.losses += 1
        if (isDraw) {
          teamStats.draws += 1
          teamStats.points += 1
        }
        return teamStats
      }, statsForTeam)

      stats.player = team.get('name')
      stats.games_played = statsForTeam.played
      stats.games_won = statsForTeam.wins
      stats.games_lost = statsForTeam.losses
      stats.draws = statsForTeam.draws
      stats.points = statsForTeam.points
      unorderedStats.push(stats)
      return unorderedStats
    }, [])

    return overallStats.sort((teamA, teamB) => {
      let sortResult
      if (teamA.points > teamB.points) sortResult = -1
      if (teamA.points === teamB.points) sortResult = 0
      if (teamA.points < teamB.points) sortResult = 1
      return sortResult
    })
  }

  isWin(match, team) {
    return this.isPlayed(match, team) && match.get('result') === team.id
  }

  isPlayer(match, team) {
    return match.get('local_team_uuid') === team.id || match.get('away_team_uuid') === team.id
  }

  isLoss(match, team) {
    return this.isPlayed(match, team) 
        && this.isPlayer(match, team)
        && !this.isWin(match, team)
        && !this.isDraw(match, team)
  }

  isDraw(match, team) {
    return this.isPlayer(match, team) && match.get('result') === 'draw'
  }

  isPlayed(match, team) {
    return this.isPlayer(match, team) && match.get('status') === 'played'
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
    const stats = this.calculateStats()

    return (
      <div className='Stats'>
        <h3>Stats for { schedule.get('name') }</h3>
        <Link to={{ pathname: '/' }}>Back</Link>
        <table>
          <thead>
            <tr>
              <td></td>
              <td></td>
              <td><abbr title="Games Played">GP</abbr></td>
              <td><abbr title="Games Won">W</abbr></td>
              <td><abbr title="Draws">D</abbr></td>
              <td><abbr title="Games Lost">L</abbr></td>
              <td><abbr title="Points">Pts</abbr></td>
            </tr>
          </thead>
          <tbody>
        {
          stats.map((stat, index) => (
            <tr key={index}>
              <td>{index + 1}</td>
              <td>{stat.player}</td>
              <td>{stat.games_played}</td>
              <td>{stat.games_won}</td>
              <td>{stat.draws}</td>
              <td>{stat.games_lost}</td>
              <td>{stat.points}</td>
            </tr>
          ))
        }
          </tbody>
        </table>
        <Link to={{ pathname: '/' }}>Back</Link>
      </div>
    )
  }
}

export default withRouter(observer(Stats))
