import { ContentCopyTwoTone, ShareTwoTone } from "@mui/icons-material"
import { Button, Card, CardActions, CardContent, CardHeader, IconButton, Stack, Tooltip, Typography } from "@mui/material"
import { useEffect, useState } from "react"
import CopyToClipboardButton from "../components/CopyToClipboardButton"
import useURLShortnerService, { DwarfURL } from "./URLShortnerService"

type ShortenedURLStackProps = {
  dwarfURLs: DwarfURL[],
}

const shortendURLCard = (dwarfURL: DwarfURL) => {
  return (
    <Card raised key={dwarfURL.slug}>
      <CardContent>
        <Typography variant="h6" color="primary">
          {document.location.origin + '/' + dwarfURL.slug}
        </Typography>
        <Typography variant="subtitle2" color="secondary">
          {dwarfURL.original_url}
        </Typography>
      </CardContent>
      <CardActions>
        <Tooltip title="Copy Dwarfurl">
          <span>
            <CopyToClipboardButton copyText={document.location.origin + '/' + dwarfURL.slug} />
          </span>
        </Tooltip>
        <Tooltip title="Coming soon">
          <span>
            <IconButton disabled><ShareTwoTone /></IconButton>
          </span>
        </Tooltip>
      </CardActions>
    </Card>
  )
}

const ShortenedURLStack = (props: ShortenedURLStackProps) => {
  return (
    <Card raised>
      <CardHeader title="Recent URLs" titleTypographyProps={{ variant: "h5" }} />
      <CardContent>
        {props.dwarfURLs.length === 0 && <Typography variant="body1">No Recent URLs</Typography>}
        <Stack spacing={2}>
          {props.dwarfURLs.map((dwarfURL) => (shortendURLCard(dwarfURL)))}
        </Stack>
      </CardContent>
    </Card>
  )
}

export default ShortenedURLStack