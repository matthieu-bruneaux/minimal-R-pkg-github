#' Home-made square-root function
#'
#' A light wrapper that does nothing special except calling \code{sqrt()} itself.
#'
#' @param x A vector of numerical values.
#'
#' @return A vector containing the square root of the input.
#'
#' @examples
#' mysqrt(4)
#' mysqrt(3)
#' mysqrt(1:10)
#' mysqrt(-1)
#'
#' @export

mysqrt <- function(x) {
    out <- sqrt(x)
    return(out)
}
