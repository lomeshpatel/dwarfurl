import { useState } from "react"

export type DwarfURL = {
  original_url: string,
  slug?: string,
}

export type ErrorResponse = {
  detail?: string,
  original_url?: any,
  slug?: any,
}

const useURLShortnerService = () => {
  const [dwarfURLs, setDwarfURLs] = useState<DwarfURL[]>([])
  const [apiErrors, setApiErrors] = useState<ErrorResponse>()

  const handleResponse = async (response: Response) => {
    const isJson = response.headers.get('Content-Type')?.includes('application/json')
    const resBody = isJson && await response.json()

    console.log(`Response Body: ${JSON.stringify(resBody)}`)

    if (200 <= response.status && response.status < 400) {
      handleSuccess(resBody)
    } else {
      handleError(resBody)
    }
  }

  const handleSuccess = (resBody: any) => {
    setDwarfURLs([...dwarfURLs, resBody.data])
    Promise.resolve('success')
  }

  const handleError = (resBody: any) => {
    setApiErrors(resBody.errors)
    Promise.resolve('error')
  }

  const shortenURL = (dwarfURL: DwarfURL) => {
    const headers = new Headers()
    headers.append('Content-Type', 'application/json; charset=utf-8')
    headers.append('Accept', 'application/json')

    return new Promise((resolve, reject) => {
      fetch('/v1/urls', {
        method: 'POST',
        body: JSON.stringify({ url: dwarfURL }),
        headers
      }).then(handleResponse)
        .catch(error => {
          console.log(`Error: ${JSON.stringify(error)}`)
          reject(error)
        })
    })
  }

  return { dwarfURLs, shortenURL, apiErrors, setApiErrors }
}

export default useURLShortnerService