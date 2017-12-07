import React, { Component } from 'react' // eslint-disable-line no-unused-vars
import { observer } from 'mobx-react'
import ReactModal from 'react-modal'

ReactModal.setAppElement('#page-wrapper')

export default observer(class Match extends Component {
  constructor(props) {
    super(props)
    this.state = {
      showModal: false,
      form: {},
      submitting: false,
      result: '',
      score_local_team: 0,
      score_away_team: 0,
    }

    this.handleOpenModal = this.handleOpenModal.bind(this)
    this.handleCloseModal = this.handleCloseModal.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleInputChange = this.handleInputChange.bind(this)
  }

  handleOpenModal() {
    this.setState({ showModal: true })
  }

  handleCloseModal(event) {
    event.preventDefault()
    this.setState({ showModal: false })
  }

  handleSubmit(event) {
    const nodes = this.inputNodes()
    const form = {}
    nodes.forEach(node => {
      form[node.name] = node.value
    })

    const data = {
      form,
    }
    this.setState(data, () => {
      this.updateMatch()
    })
    event.preventDefault()
  }

  handleInputChange(event) {
    const { target } = event
    const value = target.type === 'checkbox' ? target.checked : target.value
    const { name } = target

    this.setState({
      [name]: value,
    })
  }

  inputNodes() {
    return document.querySelectorAll(`select#match_result,
                                    input#match_score_local_team,
                                    input#match_score_away_team`)
  }

  updateMatch() {
    const { match } = this.props
    const status = 'played'
    const {
      result,
      score_local_team,
      score_away_team,
    } = this.state.form

    const promise = match.save({
      result,
      score_local_team,
      score_away_team,
      status,
    }, { optimistic: false })

    this.setState({ submitting: true })
    promise.then(() => {
      this.setState({ submitting: false, showModal: false })
    }).catch(error => {
      console.error(`There has been a problem with your fetch operation: ${error.message}`)
    })
  }

  render() {
    const { localTeam, awayTeam, match } = this.props
    const played = match.get('status') === 'played'
    const submitLabel = match.isRequest('saving') ? 'Saving' : 'Submit'
    const submitDisabled = match.isRequest('saving')

    return (
      <span>
        {
          !played && <button onClick={ this.handleOpenModal }>Mark as played</button>
        }
        <ReactModal
           isOpen={ this.state.showModal }
           contentLabel="onRequestClose Example"
           onRequestClose={ this.handleCloseModal }
           shouldCloseOnOverlayClick={ false }
        >
          <form onSubmit={ this.handleSubmit }>
            <label>
              Result:
              <select
                id='match_result'
                name='result'
                value={ this.state.result }
                onChange={ this.handleInputChange } >
                <option value={ localTeam.id }>Win for { localTeam.get('name') }</option>
                <option value={ awayTeam.id }>Win for { awayTeam.get('name') }</option>
                <option value="draw">Draw</option>
              </select>
            </label>
            <label>
              { localTeam.get('name') }'s score:
              <input
                id='match_score_local_team'
                name='score_local_team'
                type="text"
                value={ this.state.score_local_team }
                onChange={ this.handleInputChange } />
            </label>
            <label>
              { awayTeam.get('name') }'s score:
              <input
                id='match_score_away_team'
                name='score_away_team'
                type="text"
                value={ this.state.score_away_team }
                onChange={ this.handleInputChange } />
            </label>
            <input type="submit" disabled={ submitDisabled } value={ submitLabel } />
            <input type="submit" onClick={ this.handleCloseModal } value='Cancel' style={{marginLeft: '2em'}}/>
          </form>
        </ReactModal>
      </span>
    )
  }
})
