# GenServer Tutorial

This is a tutorial which shows how to use GenServers in Elixir
to track unique ids.

Read the code thoroughly and interact with the GenServer through
IEx to get a good idea of how it works.

## Usage

Start an interactive session with the following:

```bash
iex -S mix
```

Then run these commands.

```elixir
alias GsTut.IDMaker

{:ok, port} = IDMaker.reserve("/logs/active-portside-only/")

IDMaker.free(port)
```

If using this code in a project, use a `case` statement to
handle the possibility of an error.

```elixir
alias GsTut.IDMaker

case IDMaker.reserve("/logs/active-portside-only/") do
  {:ok, id} -> 
    IO.puts("reserved id #{id}")
    case IDMaker.free(id) do
      :ok -> IO.puts("id #{id} has been freed")
      {:error, :id_not_found} -> IO.puts("#{id} does not exist to free")
    end
  {:error, :no_unused_ids} ->
    IO.puts("Could not reserve an id, all ids are already reserved")
end
```

## Explanation

### IDMaker

See `lib/gs_tut/id_maker.ex`

`IDMaker` is a simple GenServer which has a map as state. This
map has integer keys and arbitrary values.

Because `IDMaker` has assigned it's name as `__MODULE__`,
The global instance of `IDMaker` can be referenced by
`GsTut.IDMaker` from anywhere if it is running.

See https://hexdocs.pm/elixir/1.12/GenServer.html

When you call `reserve` it will store the provided metadata as
the value of a random unused key, the key is returned to the
caller. If there is no unused keys it will return an error.

When you call `free` it will remove the metadata associated
the key. This function either returns `:ok` which tells the
user that the function was successful or and error is returned
if the specified key is not already in use.

### Application Tree

See `lib/gs_tut/application.ex`

```elixir
{GsTut.IDMaker, %{first: 6000, last: 7000}}
```

IDMaker is added to the application tree. This means that when
the `GsTut` application is started the GenServer will be started
too.

Documentation: https://hexdocs.pm/elixir/1.12/GenServer.html

### Further Reading

https://hexdocs.pm/elixir/1.12/GenServer.html#module-name-registration