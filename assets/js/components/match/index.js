import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'

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

  render() {
    const { match } = this.props
    const localTeam = this.localTeam()
    const awayTeam = this.awayTeam()
    const className = match.isNew
      ? 'Match Match--New'
      : 'Match'

    return (
      <div className={ className }>
        <span className='number'>{match.get('match_number') + 1} - </span>
        <span className='local'>{localTeam.get('name')} </span>
        versus
        <span className='away'> {awayTeam.get('name')}</span>
        <span className='status'> <strong>[{match.get('status')}]</strong> </span>
        <button>Mark as played</button>
      </div>
    )
  }
})
