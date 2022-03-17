import { render, screen } from "@testing-library/react"
import ResponsiveAppBar from "./ResponsiveAppBar"

describe('ResponsiveAppBar', () => {
  test('renders AppBar with title', () => {
    render(<ResponsiveAppBar />)

    expect(screen.getByText(/dwarfurl/i)).toBeInTheDocument()
  })
})