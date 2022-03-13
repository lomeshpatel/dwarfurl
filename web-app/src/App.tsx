import { Box, Container, Link, Typography } from '@mui/material';
import React from 'react';
import './App.css';
import ResponsiveAppBar from './components/ResponsiveAppBar';
import ProTip from './ProTip';
import URLShortnerContainer from './url-shortner/URLShortnerContainer';

function Copyright() {
  return (
    <Typography variant="body2" color="text.secondary" align="center">
      {'Copyright © '}
      <Link color="inherit" href="https://mui.com/">
        Looney Tunes
      </Link>{' '}
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
        <ProTip />
        <Copyright />
      </Box>
    </Container>
  );
}

export default App;
