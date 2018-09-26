/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import schedules from '../../stores/schedules'
import Loading from '../loading'
import Schedule from '../schedule'

const styles = {
  active: {
    marginBottom: '15px',
  },
  completed: {
    opacity: 0.7,
  }
}

class Schedules extends Component {
  componentWillMount() {
    schedules.fetch()
  }

  nonTerminatedSchedules() {
    return schedules.models.filter(schedule => (
      ['completed', 'terminated'].every((status) => schedule.get('status') !== status) 
    ))
  }

  completedSchedules() {
    return schedules.models.filter(schedule => (
      schedule.get('status') === 'completed'
    ))
  }

  render() {
    const nonTerminatedSchedules = this.nonTerminatedSchedules()
    const completedSchedules = this.completedSchedules()

    if (schedules.isRequest('fetching')) {
      return <Loading label='schedules' />
    }

    return (
      <div className='Schedules'>
        <h4>Active</h4>
        <div style={styles.active}>
          {
            !nonTerminatedSchedules.length && <span>No active tournaments!</span>
          }
          {
            nonTerminatedSchedules.map(schedule => (
              <Schedule key={ schedule.id } schedule={ schedule } />
            ))
          }
        </div>
        {
          !!completedSchedules.length && (
            <div>
              <h4>Completed</h4>
              <div style={styles.completed}>
                {
                  completedSchedules.map(schedule => (
                    <Schedule key={ schedule.id } schedule={ schedule } />
                  ))
                }
              </div>
            </div>
          )
        }
      </div>
    )
  }
}

export default observer(Schedules)
