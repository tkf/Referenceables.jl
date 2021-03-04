module TestArray

using Referenceables
using Referenceables: isreferenceable
using Test

@testset begin
    x = collect(reshape(1:6, (2, 3)))
    y = referenceable(x)
    r1 = y[1]
    r1[] = r1[] * 10
    @test x[1] == 10

    r12 = y[1, 2]
    r12[] = r12[] * 10
    @test x[1, 2] == 30
end

@testset "eachindex" begin
    @testset for x in [
        ones(3),
        ones(2, 2),
    ]
        @test eachindex(x) == eachindex(x, referenceable(x))
    end
end

@testset "isreferenceable" begin
    x = collect(reshape(1:6, (2, 3)))
    @test isreferenceable(referenceable(x))
    @test isreferenceable(collect(referenceable(x)))
    @test isreferenceable(view(referenceable(x), 1:1, 1:2))
    @test isreferenceable(view(referenceable(x), 1:1))
    @test !isreferenceable(x)
    @test !isreferenceable(1:1)
end

end  # module
