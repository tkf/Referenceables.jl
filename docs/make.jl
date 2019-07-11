using Documenter, Referenceables

makedocs(;
    modules=[Referenceables],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        hide("internals.md"),
    ],
    repo="https://github.com/tkf/Referenceables.jl/blob/{commit}{path}#L{line}",
    sitename="Referenceables.jl",
    authors="Takafumi Arakaki <aka.tkf@gmail.com>",
)

deploydocs(;
    repo="github.com/tkf/Referenceables.jl",
)
