module TestArray

using Referenceables
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

end  # module
