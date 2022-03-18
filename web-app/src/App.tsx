import { Box, Container, Typography } from '@mui/material';
import './App.css';
import ResponsiveAppBar from './components/ResponsiveAppBar';
import URLShortnerContainer from './url-shortner/URLShortnerContainer';

function Copyright() {
  return (
    <Typography variant="body2" color="text.secondary" align="center">
      {'Copyright © Dwarfurl '}
      {new Date().getFullYear()}.
    </Typography>
  );
}

function App() {
  return (
    <Container maxWidth={false}>
      <ResponsiveAppBar />
      <Box sx={{ my: 4 }}>
        <URLShortnerContainer />
        <br></br>
        <Copyright />
      </Box>
    </Container>
  );
}

export default App;
