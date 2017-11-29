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
    const { teams } = this.props
    teams.create({ name: this.state.team })
  }

  render() {
    const { teams } = this.props

    if (teams.isRequest('creating')) {
      return <div className='FormSaving'>Saving team...</div>
    }

    return (
      <form onSubmit={ this.onSubmit.bind(this) } className='TeamForm'>
        <label className='Form__Label'>

          <span>Name</span>
          <input className='Form__Textarea' onChange={ this.onChange.bind(this) } type='text' />
        </label>
        <button className='Form__Submit' type='submit'>Add</button>
      </form>
    )
  }
})
