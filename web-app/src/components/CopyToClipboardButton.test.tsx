import { fireEvent, render, screen } from "@testing-library/react"
import CopyToClipboardButton from "./CopyToClipboardButton"

describe('CopyToClipboardButton', () => {
  const copyText = "Scooby Doo!"
  const writeToClipboard = jest.fn()

  beforeEach(() => {
  })

  test('renders the button', () => {
    render(<CopyToClipboardButton copyText={copyText} writeToClipboard={writeToClipboard} />)
    const button = screen.getByRole('button')
    expect(button).toBeInTheDocument()
  })

  test('copies the text to the clipboard', () => {
    render(<CopyToClipboardButton copyText={copyText} writeToClipboard={writeToClipboard} />)
    const button = screen.getByRole('button')
    fireEvent.click(button)

    expect(writeToClipboard).toHaveBeenCalledWith(copyText)
  })

  test('renders a toast after a successful copy', () => {
    render(<CopyToClipboardButton copyText={copyText} writeToClipboard={writeToClipboard} />)
    const button = screen.getByRole('button')
    fireEvent.click(button)

    expect(screen.getByText(/copied/i)).toBeInTheDocument()
  })
})