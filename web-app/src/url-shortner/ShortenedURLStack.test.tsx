import { render, screen } from "@testing-library/react"
import { rest } from "msw"
import { setupServer } from "msw/node"
import { DwarfURL } from "./URLShortnerService"
import ShortenedURLStack from "./ShortenedURLStack"

const server = setupServer(
  rest.post('/v1/urls', (req, res, ctx) => {
    const { url } = req.body as { url: DwarfURL }
    const respBody = { data: { ...url, slug: "slug" } }

    return res(
      ctx.status(201),
      ctx.json(respBody),
    )
  })
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

describe('Shortened URL Stack', () => {
  test('is not rendered when no shortened URLs found', () => {
    render(<ShortenedURLStack dwarfURLs={[]} />)
    expect(screen.getByText(/^recent urls/i)).toBeInTheDocument()
    expect(screen.getByText(/^no recent urls/i)).toBeInTheDocument()
  })
})