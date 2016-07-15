use "files"

actor Main
  new create(env: Env) =>

    try
        let ff = File(FilePath(env.root, "temp.txt"))

        let lines = ff.lines()

        for line in lines do
            env.out.print(line)
        end
    else
        env.out.print("No printing lines.")
    end

    env.out.print("Hello, world!")
