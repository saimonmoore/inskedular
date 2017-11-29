/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { withRouter } from 'react-router-dom'
import { observer } from 'mobx-react'
import schedules from '../../stores/schedules'
import Teams from '../teams'

class AddTeams extends Component {
  constructor(props) {
    super(props)
    const { schedule_uuid } = props.location.state
    this.state = { schedule_uuid }
  }

  componentWillMount() {
    schedules.fetch()
  }

  schedule() {
    const { schedule_uuid } = this.state
    return schedules.find({ uuid: schedule_uuid })
  }

  render() {
    if (schedules.isRequest('fetching')) {
      return (<Loading label='schedule' />)
    }

    const schedule = this.schedule()
    return (
      <div className="Schedule">
      <Teams schedule={ schedule } />
    </div>
    )
  }
}

export default observer(withRouter(AddTeams))
