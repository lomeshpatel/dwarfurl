import { Button, Card, CardActions, CardContent, Container, TextField } from '@mui/material';
import * as React from 'react';

const fullWidth = {
  width: '100%',
}

export default class URLShortnerContainer extends React.Component {
  public render() {
    return (
      <Container maxWidth="sm">
        <Card raised={true}>
          <CardContent>
            <TextField id="long-url" label="Long URL" variant="filled" sx={fullWidth} />
          </CardContent>
          <CardActions>
            <Button variant="contained" sx={fullWidth}>Shorten</Button>
          </CardActions>
        </Card>
      </Container>
   );
  }
}
