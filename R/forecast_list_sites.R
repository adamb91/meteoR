#' List available locations for forecasts
#'
#' Requests locations from the met office API in xml format and returns a \code{tibble}
#' @export
#' @examples
#' forecast_list_sites()
#' @importFrom magrittr %>%
forecast_list_sites <- function() {
  xml_data <- xml2::read_xml(paste0(
    api_root(),
    "val/wxfcs/all/xml/sitelist?res=daily",
    "&key=",
    read_api_key()
  ))

  df <- tibble::tibble(xml = rvest::xml_nodes(xml_data, "Location")) %>%
    dplyr::mutate(locations = purrr::map(xml, .f = ~tibble::as.tibble(t(xml2::xml_attrs(.))))) %>%
    dplyr::select(locations) %>%
    tidyr::unnest()

  df

}