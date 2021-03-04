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
end

@testset "isreferenceable" begin
    x = Dict()
    @test isreferenceable(referenceable(x))
    @test !isreferenceable(x)
end

end  # module
