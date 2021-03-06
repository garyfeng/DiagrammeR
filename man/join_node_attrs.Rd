% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/join_node_attrs.R
\name{join_node_attrs}
\alias{join_node_attrs}
\title{Join new node attribute values using a data frame}
\usage{
join_node_attrs(graph, df, by_graph = NULL, by_df = NULL)
}
\arguments{
\item{graph}{a graph object of class}

\item{df}{the data frame to use for joining.}

\item{by_graph}{optional specification of the column
in the graph's internal node data frame for the left
join. If both \code{by_graph} and \code{by_df} are
not provided, then a natural join will occur if
there are columns in the graph's ndf and in
\code{df} with identical names.}

\item{by_df}{optional specification of the column in
\code{df} for the left join. If both \code{by_graph}
and \code{by_df} are not provided, then a natural
join will occur if there are columns in the graph's
ndf and in \code{df} with identical names.
\code{dgr_graph} that is created using
\code{create_graph}.}
}
\value{
a graph object of class
\code{dgr_graph}.
}
\description{
Join new node attribute values in a
left join using a data frame. The use of a left join
in this function allows for no possibility that
nodes in the graph might be removed after the join.
}
\examples{
# Create a simple graph
graph <-
  create_graph() \%>\%
  add_n_nodes(5) \%>\%
  add_edges_w_string("1->2 1->3 2->4 2->5 3->5")

# Create a data frame with node ID values and a
# set of numeric values
set.seed(25)

df <-
  data.frame(
    id = 1:6,
    values = round(rnorm(6, 5), 2))

# Join the values in the data frame to the
# graph's nodes; this works as a left join using
# identically-named columns in the graph and the df
# (in this case `nodes` is common to both)
graph <-
  graph \%>\% join_node_attrs(df)

# Get the graph's internal ndf to show that the
# join has been made
get_node_df(graph)
#>   id type label values
#> 1  1          1   4.79
#> 2  2          2   3.96
#> 3  3          3   3.85
#> 4  4          4   5.32
#> 5  5          5    3.5

# Get betweenness values for each node and
# add them as a node attribute (Note the
# column names `nodes` and `node` in the
# different tables still result in a
# natural join)
graph <-
  graph \%>\%
  join_node_attrs(
    get_betweenness(.))

# Get the graph's internal ndf to show that
# this join has been made
get_node_df(graph)
#>   id type label values betweenness
#> 1  1          1   4.79           2
#> 2  2          2   3.96           7
#> 3  3          3   3.85           1
#> 4  4          4   5.32           0
#> 5  5          5    3.5           2
}

