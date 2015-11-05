context("Selecting nodes or edges in a graph object")

test_that("selecting a node in a graph is possible", {

  library(magrittr)

  # Create a simple graph
  nodes <-
    create_nodes(nodes = c("a", "b", "c", "d"),
                 type = "letter",
                 label = TRUE,
                 value = c(3.5, 2.6, 9.4, 2.7))

  edges <-
    create_edges(from = c("a", "b", "c"),
                 to = c("d", "c", "a"),
                 rel = "leading_to",
                 width = c(1, 2, 3))

  graph <-
    create_graph(nodes_df = nodes,
                 edges_df = edges)

  # Select nodes "a" and "c"
  graph_a_c <- select_nodes(graph = graph, nodes = c("a", "c"))

  # Expect that a selection object is available
  expect_true(!is.null(graph_a_c$selection))

  # Expect that a list 'nodes' is available in 'selection'
  expect_true(!is.null(graph_a_c$selection$nodes))

  # Expect that a list 'edges' is not available in 'selection'
  expect_null(graph_a_c$selection$edges)

  # Expect that nodes "a" and "c" are part of a selection
  # object in 'nodes'
  expect_true(all(graph_a_c$selection$nodes == c("a", "c")))

  # Select nodes where `value` > 3
  graph_val_gt_3 <-
    select_nodes(graph = graph,
                 node_attr = "value",
                 comparison = ">3")

  # Expect that nodes "a" and "c" are part of a selection
  # object in 'nodes'
  expect_true(all(graph_val_gt_3$selection$nodes == c("a", "c")))

  # Select nodes where `value` < 3
  graph_val_lt_3 <-
    select_nodes(graph = graph,
                 node_attr = "value",
                 comparison = "<3")

  # Expect that nodes "a" and "c" are part of a selection
  # object in 'nodes'
  expect_true(all(graph_val_lt_3$selection$nodes == c("b", "d")))

  # Select nodes where `value` == 2.7
  graph_val_eq_2_7 <-
    select_nodes(graph = graph,
                 node_attr = "value",
                 comparison = "==2.7")

  # Expect that node "d" is part of a selection object in 'nodes'
  expect_true(all(graph_val_eq_2_7$selection$nodes == "d"))

  # Select nodes where `value` != 2.7
  graph_val_neq_2_7 <-
    select_nodes(graph = graph,
                 node_attr = "value",
                 comparison = "!=2.7")

  # Expect that nodes "a", "b", and "c" are part of a selection
  # object in 'nodes'
  expect_true(all(graph_val_neq_2_7$selection$nodes == c("a", "b", "c")))

  # Select nodes where `type` is `letter`
  graph_val_letter <-
    select_nodes(graph = graph,
                 node_attr = "type",
                 regex = "let")

  # Expect that nodes "a", "b", "c", and "d" are part of a selection
  # object in 'nodes'
  expect_true(all(graph_val_letter$selection$nodes == c("a", "b", "c", "d")))

  # Create a union of selections in a magrittr pipeline
  graph_sel_union_a_b_c_d <-
    graph %>% select_nodes(c("a", "b")) %>% select_nodes(c("c", "d"))

  # Expect that nodes "a", "b", "c", and "d" are part of a selection
  # object in 'nodes'
  expect_true(all(graph_sel_union_a_b_c_d$selection$nodes == c("a", "b", "c", "d")))

  # Create a intersection of selections in a magrittr pipeline
  graph_sel_intersect <-
    graph %>% select_nodes(c("a", "b", "c")) %>%
    select_nodes(c("b", "c", "d"), set_op = "intersect")

  # Expect that nodes "b" and "c" are part of a selection object
  # in 'nodes'
  expect_true(all(graph_sel_intersect$selection$nodes == c("b", "c")))

  # Create a selection that is a difference of selections
  graph_sel_difference <-
    graph %>% select_nodes(c("a", "b", "c")) %>%
    select_nodes(c("b", "c"), set_op = "difference")

  # Expect that node "a" is part of a selection object in 'nodes'
  expect_true(all(graph_sel_difference$selection$nodes == "a"))

  # Expect an error if a comparison and regex are used together
  expect_error(
    select_nodes(graph = graph,
                 node_attr = "value",
                 comparison = ">3",
                 regex = "3")
  )

  # Expect an error if selecting nodes from an empty graph
  expect_error(
    select_nodes(graph = create_graph(),
                 nodes = "s")
  )

  # Expect an error if specifying more than one attribute
  expect_error(
    select_nodes(graph = graph,
                 node_attr = c("label", "value"),
                 regex = "a")
  )

  # Expect an error if specifying a node that doesn't exist
  expect_error(
    select_nodes(graph = graph,
                 nodes = "e")
  )

  expect_error(
    select_nodes(graph = graph,
                 nodes = "e",
                 node_attr = "value",
                 comparison = ">0")
  )
})

