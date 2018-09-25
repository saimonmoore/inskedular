import React, { Component } from 'react' // eslint-disable-line no-unused-vars

class InlineInput extends Component {
  static ENTER_KEY = 13

  constructor(props) {
    super(props)

    this.handleChange = this.handleChange.bind(this)
    this.handleKey = this.handleKey.bind(this)
    this.toggleEditing = this.toggleEditing.bind(this)
    this.state = { editing: false }
  }

  handleChange(event) {
    const { value } = event.target
    this.setState({ value })
  }

  handleKey(event) {
    const { which: key } = event
    if (key === InlineInput.ENTER_KEY) this.toggleEditing()
  }

  toggleEditing() {
    const { editing, value } = this.state
    const { onChange } = this.props
    const newEditing = !editing
    this.setState({ editing: newEditing }, () => (
      !newEditing && onChange && onChange(value)
    ))
  }

  renderInput() {
    const stateValue = this.state.value
    const propsValue = this.props.value
    const value = stateValue || propsValue
    return (
      <input autoFocus value={ value } onKeyDown={ this.handleKey } onChange= { this.handleChange } onBlur={ this.toggleEditing } />
    )
  }

  renderText() {
    const stateValue = this.state.value
    const propsValue = this.props.value
    const value = stateValue || propsValue
    return (
      <span onClick={ this.toggleEditing }>{ value }</span>
    )
  }

  render() {
    const { editing } = this.state

    if (editing) return this.renderInput()
    return this.renderText()
  }
}

export default InlineInput
