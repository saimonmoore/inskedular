import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter, Redirect } from 'react-router-dom'

export default withRouter(observer(class Schedule extends Component {
  constructor(props) {
    super(props)
    this.state = {
      redirected: false,
    }
  }

  redirectToScheduleShow() {
    this.setState({ redirected: true })
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
    const { redirected } = this.state
    const { schedule } = this.props
    if (redirected) {
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
        <span className="games">
          {schedule.get('number_of_games')} games @ {schedule.get('game_duration')} minutes each
        </span>
        <span className="actions"><button onClick={ this.handleStartSchedule }>{ scheduleStatus }</button></span>
      </div>
    )
  }
}))