test_that("selecting an edge in a graph is possible", {

  # Create a simple graph
  nodes <-
    create_nodes(nodes = c("a", "b", "c", "d"),
                 type = "letter",
                 label = TRUE,
                 value = c(3.5, 2.6, 9.4, 2.7))

  edges <-
    create_edges(from = c("a", "b", "c"),
                 to = c("d", "c", "a"),
                 rel = "leading_to",
                 width = c(1, 2, 3))

  graph <-
    create_graph(nodes_df = nodes,
                 edges_df = edges)

  # Select nodes "a" -> "d" and "b" -> "c"
  graph_ad_bc <- select_edges(graph = graph,
                              from = c("a", "b"),
                              to = c("d", "c"))

  # Expect that a selection object is available
  expect_true(!is.null(graph_ad_bc$selection))

  # Expect that a list 'edges' is available in 'selection'
  expect_true(!is.null(graph_ad_bc$selection$edges))

  # Expect that a list 'from' is available in 'selection/edges'
  expect_true(!is.null(graph_ad_bc$selection$edges$from))

  # Expect that a list 'to' is available in 'selection/edges'
  expect_true(!is.null(graph_ad_bc$selection$edges$to))

  # Expect that a list 'nodes' is not available in 'selection'
  expect_null(graph_ad_bc$selection$nodes)

  # Expect that nodes "a" and "b" are part of a selection
  # object in 'from'
  expect_true(all(graph_ad_bc$selection$edges$from == c("a", "b")))

  # Expect that nodes "d" and "c" are part of a selection
  # object in 'to'
  expect_true(all(graph_ad_bc$selection$edges$to == c("d", "c")))

  # Select edges where `width` > 2
  graph_width_gt_2 <-
    select_edges(graph = graph,
                 edge_attr = "width",
                 comparison = ">2")

  # Expect that node "c" is part of a selection
  # object in 'edges/from'
  expect_true(graph_width_gt_2$selection$edges$from == "c")

  # Expect that node "a" is part of a selection
  # object in 'edges/to'
  expect_true(graph_width_gt_2$selection$edges$to == "a")

  # Select nodes where `width` < 3
  graph_width_lt_3 <-
    select_edges(graph = graph,
                 edge_attr = "width",
                 comparison = "<3")

  # Expect that nodes "a" and "b" are part of a selection
  # object in 'edges/from'
  expect_true(all(graph_width_lt_3$selection$edges$from == c("a", "b")))

  # Expect that nodes "d" and "c" are part of a selection
  # object in 'edges/to'
  expect_true(all(graph_width_lt_3$selection$edges$to == c("d", "c")))

  # Select nodes where `width` == 2
  graph_width_eq_2 <-
    select_edges(graph = graph,
                 edge_attr = "width",
                 comparison = "== 2")

  # Expect that node "b" is part of a selection
  # object in 'edges/from'
  expect_true(graph_width_eq_2$selection$edges$from == "b")

  # Expect that node "c" is part of a selection
  # object in 'edges/to'
  expect_true(graph_width_eq_2$selection$edges$to == "c")

  # Select nodes where `width` != 2
  graph_width_neq_2 <-
    select_edges(graph = graph,
                 edge_attr = "width",
                 comparison = "!=2")

  # Expect that nodes "a" and "c" are part of a selection
  # object in 'edges/from'
  expect_true(all(graph_width_neq_2$selection$edges$from == c("a", "c")))

  # Expect that nodes "d" and "a" are part of a selection
  # object in 'edges/to'
  expect_true(all(graph_width_neq_2$selection$edges$to == c("d", "a")))

  # Select nodes where `rel` is `leading_to`
  graph_val_leading_to <-
    select_edges(graph = graph,
                 edge_attr = "rel",
                 regex = "leading")

  # Expect that nodes "a", "b", and "c" are part of a selection
  # object in 'edges/from'
  expect_true(all(graph_val_leading_to$selection$edges$from == c("a", "b", "c")))

  # Expect that nodes "d", "c", and "a" are part of a selection
  # object in 'edges/to'
  expect_true(all(graph_val_leading_to$selection$edges$to == c("d", "c", "a")))

  # Create a union of selections in a magrittr pipeline
  graph_sel_union_ab_bc <-
    graph %>% select_edges("a", "d") %>% select_edges("b", "c")

  # Expect that nodes "a" and "b" are part of a selection
  # object in 'edges/from'
  expect_true(all(graph_sel_union_ab_bc$selection$edges$from == c("a", "b")))

  # Expect that nodes "d" and "c" are part of a selection
  # object in 'edges/to'
  expect_true(all(graph_sel_union_ab_bc$selection$edges$to == c("d", "c")))

  # Create a intersection of selections in a magrittr pipeline
  graph_sel_intersect_bc <-
    graph %>% select_edges(c("a", "b"), c("d", "c")) %>%
    select_edges(c("b", "c"), c("c", "a"), set_op = "intersect")

  # Expect that node "b" is part of a selection
  # object in 'edges/from'
  expect_true(graph_sel_intersect_bc$selection$edges$from == "b")

  # Expect that node "c" is part of a selection
  # object in 'edges/to'
  expect_true(graph_sel_intersect_bc$selection$edges$to == "c")

  # Create a selection that is a difference of selections
  graph_sel_edge_difference_ad <-
    graph %>% select_edges(c("a", "b", "c"), c("d", "c", "a")) %>%
    select_edges(c("b", "c"), c("c", "a"), set_op = "difference")

  # Expect that node "c" is part of a selection
  # object in 'edges/from'
  expect_true(graph_sel_edge_difference_ad$selection$edges$from == "a")

  # Expect that node "a" is part of a selection
  # object in 'edges/to'
  expect_true(graph_sel_edge_difference_ad$selection$edges$to == "d")

  # Expect an error if a comparison and regex are used together
  expect_error(
    select_edges(graph = graph,
                 edge_attr = "width",
                 comparison = ">3",
                 regex = "3")
  )

  # Expect an error if selecting edges from an empty graph
  expect_error(
    select_edges(graph = create_graph(),
                 from = "a",
                 to = "c")
  )

  # Expect an error if specifying more than one attribute
  expect_error(
    select_edges(graph = graph,
                 edge_attr = c("rel", "width"),
                 regex = "a")
  )
})