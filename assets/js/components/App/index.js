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
import Stats from '../stats'

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
    <NavLink to="/schedule/new" activeClassName="button">New Schedule</NavLink>
    <header className="major">
      <h3>Schedules</h3>
    </header>
    <Schedules />
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

const SchedulePage = () => (
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

const StatsPage = () => (
  <section className="box special">
    <header className="major">
      <Stats />
    </header>
  </section>
)

const App = () => (
  <Router>
    <div className="features-row">
      <Switch>
        <Route exact path="/" component={ Home }/>
        <Route path="/schedule/new" component={ NewSchedule }/>
        <Route path="/add_teams/:schedule_uuid" component={ AddTeamsPage }/>
        <Route path="/schedule/:schedule_uuid" component={ SchedulePage }/>
        <Route path="/matches/:schedule_uuid" component={ MatchesPage }/>
        <Route path="/stats/:schedule_uuid" component={ StatsPage }/>
      </Switch>
    </div>
  </Router>
)

export default App
