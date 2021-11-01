import React from 'react'
import { render, screen } from '@testing-library/react'
import { make as App } from '../App.bs'
import userEvent from '@testing-library/user-event'

const setup = (customProps = {}) => {
  const props = {
    ...customProps,
  }

  return render(<App {...props} />)
}

test('displays todo list empty state', () => {
  setup()

  expect(screen.getByText(/You don't have any todos/i)).toBeInTheDocument()
})

test('display todo item and clear input when adding new todo', () => {
  setup()

  userEvent.type(screen.getByLabelText(/new todo/i), 'Hello{enter}')

  expect(screen.getByText(/hello/i)).toBeInTheDocument()
  expect(screen.getByLabelText(/new todo/i)).toHaveValue('')
})

test('complete todo item when clicking checkbox', () => {
  setup()

  userEvent.type(screen.getByLabelText(/new todo/i), 'Hello{enter}')
  userEvent.click(screen.getByRole('checkbox', { name: /hello/i }))

  expect(screen.getByText(/hello 2021/i)).toBeInTheDocument()
})
