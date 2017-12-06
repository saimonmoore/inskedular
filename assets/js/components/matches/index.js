/* eslint no-param-reassign: ["error", { "props": true, "ignorePropertyModificationsFor": ["node"] }] */

import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import { withRouter } from 'react-router-dom'
import matches from '../../stores/matches'
import Loading from '../loading'
import Match from '../Match'

class Matches extends Component {
  componentWillMount() {
    const { match } = this.props
    if (match && match.params) {
      const { schedule_uuid } = match.params
      matches.fetch({ data: { schedule_uuid } })
    }
  }

  render() {
    // const { schedule } = this.props
    if (matches.isRequest('fetching')) {
      return <Loading label='matches' />
    }

    return (
      <div className='Matches'>
        {
          matches.models.map(match => (
            <Match key={ match.id } match={ match } />
          ))
        }
      </div>
    )
  }
}

export default withRouter(observer(Matches))
