defmodule EFile do
  defstruct [:filename, :file, opening: false]

  def open(filename) do
    case File.open(filename) do
      {:ok, device} ->
        {:ok, %EFile{file: device, filename: filename, opening: true}}

      {:error, _} = err ->
        err
    end
  end

  def close(%EFile{file: file} = efile) do
    File.close(file)
    %{efile | file: nil, opening: false}
  end

  def readline(%EFile{file: file}) do
    IO.read(file, :line)
  end

  defimpl Enumerable do
    def count(%EFile{}), do: {:error, __MODULE__}
    def member?(%EFile{}, _), do: {:error, __MODULE__}
    def slice(%EFile{}), do: {:error, __MODULE__}
    def reduce(%EFile{}, {:halt, acc}, _), do: {:halted, acc}
    def reduce(%EFile{} = efile, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(efile, &1, fun)}
    def reduce(%EFile{} = efile, {:cont, acc}, fun) do
      case EFile.readline(efile) do
        :eof ->
          {:done, acc}

        line ->
          reduce(efile, fun.(String.trim_trailing(line, "\n"), acc), fun)
      end
    end
  end
end
