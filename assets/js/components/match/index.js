import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import MatchForm from '../match_form'

export default observer(class Match extends Component {
  constructor(props) {
    super(props)
    this.state = {}
  }

  localTeam() {
    const { match, teams } = this.props
    return teams.get(match.get('local_team_uuid'))
  }

  awayTeam() {
    const { match, teams } = this.props
    return teams.get(match.get('away_team_uuid'))
  }

  result() {
    const { match } = this.props
    const localTeam = this.localTeam()
    const awayTeam = this.awayTeam()
    const result = match.get('result')
    if (result === 'draw') {
      return 'drawed'
    }
    
    const localWinner = result === match.get('local_team_uuid')
    const awayWinner = result === match.get('away_team_uuid')
    if (localWinner) return `${localTeam.get('name')} wins`
    if (awayWinner) return `${awayTeam.get('name')} wins`
    return ''
  }

  render() {
    const { match } = this.props
    const played = match.get('status') === 'played'
    const localTeam = this.localTeam()
    const awayTeam = this.awayTeam()
    const className = match.isNew
      ? 'Match Match--New'
      : 'Match'

    return (
      <tr className={ className } >
        <td className='number'>{match.get('match_number') + 1}</td>
        <td className='local'>{localTeam.get('name')} </td>
        <td className='away'> {awayTeam.get('name')}</td>
        <td className='status'> <strong>{match.get('status')}</strong> </td>
        <td className='result'>
          {
            played && <strong>{this.result()}</strong>
          }
        </td>
        <td className='actions' >
          <MatchForm match={ match } localTeam={ localTeam } awayTeam={ awayTeam } />
        </td>
      </tr>
    )
  }
})
