import { render, screen, fireEvent } from "@testing-library/react"
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

      expect(longURLTB).toHaveValue(validURL)
      expect(screen.queryByText(/URL must be a valid one/i)).toBeNull()
    })
  })

  describe('Slug textbox', () => {
    test('renders', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const slugTB = screen.getByRole('textbox', { name: /slug/i })

      expect(slugTB).toBeInTheDocument()
      expect(slugTB).not.toBeRequired()
    })

    test('displays error message for slug shorter than 4 characters', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const slugTB = screen.getByRole('textbox', { name: /slug/i })
      userEvent.type(slugTB, 'ab')

      expect(screen.getByText(/Slug must not be shorter than 4 characters/)).toBeInTheDocument()
    })

    test('displays error message for slug longer than 16 characters', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const slugTB = screen.getByRole('textbox', { name: /slug/i })
      userEvent.type(slugTB, 'abcdefghijklmnopq')

      expect(screen.getByText(/Slug must not be longer than 16 characters/)).toBeInTheDocument()
    })

    test('displays no error message when no slug is entered', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const slugTB = screen.getByRole('textbox', { name: /slug/i })
      userEvent.type(slugTB, 'ab')
      const errEl = screen.getByText(/Slug must not be shorter than 4 characters/)
      expect(errEl).toBeInTheDocument()

      fireEvent.change(slugTB, { target: { value: '' } })

      expect(screen.queryByText(/Slug must not be shorter than 4 characters/)).toBeNull()
      expect(screen.queryByText(/Slug must not be longer than 16 characters/)).toBeNull()
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

    test('is disabled when a valid Long URL and too short slug is entered', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      const slugTB = screen.getByRole('textbox', { name: /slug/i })
      const shortenBtn = screen.getByRole('button', { name: /shorten/i })
      userEvent.type(longURLTB, validURL)
      expect(shortenBtn).toBeEnabled()

      userEvent.type(slugTB, 'ab')
      expect(shortenBtn).toBeDisabled()
    })

    test('is disabled when a valid Long URL and too long slug is entered', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      const slugTB = screen.getByRole('textbox', { name: /slug/i })
      const shortenBtn = screen.getByRole('button', { name: /shorten/i })
      userEvent.type(longURLTB, validURL)
      expect(shortenBtn).toBeEnabled()

      userEvent.type(slugTB, 'abcdefghijklmnopq')
      expect(shortenBtn).toBeDisabled()
    })

    test('is disabled when a valid Long URL and invalide slug is entered and then enabled when valid slug is entered', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      const slugTB = screen.getByRole('textbox', { name: /slug/i })
      const shortenBtn = screen.getByRole('button', { name: /shorten/i })
      userEvent.type(longURLTB, validURL)
      expect(shortenBtn).toBeEnabled()

      userEvent.type(slugTB, 'abcdefghijklmnopq')
      expect(shortenBtn).toBeDisabled()

      userEvent.type(slugTB, '{backspace}')
      expect(shortenBtn).toBeEnabled()
    })

    test('is disabled when a valid Long URL and invalide slug is entered and then enabled when slug is removed', () => {
      render(<URLShortnerForm shortenURL={() => { return }} />)
      const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
      const slugTB = screen.getByRole('textbox', { name: /slug/i })
      const shortenBtn = screen.getByRole('button', { name: /shorten/i })
      userEvent.type(longURLTB, validURL)
      expect(shortenBtn).toBeEnabled()

      userEvent.type(slugTB, 'ab')
      expect(shortenBtn).toBeDisabled()

      userEvent.type(slugTB, '{backspace}{backspace}')
      expect(shortenBtn).toBeEnabled()
    })
  })
})