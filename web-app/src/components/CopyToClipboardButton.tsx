import { ContentCopyTwoTone } from "@mui/icons-material"
import { IconButton, Snackbar } from "@mui/material"
import { useState } from "react"
import Alert from "./Alert"

type CopyToClipboardButtonProps = {
  copyText: string,
  writeToClipboard?: (copyText: string) => void,
}

const CopyToClipboardButton = (props: CopyToClipboardButtonProps) => {
  const [open, setOpen] = useState(false)

  const handleClick = () => {
    if (props.writeToClipboard !== undefined) {
      props.writeToClipboard(props.copyText)
    } else {
      navigator.clipboard.writeText(props.copyText)
    }
    setOpen(true)
  }

  return (
    <div>
      <IconButton name="copy" onClick={handleClick}>
        <ContentCopyTwoTone />
      </IconButton>

      <Snackbar
        open={open}
        autoHideDuration={6000}
        onClose={() => setOpen(false)}>
        <Alert
          onClose={() => setOpen(false)}
          severity="success"
          sx={{ width: '100%' }}>
          {props.copyText} has been copied!
        </Alert>
      </Snackbar>
    </div>
  )
}

export default CopyToClipboardButton