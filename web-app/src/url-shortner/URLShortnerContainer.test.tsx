import URLShortnerContainer from "./URLShortnerContainer"
import { fireEvent, render, screen } from "@testing-library/react"
import userEvent from "@testing-library/user-event"
import { rest } from "msw"
import { setupServer } from "msw/node"
import { DwarfURL } from "./URLShortnerService"

const server = setupServer(
  rest.post('/v1/urls', (req, res, ctx) => {
    const { url } = req.body as { url: DwarfURL }
    const respBody = { data: { ...url, slug: "abcd1234" } }

    return res(
      ctx.status(201),
      ctx.json(respBody),
    )
  })
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

describe('URL Shortner Container', () => {
  const validURL = 'https://www.looneytunes.com/daffy/duck'

  test('rendered when a valid form is submitted successfully', async () => {
    render(<URLShortnerContainer />)
    const longURLTB = screen.getByRole('textbox', { name: /Long.URL/i })
    const shortenBtn = screen.getByRole('button', { name: /shorten/i })

    await userEvent.type(longURLTB, validURL)

    fireEvent.click(shortenBtn)

    await screen.findByText(/abcd1234/i)
    expect(screen.queryByText(/^no recent urls/i)).toBeNull()
  })
})