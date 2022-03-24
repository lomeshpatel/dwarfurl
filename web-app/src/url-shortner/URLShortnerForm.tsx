import { Button, Card, CardActions, CardContent, CardHeader, TextField } from "@mui/material"
import React, { useState } from "react"
import { DwarfURL, ErrorResponse } from "./URLShortnerService"

const fullWidth = {
  width: '100%',
}

type URLShortnerFormProps = {
  shortenURL: (dwarfURLReq: DwarfURL) => void
}

const URLShortnerForm = (props: URLShortnerFormProps) => {
  const initialDwarfURLReq: DwarfURL = {
    original_url: '',
    slug: undefined
  }

  const initialErrorResponse: ErrorResponse = {
    detail: undefined,
    original_url: undefined,
    slug: undefined,
  }

  const [dwarfURLReq, setDwarfURLReq] = useState<DwarfURL>(initialDwarfURLReq)
  const [errors, setErrors] = useState<ErrorResponse>(initialErrorResponse)

  const validateOriginalURL = (inputValue: string) => {
    const urlRegEx = new RegExp(/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)/)
    if (!urlRegEx.test(inputValue)) {
      setErrors(prevErrs => ({
        ...prevErrs, original_url: "URL must be a valid one that starts with http"
      }))
    } else {
      setErrors(prevErrs => ({
        ...prevErrs, original_url: undefined
      }))
    }
  }

  const validateSlug = (inputValue: string) => {
    if (inputValue === undefined || inputValue.length === 0 || (4 <= inputValue.length && inputValue.length <= 16)) {
      setErrors(prevErrs => ({
        ...prevErrs, slug: undefined
      }))
      return
    }

    if (inputValue.length < 4) {
      setErrors(prevErrs => ({
        ...prevErrs, slug: "Slug must not be shorter than 4 characters"
      }))
      return
    }

    if (16 < inputValue.length) {
      setErrors(prevErrs => ({
        ...prevErrs, slug: "Slug must not be longer than 16 characters"
      }))
      return
    }
  }

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const inputName: string = event.target.name
    const inputVal: string = event.target.value

    if (inputName === "original_url") {
      validateOriginalURL(inputVal)
    }
    if (inputName === "slug") {
      validateSlug(inputVal)
    }

    event.persist()
    setDwarfURLReq(prevReq => ({
      ...prevReq,
      [event.target.name]: event.target.value
    }))
  }

  const handleFormSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    if (errors.original_url === undefined && errors.slug === undefined) {
      props.shortenURL(dwarfURLReq)
    }
  }

  return (
    <Card raised={true}>
      <CardHeader title="Shorten URL" titleTypographyProps={{ variant: "h5" }} />
      <form onSubmit={handleFormSubmit}>
        <CardContent>
          <TextField
            id="original_url"
            name="original_url"
            label="Long URL"
            variant="filled"
            sx={fullWidth}
            required
            onChange={handleChange}
            error={Boolean(errors?.original_url)}
            helperText={errors?.original_url}
          />
          <TextField
            id="slug"
            name="slug"
            label="Slug (Optional)"
            variant="filled"
            sx={fullWidth}
            onChange={handleChange}
            error={Boolean(errors?.slug)}
            helperText={errors?.slug}
          />
        </CardContent>
        <CardActions>
          <Button
            type="submit"
            variant="contained"
            sx={fullWidth}
            disabled={Boolean(dwarfURLReq.original_url === '' || errors?.original_url || errors?.slug)}>
            Shorten
          </Button>
        </CardActions>
      </form>
    </Card>
  )
}

export default URLShortnerForm