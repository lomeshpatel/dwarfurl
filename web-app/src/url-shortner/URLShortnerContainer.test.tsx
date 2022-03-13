import { render, screen } from "@testing-library/react";
import URLShortnerContainer from "./URLShortnerContainer";

describe('URL Shortner Container', () => {
  test('renders TextBox for Long URL', () => {
    render(<URLShortnerContainer />);
    
    const textBox = screen.getByRole('textbox');

    expect(textBox).toBeInTheDocument();
    expect(textBox.id).toBe('long-url');
  });

  test('renders Shorten button', () => {
    render(<URLShortnerContainer />);

    const button = screen.getByText(/shorten/i);

    expect(button).toBeInTheDocument();
  });
});