/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import schedules from '../../stores/schedules'
import Loading from '../loading'
import Schedule from '../schedule'

class Schedules extends Component {
  componentWillMount() {
    schedules.fetch()
  }

  render() {
    if (schedules.isRequest('fetching')) {
      return <Loading label='schedules' />
    }

    return (
      <div className='Schedules'>
        {
          schedules.models.map(schedule => (
            <Schedule key={ schedule.id } schedule={ schedule } />
          ))
        }
      </div>
    )
  }
}

export default observer(Schedules)
