module Referenceables

export referenceable

struct ReferenceableArray{T, N, A <: AbstractArray{T, N}} <: AbstractArray{Ref{T}, N}
    x::A
end

parenttype(::Type{<:ReferenceableArray{<:Any, <:Any, A}}) where A = A

struct ReferenceableDict{K, V, A <: AbstractDict{K, V}} <: AbstractDict{K, Ref{V}}
    x::A
end

parenttype(::Type{<:ReferenceableDict{<:Any, <:Any, A}}) where A = A

struct RefIndexable{inbounds, T, A, I} <: Ref{T}
    x::A
    i::I
end

RefIndexable{inbounds}(x, i) where {inbounds} =
    RefIndexable{inbounds, eltype(x), typeof(x), typeof(i)}(x, i)

RefIndexable(x, i) = RefIndexable{false}(x, i)

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

const Referenceable = Union{ReferenceableArray, ReferenceableDict}

@inline function Base.getindex(x::ReferenceableArray, i::Int...)
    @boundscheck checkbounds(x, i...)
    return RefIndexable{true}(x.x, i)
end

@inline function Base.getindex(x::ReferenceableDict, i...)
    return RefIndexable(x.x, i...)
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

end # module
