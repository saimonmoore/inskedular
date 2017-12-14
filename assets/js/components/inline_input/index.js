import React, { Component } from 'react' // eslint-disable-line no-unused-vars

class InlineInput extends Component {
  constructor(props) {
    super(props)

    this.handleChange = this.handleChange.bind(this)
    this.toggleEditing = this.toggleEditing.bind(this)
    this.state = { editing: false }
  }

  handleChange(event) {
    const { value } = event.target
    this.setState({ value })
  }

  toggleEditing() {
    const { editing, value } = this.state
    const { onChange } = this.props
    this.setState({ editing: !editing }, () => (
      onChange && onChange(value)
    ))
  }

  renderInput() {
    const stateValue = this.state.value
    const propsValue = this.props.value
    const value = stateValue || propsValue
    return (
      <input value={ value } onChange= { this.handleChange } onBlur={ this.toggleEditing } />
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
