import { ContentCopyTwoTone } from "@mui/icons-material"
import { AlertProps, IconButton, Snackbar } from "@mui/material"
import MuiAlert from '@mui/material/Alert'
import React, { useState } from "react"

const Alert = React.forwardRef<HTMLDivElement, AlertProps>((props, ref) => {
  return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />
})

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