import { Container, Snackbar } from '@mui/material'
import Alert from '../components/Alert';
import ShortenedURLStack from './ShortenedURLStack'
import URLShortnerForm from './URLShortnerForm'
import useURLShortnerService from './URLShortnerService';

const URLShortnerContainer = () => {
  const { dwarfURLs, shortenURL, apiErrors, setApiErrors } = useURLShortnerService()

  return (
    <Container maxWidth="sm">
      <URLShortnerForm shortenURL={shortenURL} />
      <br></br>
      <ShortenedURLStack dwarfURLs={dwarfURLs} />

      <Snackbar
        open={apiErrors !== undefined}
        autoHideDuration={6000}
        onClose={() => setApiErrors(undefined)}>
        <Alert
          onClose={() => setApiErrors(undefined)}
          severity="error"
          sx={{ width: '100%' }}>
          {apiErrors?.detail || apiErrors?.original_url || apiErrors?.slug}
        </Alert>
      </Snackbar>
    </Container>
  )
}

export default URLShortnerContainer