import { createTheme } from '@mui/material/styles';
import { red } from '@mui/material/colors';

// A custom theme for this app
const theme = createTheme({
  palette: {
    primary: {
      main: '#0c2355',
    },
    secondary: {
      main: '#c9c095',
    },
    error: {
      main: red.A400,
    },
    background: {
      default: '#e0e0e0',
      paper: '#eeeeee',
    }
  },
});

export default theme;