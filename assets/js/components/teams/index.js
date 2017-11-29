/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import schedules from '../../stores/schedules'
import teams from '../../stores/teams'
import Loading from '../loading'
import Team from '../team'
import TeamForm from '../team_form'

class Teams extends Component {
  componentWillMount() {
    const { schedule } = this.props
    teams.fetch({ schedule_id: schedule.get('uuid') })
  }

  schedule() {
    const { schedule_uuid } = this.state
    return schedules.find({ uuid: schedule_uuid })
  }

  render() {
    if (teams.isRequest('fetching')) {
      return <Loading label='teams' />
    }

    return (
      <div className='Teams'>
        {
          teams.models.forEach(team => (
            <Team key={ team.id } team={ team } />
          ))
        }
        <TeamForm teams={ teams } />
      </div>
    )
  }
}

export default observer(Teams)
