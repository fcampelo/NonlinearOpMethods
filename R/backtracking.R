#' Backtracking line search.
#'
#' \code{backtracking} is an approximate line search method to determine a step
#' length that makes a reasonable reduction in function value in a given search
#' direction.
#'
#' @param obj.list A list with the problem functions.
#' @param x.list A list with the current solution. It must have the names \cr
#'   x: a vector with its value in the search space \cr
#'   fx: a scalar with its objective value \cr
#'   dfx: a vector with its gradient value \cr
#' @param searchD A search direction for the method.
#' @param alpha0 Initial step size, usually set to 1 in most Newton-based
#' methods.
#' @param rho A constant to reduce alpha in each iteration, control parameter.
#' @param c A small constant, control parameter.
#'
#' @return Returns the step length \code{alpha} that provides a reasonable
#' decrease in function value.
#'
#' @details
#' The idea is, given a starting point \code{x} and a descent direction
#' \code{s}, the minimization of \code{f(x + alpha*s)} proceeds by setting
#' \code{alpha = 1} (or another value if provided) and iteratively reducing it
#' by a factor \code{rho} (set to 0.5 as default) until the following condition
#' is satisfied:
#'
#' \code{f(x + alpha*s) <= f(x) + c*alpha*(t(df(x))*s)}
#'
#' wherein \code{c} is a small constant (set to \code{c = 1e-4} here) and
#' \code{df(x)} is the gradient computed at the starting point \code{x}.0
#'
#'
#' @examples
#' # A quadratic translated function and its gradient
#' f <- function (x)
#' {
#'  i <- seq(1, length(x))
#'  return (sum( (x - i)^2 ))
#' }
#' fun <- list(f = f)
#' df <- function(x)
#' {
#'   i <- seq(1, length(x))
#'   return (2*(x - i))
#' }
#' # Get the current point in the form of a list
#' x <- c(0,1,0,1) #current point
#' X.list <- list(x = x, fx = f(x), dfx = df(x))
#' searchD <- -df(x) #search direction (negative of the gradient, for instance)
#' # Backtracking with default parameters
#' alpha.opt <- backtracking(fun, X.list, searchD)
#' print(f(x + alpha.opt*searchD)) #optimum by coincidence
#' # If rho were set to, say, 0.6 instead, the result would be
#' alpha.opt2 <- backtracking(fun, X.list, searchD)
#' # Which is not the optimum in this case, but already smaller than the initial
#' # solution x
#' print(f(x + alpha.opt2*searchD))
#'
#' @references
#' \enumerate{
#' \item Nocedal, Jorge; Wright, Stephen J.; \emph{Numerical Optimization}, 2nd ed., page 37.
#' \item Wikipedia, \emph{Backtracking line search} \url{https://en.wikipedia.org/wiki/Backtracking_line_search}.
#' }
#' @export

backtracking <- function(obj.list, x.list, searchD,
                         alpha0 = 1,
                         rho = 0.5,
                         c = 1e-4)
{
  x <- x.list$x
  fx <- x.list$fx
  dfx <- x.list$dfx

  alpha <- alpha0 #initial alpha
  sdfx <- sum(dfx * searchD) #dot product between dfx and searchD

  while( obj.list$f(x + alpha*searchD) > fx + c*alpha*sdfx )
  {
    alpha <- alpha*rho
  }

  return(alpha)
}
