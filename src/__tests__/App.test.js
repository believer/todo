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

  expect(screen.getByLabelText(/hello/i)).toBeInTheDocument()
  expect(screen.getByLabelText(/new todo/i)).toHaveValue('')
})

test('complete todo item when clicking checkbox', () => {
  setup()

  userEvent.type(screen.getByLabelText(/new todo/i), 'Hello{enter}')
  userEvent.click(screen.getByRole('checkbox', { name: /hello/i }))

  expect(screen.getByRole('checkbox', { name: /hello/i })).toBeChecked()
})

test('completed tasks can be archived', () => {
  setup()

  userEvent.type(screen.getByLabelText(/new todo/i), 'Hello{enter}')
  userEvent.click(screen.getByRole('checkbox', { name: /hello/i }))
  userEvent.click(screen.getByRole('button', { name: /archive todos/i }))

  expect(
    screen.queryByRole('checkbox', { name: /hello/i })
  ).not.toBeInTheDocument()
})

test('remove a todo', () => {
  setup()

  userEvent.type(screen.getByLabelText(/new todo/i), 'Hello{enter}')
  userEvent.click(screen.getByRole('button', { name: /remove/i }))

  expect(screen.queryByText(/hello/i)).not.toBeInTheDocument()
})

test('can update a todo', () => {
  setup()

  userEvent.type(screen.getByLabelText(/new todo/i), 'Hello{enter}')
  userEvent.click(screen.getByRole('button', { name: /hello/i }))
  userEvent.type(
    screen.getByRole('textbox', { name: /hello/i }),
    '{selectall}Goodbye{enter}'
  )

  expect(screen.getByRole('button', { name: /goodbye/i })).toBeInTheDocument()
  expect(screen.queryByText(/hello/i)).not.toBeInTheDocument()
})

test('can search in todos', () => {
  setup()

  userEvent.type(screen.getByLabelText(/new todo/i), 'Good morning{enter}')
  userEvent.type(screen.getByLabelText(/new todo/i), 'Goedemorgen{enter}')
  userEvent.type(screen.getByLabelText(/new todo/i), 'God morgon{enter}')

  expect(screen.getByLabelText(/good morning/i)).toBeInTheDocument()
  expect(screen.getByLabelText(/goedemorgen/i)).toBeInTheDocument()
  expect(screen.getByLabelText(/god morgon/i)).toBeInTheDocument()

  userEvent.type(screen.getByLabelText(/search/i), 'goede')

  expect(screen.queryByLabelText(/good morning/i)).not.toBeInTheDocument()
  expect(screen.queryByLabelText(/god morgon/i)).not.toBeInTheDocument()
  expect(screen.getByLabelText(/goedemorgen/i)).toBeInTheDocument()
})
