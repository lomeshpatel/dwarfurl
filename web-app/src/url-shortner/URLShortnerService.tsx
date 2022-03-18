import { useState } from "react";

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
  const [dwarfURLs, setDwarfURLs] = useState<DwarfURL[]>([]);
  /* eslint-disable no-unused-vars */
  const [errors, setErrors] = useState<ErrorResponse>();

  const shortenURL = (dwarfURL: DwarfURL) => {
    const headers = new Headers();
    headers.append('Content-Type', 'application/json; charset=utf-8');
    headers.append('Accept', 'application/json');

    return new Promise((resolve, reject) => {
      fetch('/v1/urls', {
        method: 'POST',
        body: JSON.stringify({ url: dwarfURL }),
        headers
      }).then(response => response.json())
        .then(response => {
          console.log(`Response: ${JSON.stringify(response)}`);
          setDwarfURLs([...dwarfURLs, response.data]);
          resolve(response);
        })
        .catch(error => {
          console.log(`Error: ${JSON.stringify(error)}`);
          setErrors(error.json().errors);
          reject(error);
        });
    });
  };

  return { dwarfURLs, shortenURL };
};

export default useURLShortnerService;