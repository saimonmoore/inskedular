import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'

export default observer(class Team extends Component {
  render() {
    const { team } = this.props
    const className = team.isNew
      ? 'Team Team--New'
      : 'Team'

    return (
      <div className={ className }>
        {team.get('name')}
      </div>
    )
  }
})
