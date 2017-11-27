/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import moment from 'moment'

class ScheduleForm extends Component {
  constructor(props) {
    super(props)
    this.state = {
      form: {},
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
    const headers = new Headers()
    headers.set('Accept', 'application/json')
    headers.set('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8')

    const body = new URLSearchParams()
    body.append('schedule[name]', name)
    body.append('schedule[number_of_games]', numberOfGames)
    body.append('schedule[game_duration]', gameDuration)
    body.append('schedule[start_date]', startDate)
    body.append('schedule[end_date]', endDate)

    const conf = {
      method: 'POST',
      mode: 'cors',
      cache: 'default',
      headers,
      body,
    }

    fetch('/api/v1/schedules', conf).then(response => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok.')
    }).then(json => {
      console.log(`Got JSON: ${json}`)
    }).catch(error => {
      console.log(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  handleSubmit(event) {
    const { target } = event
    const nodes = target.querySelectorAll(`input#schedule_name,
                                           input#schedule_start_date,
                                           input#schedule_end_date,
                                           input#schedule_number_of_games,
                                           input#schedule_game_duration`)

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
      console.log(`The form was submitted: ${this.state.form.name}`)
      this.createSchedule()
      nodes.forEach(node => {
        node.value = ''
      })
    })
    event.preventDefault()
  }

  render() {
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

        <input type="submit" value="Create" />
      </form>
    )
  }
}

export default ScheduleForm
