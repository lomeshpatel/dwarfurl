import { AlertProps } from "@mui/material"
import MuiAlert from '@mui/material/Alert'
import React from "react"

const Alert = React.forwardRef<HTMLDivElement, AlertProps>((props, ref) => {
  return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />
})

export default Alert