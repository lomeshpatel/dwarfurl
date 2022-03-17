import { Container } from '@mui/material'
import ShortenedURLStack from './ShortenedURLStack'
import URLShortnerForm from './URLShortnerForm'
import useURLShortnerService from './URLShortnerService';

const URLShortnerContainer = () => {
  const { dwarfURLs, shortenURL } = useURLShortnerService()

  return (
    <Container maxWidth="sm">
      <URLShortnerForm shortenURL={shortenURL} />
      <br></br>
      <ShortenedURLStack dwarfURLs={dwarfURLs} />
    </Container>
  )
}

export default URLShortnerContainer