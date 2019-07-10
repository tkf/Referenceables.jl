# Referenceables

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tkf.github.io/Referenceables.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tkf.github.io/Referenceables.jl/dev)
[![Build Status](https://travis-ci.com/tkf/Referenceables.jl.svg?branch=master)](https://travis-ci.com/tkf/Referenceables.jl)
[![Codecov](https://codecov.io/gh/tkf/Referenceables.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/tkf/Referenceables.jl)
[![Coveralls](https://coveralls.io/repos/github/tkf/Referenceables.jl/badge.svg?branch=master)](https://coveralls.io/github/tkf/Referenceables.jl?branch=master)

Referenceables.jl provides an interface for readable and writable
reference to an element of an array or dictionary.  The entry point
function is `referenceable`.  Wrapping a container `x` yields a new
view `y = referenceable(x)` to `x` where indexing to it yields a
reference `r = y[i]`.  This reference can be used to read `value =
r[]` or write `r[] = value` a value.

## Examples

```julia
julia> using Referenceables

julia> x = collect(reshape(1:6, (2, 3)))
       y = referenceable(x);

julia> r = y[1] :: Ref
↪1

julia> r[] = 100;

julia> x
2×3 Array{Int64,2}:
 100  3  5
   2  4  6
```
