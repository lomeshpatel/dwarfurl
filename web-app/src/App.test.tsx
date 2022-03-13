import { render, screen } from '@testing-library/react';
import App from './App';

describe('Dwarfurl App', () => {
  test('renders App component', () => {
    render(<App />);
  });

  test('renders AppBar with Logo', () => {
    render(<App />);
    /* TODO */
  });

  test('renders TextBox for Long URL', () => {
    render(<App />);

    const textBox = screen.getByRole('textbox');

    expect(textBox).toBeInTheDocument();
    expect(textBox.id).toBe('long-url');
  });

  test('renders Shorten button', () => {
    render(<App />);

    const button = screen.getByText(/shorten/i);

    expect(button).toBeInTheDocument();
  });

  test('renders Looney Tunes link', () => {
    render(<App />);
    const linkElement = screen.getByText(/Looney Tunes/i);
    expect(linkElement).toBeInTheDocument();
  });
});