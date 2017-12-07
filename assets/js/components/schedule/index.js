import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter, Redirect, Link } from 'react-router-dom'

export default withRouter(observer(class Schedule extends Component {
  constructor(props) {
    super(props)
    this.state = {
      redirectedToShow: false,
    }
  }

  handleUpdateStatus(event) {
    const { schedule } = this.props
    switch (schedule.get('status')) {
      case 'inactive': this.startSchedule(); break
      case 'running': this.cancelSchedule(); break
      default: this.doNothing(event)
    }
  }

  pollForRunning() {
    const poller = setInterval(this.pollStatus.bind(this), 2000)
    this.setState(poller)
  }

  pollStatus() {
    const { schedule } = this.props
    const { poller } = this.state
    const promise = schedule.fetch()

    promise.then(() => {
      if (schedule.get('status') === 'running') {
        clearInterval(poller)
        this.setState({ poller: false })
      } else {
        this.setState({ poller })
      }
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  cancelSchedule() {
    this.doNothing()
  }
  startSchedule() {
    const { schedule } = this.props

    const promise = schedule.rpc('status', { status: 'start' })
    // const promise = schedule.rpc(`status/${schedule.id}`, { status: 'start' }, { method: 'put' })

    promise.then(json => {
      console.dir(json)
      this.setState({ uuid: schedule.id })
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  doNothing(event) {
    event.preventDefault();
  }

  redirectToScheduleShow() {
    this.setState({ redirectedToShow: true })
  }

  scheduleStatusAction() {
    const { schedule } = this.props
    const scheduleStatus = schedule.get('status')
    switch (scheduleStatus) {
      case 'started': return 'Setting up matches...'
      case 'terminated': return 'Delete'
      case 'running': return 'Cancel'
      case 'inactive': return 'Start'
      default: return 'Delete'
    }
  }

  render() {
    const { redirectedToShow } = this.state
    const { schedule } = this.props
    const isRunning = schedule.get('status') === 'running'

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
        <span className="name" onClick={ this.redirectToScheduleShow.bind(this) } style={{ cursor: 'pointer' }}>
          {schedule.get('name')}
        </span>
        &nbsp;
        <span className="competition_type">({schedule.get('competition_type')})</span>
        &nbsp;
        <span className="games">
          {schedule.get('number_of_games')} games in {schedule.get('number_of_weeks')} weeks
        </span>
        &nbsp;
        <span className="status">
          <strong>{schedule.get('status').toUpperCase()}</strong>
        </span>
        &nbsp;
        <span className="actions">
          <button onClick={ this.handleUpdateStatus.bind(this) }>
            { scheduleStatus }
          </button>
        </span>
        &nbsp;
        {
          isRunning &&
            <Link to={{ pathname: `/matches/${schedule.id}`, state: { schedule_uuid: schedule.id } }}>Matches</Link>
        }
      </div>
    )
  }
}))
