import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import InlineInput from '../inline_input'

export default observer(class Team extends Component {
  constructor(props) {
    super(props)
    this.nameChanged = this.nameChanged.bind(this)
  }

  nameChanged(name) {
    const { team } = this.props
    team.save({ name })
  }

  handleDelete() {
    const { team } = this.props
    team.destroy()
  }

  render() {
    const { team, index, schedule } = this.props
    const isRunning = schedule.get('status') === 'running'
    const className = team.isNew
      ? 'Team Team--New'
      : 'Team'

    return (
      <tr className={ className } >
        <td className='number'>{index}</td>
        <td className='name'>
            <InlineInput
              value={ team.get('name') }
              onChange={ this.nameChanged }
              style={{
                backgroundColor: 'yellow',
                minWidth: 150,
                display: 'inline-block',
                margin: 0,
                padding: 0,
                fontSize: 15,
                outline: 0,
                border: 0,
              }}
            />
        </td>
        <td className='actions' >
          {
            !isRunning && <button onClick={ this.handleDelete.bind(this) } className="button">Delete</button>
          }
        </td>
      </tr>
    )
  }
})
