#' Get a graph available in a series
#' @description Using a graph series object of type
#' \code{dgr_graph_1D}, get a graph object.
#' @param graph_series a graph series object of type
#' \code{dgr_graph_1D}.
#' @param graph_no the index of the graph in the graph
#' series.
#' @examples
#' # Create three graphs
#' graph_1 <-
#'   create_graph() %>%
#'   add_n_nodes(3) %>%
#'   add_edges_w_string(
#'     "1->3 1->2 2->3")
#'
#' graph_2 <-
#'   graph_1 %>%
#'   add_node() %>%
#'   add_edge(4, 3)
#'
#' graph_3 <-
#'   graph_2 %>%
#'   add_node() %>%
#'   add_edge(5, 2)
#'
#' # Create an empty graph series and add
#' # the graphs
#' series <-
#'   create_series() %>%
#'   add_to_series(graph_1, .) %>%
#'   add_to_series(graph_2, .) %>%
#'   add_to_series(graph_3, .)
#'
#' # Get the second graph in the series
#' extracted_graph <-
#'   get_graph_from_series(
#'     graph_series = series,
#'     graph_no = 2)
#' @export get_graph_from_series

get_graph_from_series <- function(graph_series,
                                  graph_no) {

  # Stop function if no graphs are available
  if (is.null(graph_series$graphs)) {
    stop("There are no graphs in this graph series.")
  }

  # Stop function if `graph_no` out of range
  if (!(graph_no %in% 1:graph_count(graph_series))) {
    stop("The index chosen doesn't correspond to that of a graph in the series.")
  }

  # Extract the specified graph from the series
  graph <- graph_series$graphs[[graph_no]]

  # Return the graph object
  return(graph)
}
