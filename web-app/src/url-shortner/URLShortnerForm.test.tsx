import { fireEvent, render, screen } from "@testing-library/react"
import userEvent from "@testing-library/user-event"
import URLShortnerForm from "./URLShortnerForm"
import { rest } from "msw"
import { setupServer } from "msw/node"
import { DwarfURL } from "./URLShortnerService"

const server = setupServer(
  rest.post('/v1/urls', (req, res, ctx) => {
    console.log(`Request: ${JSON.stringify(req)}`)
  })
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

describe('URLShortnerForm', () => {
  const validURL = 'https://www.looneytunes.com/daffy/duck'
  let longURLTB: any
  beforeEach(() => {
    render(<URLShortnerForm shortenURL={() => { return }} />)
    longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
  })

  describe('Long URL textbox', () => {
    test('renders', () => {
      expect(longURLTB).toBeInTheDocument()
      expect(longURLTB).toBeRequired()
    })

    test('displays error message for invalid Long URL', () => {
      userEvent.type(longURLTB, 'invalid url')

      expect(screen.getByText(/URL must be a valid one/i)).toBeInTheDocument()
    })

    test('accepts valid Long URL', () => {
      userEvent.type(longURLTB, validURL)

      expect(screen.queryByText(/URL must be a valid one/i)).toBeNull()
    })
  })

  describe('Shorten button', () => {
    let shortenBtn: any

    beforeEach(() => {
      shortenBtn = screen.getByRole('button', { name: /shorten/i })
    })

    test('renders disabled button when Long URL is blank', () => {
      expect(shortenBtn).toBeInTheDocument()
      expect(shortenBtn).toBeDisabled()
    })

    test('is disabled when an invalid Long URL is entered', () => {
      userEvent.type(longURLTB, 'invalid url')

      expect(shortenBtn).toBeDisabled()
    })

    test('is enabled when a valid Long URL is entered', () => {
      userEvent.type(longURLTB, validURL)

      expect(shortenBtn).toBeEnabled()
    })

    // test('makes an API call when clicked with valid input', async () => {
    // })
  })
})