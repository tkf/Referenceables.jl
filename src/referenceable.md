    referenceable(x::AbstractArray{T}) :: AbstractArray{<:Ref{T}}
    referenceable(x::AbstractDict{K, V}) :: AbstractDict{K, <:Ref{V}}

`referenceable(x)` converts a collection `x` to a wrapped container where
indexing to it produces a reference, not the value.

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

!!! warning

    Inbound check is done when indexing the `referenceable(x)`
    container, _not_ during de-referencing `r[]`.  It means that
    passing the reference `r` to unknown code can result in a
    segmentation fault if the original container `x` is mutated
    afterwards.

`referenceable` works with dictionaries as well:

```julia
julia> x = Dict()
       y = referenceable(x);

julia> r = y[1] :: Ref
       r[] = 100;

julia> x
Dict{Any,Any} with 1 entry:
  1 => 100
```
