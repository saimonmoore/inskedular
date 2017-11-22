import React, { Component } from 'react' // eslint-disable-line no-unused-vars

class ScheduleForm extends Component {
  constructor(props) {
    super(props)
    this.state = { form: {}, value: '' }

    this.handleChange = this.handleChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.createSchedule = this.createSchedule.bind(this)
  }

  handleChange(event) {
    this.setState({ value: event.target.value })
  }

  createSchedule() {
    const { name } = this.state.form
    const headers = new Headers()
    headers.set('Accept', 'application/json')

    const body = new FormData()
    body.append('name', name)

    const conf = {
      method: 'POST',
      mode: 'cors',
      cache: 'default',
      headers,
      body,
    }

    fetch('/api/v1/schedule', conf).then(response => {
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
    const input = target.querySelector('input[type=text]')
    const name = this.state.value
    this.setState({ form: { name } }, () => {
      console.log(`The form was submitted: ${this.state.form.name}`)
      this.createSchedule()
      input.value = ''
    })
    event.preventDefault()
  }

  render() {
    return (
      <form onSubmit={ this.handleSubmit }>
        <label>
          Name:
          <input type="text" value={ this.state.value } onChange={ this.handleChange } />
        </label>
        <input type="submit" value="Create" />
      </form>
    )
  }
}

export default ScheduleForm
