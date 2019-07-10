module TestDict

using Referenceables
using Test

@testset begin
    x = Dict()
    y = referenceable(x)
    r = y[1]
    r[] = 10
    @test x[1] == 10
end

end  # module
