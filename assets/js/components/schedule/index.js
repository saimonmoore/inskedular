import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter, Redirect, Link } from 'react-router-dom'
import teams from '../../stores/teams'
import Loading from '../loading'

export default withRouter(observer(class Schedule extends Component {
  constructor(props) {
    super(props)
    this.state = {
      redirectedToShow: false,
      polling: false,
      poller: false,
    }
  }

  componentWillMount() {
    const { schedule } = this.props
    teams.fetch({ data: { schedule_uuid: schedule.get('uuid') } })
  }

  handleUpdateStatus(event) {
    const { schedule } = this.props
    switch (schedule.get('status')) {
      case 'inactive': this.startSchedule(); break
      case 'stopped': this.restartSchedule(); break
      case 'running': this.cancelSchedule(); break
      default: this.doNothing(event)
    }
  }

  pollForRunning() {
    const poller = setInterval(() => { this.pollStatus.bind(this)('running') }, 2000)
    this.setState({ poller, polling: true })
  }

  pollForStopped() {
    const poller = setInterval(() => { this.pollStatus.bind(this)('stopped') }, 2000)
    this.setState({ poller, polling: true })
  }

  pollStatus(status) {
    const { schedule } = this.props
    const { poller, polling } = this.state
    const promise = schedule.fetch()

    promise.then(() => {
      if (!polling || schedule.get('status') === status) {
        clearInterval(poller)
        this.setState({ polling: false })
      }
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  cancelSchedule() {
    const { schedule } = this.props

    const promise = schedule.rpc('status', { status: 'stop' })

    promise.then(() => {
      this.setState({ uuid: schedule.id })
      this.pollForStopped()
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  destroySchedule() {
    const { schedule } = this.props

    const promise = schedule.destroy()

    promise.then(() => {
      this.setState({ uuid: schedule.id })
      this.pollForDestroyed()
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  startSchedule() {
    const { schedule } = this.props

    const promise = schedule.rpc('status', { status: 'start' })

    promise.then(() => {
      this.setState({ uuid: schedule.id })
      this.pollForRunning()
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  restartSchedule() {
    const { schedule } = this.props

    const promise = schedule.rpc('status', { status: 'restart' })

    promise.then(() => {
      this.setState({ uuid: schedule.id })
      this.pollForRunning()
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  doNothing(event) {
    event && event.preventDefault();
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
      case 'stopped': return 'Restart'
      default: return 'Delete'
    }
  }

  render() {
    if (teams.isRequest('fetching')) {
      return <Loading label='teams' />
    }

    const { redirectedToShow, polling } = this.state
    const { schedule } = this.props
    const isRunning = schedule.get('status') === 'running'
    const isStopped = schedule.get('status') === 'stopped'
    const pollingAction = isRunning ? 'Stopping' : 'Starting'

    if (redirectedToShow) {
      return <Redirect to={{
                             pathname: `/schedule/${schedule.id}`,
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
          <strong>{schedule.get('name')}</strong>
        </span>
        &nbsp;
        <span className="competition_type">({schedule.get('competition_type')})</span>
        &nbsp;
        <span className="games">
          {schedule.get('number_of_games')} games
        </span>
        &nbsp;
        <span className="status">
          {
            polling ?
              <strong>{pollingAction}...</strong>
              :
              <strong>{schedule.get('status').toUpperCase()}</strong>
          }
        </span>
        &nbsp;
        <span className="actions">
          <button onClick={ this.handleUpdateStatus.bind(this) }>
            { scheduleStatus }
          </button>

          {
            isStopped &&
            <button onClick={ this.destroySchedule.bind(this) }>
              Delete
            </button>
          }
        </span>
        &nbsp;
        {
          isRunning &&
            <span>
              <Link to={{ pathname: `/matches/${schedule.id}`, state: { schedule_uuid: schedule.id } }} style={{ marginRight: '5px' }}>Matches</Link>
              <Link to={{ pathname: `/stats/${schedule.id}`, state: { schedule_uuid: schedule.id } }}>Stats</Link>
            </span>
          }
      </div>
    )
  }
}))
