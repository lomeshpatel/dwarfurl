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

  test('renders Copyright', () => {
    render(<App />);
    const linkElement = screen.getByText(/copyright/i);
    expect(linkElement).toBeInTheDocument();
  });
});