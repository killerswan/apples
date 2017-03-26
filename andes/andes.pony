// 2016-07-16
// Solving Guy Steele's favorite toy problem, with Kevin's first brute force approach

use "collections"

actor Main
    let _env: Env

    fun show(xxs: List[I8]) =>
        for xx in xxs.values() do
            _env.out.print(xx.string())
        end

    // Q1 why does this break if I don't say :String ?
    fun show_slice(xxs: List[I8]) : String =>
        var collect = "["
        for xx in xxs.values() do
            collect = collect + xx.string() + ", "
        end
        collect + "]"

    fun max(xxs: List[I8]): I8 ? =>
        var found = xxs(0)
        for xx in xxs.values() do
            found = found.max(xx)
        end
        found

    // Q1 isn't this built in?
    // Q2 what about generics, ugh!?
    // Q3 isn't there a fori control structure? A: pairs() and keys() are neato
    fun slice(xxs: List[I8], start: USize, stop: USize): List[I8] => 
        var collect = List[I8]()
        try
            var ii: USize = 0
            while ((ii < xxs.size()) and (ii < stop)) do
                if ((start <= ii) and (ii < stop)) then
                    let xx = xxs(ii) // Q4 can we prove this will be OK?
                                     // oooh, this is a code smell and we should use pairs()
                    collect.push(xx)
                end

                ii = ii + 1 // forgetting this makes Alan Turing cry
            end
        end
        // whether or not we finished, return the collected slice
        collect

    fun peak_in_slice(xxs: List[I8]): I8 =>
        let peak =
            try
                max(xxs)
            else
                /* no max? */ 0
            end

        _env.out.print("peak: " + peak.string() + " in slice: " + show_slice(xxs))

        peak


    new create(env: Env) =>
        _env = env

        var lakes = List[I8]()
        var terrain = List[I8]()
        terrain.push(1)
        terrain.push(2)
        terrain.push(3)
        terrain.push(4)
        terrain.push(12)
        terrain.push(3)
        terrain.push(41)
        terrain.push(1)
        terrain.push(13)


        show(terrain)
        

        var ii : USize = 0
        while ii < terrain.size() do 

            let peak_behind = peak_in_slice(slice(terrain, 0,    ii))
            let peak_before = peak_in_slice(slice(terrain, ii+1, terrain.size()))

            let shorter_peak = peak_behind.min(peak_before)

            let depth = 
                try
                    if shorter_peak <= terrain(ii) then
                        env.out.print("no lake")
                        0
                    else
                        let dd = shorter_peak - terrain(ii)
                        env.out.print("a lake of " + dd.string())
                        dd
                    end

                else
                    // OOOOH: doing the pushes INSIDE these clauses
                    // allows us to comment out this else block (sketchy!)
                    //
                    // but if we just return a value, then the block's type is (I8 val | None val),
                    // which indeed makes no sense to push

                    // note: the reason for this is the terrain(ii) above
                    env.out.print("no lake (?)")
                    0
                end

            lakes.push(depth)

            ii = ii + 1
        end

        var water: I8 = 0

        for lake in lakes.values() do
            water = water + lake
        end

        env.out.print("water found: " + water.string())

