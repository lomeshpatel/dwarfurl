import { render, screen } from "@testing-library/react"
import userEvent from "@testing-library/user-event"
import URLShortnerForm from "./URLShortnerForm"

describe('URLShortnerForm', () => {
  const validURL = 'https://www.looneytunes.com/daffy/duck'

  describe('Long URL textbox', () => {
    test('renders', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      expect(longURLTB).toBeInTheDocument()
      expect(longURLTB).toBeRequired()
    })

    test('displays error message for invalid Long URL', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      userEvent.type(longURLTB, 'invalid url')

      expect(screen.getByText(/URL must be a valid one/i)).toBeInTheDocument()
    })

    test('accepts valid Long URL', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      userEvent.type(longURLTB, validURL)

      expect(screen.queryByText(/URL must be a valid one/i)).toBeNull()
    })
  })

  describe('Shorten button', () => {
    test('renders disabled button when Long URL is blank', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const shortenBtn = screen.getByRole('button', { name: /shorten/i })
      expect(shortenBtn).toBeInTheDocument()
      expect(shortenBtn).toBeDisabled()
    })

    test('is disabled when an invalid Long URL is entered', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      const shortenBtn = screen.getByRole('button', { name: /shorten/i })
      userEvent.type(longURLTB, 'invalid url')

      expect(shortenBtn).toBeDisabled()
    })

    test('is enabled when a valid Long URL is entered', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      const shortenBtn = screen.getByRole('button', { name: /shorten/i })
      userEvent.type(longURLTB, validURL)

      expect(shortenBtn).toBeEnabled()
    })
  })
})