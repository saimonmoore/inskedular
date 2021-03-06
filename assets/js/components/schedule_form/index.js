/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { withRouter, Redirect, NavLink } from 'react-router-dom'
import { observer } from 'mobx-react'
import moment from 'moment'
import schedules from '../../stores/schedules'

const WrappedLink = props => (
  <button className='button' style={{ marginLeft: '250px' }}>
    <NavLink { ...props } />
  </button>
)

const styles = {
  validation: {
    color: "red",
  }
}

class ScheduleForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      form: {},
      submitted: false,
      valid: true,
      name: '',
      competition_type: 'league',
      number_of_games: 1,
      number_of_weeks: 1,
      game_duration: 60,
      start_date: moment().format('YYYY-MM-DDTHH:mm:ss\\.SSSSSSZ'),
      end_date: moment().format('YYYY-MM-DDTHH:mm:ss\\.SSSSSSZ'),
    }

    this.handleInputChange = this.handleInputChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.createSchedule = this.createSchedule.bind(this)
    this.updateSchedule = this.updateSchedule.bind(this)
  }

  componentDidMount() {
    schedules.fetch().then(() => {
      const schedule = this.schedule()

      if (!schedule) return
      this.setState(schedule.toJS(), state => {
        console.log('state is now: ', state, this.state)
      })
    })
  }

  scheduleId() {
    let scheduleUuid
    const { match } = this.props
    if (match && match.params) {
      scheduleUuid = match.params.schedule_uuid
    }

    return scheduleUuid
  }

  schedule() {
    const scheduleId = this.scheduleId()
    if (!scheduleId) return null
    return schedules.find({ uuid: scheduleId })
  }

  handleInputChange(event) {
    const { target } = event
    const value = target.type === 'checkbox' ? target.checked : target.value
    const { name } = target

    this.setState({
      [name]: value,
    })
  }

  createSchedule() {
    const {
      name,
      competition_type,
      number_of_games,
      number_of_weeks,
      game_duration,
      start_date,
      end_date,
    } = this.state

    return schedules.create({
      name,
      competition_type,
      number_of_games,
      number_of_weeks,
      game_duration,
      start_date,
      end_date,
    }, { optimistic: false })
  }

  updateSchedule() {
    const schedule = this.schedule()
    const {
      name,
      competition_type,
      number_of_games,
      number_of_weeks,
      game_duration,
      start_date,
      end_date,
    } = this.state

    return schedule.save({
      name,
      competition_type,
      number_of_games,
      number_of_weeks,
      game_duration,
      start_date,
      end_date,
    }, { optimistic: false })
  }

  createOrUpdateSchedule() {
    let schedule
    const { uuid } = this.state
    const moreState = { submitted: true }

    if (uuid) {
      schedule = this.schedule()
      moreState.submitted = false
    }
    const promise = schedule ? this.updateSchedule() : this.createSchedule()
    promise.then(json => {
      this.setState({ ...moreState, uuid: json.uuid })

      // if (!uuid) this.resetForm()
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  resetForm() {
    const nodes = this.inputNodes()
    nodes.forEach(node => {
      node.value = ''
    })
  }

  validate() {
    const { name } = this.state

    const valid = name.length >= 2

    if (!valid) {
      this.setState({ valid })
    }

    return valid
  }

  handleSubmit(event) {
    event && event.preventDefault()

    if (!this.validate()) {
      return
    }
    this.createOrUpdateSchedule()
  }

  render() {
    let schedule
    const { submitted, uuid, valid } = this.state
    if (submitted) {
      return <Redirect to={{ pathname: `/add_teams/${uuid}` }}/>
    }

    if (uuid) {
      schedule = this.schedule()
    }

    const submitLabel = schedule ? 'Update' : 'Create'
    return (
      <form onSubmit={ this.handleSubmit }>
        <label>
          Name:
          <input
            id='schedule_name'
            name='name'
            type="text"
            value={ this.state.name }
            onChange={ this.handleInputChange } />
          { !valid && ( <span style={styles.validation}>'name' is required!</span>)}
        </label>
        <label>
          Competition Type:
          <select
            disabled
            id='schedule_competition_type'
            name='competitionType'
            value={ this.state.competition_type }
            title="Only league is supported for now..."
            onChange={ this.handleInputChange } >
            <option value="league">League</option>
            <option value="knockout">Knockout</option>
          </select>
        </label>
        <label>
          {/* Starting on: */}
          <input
            id='schedule_start_date'
            name='start_date'
            type="hidden"
            value={ this.state.start_date }
            onChange={ this.handleInputChange } />
        </label>
        <label>
          {/* Ending on: */}
          <input
            id='schedule_end_date'
            type="hidden"
            name='end_date'
            value={ this.state.end_date }
            onChange={ this.handleInputChange } />
        </label>
        <label>
          Number of games:
          <select
            id='schedule_number_of_games'
            name='number_of_games'
            value={ this.state.number_of_games }
            onChange={ this.handleInputChange } >
            {
              Array.from(Array(10).keys()).map((gameNumber) => (
                <option key={gameNumber + 1} value={gameNumber + 1}>{gameNumber + 1}</option>
              ))
            }
          </select>
        </label>
        <label>
          {/* Number of weeks: */}
          <input
            id='schedule_number_of_weeks'
            name='number_of_weeks'
            type="hidden"
            value={ this.state.number_of_weeks }
            onChange={ this.handleInputChange } />
        </label>
        <label>
          {/* Duration of each game (minutes): */}
          <input
            id='schedule_game_duration'
            type="hidden"
            name='game_duration'
            value={ this.state.game_duration }
            onChange={ this.handleInputChange } />
        </label>

        <input type="submit" value={ submitLabel } />
        {
          schedule && <WrappedLink to={{ pathname: `/add_teams/${schedule.id}` }}>Update Teams</WrappedLink>
        }
      </form>
    )
  }
}

export default withRouter(observer(ScheduleForm))
