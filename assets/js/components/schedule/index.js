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

  render() {
    const { redirected } = this.state
    const { schedule } = this.props
    if (redirected) {
      return <Redirect to={{
                             pathname: '/show_schedule',
                             state: { schedule_uuid: schedule.id },
                           }}/>
    }


    const className = schedule.isNew
      ? 'Schedule Schedule--New'
      : 'Schedule'

    return (
      <div className={ className } onClick={ this.redirectToScheduleShow.bind(this) }>
        <span className="name">{schedule.get('name')}</span>
        <span className="games">
          {schedule.get('number_of_games')} games @ {schedule.get('game_duration')} minutes each
        </span>
        <span className="actions"><button>Start</button></span>
      </div>
    )
  }
}))
