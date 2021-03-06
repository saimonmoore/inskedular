/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import teams from '../../stores/teams'
import Loading from '../loading'
import Team from '../team'
import TeamForm from '../team_form'

class Teams extends Component {
  constructor(props) {
    super(props)
    this.state = { name: '' }
  }

  componentWillMount() {
    const { schedule } = this.props
    teams.fetch({ data: { schedule_uuid: schedule.get('uuid') } })
  }

  render() {
    if (teams.isRequest('fetching')) {
      return <Loading label='teams' />
    }

    const { schedule } = this.props
    return (
      <div className='Teams'>
        <table>
          <thead>
            <tr>
              <td>Number</td>
              <td>Name</td>
              <td>Action</td>
            </tr>
          </thead>
          <tbody>
        {
          teams.models.map((team, index) => (
            <Team key={ team.id } team={ team } index={ index + 1 } schedule={ schedule } />
          ))
        }
          </tbody>
        </table>
        <TeamForm schedule ={ schedule } teams={ teams } />
      </div>
    )
  }
}

export default observer(Teams)
