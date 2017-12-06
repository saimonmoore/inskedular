import React from 'react' // eslint-disable-line no-unused-vars
import {
  HashRouter as Router,
  Route,
  Link,
  NavLink,
  Switch,
} from 'react-router-dom'

import { apiClient } from 'mobx-rest'
import adapter from 'mobx-rest-fetch-adapter'

import ScheduleForm from '../schedule_form'
import Schedules from '../schedules'
import AddTeams from '../add_teams'
import Matches from '../matches'

import DevTools from 'mobx-react-devtools'

// Initialize mob-rest API adapter
apiClient(adapter, {
  commonOptions: {
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
  },
})

const Home = () => (
  <section className="box special">
    <Schedules />
    <header className="major">
      <h2>New Schedule</h2>
      <p>Click to create a Schedule</p>
    </header>
    <NavLink to="/new_schedule" activeClassName="button">New Schedule</NavLink>
    <span className="image featured"><img src="/static/images/pic01.jpg" alt="" /></span>
  </section>
)

const NewSchedule = () => (
  <section className="box special">
    <header className="major">
      <h2>New Schedule</h2>
      <ScheduleForm />
    </header>
    <Link to="/">Back</Link>
  </section>
)

const ShowSchedulePage = () => (
  <section className="box special">
    <header className="major">
      <ScheduleForm />
    </header>
    <Link to="/">Back</Link>
  </section>
)

const AddTeamsPage = () => (
  <section className="box special">
    <header className="major">
      <AddTeams />
    </header>
  </section>
)

const MatchesPage = () => (
  <section className="box special">
    <header className="major">
      <Matches />
    </header>
  </section>
)

const App = () => (
  <Router>
    <div className="features-row">
      <Switch>
        <Route exact path="/" component={ Home }/>
        <Route path="/new_schedule" component={ NewSchedule }/>
        <Route path="/add_teams" component={ AddTeamsPage }/>
        <Route path="/show_schedule" component={ ShowSchedulePage }/>
        <Route path="/matches/:schedule_uuid" component={ MatchesPage }/>
      </Switch>
      <DevTools />
    </div>
  </Router>
)

export default App
