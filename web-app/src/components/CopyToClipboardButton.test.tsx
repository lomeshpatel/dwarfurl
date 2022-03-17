import { fireEvent, render, screen } from "@testing-library/react"
import CopyToClipboardButton from "./CopyToClipboardButton"

describe('CopyToClipboardButton', () => {
  const copyText = "Scooby Doo!"
  const writeToClipboard = jest.fn()
  let button: any

  beforeEach(() => {
    render(<CopyToClipboardButton copyText={copyText} writeToClipboard={writeToClipboard} />)
    button = screen.getByRole('button')
  })

  test('renders the button', () => {
    expect(button).toBeInTheDocument()
  })

  test('copies the text to the clipboard', () => {
    fireEvent.click(button)

    expect(writeToClipboard).toHaveBeenCalledWith(copyText)
  })

  test('renders a toast after a successful copy', () => {
    fireEvent.click(button)

    expect(screen.getByText(/copied/i)).toBeInTheDocument()
  })
})