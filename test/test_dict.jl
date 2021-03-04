module TestDict

using Referenceables
using Referenceables: isreferenceable
using Test

@testset begin
    x = Dict()
    y = referenceable(x)
    r = y[1]
    r[] = 10
    @test x[1] == 10
    @test y[1] isa valtype(y)
    @test y[1.0] isa valtype(y)
end

@testset "keytype" begin
    x = Dict{Int,Int}(1 => 1)
    y = referenceable(x)
    @test y[1] isa valtype(y)
    @test y[1.0] isa valtype(y)
end

@testset "isreferenceable" begin
    x = Dict()
    @test isreferenceable(referenceable(x))
    @test !isreferenceable(x)
end

end  # module
