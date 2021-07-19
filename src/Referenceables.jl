module Referenceables

export referenceable

import Adapt

# Use markdown files as the docstring:
for (name, path) in [
    :Referenceables => joinpath(dirname(@__DIR__), "README.md"),
    :referenceable => joinpath(@__DIR__, "referenceable.md"),
]
    include_dependency(path)
    str = replace(read(path, String), "```julia" => "```jldoctest $name")
    @eval @doc $str $name
end

"""
    RefIndexable{inbounds}(x, i::Tuple) where {inbounds isa Bool} <: Ref{valtype(x)}

Like `Base.RefArray`, but works with arbitrary containers and indices.
"""
struct RefIndexable{inbounds,T,A,I} <: Ref{T}
    x::A
    i::I
end

struct ReferenceableArray{T,N,A<:AbstractArray{T,N}} <:
       AbstractArray{RefIndexable{inbounds,T,A} where inbounds,N}
    x::A
end

Base.parent(x::ReferenceableArray) = x.x
parenttype(::Type{<:ReferenceableArray{<:Any, <:Any, A}}) where A = A

struct ReferenceableDict{K,V,A<:AbstractDict{K,V}} <:
       AbstractDict{K,RefIndexable{false,V,A,K}}
    x::A
end

Base.parent(x::ReferenceableDict) = x.x
parenttype(::Type{<:ReferenceableDict{<:Any, <:Any, A}}) where A = A

RefIndexable{inbounds}(x, i) where {inbounds} =
    RefIndexable{inbounds, _valtype(x), typeof(x), typeof(i)}(x, i)

RefIndexable(x, i) = RefIndexable{false}(x, i)

RefIndexable{inbounds}(x, i, ::Type{K}) where {inbounds, K} =
    RefIndexable{inbounds, _valtype(x), typeof(x), K}(x, i)

RefIndexable(x, i, ::Type{K}) where {K} = RefIndexable{false}(x, i, K)

Base.show(io::IO, x::RefIndexable) =
    if get(io, :limit, false)
        print(io, '↪', x[])
    else
        Base.show_default(io, x)
    end

@inline Base.getindex(x::RefIndexable{inbounds}) where {inbounds} =
    if inbounds
        @inbounds x.x[x.i...]
    else
        x.x[x.i...]
    end

@inline Base.setindex!(x::RefIndexable{inbounds}, value) where {inbounds} =
    if inbounds
        @inbounds x.x[x.i...] = value
    else
        x.x[x.i...] = value
    end

@inline Base.pointer(ref::RefIndexable) = pointer(ref.x, LinearIndices(ref.x)[ref.i...])

@inline Base.unsafe_convert(::Ptr{T}, ref::RefIndexable{inbounds,T}) where {inbounds,T} =
    pointer(ref)

const Referenceable = Union{ReferenceableArray, ReferenceableDict}

@inline function Base.getindex(x::ReferenceableArray, i::Int...)
    @boundscheck checkbounds(x, i...)
    return RefIndexable{true}(x.x, i)
end

@inline function Base.getindex(x::ReferenceableDict{K}, i) where {K}
    return RefIndexable(x.x, convert(K, i), K)
end

referenceable(x::AbstractArray) = ReferenceableArray(x)
referenceable(x::AbstractDict) = ReferenceableDict(x)

Base.size(A::ReferenceableArray) = size(A.x)
Base.axes(A::ReferenceableArray) = axes(A.x)
Base.IndexStyle(::Type{A}) where {A <: ReferenceableArray} =
    Base.IndexStyle(parenttype(A))

Base.length(A::ReferenceableDict) = length(A.x)
Base.iterate(A::ReferenceableDict) = iterate(A.x)
Base.iterate(A::ReferenceableDict, state) = iterate(A.x, state)

isreferenceable(xs) = _valtype(xs) <: RefIndexable
_valtype(xs) = valtype(xs)
_valtype(xs::AbstractArray) = eltype(xs)  # for old Julia

Adapt.adapt_structure(to, x::Referenceable) = referenceable(Adapt.adapt(to, parent(x)))

end # module
