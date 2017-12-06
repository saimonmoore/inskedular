import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import teams from '../../stores/teams'

export default observer(class Match extends Component {
  constructor(props) {
    super(props)
    this.state = {}
  }

  componentWillMount() {
    const { schedule } = this.props
    teams.fetch({ data: { schedule_uuid: schedule.get('uuid') } })
  }

  localTeam() {
    const { match } = this.props
    return teams.get(match.local_team_uuid)
  }

  awayTeam() {
    const { match } = this.props
    return teams.get(match.away_team_uuid)
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
        <span className='number'>{match.get('match_number')}</span>
        &nbps;
        <span className='local'>{localTeam.get('name')}</span>
        &nbps;
        versus
        &nbps;
        <span className='away'>{awayTeam.get('name')}</span>
        &nbps;
        <span className='status'>[{match.get('status')}]</span>
        &nbps;
        <button>Played</button>
      </div>
    )
  }
})
