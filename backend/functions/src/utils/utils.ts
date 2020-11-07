import axios, { AxiosRequestConfig } from "axios";


// Returns details of pnr else returns false
export const validatePnr = async (pnr: string) => {
  const options:AxiosRequestConfig = {
    method: 'GET',
    url: `https://pnr-status-indian-railway.p.rapidapi.com/rail/${pnr}`,
    headers: {
      'x-rapidapi-key': '2920326c74msh76b3d11efcebf53p1fbc5ajsn2eadf9d76347',
      'x-rapidapi-host': 'pnr-status-indian-railway.p.rapidapi.com'
    }
  };
  try {
    const response = await axios.request(options);
    const data = response.data;
    if ("error" in data) {
      return false;
    } else {
      return data;
    }
  } catch (err) {
    console.log(err);
    return false;
  }
}