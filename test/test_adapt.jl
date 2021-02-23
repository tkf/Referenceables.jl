module TestAdapt

using Adapt
using Referenceables: Referenceable, referenceable
using Test

struct Incrementer end

Adapt.adapt_storage(::Incrementer, xs::AbstractArray) = xs .+ 1
Adapt.adapt_storage(::Incrementer, xs::Dict) = Dict(k => v + 1 for (k, v) in xs)

adapt_inc(xs::Referenceable) = parent(adapt(Incrementer(), xs)::Referenceable)

@testset begin
    @test adapt_inc(referenceable([1, 2, 3])) == 2:4
    @test adapt_inc(referenceable(Dict('a':'c' .=> 1:3))) == Dict('a':'c' .=> 2:4)
end

end  # module
