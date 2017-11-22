import React from 'react' // eslint-disable-line no-unused-vars
import {
  HashRouter as Router,
  Route,
  Link,
  NavLink,
  Switch,
} from 'react-router-dom'

import ScheduleForm from '../schedule_form'

const Home = () => (
  <section className="box special">
    <header className="major">
      <h2>New Schedule</h2>
      <p>Click to create a Schedule</p>
    </header>
    <NavLink to="/new_schedule" activeClassName="button">New Schedule</NavLink>
    <span class="image featured"><img src="/static/images/pic01.jpg" alt="" /></span>
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

const App = () => (
  <Router>
    <div className="features-row">
      <Switch>
        <Route exact path="/" component={ Home }/>
        <Route path="/new_schedule" component={ NewSchedule }/>
      </Switch>
    </div>
  </Router>
)

export default App
