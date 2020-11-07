import axios from "axios"

export const BaseUrl = `https://www.cleartrip.com/node/flight/search?sd=1604745810378&adults=1`
// const depart_date = "11/11/2020"
// const adults = 1
// const from = "JAI"
// const to = "DEL"
// const sellingCountry = "IN"

export const getFlightData = async ({ depart_date, from, to, refCode }: { depart_date: string, from: string, to: string, refCode: string }): Promise<object> => {
  let date:String|Date = new Date(depart_date);
  const year = date.getFullYear();
  let month:String|Number = date.getMonth()+1;
  let dt:String|Number = date.getDate();

  if (dt < 10) {
    dt = '0' + dt;
  }
  if (month < 10) {
    month = '0' + month;
  }

  date = `${dt}/${month}/${year}`

  const url = `${BaseUrl}&depart_date=${date}&from=${from}&to=${to}&sellingCountry=IN&intl=n`
  const response: any = await axios.get(url);
  // console.log(response.data.cards[0])

  return response.data.cards[0].find((value: any) => {
    // console.log(value)
    const code = value.airlineCodes + value.splRtFn
    const regex = new RegExp(refCode,'ig')
    return code.match(regex);
  });
}
