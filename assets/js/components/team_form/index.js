import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'

export default observer(class TeamForm extends Component {
  constructor(props) {
    super(props)
    this.state = { name: '' }
  }

  onChange(event) {
    this.setState({ name: event.target.value })
  }

  onSubmit(event) {
    event.preventDefault()
    const { teams, schedule } = this.props
    if (!schedule) {
      this.setState({ error: 'No schedule' })
      return
    }
    teams.create({
      name: this.state.name,
      schedule_uuid: schedule.id,
    }, { optimistic: false })

    this.setState({ error: null })
  }

  focusOnForm() {
    document.getElementById('team-form').focus()
  }

  render() {
    const { teams } = this.props
    const { error } = this.state

    if (error) {
      return <div className='FormError'>{error}</div>
    }

    if (teams.isRequest('creating')) {
      return <div className='FormSaving'>Saving team...</div>
    }

    setTimeout(this.focusOnForm, 200)
    return (
      <form onSubmit={ this.onSubmit.bind(this) } className='TeamForm'>
        <label className='Form__Label'>

          <span>Name</span>
          <input id='team-form' className='Form__Textarea' onChange={ this.onChange.bind(this) } type='text' tabIndex="-1" />
        </label>
        <button className='Form__Submit' type='submit'>Add</button>
      </form>
    )
  }
})
