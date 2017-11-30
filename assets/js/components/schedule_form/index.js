/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { withRouter, Redirect, Link } from 'react-router-dom'
import { observer } from 'mobx-react'
import moment from 'moment'
import schedules from '../../stores/schedules'

class ScheduleForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      form: {},
      submitted: false,
      name: '',
      numberOfGames: 4,
      gameDuration: 60,
      startDate: moment().format('YYYY-MM-DDTHH:mm:ss\\.SSSSSSZ'),
      endDate: moment().format('YYYY-MM-DDTHH:mm:ss\\.SSSSSSZ'),
    }

    this.handleChangeName = this.handleChangeName.bind(this)
    this.handleChangeNumberOfGames = this.handleChangeNumberOfGames.bind(this)
    this.handleChangeGameDuration = this.handleChangeGameDuration.bind(this)
    this.handleChangeStartDate = this.handleChangeStartDate.bind(this)
    this.handleChangeEndDate = this.handleChangeStartDate.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.createSchedule = this.createSchedule.bind(this)
    this.updateSchedule = this.updateSchedule.bind(this)

    if (!props.location.state) {
      return
    }
    const { schedule_uuid } = props.location.state
    if (schedule_uuid) {
      this.state = Object.assign(this.state, this.schedule().toJS())
    }
  }

  componentWillMount() {
    schedules.fetch()
  }

  schedule() {
    const { schedule_uuid } = this.props.location.state
    if (!schedule_uuid) {
      return null
    }
    return schedules.find({ uuid: schedule_uuid })
  }

  handleChangeName(event) {
    this.setState({ name: event.target.value })
  }

  handleChangeNumberOfGames(event) {
    this.setState({ numberOfGames: event.target.value })
  }

  handleChangeGameDuration(event) {
    this.setState({ gameDuration: event.target.value })
  }

  handleChangeStartDate(event) {
    this.setState({ startDate: event.target.value })
  }

  handleChangeEndDate(event) {
    this.setState({ endDate: event.target.value })
  }

  createSchedule() {
    const {
      name,
      numberOfGames,
      gameDuration,
      startDate,
      endDate,
    } = this.state.form

    return schedules.create({
      name,
      number_of_games: numberOfGames,
      game_duration: gameDuration,
      start_date: startDate,
      end_date: endDate,
    }, { optimistic: false })
  }

  updateSchedule() {
    const schedule = this.schedule()
    const {
      name,
      numberOfGames,
      gameDuration,
      startDate,
      endDate,
    } = this.state.form

    return schedule.save({
      name,
      number_of_games: numberOfGames,
      game_duration: gameDuration,
      start_date: startDate,
      end_date: endDate,
    }, { optimistic: false })
  }

  createOrUpdateSchedule() {
    const schedule = this.schedule()
    const promise = schedule ? this.updateSchedule() : this.createSchedule()
    promise.then(json => {
      this.setState({ submitted: true, schedule_uuid: json.uuid })
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  inputNodes() {
    return document.querySelectorAll(`input#schedule_name,
                                    input#schedule_start_date,
                                    input#schedule_end_date,
                                    input#schedule_number_of_games,
                                    input#schedule_game_duration`)
  }

  resetForm() {
    const nodes = this.inputNodes()
    nodes.forEach(node => {
      node.value = ''
    })
  }

  handleSubmit(event) {
    const nodes = this.inputNodes()

    const [
      name,
      startDate,
      endDate,
      numberOfGames,
      gameDuration,
    ] = nodes
    const data = {
      form: {
        name: name.value,
        numberOfGames: numberOfGames.value,
        gameDuration: gameDuration.value,
        startDate: startDate.value,
        endDate: endDate.value,
      },
    }
    this.setState(data, () => {
      this.createOrUpdateSchedule()
      this.resetForm()
    })
    event.preventDefault()
  }

  render() {
    const { submitted, schedule_uuid } = this.state
    if (submitted) {
      return <Redirect to={{
                             pathname: '/add_teams',
                             state: { schedule_uuid },
                           }}/>
    }

    const schedule = this.schedule()
    const submitLabel = schedule ? 'Update' : 'Create'
    return (
      <form onSubmit={ this.handleSubmit }>
        <label>
          Name:
          <input
            id='schedule_name'
            type="text"
            value={ this.state.name }
            onChange={ this.handleChangeName } />
        </label>
        <label>
          Starting on:
          <input
            id='schedule_start_date'
            type="text"
            value={ this.state.startDate }
            onChange={ this.handleChangeStartDate } />
        </label>
        <label>
          Ending on:
          <input
            id='schedule_end_date'
            type="text"
            value={ this.state.endDate }
            onChange={ this.handleChangeEndDate } />
        </label>
        <label>
          Number of games per week:
          <input
            id='schedule_number_of_games'
            type="text"
            value={ this.state.numberOfGames }
            onChange={ this.handleChangeNumberOfGames } />
        </label>
        <label>
          Duration of each game (seconds):
          <input
            id='schedule_game_duration'
            type="text"
            value={ this.state.gameDuration }
            onChange={ this.handleChangeGameDuration } />
        </label>

        <input type="submit" value={ submitLabel } />
        {
          schedule && <Link to={{ pathname: '/add_teams', state: { schedule_uuid: schedule.id } }}>Update Teams</Link>
        }
      </form>
    )
  }
}

export default withRouter(observer(ScheduleForm))
