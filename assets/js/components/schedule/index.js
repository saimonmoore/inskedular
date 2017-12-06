import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter, Redirect } from 'react-router-dom'

export default withRouter(observer(class Schedule extends Component {
  constructor(props) {
    super(props)
    this.state = {
      redirectedToShow: false,
      redirectedToMatches: false,
    }
  }

  handleStartSchedule() {
    const { schedule } = this.props

    const promise = schedule.rpc(`status`, { status: 'start' })
    // const promise = schedule.rpc(`status/${schedule.id}`, { status: 'start' }, { method: 'put' })

    promise.then(json => {
      this.setState({ redirectedToMatches: true, uuid: schedule.id })
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  redirectToScheduleShow() {
    this.setState({ redirectedToShow: true })
  }

  scheduleStatusAction() {
    const { schedule } = this.props
    const scheduleStatus = schedule.get('status')
    switch (scheduleStatus) {
      case 'started': return 'Stop'
      case 'terminated': return 'Delete'
      case 'stopped': return 'Restart'
      case 'inactive': return 'Start'
      default: return 'Delete'
    }
  }

  render() {
    const { redirectedToShow } = this.state
    const { schedule } = this.props
    if (redirectedToShow) {
      return <Redirect to={{
                             pathname: '/show_schedule',
                             state: { schedule_uuid: schedule.id },
                           }}/>
    }

    const scheduleStatus = this.scheduleStatusAction()
    const className = schedule.isNew
      ? 'Schedule Schedule--New'
      : 'Schedule'

    return (
      <div className={ className } >
        <span className="name" onClick={ this.redirectToScheduleShow.bind(this) }>{schedule.get('name')}</span>
        <span className="competition_type">{schedule.get('competition_type')}</span>
        <span className="games">
          {schedule.get('number_of_games')} games in {schedule.get('number_of_weeks')} weeks
        </span>
        <span className="actions">
          <button onClick={ this.handleStartSchedule.bind(this) }>
            { scheduleStatus }
          </button>
        </span>
      </div>
    )
  }
}))
