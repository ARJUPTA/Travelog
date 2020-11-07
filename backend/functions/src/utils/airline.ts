import axios from "axios"

export const BaseUrl = `https://www.cleartrip.com/node/flight/search?sd=1604745810378&adults=1`
// const depart_date = "11/11/2020"
// const adults = 1
// const from = "JAI"
// const to = "DEL"
// const sellingCountry = "IN"

export const getFlightData = async ({depart_date, from, to, time, refCode}:{depart_date:string, from:string, to: string, time:string, refCode:string}): Promise<object> => {
  const url = `${BaseUrl}&depart_date=${depart_date}&from=${from}&to=${to}&sellingCountry=IN&intl=n`
  const response: any = await axios.get(url);
  // console.log(response.data.cards[0])

  return response.data.cards[0].find((value: any) => {
    // console.log(value)
    const timeCheck = value.firstDeparture.time === time
    const code = value.airlineCodes + value.splRtFn
    const regex = new RegExp(refCode,'ig')
    return timeCheck && code.match(regex);
  });
}
